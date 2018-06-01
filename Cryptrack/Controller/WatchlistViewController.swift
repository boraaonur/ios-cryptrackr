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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 44
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadWatchlistCurrencies()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // performSegue(withIdentifier: "goToDetailVC", sender: nil)
    }
    
    func loadWatchlistCurrencies() {
        let request: NSFetchRequest<Currency> = Currency.fetchRequest()
        request.predicate = NSPredicate(format: "inWatchlist == %@", "1")
        do {
            print("test")
            watchlistCurrencies = try context.fetch(request)
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
    
    @objc func addClicked(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToAddCoinVC", sender: nil)
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
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(enterEditMode))
        longPressGestureRecognizer.numberOfTouchesRequired = 1
        longPressGestureRecognizer.numberOfTapsRequired = 0
        longPressGestureRecognizer.minimumPressDuration = 2
        cell.addGestureRecognizer(longPressGestureRecognizer)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = watchlistCurrencies[sourceIndexPath.row]
        watchlistCurrencies.remove(at: sourceIndexPath.row)
        watchlistCurrencies.insert(movedObject, at: destinationIndexPath.row)
        NSLog("%@", "\(sourceIndexPath.row) => \(destinationIndexPath.row)")
        // To check for correctness enable: self.tableView.reloadData()
    }
}
