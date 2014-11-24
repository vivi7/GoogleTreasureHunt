//
//  ViewController.swift
//  TreasureHunt
//
//  Created by Vincenzo Favara on 23/09/14.
//  Copyright (c) 2014 Vincenzo Favara. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation


class ViewController: UIViewController , DetailsDelegate, AVCaptureMetadataOutputObjectsDelegate {
    
    //@IBOutlet var currentPoint : UILabel!
    
    @IBOutlet var clueImage : UIImageView!
    
    @IBOutlet var tagImage1 : UIImageView!
    
    @IBOutlet var tagImage2 : UIImageView!
    
    @IBOutlet var currentClue : UILabel!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet var labelInstruction: UILabel!
    
    var stringValueQrCode:String = ""
    
    var hunt : Hunt!
    
    //let driveService : GTLService =  GTLService()
    /*
    let kKeychainItemName : NSString = "Google Plus Quickstart"
    let kClientID : NSString = "208944949242-3nv46f8d2priu2p4su9kj1sdruekah56.apps.googleusercontent.com"
    let kClientSecret : NSString = "4LCknQQmdH_Oa_Kx28Ufgh2f"
    
    
    var num : Int = 0;
    */
    
    func labelDelegateMethodWithString(string: String) {
        label.text = string
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let controller = segue.destinationViewController as QrViewController
        controller.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Treasure Hunt"
        //currentPoint.text = self.title
        
        var hunt:Hunt = Hunt()
        var currentClue:Clue = hunt.getCurrentClue()!
        clueImage.image = UIImage(named:currentClue.displayImage)
        
        
        
        //For google login
        //  driveService = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychainForName(kKeychainItemName,
        //    clientID: kClientID,
        //  clientSecret: kClientSecret)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func callListClues(){
        self.performSegueWithIdentifier("listViewControllerSegue", sender: self)
    }
    
    @IBAction func callScan(buttonTapped: UIButton){
        //self.performSegueWithIdentifier("qrViewControllerSegue", sender: self)
        //currentClue.text = "Scan Qr Code "
        
        self.view.backgroundColor = UIColor.grayColor()
        currentClue = UILabel(frame:CGRectMake(15, 80, 290, 50))
        currentClue.backgroundColor = UIColor.clearColor()
        currentClue.numberOfLines = 2
        currentClue.textColor = UIColor.whiteColor()
        self.view.addSubview(currentClue)
        let imageView = UIImageView(frame:CGRectMake(10, 140, 300, 300))
        imageView.image = UIImage(named:"pick_bg")
        self.view.addSubview(imageView)
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        let item0 = UIBarButtonItem(image:(UIImage(named:"back.png")), style:(UIBarButtonItemStyle.Bordered), target:self, action:(Selector("backClick")))
        let item1 = UIBarButtonItem(image:(UIImage(named:"ocr_flash-off.png")), style:(UIBarButtonItemStyle.Bordered), target:self, action:(Selector("turnTorchOn")))
        let item2 = UIBarButtonItem(image:(UIImage(named:"ocr_albums.png")), style:(UIBarButtonItemStyle.Bordered), target:self, action:(Selector("pickPicture")))
        let flexibleSpaceItem = UIBarButtonItem(barButtonSystemItem : (UIBarButtonSystemItem.FlexibleSpace), target: self, action: nil)
        toolBar.items = [item0,flexibleSpaceItem,item2,flexibleSpaceItem, item1]
        toolBar.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height-44, 320, 44)
        self.view.addSubview(toolBar)
        
        self.setupCamera()
        self.session.startRunning()
    }
    
    func backClick(){
        
    }
    func turnTorchOn(){
        
    }
    func pickPicture(){
        
    }
    
    let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    let session = AVCaptureSession()
    var layer: AVCaptureVideoPreviewLayer?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setupCamera()
        self.session.startRunning()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //delegate.labelDelegateMethodWithString(textField.text)
    }
    
    func setupCamera(){
        self.session.sessionPreset = AVCaptureSessionPresetHigh
        var error : NSError?
        let input = AVCaptureDeviceInput(device: device, error: &error)
        if (error != nil) {
            println(error?.description)
            return
        }
        if session.canAddInput(input) {
            session.addInput(input)
        }
        layer = AVCaptureVideoPreviewLayer(session: session)
        layer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        layer!.frame = CGRectMake(20,150,280,280);
        self.view.layer.insertSublayer(self.layer, atIndex: 0)
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        if session.canAddOutput(output) {
            session.addOutput(output)
            output.metadataObjectTypes = [AVMetadataObjectTypeQRCode];
        }
        
        session.startRunning()
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects:[AnyObject]!, fromConnection connection: AVCaptureConnection!){
        if metadataObjects.count > 0 {
            var metadataObject = metadataObjects[0] as AVMetadataMachineReadableCodeObject
            stringValueQrCode = metadataObject.stringValue
        }
        self.session.stopRunning()
        println("code is \(stringValueQrCode)")
        //        let alertController = UIAlertController(title: "title1", message: "message0:\(stringValue)", preferredStyle: UIAlertControllerStyle.Alert)
        //        alertController.addAction(UIAlertAction(title: "title2", style: UIAlertActionStyle.Default, handler: nil))
        //        self.presentViewController(alertController, animated: true, completion: nil)
        var alertView = UIAlertView()
        alertView.delegate=self
        alertView.title = "QrScand say:"
        var message:String = "You faund the Tag"
        if(stringValueQrCode == ""){
            message = "You didn't find Tag"
        }
        alertView.message = message
        alertView.addButtonWithTitle("Ok")
        alertView.show()
    }
    
}

