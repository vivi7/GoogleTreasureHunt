//
//  ViewController.swift
//  TreasureHunt
//
//  Created by Vincenzo Favara on 23/09/14.
//  Copyright (c) 2014 Vincenzo Favara. All rights reserved.
//

import UIKit
import Foundation


class ViewController: UIViewController{
    
    @IBOutlet var place: UILabel!
    
    var goNext = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named:"bg")?.drawInRect(self.view.bounds)
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        view.backgroundColor = UIColor(patternImage: image)
        
        place.text = "Bugdroid is came to here!"
        
        controls()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func controls() -> Bool{
        var isConnected = checkInternetConnection()
        println(DataManager.sharedInstance.zipDownloaded)
        println(DataManager.sharedInstance.zipDownloading)
        if isConnected{
            if DataManager.sharedInstance.zipDownloaded == true && DataManager.sharedInstance.zipDownloading == false{
                goNext = true
                DataManager.sharedInstance.createHunt()
                place.text = "Bugdroid is came to " + DataManager.sharedInstance.hunt!.displayName + "!"
                return true
            } else{
                println("Zip not downloaded")
                var alert = UIAlertView(title: "No Hunt avaible", message: "Retry later", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
        }
        return false
    }
    
    func checkInternetConnection() -> Bool{
        var isConnected = Reachability.isConnectedToNetwork()
        if isConnected == true {
            println("Internet connection OK")
        } else {
            println("Internet connection FAILED")
            var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        return isConnected
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        println(segue.identifier)
//        let controller = segue.destinationViewController as! UIViewController
//    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject?) -> Bool {
        return controls()
    }
}

