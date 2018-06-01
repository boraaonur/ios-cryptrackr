//
//  BittrexClient.swift
//  Cryptrack
//
//  Created by Bora A.  on 31.05.2018.
//  Copyright © 2018 Bora A. ONUR. All rights reserved.
//

import UIKit

class BittrexClient {
    static let shared = BittrexClient()
    private init() {}
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getCoins(completion: @escaping (_ error: String?) -> Void) {
        let url = URL(string: "https://bittrex.com/api/v1.1/public/getcurrencies")
        let request = URLRequest(url: url!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                completion(error!.localizedDescription)
            } else {
                if data != nil {
                    let parsedResult: [String:Any]
                    do {
                        parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                        let result = parsedResult["result"] as! [[String:Any]]
                        print("a")
                        print(result)
                        for i in result {
                            let isActive = (i["IsActive"] as! Bool)
                            print(isActive)
                            if isActive {
                                let currency = Currency(context: self.context)
                                currency.name = (i["CurrencyLong"] as? String)
                                currency.symbol = (i["Currency"] as? String)
                                try? self.context.save()
                            }
                        }
                        completion(nil)
                        
                    } catch {
                        completion("Something went wrong")
                    }
                } else {
                    completion("Something went wrong")
                }
            }
        }
        task.resume()
    }
    
    func getCurrencyData(_ currency: Currency, completion: @escaping (_ data: CurrencyData?,_ error: String?) -> Void) {
        let url = URL(string: "https://bittrex.com/api/v1.1/public/getmarketsummary?market=btc-\(currency.symbol!)")
        let request = URLRequest(url: url!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                completion(nil, error?.localizedDescription)
            } else {
                do {
                    let parsedResult: [String:Any]
                    parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                    if let result = parsedResult["result"] as? [[String:Any]] {
                        let currencyData = CurrencyData(dictionary: result[0])
                        completion(currencyData!, nil)
                    }
                } catch {
                    completion(nil, "Something went wrong")
                }
            }
        }
        task.resume()
    }
    
    func getLastPrice(_ currency: Currency, completion: @escaping (_ lastPrice: Double?,_ error: String?) -> Void) {
        let url = URL(string: "https://bittrex.com/api/v1.1/public/getticker?market=BTC-\(currency.symbol!)")
        let request = URLRequest(url: url!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                completion(nil, error!.localizedDescription)
            } else {
                let parsedResult: [String:Any]
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                    if let result = parsedResult["result"] as? [String:Any] {
                        for i in result {
                            if i.key == "Last" {
                                let lastPrice = (i.value as! Double)
                                completion(lastPrice, nil)
                            }
                        }
                    }
                } catch {
                    completion(nil, "Something went wrong")
                }
            }
        }
        task.resume()
    }
    
    func getOrderbook(_ currency: Currency, type: String, completion: @escaping (_ orders: [[String:Any]]?,_ error: String?) -> Void) {
        let url = URL(string: "https://bittrex.com/api/v1.1/public/getorderbook?market=BTC-\(currency.symbol!)&type=both")
        let request = URLRequest(url: url!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                completion(nil, error?.localizedDescription)
            } else {
                let parsedResult: [String:Any]
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                    if let result = parsedResult["result"] as? [String:Any] {
                        let orderArray = result["\(type)"] as! [[String:Any]]
                        completion(orderArray, nil)
                    }
                } catch {
                    completion(nil, "Something went wrong")
                }
            }
        }
        task.resume()
    }
    
    func getHistoricalData(_ currency: Currency, tickInterval: String, count: Int, completion: @escaping (_ data: [Float]?, _ error: String?) -> Void) {
        let url = URL(string: "https://bittrex.com/Api/v2.0/pub/market/GetTicks?marketName=BTC-\(currency.symbol!)&tickInterval=\(tickInterval)")
        let request = URLRequest(url: url!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                completion(nil, error!.localizedDescription)
            } else {
                let parsedResult: [String:Any]
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                    if let result = parsedResult["result"] as? [[String:Any]] {
                        print("result check")
                        var x = 0
                        var graphData = [Float]()
                        for i in result {
                            let singleData = i["O"] as! Float
                            graphData.append(singleData)
                            x += 1
                            if x == count {
                                break;
                            }
                        }
                        completion(graphData, nil)
                    }
                } catch {
                    completion(nil, "Something went wrong")
                }
            }
        }
        task.resume()
        
    }
    
    func downloadLogo(currency: Currency, completion: @escaping (_ error: String?) -> Void) {
        let url = URL(string:"https://bittrex.com/api/v1.1/public/getmarkets")
        let request = URLRequest(url: url!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                completion(error!.localizedDescription)
            } else {
                let parsedResult: [String:Any]
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                    if let result = parsedResult["result"] as? [[String:Any]] {
                        for i in result {
                            let marketCurrency = i["MarketCurrency"] as! String
                            let baseCurrency = i["BaseCurrency"] as! String // this is because there are 3x logoUrl (ETH and USDT pair)
                            if currency.symbol == marketCurrency && baseCurrency == "BTC" {
                                let urlString = i["LogoUrl"] as! String
                                print(urlString)
                                let url = URL(string: urlString)
                                let data = try? Data(contentsOf: url!)
                                currency.icon = data
                            }
                        }
                        try? self.context.save()
                        completion(nil)
                    }
                } catch {
                    completion("Something went wrong")
                }
                
            }
        }
        task.resume()
    }
    
}
