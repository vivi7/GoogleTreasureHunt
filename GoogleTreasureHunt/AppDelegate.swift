//
//  AppDelegate.swift
//  GoogleTreasureHunt
//
//  Created by Vincenzo Favara on 23/10/14.
//  Copyright (c) 2014 Vincenzo Favara. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //TODO: download and create Hunt and valuate the boolean
        let huntResourceManager:HuntResourceManager = HuntResourceManager()
        var downloadedZip: Bool = huntResourceManager.dounload()
        let hunt:Hunt = Hunt()
        hunt.createHunt()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.vivi.GoogleTreasureHunt" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("GoogleTreasureHunt", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("GoogleTreasureHunt.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }

    
    
    
    
    
    let fileManager = NSFileManager()
    
    func createFolderAtPath(path: String){
        
        var error:NSError?
        
        if fileManager.createDirectoryAtPath(path,
            withIntermediateDirectories: true,
            attributes: nil,
            error: &error) == false && error != nil{
                println("Failed to create folder at \(path), error = \(error!)")
        }
        
    }
    
    /* Creates 5 .txt files in the given folder, named 1.txt, 2.txt, etc */
    func createFilesInFolder(folder: String){
        
        for counter in 1...5{
            let fileName = NSString(format: "%lu.txt", counter)
            let path = folder.stringByAppendingPathComponent(fileName)
            let fileContents = "Some text"
            var error:NSError?
            if fileContents.writeToFile(path,
                atomically: true,
                encoding: NSUTF8StringEncoding,
                error: &error) == false{
                    if let theError = error{
                        println("Failed to save the file at path \(path)" +
                            " with error = \(theError)")
                    }
            }
        }
        
    }
    
    /* Enumerates all files/folders at a given path */
    func enumerateFilesInFolder(folder: String){
        
        var error:NSError?
        let contents = fileManager.contentsOfDirectoryAtPath(
            folder,
            error: &error)!
        
        if let theError = error{
            println("An error occurred \(theError)")
        } else if contents.count == 0{
            println("No content was found")
        } else {
            println("Contents of path \(folder) = \(contents)")
        }
        
    }
    
    /* Deletes all files/folders in a given path */
    func deleteFilesInFolder(folder: String){
        
        var error:NSError?
        let contents = fileManager.contentsOfDirectoryAtPath(folder,
            error: &error) as [String]
        
        if let theError = error{
            println("An error occurred = \(theError)")
        } else {
            for fileName in contents{
                let filePath = folder.stringByAppendingPathComponent(fileName)
                if fileManager.removeItemAtPath(filePath, error: nil){
                    println("Successfully removed item at path \(filePath)")
                } else {
                    println("Failed to remove item at path \(filePath)")
                }
            }
        }
        
    }
    
    /* Deletes a folder with a given path */
    func deleteFolderAtPath(path: String){
        
        var error:NSError?
        if fileManager.removeItemAtPath(path, error: &error){
            println("Successfully deleted the path \(path)")
        } else {
            if let theError = error{
                println("Failed to remove path \(path) with error \(theError)")
            }
        }
        
    }
    
    func saveObject(obj: AnyObject, path: String){
        NSKeyedArchiver.archiveRootObject(obj, toFile: path)
    }
    
    func loadObject(path: String) -> AnyObject?{
        return NSKeyedUnarchiver.unarchiveObjectWithFile(path)
    }
    
    /** Saves the player's progress */
    func saveData(data:NSMutableData, path:String){
        //TODO: verify instance fileManager starter
        //var fileManager = NSFileManager.defaultManager()
        if (!(fileManager.fileExistsAtPath(path)))
        {
            var bundle : NSString = NSBundle.mainBundle().pathForResource("data", ofType: "plist")!
            fileManager.copyItemAtPath(bundle, toPath: path, error:nil)
        }
        data.writeToFile(path, atomically: true)
    }
    
    /** Loads player progress. */
    func restoreData(path:String) -> NSDictionary {
        return NSDictionary(contentsOfFile: path)!
    }
    
}

