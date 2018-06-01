//
//  DetailViewController.swift
//  Cryptrack
//
//  Created by Bora A.  on 31.05.2018.
//  Copyright © 2018 Bora A. ONUR. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var currency: Currency!
    let bittrexClient = BittrexClient.shared
    @IBOutlet var navigationBar: UINavigationItem!
    @IBOutlet var pairLabel: UILabel!
    @IBOutlet var yesterdayLabel: UILabel!
    @IBOutlet var highLabel: UILabel!
    @IBOutlet var lowLabel: UILabel!
    @IBOutlet var volumeLabel: UILabel!
    @IBOutlet var volumeBTCLabel: UILabel!
    @IBOutlet var bidTableView: UITableView!
    @IBOutlet var askTableView: UITableView!
    var bidArray = [Order]()
    var askArray = [Order]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bidTableView.delegate = self
        bidTableView.dataSource = self
        askTableView.delegate = self
        askTableView.dataSource = self
        askTableView.rowHeight = 16
        bidTableView.rowHeight = 16
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        bittrexClient.getCurrencyData(currency) { (currencyData) in
            DispatchQueue.main.async {
                self.pairLabel.text = "Pair: \(currencyData.marketName!)"
                self.yesterdayLabel.text = "Yesterday: \(currencyData.yesterday!)"
                self.highLabel.text = "24h High: \(currencyData.high!)"
                self.lowLabel.text = "24h Low: \(currencyData.low!)"
                self.volumeLabel.text = "24h Volume: \(currencyData.volume!)"
                self.volumeBTCLabel.text = "24h Volume(BTC): \(currencyData.btcVolume!)"
            }
        }
        
        bittrexClient.getOrderbook(currency, type: "buy") { (orderList) in
            for i in orderList {
                let rate = i["Rate"] as! Double
                let quantity = i["Quantity"] as! Double
                let bid = Order(rate: rate, quantity: quantity)
                self.bidArray.append(bid)
            }
            DispatchQueue.main.async {
                self.bidTableView.reloadData()
            }
        }
        
        bittrexClient.getOrderbook(currency, type: "sell") { (orderList) in
            for i in orderList {
                let rate = i["Rate"] as! Double
                let quantity = i["Quantity"] as! Double
                let ask = Order(rate: rate, quantity: quantity)
                self.askArray.append(ask)
            }
            DispatchQueue.main.async {
                self.askTableView.reloadData()
            }
        }
        
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.askTableView {
            return askArray.count
        } else {
            return bidArray.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.bidTableView {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "bidCell")
            cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 8)
            cell.textLabel?.text = String(self.bidArray[indexPath.row].quantity!)
            cell.detailTextLabel?.font = UIFont(name: "HelveticaNeue", size: 8)
            cell.detailTextLabel?.text = String(self.bidArray[indexPath.row].rate!)
            cell.backgroundColor = UIColor(red: 128.0/255.0, green: 206.0/255.0, blue: 160.0/255.0, alpha: 1.0)
            return cell
        } else {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "askCell")
            cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 8)
            cell.textLabel?.text = String(self.askArray[indexPath.row].quantity!)
            cell.detailTextLabel?.font = UIFont(name: "HelveticaNeue", size: 8)
            cell.detailTextLabel?.text = String(self.askArray[indexPath.row].quantity!)
            cell.backgroundColor = UIColor(red: 232.0/255.0, green: 136.0/255.0, blue: 131.0/255.0, alpha: 1.0)
            return cell
        }

    }
}
