//
//  ClueViewController.swift
//  GoogleTreasureHunt
//
//  Created by Vincenzo Favara on 07/05/15.
//  Copyright (c) 2015 Vincenzo Favara. All rights reserved.
//

import UIKit
import AVFoundation

class ClueViewController: UIViewController, QRCodeReaderViewControllerDelegate {
    
    lazy var reader = QRCodeReaderViewController(metadataObjectTypes: [AVMetadataObjectTypeQRCode])
    
    @IBOutlet var currentPoint : UILabel!
    
    @IBOutlet var clueImage : UIImageView!
    
    @IBOutlet var labelInstruction: UILabel!

    @IBOutlet var tag1Label: UILabel!
    
    @IBOutlet var tag2label: UILabel!
    
    @IBOutlet var circle1: CircleView!
    
    @IBOutlet var circle2: CircleView!
    
    var hunt : Hunt!
    
    var currentClue:Clue?
    
    var ding:AVAudioPlayer = AVAudioPlayer()
    
    //let driveService : GTLService =  GTLService()
    /*
    let kKeychainItemName : NSString = "Google Plus Quickstart"
    let kClientID : NSString = "208944949242-3nv46f8d2priu2p4su9kj1sdruekah56.apps.googleusercontent.com"
    let kClientSecret : NSString = "4LCknQQmdH_Oa_Kx28Ufgh2f"
    
    
    var num : Int = 0;
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Treasure Hunt"
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named:"bg")?.drawInRect(self.view.bounds)
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        view.backgroundColor = UIColor(patternImage: image)
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.hidden = true
        
        hunt = DataManager.sharedInstance.hunt!
        currentClue = hunt.getThisCLue()!
        
        currentPoint.text = "Clue #\(hunt.getNumClueView()) of \(hunt.getTotalClues())"
        
        if self.hunt.isHuntComplete() == false{
            clueImage.image = UIImage(named:HuntResourceManager.sharedInstance.getNameClueImage(currentClue!.displayImage))
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        hunt = DataManager.sharedInstance.hunt!
        if self.hunt.isHuntComplete() == false{
            var c1 = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0))
            c1.center = circle1.center
            c1.layer.cornerRadius = 25.0
            if hunt.tagIsFound(currentClue!.tags[0].id) == true {
                c1.backgroundColor = UIColor.greenColor()
            }
            circle1.backgroundColor = UIColor.clearColor()
            circle1.addSubview(c1)
            
            var c2 = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0))
            c2.center = circle2.center
            c2.layer.cornerRadius = 25.0
            if currentClue!.tags.count > 1{
                if hunt.tagIsFound(currentClue!.tags[1].id) == true {
                    c2.backgroundColor = UIColor.greenColor()
                }
                circle2.backgroundColor = UIColor.clearColor()
                circle2.addSubview(c2)
            } else{
                UIView.animateWithDuration(0.5) {
                    self.circle1.transform = CGAffineTransformMakeTranslation(75, 0)
                    self.circle2.removeFromSuperview()
                }
            }
            goToNext()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func callScan(buttonTapped: UIButton){
        scanAction()
    }
    
    func scanAction() {
        
        if QRCodeReader.supportsMetadataObjectTypes() {
            reader.modalPresentationStyle = .FormSheet
            reader.delegate               = self
            
            reader.completionBlock = { (result: String?) in
                myPrintln("Completion with result: \(result)")
                self.menageResultScan(result!)
                if self.hunt.isHuntComplete() == true{
                    self.goToFinish()
                }
            }
            
            presentViewController(reader, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    var message :String = ""
    func menageResultScan(result:String){
        message = self.hunt.messageFromTag(result)
        myPrintln(message)
        if message == ACK{
            hunt.setTagFound(result)
            //goToNext()
//        } else {
//            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .Alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
//            
//            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Segue
    
    func goToNext(){
        var tagsRemain = hunt.tagsRemain()
        if tagsRemain == 0{
            if hunt.isThereQuestionToAnswer() == true{
                self.goToQuestion()
            } else{
                self.goToClueVc()
            }
        }
    }
    
    func goToFinish(){
        var vc : VictoryViewController = self.storyboard?.instantiateViewControllerWithIdentifier("VictoryViewController") as! VictoryViewController;
        self.showViewController(vc, sender: "")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = segue.destinationViewController as! VictoryViewController
    }
    
    func goToQuestion(){
        var vc : QuestionViewController = self.storyboard?.instantiateViewControllerWithIdentifier("QuestionViewController") as! QuestionViewController;
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func goToClueVc(){
        let vc : ClueViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ClueViewController") as! ClueViewController;
        self.showViewController(vc, sender: "")
    }
    
    // MARK: - QRCodeReader Delegate Methods
    
    func reader(reader: QRCodeReaderViewController, didScanResult result: String) {
        prepareAudios()
        ding.play()
        self.dismissViewControllerAnimated(true, completion: { [unowned self] () -> Void in
            let alert = UIAlertController(title: "Message", message: self.message, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            })
    }
    
    func readerDidCancel(reader: QRCodeReaderViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - Play
    
    func prepareAudios() {
        var path = NSBundle.mainBundle().pathForResource("coin", ofType: "ogg")
        ding = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: path!), error: nil)
        ding.prepareToPlay()
    }
}
