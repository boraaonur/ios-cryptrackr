//
//  WatchlistViewController.swift
//  Cryptrack
//
//  Created by Bora A.  on 31.05.2018.
//  Copyright © 2018 Bora A. ONUR. All rights reserved.
//

import UIKit
import CoreData

class WatchlistViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var watchlistCurrencies = [Currency]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 44
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadWatchlistCurrencies()
        tableView.reloadData()
    }
    
    @IBAction func addClicked(_ sender: UIBarButtonItem) {
        //
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetailVC", sender: nil)
    }
    
    func loadWatchlistCurrencies() {
        let watchlist = fetchWatchlist()
        let request: NSFetchRequest<Currency> = Currency.fetchRequest()
        request.predicate = NSPredicate(format: "watchlist.id MATCHES %@", (watchlist.id)!)
        do {
            watchlistCurrencies = try context.fetch(request)
        } catch {
            print("Error reading context")
        }
    }
    
    func fetchWatchlist() -> Watchlist {
        let request: NSFetchRequest<Watchlist> = Watchlist.fetchRequest()
        let watchlist = try? context.fetch(request)
        return watchlist![0]
    }
}

// MARK: - Table view data source
extension WatchlistViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchlistCurrencies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WatchlistCell
        cell.textLabel?.text = watchlistCurrencies[indexPath.row].name
        return cell
    }
}
