//
//  AppDelegate.swift
//  Cryptrack
//
//  Created by Bora A.  on 31.05.2018.
//  Copyright © 2018 Bora A. ONUR. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        print("x")
        // checking if we've created first and only Watchlist
        let request: NSFetchRequest<Watchlist> = Watchlist.fetchRequest()
        if let watchlist = try? persistentContainer.viewContext.fetch(request) {
            print("y")
            if watchlist.isEmpty {
                print("z")
                let watchlist = Watchlist(context: persistentContainer.viewContext)
                watchlist.id = "1"
                try? persistentContainer.viewContext.save()
            }
        }
        
        
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        self.saveContext()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModal")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

