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
    
    //let driveService : GTLService =  GTLService()
    /*
    let kKeychainItemName : NSString = "Google Plus Quickstart"
    let kClientID : NSString = "208944949242-3nv46f8d2priu2p4su9kj1sdruekah56.apps.googleusercontent.com"
    let kClientSecret : NSString = "4LCknQQmdH_Oa_Kx28Ufgh2f"
    
    
    var num : Int = 0;
    */
    
    @IBOutlet var place: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataManager.sharedInstance.createHunt()
        
        let intro = "Bugdroid is came to "
        
        place.text = intro + DataManager.sharedInstance.hunt!.displayName
        DataManager.sharedInstance.startTimer()
        //For google login
        //  driveService = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychainForName(kKeychainItemName,
        //    clientID: kClientID,
        //  clientSecret: kClientSecret)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

