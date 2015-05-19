//
//  SigninViewController.swift
//  TreasureHunt
//
//  Created by Vincenzo Favara on 12/10/14.
//  Copyright (c) 2014 Vincenzo Favara. All rights reserved.
//

/*
import UIKit

class SigninViewController: UIViewController, GPGStatusDelegate{


    let kKeychainItemName : NSString = "Google Plus Quickstart"
    let kClientID : NSString = "654730014935-fdvoquqm5dvv38n328n23pbkfvlqm8c7.apps.googleusercontent.com"
    let kClientSecret : NSString = "L2k8JgaAqzeYbTJXK1Zxhds6"
    var gService : GTLService =  GTLService()
    
    @IBOutlet weak var signInButton: UIButton!;
    @IBOutlet weak var statusText: UITextView!;
    @IBOutlet weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GPGManager.sharedInstance().statusDelegate = self;
        statusText.text = "Initialized...";
        updateUI();
    }
    
    @IBAction func signInClicked(sender: AnyObject) {
        GPGManager.sharedInstance().signInWithClientID(kClientID, silently: false);
    }
    @IBAction func signOutClicked(sender: AnyObject) {
        GPGManager.sharedInstance().signOut();
        updateUI();
    }
    
    func didFinishGamesSignInWithError(error: NSError!) {
        updateUI();
        if (error != nil) {
            statusText.text = "ERROR:" + error.description;
        } else {
            statusText.text = "Signed in: " + GPGManager.sharedInstance().description;
        }
    }
    
    func didFinishGamesSignOutWithError(error: NSError!) {
        updateUI();
    }
    
    func didFinishGoogleAuthWithError(error: NSError!) {
        updateUI();
    }
    
    func updateUI() {
        var isSignedIn = GPGManager.sharedInstance().signedIn;
        signInButton.enabled = !isSignedIn;
        signOutButton.enabled = isSignedIn;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
*/
