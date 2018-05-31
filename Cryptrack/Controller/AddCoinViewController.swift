//
//  AddCoinViewController.swift
//  Cryptrack
//
//  Created by Bora A.  on 31.05.2018.
//  Copyright © 2018 Bora A. ONUR. All rights reserved.
//

import UIKit
import CoreData

class AddCoinViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    let bittrexClient = BittrexClient.shared
    var currencyArray: [Currency] = [Currency]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadCurrencies()
        print("downloaded from coredata")
        if currencyArray.count == 0 {
            bittrexClient.getCoins {
                print("downloading from zero")
                self.loadCurrencies()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
    }

    func loadCurrencies() {
        let request: NSFetchRequest<Currency> = Currency.fetchRequest()
        if let currencies = try? context.fetch(request) {
            for currency in currencies {
                currencyArray.append(currency)
            }
        }
    }
}

extension AddCoinViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = currencyArray[indexPath.row].name
        return cell
    }
}
