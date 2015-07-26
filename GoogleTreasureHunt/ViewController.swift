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
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var goNext = false
    
    var boxView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named:"bg")?.drawInRect(self.view.bounds)
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        view.backgroundColor = UIColor(patternImage: image)
        
        addActivityIndicatorView()
        menageActivityIndicatorView()
        
        place.text = "Bugdroid is came to here!"
        
        controls()
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func controls() -> Bool{
        var isConnected = checkInternetConnection()
        if isConnected{
            
            if DataManager.sharedInstance.controlHuntOnline{
            
                if !DataManager.sharedInstance.isZipUnzipped(){
                    displayAlert("Hunt unavaible", error: "Do you want test it?")
                    return goNext
                } else{
                    goNextFunc()
                    return true
                }
            
            } else {
                //non deve fare nulla
            }
            
        } else{
            var alert = UIAlertView(title: "No connection", message: "Connect your device", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        return false
    }
    
    func displayAlert(title:String, error:String) {
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            HuntResourceManager.sharedInstance.testHunt()
            self.goNextFunc()
            } ))
        alert.addAction(UIAlertAction(title: "NO", style: .Default, handler: { action in
            self.dismissViewControllerAnimated(true, completion: nil)
        } ))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func goNextFunc(){
        goNext = true
        DataManager.sharedInstance.createHunt()
        place.text = "Bugdroid is came to " + DataManager.sharedInstance.hunt!.displayName + "!"
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
    
    func menageActivityIndicatorView(){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            if DataManager.sharedInstance.controlHuntOnline{
                self.boxView.removeFromSuperview()
            } else {
                self.menageActivityIndicatorView()
            }
        }
    }
    
    func addActivityIndicatorView() {
        // You only need to adjust this frame to move it anywhere you want
        boxView = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25, width: 180, height: 50))
        boxView.backgroundColor = UIColor.whiteColor()
        boxView.alpha = 0.8
        boxView.layer.cornerRadius = 10
        
        //Here the spinnier is initialized
        var activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityView.startAnimating()
        
        var textLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        textLabel.textColor = UIColor.grayColor()
        textLabel.text = "Loading hunt..."
        
        boxView.addSubview(activityView)
        boxView.addSubview(textLabel)
        
        view.addSubview(boxView)
    }
}

