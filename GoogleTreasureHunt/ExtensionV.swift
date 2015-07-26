//
//  ExtensionV.swift
//  GoogleTreasureHunt
//
//  Created by Vincenzo Favara on 29/04/15.
//  Copyright (c) 2015 Vincenzo Favara. All rights reserved.
//

import UIKit
import Foundation

extension NSFileManager {
    //pragma mark - strip slashes
    
    class func stripSlashIfNeeded(stringWithPossibleSlash:String) -> String {
        var stringWithoutSlash:String = stringWithPossibleSlash
        // If the file name contains a slash at the beginning then we remove so that we don't end up with two
        if stringWithPossibleSlash.hasPrefix("/") {
            stringWithoutSlash = stringWithPossibleSlash.substringFromIndex(advance(stringWithoutSlash.startIndex,1))
        }
        // Return the string with no slash at the beginning
        return stringWithoutSlash
    }
    
    class func saveDataToDocumentsDirectory(fileData:NSData, path:String, subdirectory:String?) -> Bool
    {
        // Remove unnecessary slash if need
        var newPath = self.stripSlashIfNeeded(path)
        var newSubdirectory:String?
        if (subdirectory != nil) {
            newSubdirectory = self.stripSlashIfNeeded(subdirectory!)
        }
        // Create generic beginning to file save path
        var savePath = self.applicationDocumentsDirectory().path!+"/"
        
        if (newSubdirectory != nil) {
            savePath += newSubdirectory!
            self.createSubDirectory(savePath)
            savePath += "/"
        }
        
        // Add requested save path
        savePath += newPath
        
        println(savePath)
        // Save the file and see if it was successful
        var ok:Bool = NSFileManager.defaultManager().createFileAtPath(savePath,contents:fileData, attributes:nil)
        
        // Return status of file save
        return ok;
        
    }
    
    class func applicationDocumentsDirectory() -> NSURL {
        var documentsDirectory:String?
        var paths:[AnyObject] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true);
        if paths.count > 0 {
            if let pathString = paths[0] as? NSString {
                documentsDirectory = pathString as String
            }
        }
        return NSURL(fileURLWithPath: documentsDirectory!)!
    }
    
    class func applicationLibraryDirectory() -> NSURL {
        var libraryDirectory:String?
        var paths:[AnyObject] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.LibraryDirectory, NSSearchPathDomainMask.UserDomainMask, true);
        if paths.count > 0 {
            if let pathString = paths[0] as? NSString {
                libraryDirectory = pathString as String
            }
        }
        return NSURL(fileURLWithPath: libraryDirectory!)!
    }
    
    class func applicationSupportDirectory() -> NSURL {
        var applicationSupportDirectory:String?
        var paths:[AnyObject] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.ApplicationSupportDirectory, NSSearchPathDomainMask.UserDomainMask, true);
        if paths.count > 0 {
            if let pathString = paths[0] as? NSString {
                applicationSupportDirectory =  pathString as String
            }
        }
        return NSURL(fileURLWithPath: applicationSupportDirectory!)!
    }
    
    class func applicationTemporaryDirectory() -> NSURL {
        var temporaryDirectory:String? = NSTemporaryDirectory();
        return NSURL(fileURLWithPath: temporaryDirectory!)!
    }
    
    class func applicationCachesDirectory() -> NSURL {
        
        var cachesDirectory:String?
        
        var paths = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory,.UserDomainMask, true);
        
        if paths.count > 0 {
            if let pathString = paths[0] as? NSString {
                cachesDirectory = pathString as String
            }
        }
        return NSURL(fileURLWithPath: cachesDirectory!)!;
    }
    
    class func createSubDirectory(subdirectoryPath:NSString) -> Bool {
        var error:NSError?
        var isDir:ObjCBool=false;
        var exists:Bool = NSFileManager.defaultManager().fileExistsAtPath(subdirectoryPath as String, isDirectory:&isDir)
        if (exists) {
            /* a file of the same name exists, we don't care about this so won't do anything */
            if isDir {
                /* subdirectory already exists, don't create it again */
                return true;
            }
        }
        var success:Bool = NSFileManager.defaultManager().createDirectoryAtPath(subdirectoryPath as String, withIntermediateDirectories:true, attributes:nil, error:&error)
        
        if (error != nil) { println(error) }
        
        return success;
    }
    
    class func deleteFromDocumentsDirectory(subdirectoryOrFileName:String) -> Bool{
        // Remove unnecessary slash if need
        var newSubdirectory:String? = self.stripSlashIfNeeded(subdirectoryOrFileName)
        
        // Create generic beginning to file delete path
        var deletePath = self.applicationDocumentsDirectory().path!+"/"
        
        if (newSubdirectory != nil) {
            deletePath += newSubdirectory!
            var dir:ObjCBool=true
            if !NSFileManager.defaultManager().fileExistsAtPath(deletePath) {
                return false
            }
        }
        // Delete the file and see if it was successful
        var error:NSError?
        var isDelete : Bool = NSFileManager.defaultManager().removeItemAtPath(deletePath, error: &error)
        if (error != nil) {
            println(error)
        }
        return isDelete
    }
}

