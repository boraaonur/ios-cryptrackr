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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
    }

    
}
