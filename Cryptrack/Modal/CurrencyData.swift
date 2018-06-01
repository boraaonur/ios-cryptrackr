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

    init?(dictionary: [String:Any]) {

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
