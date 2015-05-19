//
//  ImageManager.swift
//  Spesami
//
//  Created by Vincenzo Favara on 23/01/15.
//  Copyright (c) 2015 Vincenzo Favara (VinSoft). All rights reserved.
//

import Foundation
import UIKit
 
 
public typealias ImageInitCompletion = (image:UIImage?, error: NSError?)->()
public typealias DownloadCompletion = (data:NSData?, error: NSError?)->()
 
public class ImageManager {
    //NOTE: Evidently, Comp URLs are returned URL escaped but thumb URLs are not
    private class var imageCache: NSCache {
        struct Static {
            static var instance: NSCache?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = NSCache()
        }
        return Static.instance!
    }
 
    public class func getImage(urlString:String, encodeURL:Bool = false, completionHandler:ImageInitCompletion) {
        showNetworkActivity()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), {
            var image:UIImage?
            var returnError:NSError?
            let url = encodeURL ? self.urlEncode(urlString) : urlString
 
            if let cachedImage = self.imageCache.objectForKey(url) as? UIImage {
                image = cachedImage
            }
 
            if let data = self.fetchDataSyncronously(url) {
                image = UIImage(data: data)
                if image != nil {
                    self.imageCache.setObject(image!, forKey: url)
                }
            }
 
            if image == nil {
                returnError = NSError(domain:"Error not loaded", code:0, userInfo:nil)
            }
 
            self.hideNetworkActivity()
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(image:image,error:returnError)
            })
        })
    }
 
    private class func fetchDataSyncronously(url:String) -> NSData? {
        var URLObject: NSURL = NSURL(string:url)!
        var request: NSURLRequest = NSURLRequest(URL: URLObject)
        var urlConnection: NSURLConnection = NSURLConnection(request: request, delegate: self)!
        var response: NSURLResponse?
        var error:NSError?
        return NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&error)
    }
 
    private class func urlEncode(url:String) -> String {
        var raw: NSString = url
        var str = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,raw,"[].","|",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding))
        return str as NSString as String
    }
 
    private class func showNetworkActivity() {
        dispatch_async(dispatch_get_main_queue()) {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        }
    }
 
    private class func hideNetworkActivity() {
        dispatch_async(dispatch_get_main_queue()) {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
}

func resizeImageToIcon64(image:UIImage) -> UIImage {
    let newSize:CGSize = CGSize(width: 64,height: 64)
    //let size = CGSizeApplyAffineTransform(image.size, CGAffineTransformMakeScale(0.5, 0.5))
    return resizeImage(image, newSize)
}

func resizeImage(image:UIImage, newSize:CGSize) -> UIImage {
    let rect = CGRectMake(0,0, newSize.width, newSize.height)
    let hasAlpha = false
    let scale: CGFloat = 0.0 // Automatically use scale factor of main screen //first 1.0
    
//    image.drawInRect(CGRect(origin: CGPointZero, size: size))    
    UIGraphicsBeginImageContextWithOptions(newSize, hasAlpha, scale)
    image.drawInRect(rect)
    
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
}



