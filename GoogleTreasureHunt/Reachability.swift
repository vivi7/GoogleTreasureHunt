//
//  Reachability.swift
//  GoogleTreasureHunt
//
//  Created by Vincenzo Favara on 20/05/15.
//  Copyright (c) 2015 Vincenzo Favara. All rights reserved.
//

import Foundation
public class Reachability {
    
    class func isConnectedToNetwork()->Bool{
        
        var urlString = "http://google.com/"
        
        var status:Bool = isValidUrlString(urlString)
        
        return status
    }
    
    class func isValidUrlString(urlString:String)->Bool{
        var status:Bool = false
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response: NSURLResponse?
        
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: nil) as NSData?
        
        if let httpResponse = response as? NSHTTPURLResponse {
            if httpResponse.statusCode == 200 {
                status = true
            }
        }
        return status
    }
}
