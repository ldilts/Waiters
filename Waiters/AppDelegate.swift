//
//  AppDelegate.swift
//  Waiters
//
//  Created by Lucas Dilts on 2016-10-13.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        let fetchRequest: NSFetchRequest<Waiter> = Waiter.fetchRequest()
//        
//        do {
//            let results = try coreDataStack.managedObjectContext.fetch(fetchRequest)
//            
//            if results.count == 0 {
//                addTestData()
//            }
//        } catch {
//            fatalError("Error fetching data: \(error)")
//        }
        
        if let tab = window?.rootViewController as? UITabBarController {
            for child in tab.viewControllers ?? [] {
                if let child = child as? UINavigationController, let top = child.topViewController {
                    if top.responds(to: #selector(setter: AppDelegate.coreDataStack)) {
                        top.perform(#selector(setter: AppDelegate.coreDataStack), with: coreDataStack)
                    }
                }
            }
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.coreDataStack.saveMainContext()
    }

//    func addTestData() {
//        guard let waiterEntity = NSEntityDescription.entity(forEntityName: "Waiter", in: coreDataStack.managedObjectContext) else {
//            fatalError("Could not find entity descriptions")
//        }
//        
//        let aaron = Waiter(entity: waiterEntity, insertInto: coreDataStack.managedObjectContext)
//        aaron.name = "Aaron"
//        
//        let beatrice = Waiter(entity: waiterEntity, insertInto: coreDataStack.managedObjectContext)
//        beatrice.name = "Beatrice"
//        
//        let charles = Waiter(entity: waiterEntity, insertInto: coreDataStack.managedObjectContext)
//        charles.name = "Charles"
//        
//        coreDataStack.saveMainContext()
//    }
}

