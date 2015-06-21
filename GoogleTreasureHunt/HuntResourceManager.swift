//
//  HuntResourceManager.swift
//  TreasureHunt
//
//  Created by Vincenzo Favara on 25/09/14.
//  Copyright (c) 2014 Vincenzo Favara. All rights reserved.
//

import Foundation
import Alamofire

class HuntResourceManager {
    
    // MARK: - Singleton
    //***** CODICE SPECIALE CHE TRASFORMA QUESTA CLASSE IN UN SINGLETON (snippet sw_sgt)*****\\
    class var sharedInstance:HuntResourceManager {
        get {
            struct Static {
                static var instance : HuntResourceManager? = nil
                static var token : dispatch_once_t = 0
            }
            
            dispatch_once(&Static.token) { Static.instance = HuntResourceManager() }
            
            return Static.instance!
        }
    }
    //***** FINE CODICE SPECIALE *****\\
    
    
    //let urlPath = "http://192.168.1.3:8089/hunt.zip" //per provare attivare il servizio web da Server
    let urlPath = "http://162.248.167.159:8080/zip/hunt.zip"
    let nameHuntZip = "hunt.zip"
    let nameJSON = "sampleHunt.json"
    var jsonDictionary:NSDictionary!
    var jsonString:String!
    
    
    init(){
        
    }

    func download() -> Bool{
        var isDownloaded = false
        var fileName: String?
        var finalPath: NSURL?
        
        let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
        Alamofire.download(.GET, urlPath, destination)
            .progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
                println(totalBytesRead)
            }
            .response { (request, response, data, error) in
                if error != nil {
                    println("REQUEST: \(request)")
                    println("RESPONSE: \(response)")
                    isDownloaded = false
                } else {
                    isDownloaded = true
                    let fileUrl = NSFileManager.applicationDocumentsDirectory().URLByAppendingPathComponent(response!.suggestedFilename!)
                    data?.writeToURL(fileUrl, atomically: true, encoding: 1, error: nil)
                }
        }
        println(isDownloaded)
        
        return isDownloaded
    }
    
    func downloadZip(){
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue, {
            //<code to load/prepare images>
            println("->downloadZip() server: " + self.urlPath)
            if Reachability.isValidUrlString(self.urlPath){
                println("OK------------------" + self.urlPath)
                let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: self.urlPath)!, completionHandler: {(data, response, error) in
                    println("Task completed")
                    let fileUrl = NSFileManager.applicationDocumentsDirectory().URLByAppendingPathComponent(response!.suggestedFilename!)
                    data.writeToURL(fileUrl, atomically: true)
                    DataManager.sharedInstance.zipDownloaded = true
                    DataManager.sharedInstance.zipDownloading = false
                    println(data?.bytes)
                })
                task.resume()
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                //<code to update UI elements>
            })
        })
    }
    
    func createHunt(){
        
        self.unzipFile()
        DataManager.sharedInstance.hunt = Hunt()
        DataManager.sharedInstance.hunt!.createHunt()
        DataManager.sharedInstance.salvaHunt()
        
        //DataManager.sharedInstance.printHunt()
    }
    
    func getDestinationHuntFolder() -> String{
        var paths = NSFileManager.applicationDocumentsDirectory().path!
        var destination = paths.stringByAppendingPathComponent(DataManager.sharedInstance.containerFolder) + "/"
        
        return destination
    }
    
    func getNameClueImage(name:String) -> String{
        return getDestinationHuntFolder() + name
    }
    
    func unzipFile() {
        var paths = NSFileManager.applicationDocumentsDirectory().path!
        var path = paths.stringByAppendingPathComponent(nameHuntZip)
        var destination = paths//.stringByAppendingPathComponent(DataManager.sharedInstance.containerFolder)
        
        let unZipped = SSZipArchive.unzipFileAtPath(path, toDestination: destination)
    }
    
    func getJsonData() -> NSData{
        var path = NSFileManager.applicationDocumentsDirectory().path!.stringByAppendingPathComponent(DataManager.sharedInstance.containerFolder+nameJSON)
        
        let data = NSData(contentsOfFile: path)
        
        return data!
    }
    
    //metodo alternativo che scarica e converte in JSON direttamente
    func downloadJson(){
        Alamofire.request(.GET, urlPath)
            .responseJSON { (req, res, json, error) in
                if(error != nil) {
                    NSLog("Error: \(error)")
                    println(req)
                    println(res)
                }
                else {
                    NSLog("Success: \(self.urlPath)")
                    var json = JSON(json!)
                }
        }
    }
}
