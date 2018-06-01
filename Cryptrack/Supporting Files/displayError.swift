//
//  displayError.swift
//  Cryptrack
//
//  Created by Bora A.  on 1.06.2018.
//  Copyright © 2018 Bora A. ONUR. All rights reserved.
//

import UIKit

extension UIViewController {
    func displayError(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}
