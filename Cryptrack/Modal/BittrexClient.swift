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
    
    func getCoins(completion: @escaping () -> Void) {
        let url = URL(string: "https://bittrex.com/api/v1.1/public/getcurrencies")
        let request = URLRequest(url: url!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
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
                        print("b")
                        
                        completion()
                        
                    } catch {
                        print("c")
                    }
                } else {
                    print("data is nil")
                }
            }
        }
        task.resume()
    }
}
