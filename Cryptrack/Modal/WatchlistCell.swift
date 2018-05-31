//
//  WatchlistCell.swift
//  Cryptrack
//
//  Created by Bora A.  on 31.05.2018.
//  Copyright © 2018 Bora A. ONUR. All rights reserved.
//

import UIKit

class WatchlistCell: UITableViewCell {
    
    var pair = "BTC"
    @IBOutlet var icon: UIImageView!
    @IBOutlet var currencyNameLabel: UILabel!
    @IBOutlet var trend: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
