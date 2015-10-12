//
//  HuntResourceManager.swift
//  TreasureHunt
//
//  Created by Vincenzo Favara on 25/09/14.
//  Copyright (c) 2014 Vincenzo Favara. All rights reserved.
//

import Foundation

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
    
    //ATTENZIONE: non usare dropbox
    //let urlPath = "http://192.168.1.3:8089/hunt.zip" //per provare attivare il servizio web da Server
    let urlPaths = ["http://162.248.167.159:8080/zip/hunt.zip","http://162.219.7.211/resources/hunt.zip"]
    let nameHuntZip = "hunt.zip"
    let nameHuntfolder = "hunt.zip"
    let nameJSON = "sampleHunt.json"
    var jsonDictionary:NSDictionary!
    var jsonString:String!
    
    var huntIsReady = false
    
    init(){
        
    }
    
    func downloadZipDispatched(){
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue, {
            self.downloadZip()
            dispatch_async(dispatch_get_main_queue(), {
                //<code to update UI elements>
            })
        })
    }
    
    func downloadZip(){
        for urlPath in self.urlPaths{
            myPrintln("->downloadZip() server: " + urlPath + " \n\n")
            if Reachability.isValidUrlString(urlPath){
                myPrintln("SERVER UP: " + urlPath)
                let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: urlPath)!, completionHandler: {(data, response, error) in
                    myPrintln("Task completed")
                    let fileUrl = NSFileManager.applicationDocumentsDirectory().URLByAppendingPathComponent(response!.suggestedFilename!)
                    DataManager.sharedInstance.controlHuntOnline = true
                    data!.writeToURL(fileUrl, atomically: true)
                    print(data?.bytes)
                })
                task.resume()
            } else {
                myPrintln("SERVER DOWN: " + urlPath)
            }
        }
        self.unzipFile()
    }
    
    func testHunt(){
        let paths = NSFileManager.applicationDocumentsDirectory().path!
        
        let bundle = NSBundle.mainBundle()
        let path = bundle.pathForResource("hunt", ofType: "zip")
        
        myPrintln("servers down: testHunt() start")
        SSZipArchive.unzipFileAtPath(path, toDestination: paths)
    }
    
    func createHunt(){
        
        self.unzipFile()
        DataManager.sharedInstance.hunt = Hunt()
        DataManager.sharedInstance.hunt!.createHunt()
        DataManager.sharedInstance.salvaHunt()
        
        huntIsReady = true
        //DataManager.sharedInstance.printHunt()
    }
    
    func getDestinationHuntFolder() -> String{
        let paths = NSFileManager.applicationDocumentsDirectory().path!
        let destination = (paths as NSString).stringByAppendingPathComponent(DataManager.sharedInstance.containerFolder) + "/"
        
        return destination
    }
    
    func getNameClueImage(name:String) -> String{
        return getDestinationHuntFolder() + name
    }
    
    func unzipFile() {
        let paths = NSFileManager.applicationDocumentsDirectory().path!
        //var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        //        return paths[0] as String
        let path = (paths as NSString).stringByAppendingPathComponent(nameHuntZip)
        let destination = paths
        SSZipArchive.unzipFileAtPath(path, toDestination: destination)
    }
    
    func getJsonData() -> NSData{
        let path = (NSFileManager.applicationDocumentsDirectory().path! as NSString).stringByAppendingPathComponent(DataManager.sharedInstance.containerFolder+nameJSON)
        
        let data = NSData(contentsOfFile: path)
        
        return data!
    }
    
    func downloadZipFromFTPConnection(url:String)
    {
        var url: CFStringRef
        url = "Test" as NSString
        var requestURL: CFURLRef
        requestURL = CFURLCreateWithString(kCFAllocatorDefault, url, nil);
        
        let ftpStream = CFReadStreamCreateWithFTPURL(kCFAllocatorDefault, requestURL).takeRetainedValue()
        
        CFReadStreamOpen(ftpStream)
        
        var numBytesRead = 0
        let bufSize = 4096
        var buf = [UInt8](count: bufSize, repeatedValue: 0)
        
        repeat{
            numBytesRead = CFReadStreamRead(ftpStream, &buf, bufSize)
        } while( numBytesRead > 0 );
        
        
        CFReadStreamClose(ftpStream)
        
        let data = NSData(bytes: buf, length: bufSize)
        let paths = NSFileManager.applicationDocumentsDirectory().path!
        let path = (paths as NSString).stringByAppendingPathComponent(nameHuntZip)
        do {
            try data.writeToFile(path, options: NSDataWritingOptions.DataWritingAtomic)
        } catch {
            print("Error to write file at path:\(path)")
        }
    }
}
