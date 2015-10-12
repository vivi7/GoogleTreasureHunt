//
//  WelcomeViewController.swift
//  GoogleTreasureHunt
//
//  Created by Vincenzo Favara on 22/05/15.
//  Copyright (c) 2015 Vincenzo Favara. All rights reserved.
//

import UIKit
import Foundation
import MBProgressHUD

class WelcomeViewController: UIViewController {

    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var boxView = UIView()
    
    var controlOK = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.hidden = true
        view.backgroundColor = UIColor.getFitPatternBackgroungImage("bg", container: self.view)
        
        controls()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return controls()
    }
    
    func controls() -> Bool{
        if !DataManager.sharedInstance.huntIsReady(){
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.labelText = "Loading Hunt..."
            if Reachability.isConnectedToNetwork() {
                
                let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                dispatch_async(queue, {
                    
                    DataManager.sharedInstance.downloadHuntZip(false)
                    if DataManager.sharedInstance.controlHuntOnline {
                        self.goNextFunc()
                    } else {
                        self.displayAlert("Hunt unavaible", error: "Do you want test it?")
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        //<code to update UI elements>
                        MBProgressHUD.hideHUDForView(self.view, animated: true)
                    })
                })
                
            } else{
                self.displayAlert("No connection", error: "Do you want test it?")
            }
        }
        return controlOK
    }

    func goNextFunc(){
        controlOK = true
        DataManager.sharedInstance.createHunt()
    }
    
    func displayAlert(title:String, error:String){
        let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "No", style: .Default, handler: { action in
            self.dismissViewControllerAnimated(true, completion: nil)
        } ))
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            DataManager.sharedInstance.testHunt()
            self.goNextFunc()
            self.shouldPerformSegueWithIdentifier("", sender: "")
        } ))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
