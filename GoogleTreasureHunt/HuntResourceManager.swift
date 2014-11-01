//
//  HuntResourceManager.swift
//  TreasureHunt
//
//  Created by Vincenzo Favara on 25/09/14.
//  Copyright (c) 2014 Vincenzo Favara. All rights reserved.
//

import Foundation

class HuntResourceManager {
    
    let urlPath = "http://162.248.167.159:8080/zip/hunt.zip"
    var jsonDictionary:NSDictionary!
    var jsonString:String!
    
    init(){
        
    }
    
    func unzipFile() {
        //TODO: unzip file
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        var path = paths.stringByAppendingPathComponent("hunt.zip")
        var destination = paths.stringByAppendingPathComponent("hunt/")
        
        //var zip: SSZipArchive = SSZipArchive()
        
        //zip.unzipFileAtPath:path toDestination:destination
    }
    
    func getJSon() -> NSDictionary {
        var err: NSError?
        
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        var path = paths.stringByAppendingPathComponent("sampleHunt.json")
        
        let data  =   NSData(contentsOfFile: path)
        jsonDictionary =   NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(0), error: nil) as NSDictionary
        
        if(err != nil) {
            // If there is an error parsing JSON, print it to the console
            println("JSON Error \(err!.localizedDescription)")
        }
        // let results: NSArray = jsonDictionary["results"] as NSArray  //example to get a part
        return jsonDictionary
    }
    
    func getJSonString() -> String {
        var err: NSError?
        
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        var path = paths.stringByAppendingPathComponent("sampleHunt.json")
        
        let data  =   NSData(contentsOfFile: path)
        jsonString =   NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(0), error: nil) as String
        return jsonString
    }
    
    func dounload() -> Bool {
        var downloadesZip:Bool?
        let url: NSURL = NSURL(string: urlPath)!
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
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
        return downloadesZip!
    }

}
