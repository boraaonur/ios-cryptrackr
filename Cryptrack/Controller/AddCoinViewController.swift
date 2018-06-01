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
    lazy var itemsToDelete = [Currency]()
    var filteredArray: [Currency] = [Currency]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
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
        request.predicate = NSPredicate(format: "inWatchlist == %@", "0")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        if let currencies = try? context.fetch(request) {
            for currency in currencies {
                currencyArray.append(currency)
            }
        }
    }
    
    func getWatchlistCurrencyCount() -> Int16 {
        var count: Int16 = 0
        let request: NSFetchRequest<Currency> = Currency.fetchRequest()
        request.predicate = NSPredicate(format: "inWatchlist == %@", "1")
        if let currencies = try? context.fetch(request) {
            for _ in currencies {
                count += 1
            }
        }
        return count
    }
}

extension AddCoinViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = currencyArray[indexPath.row].name
        
        if currencyArray[indexPath.row].inWatchlist {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        // Refactor this
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
            // delete from watchlist
            currencyArray[indexPath.row].setValue(false, forKey: "inWatchlist")
            currencyArray[indexPath.row].setValue(nil, forKey: "index")
        } else {
            cell?.accessoryType = .checkmark
            currencyArray[indexPath.row].setValue(true, forKey: "inWatchlist")
            currencyArray[indexPath.row].setValue(getWatchlistCurrencyCount(), forKey: "index")
            print("item added to index \(getWatchlistCurrencyCount())")

        }
        try? context.save()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
}


extension AddCoinViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currencyArray.removeAll() // this allows update on deletion
        loadCurrencies()
        if searchBar.text?.isEmpty == false {
            currencyArray = currencyArray.filter({ (currency) -> Bool in
                let currencyName = currency.name?.lowercased()
                let result = currencyName?.range(of: searchText.lowercased())
                return result != nil
            })
        } else {
            loadCurrencies()
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        currencyArray.removeAll()
        loadCurrencies()
        tableView.reloadData()
    }
    
}
