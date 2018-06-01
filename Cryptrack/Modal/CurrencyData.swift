//
//  CurrencyData.swift
//  Cryptrack
//
//  Created by Bora A.  on 1.06.2018.
//  Copyright © 2018 Bora A. ONUR. All rights reserved.
//

import Foundation

struct CurrencyData {
    let marketName: String?
    let high: Double?
    let low: Double?
    let volume: Double?
    let btcVolume: Double?
    let yesterday: Double?
    // "MarketName":"BTC-LTC","High":0.01600000,"Low":0.01561272,"Volume":9524.56278279,"Last":0.01568022,"BaseVolume":150.51315165,"TimeStamp":"2018-06-01T05:34:34.917","Bid":0.01568027,"Ask":0.01573000,"OpenBuyOrders":1149,"OpenSellOrders":3928,"PrevDay":0.01596173,"Created":"2014-02-13T00:00:00"}]
    init?(dictionary: [String:Any]) {
        //guard let firstName = dictionary["firstName"] as? String,
          //  let lastName = dictionary["lastName"] as? String,
           // let mapString = dictionary["location"] as? String else { return nil }
        //self.firstName = firstName
        //self.lastName = lastName
        //self.location = location
        guard let marketName = dictionary["MarketName"] as? String else { return nil }
        guard let high = dictionary["High"] as? Double else { return nil }
        guard let low = dictionary["Low"] as? Double else { return nil }
        guard let volume = dictionary["Volume"] as? Double else { return nil }
        guard let btcVolume = dictionary["BaseVolume"] as? Double else { return nil }
        guard let yesterday = dictionary["PrevDay"] as? Double else { return nil }

        self.marketName = marketName
        self.high = high
        self.low = low
        self.volume = volume
        self.btcVolume = btcVolume
        self.yesterday = yesterday
        
    }
}
