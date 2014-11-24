//
//  HuntResourceManager.swift
//  TreasureHunt
//
//  Created by Vincenzo Favara on 25/09/14.
//  Copyright (c) 2014 Vincenzo Favara. All rights reserved.
//

import Foundation

class HuntResourceManager {
    
    //let urlPath = "http://162.248.167.159:8080/zip/hunt.zip"
    let urlPath = "192.168.1.4:8080/hunt.zip" //per provare attivare il servizio web da Server
    let nameHuntZip = "hunt.zip"
    let nameJSON = "sampleHunt.json"
    var jsonDictionary:NSDictionary!
    var jsonString:String!
    
    init(){
        
    }
    
    func unzipFile() {
        //TODO: unzip file
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        var path = paths.stringByAppendingPathComponent(nameHuntZip)
        var destination = paths.stringByAppendingPathComponent("hunt/")
        
        //var zip: SSZipArchive = SSZipArchive()
        
        //zip.unzipFileAtPath:path toDestination:destination
        
        //let zipPath = globalFileStrucure.stringByAppendingPathComponent("zipfile.zip")
        //data.writeToFile(zipPath, options: nil, error: &error)
        
        let unZipped = SSZipArchive.unzipFileAtPath(path, toDestination: destination)
    }
    
    func getJSon() -> NSDictionary {
        // /Users/vivi/Library/Developer/CoreSimulator/Devices/B1950C18-0792-4D3D-B0B4-63C9B80913F2/data/Containers/Data/Application/4CDBA951-B55E-4558-A47F-218234C1360A/Documents
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        var path = paths.stringByAppendingPathComponent(nameJSON)
        
        let data  =   NSData(contentsOfFile: path)
        
        var error: NSErrorPointer = nil
        jsonDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: error) as NSDictionary
        
        if(error != nil) {
            // If there is an error parsing JSON, print it to the console
            println("JSON Error \(error.debugDescription)")
        }
        // let results: NSArray = jsonDictionary["results"] as NSArray  //example to get a part
        return jsonDictionary
    }
    
    func getJSonString() -> String {
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        var path = paths.stringByAppendingPathComponent(nameJSON)
        
        let data  =   NSData(contentsOfFile: path)
        
        jsonString =   NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil) as String
        return jsonString
    }
    
    var pathUrl: NSURL {
        let folder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let path = folder.stringByAppendingPathComponent(nameHuntZip)
        let url = NSURL(fileURLWithPath: path)
        return url!
    }
    
    func dounload() -> Bool {
        //var downloadesZip:Bool = false
        let url: NSURL = NSURL(string: urlPath)!
        var request = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
/*        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            println("Task completed")
            if(error != nil) {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
                downloadesZip = false
            } else {
                downloadesZip = true
            }
        })
        task.resume()
        
        let task1 = session.dataTaskWithURL(url)
        task1.resume()
        
        var task2:NSURLSessionDownloadTask = session.downloadTaskWithURL(url)
        task2.resume()
*/
        var task3 = session.downloadTaskWithRequest(request, completionHandler: {
                response, localfile, error in
                println("response \(response)")
        })
        task3.resume()
        //sdownloadZip()
        return false //downloadesZip
    }
    
    func downloadZip(){
        
        var downloadesZip:Bool = false
        let url: NSURL = NSURL(string: urlPath)!
        
        func completionHandler(response: NSURLResponse!, data: NSData!, error: NSError!) ->() {
            
            assert(error == nil,"Download Error")
        }
        
        NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: url), queue: NSOperationQueue(), completionHandler:completionHandler)
    }
    
}
