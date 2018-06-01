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
    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet var navigationBar: UINavigationItem!
    let bittrexClient = BittrexClient.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 44
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadWatchlistCurrencies()
        tableView.reloadData()
        for i in watchlistCurrencies {
            if i.icon == nil {
                bittrexClient.downloadLogo(currency: i, completion: {
                    self.loadWatchlistCurrencies()
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                })
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetailVC", sender: nil)
    }
    
    func loadWatchlistCurrencies() {
        watchlistCurrencies.removeAll()
        let request: NSFetchRequest<Currency> = Currency.fetchRequest()
        request.predicate = NSPredicate(format: "inWatchlist == %@", "1")
        request.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
        do {
            watchlistCurrencies = try context.fetch(request)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Error reading context")
        }
    }
    
    @objc func enterEditMode(sender: UILongPressGestureRecognizer) {
        if sender.state ==  UIGestureRecognizerState.began {
            tableView.setEditing(true, animated: true)
            let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(doneClicked))
            navigationBar.rightBarButtonItem = doneButton
        }
    }
    
    @objc func doneClicked(sender: UIBarButtonItem) {
        tableView.setEditing(false, animated: true)
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addClicked))
        navigationBar.rightBarButtonItem = addButton
    }
    
    @objc func addClicked() {
        performSegue(withIdentifier: "goToAddCoinVC", sender: nil)
    }
    
    @IBAction func addButtonClicked(_ sender: UIBarButtonItem) {
        addClicked()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetailVC" {
            let destination = segue.destination as! DetailViewController
            let indexPath = tableView.indexPathForSelectedRow!
            destination.currency = watchlistCurrencies[indexPath.row]
        }
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
        cell.currencyNameLabel.text = watchlistCurrencies[indexPath.row].name
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(enterEditMode))
        longPressGestureRecognizer.numberOfTouchesRequired = 1
        longPressGestureRecognizer.numberOfTapsRequired = 0
        longPressGestureRecognizer.minimumPressDuration = 1
        cell.addGestureRecognizer(longPressGestureRecognizer)
        
        bittrexClient.getLastPrice(watchlistCurrencies[indexPath.row]) { (lastPrice) in
            DispatchQueue.main.async {
                cell.priceLabel.text = String(lastPrice)
            }
        }
        
        cell.loadingIndicator.startAnimating()
        if let data = watchlistCurrencies[indexPath.row].icon {
            DispatchQueue.main.async {
                 cell.icon.image = UIImage(data: data)
                    cell.loadingIndicator.stopAnimating()
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = watchlistCurrencies[sourceIndexPath.row]
        
        // Change index visually
        watchlistCurrencies.remove(at: sourceIndexPath.row)
        watchlistCurrencies.insert(movedObject, at: destinationIndexPath.row)
        
        // Update CoreData
        var updatedIndex: Int16 = 0
        for currency in watchlistCurrencies {
            currency.index = updatedIndex
            updatedIndex += 1
        }
        try? context.save()
        loadWatchlistCurrencies()
        NSLog("%@", "\(sourceIndexPath.row) => \(destinationIndexPath.row)")
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            watchlistCurrencies[indexPath.row].setValue(false, forKey: "inWatchlist")
            try? context.save()
            loadWatchlistCurrencies()
        }
    }

}