extension UIImageView {
    
    func downloadAsyncImage(urlStr:String){
        let url = NSURL(string: urlStr)
        
        let urlRequest = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            
            if error != nil {
                
                println(error)
                
            } else {
                
                if let bach = UIImage(data: data) {
                    
                    // self.image.image = bach
                    
                    var documentsDirectory:String?
                    
                    var paths:[AnyObject] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
                    
                    if paths.count > 0 {
                        
                        documentsDirectory = paths[0] as? String
                        
                        var savePath = documentsDirectory! + url!.lastPathComponent!
                        
                        NSFileManager.defaultManager().createFileAtPath(savePath, contents: data, attributes: nil)
                        
                        self.image = UIImage(named: savePath)
                        
                    }
                    
                }
                
                
            }
        }
    }
    
    func loadImage(url: NSURL, autoCache: Bool) {
        var urlId = url.hash
        
        var fileHandler = FileController()
        var cacheDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String //"Documents/cache/images/\(urlId)"
        var existFileData = fileHandler.readFile(cacheDir)
        
        if existFileData == nil {
            NSURLSession.sharedSession().dataTaskWithURL(url) {
                (data: NSData!, response: NSURLResponse!, error: NSError!) in
                if error == nil {
                    dispatch_async(dispatch_get_main_queue()) { self.image = UIImage(data: data) }
                }
                }.resume()
        } else {
            image = UIImage(data: existFileData!)
        }
    }
    
    class FileController {
        func writeFile(fileDir: String, fileContent: NSData) -> Bool {
            var filePath = NSHomeDirectory().stringByAppendingPathComponent(fileDir)
            
            return fileContent.writeToFile(filePath, atomically: true)
        }
        
        func readFile(fileDir: String) -> NSData? {
            var filePath = NSHomeDirectory().stringByAppendingPathComponent(fileDir)
            if let fileHandler = NSFileHandle(forReadingAtPath: filePath) {
                var fileData = fileHandler.readDataToEndOfFile()
                fileHandler.closeFile()
                return fileData
            } else {
                return nil
            }
        }
        
        func mkdir(fileDir: String) -> Bool {
            var filePath = NSHomeDirectory().stringByAppendingPathComponent(fileDir)
            return NSFileManager.defaultManager().createDirectoryAtPath(filePath, withIntermediateDirectories: true, attributes: nil, error: nil)
        }
    }
}

//Methods
func verifyUrl(urlString: String?) ->Bool{
    //Check for nil
    if let urlString = urlString{
        //Create NSURL instance
        if let url = NSURL(string: urlString){
            //Check if your application can open the NSURL instance
            if UIApplication.sharedApplication().canOpenURL(url){
                return true
            } else { return false }
        }else { return false }
    } else { return false }
}

//Static Class
class File {
    class func open (path: String, utf8: NSStringEncoding = NSUTF8StringEncoding) -> String? {
        var error: NSError?
        return NSFileManager().fileExistsAtPath(path) ? String(contentsOfFile: path, encoding: utf8, error: &error)! : nil
    }
    class func save (path: String, _ content: String, utf8: NSStringEncoding = NSUTF8StringEncoding) -> Bool {
        var error: NSError?
        return content.writeToFile(path, atomically: true, encoding: utf8, error: &error)
    }
}