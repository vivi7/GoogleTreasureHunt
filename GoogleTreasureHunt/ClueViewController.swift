//
//  ClueViewController.swift
//  GoogleTreasureHunt
//
//  Created by Vincenzo Favara on 07/05/15.
//  Copyright (c) 2015 Vincenzo Favara. All rights reserved.
//

import UIKit
import AVFoundation
import QRCodeReader
//import LiquidFloatingActionButton

class ClueViewController: UIViewController, QRCodeReaderViewControllerDelegate /*, LiquidFloatingActionButtonDataSource, LiquidFloatingActionButtonDelegate*/ {
    
    lazy var reader = QRCodeReaderViewController(metadataObjectTypes: [AVMetadataObjectTypeQRCode])
    
    @IBOutlet var currentPoint : UILabel!
    
    //@IBOutlet var clueImage : UIImageView!
    
    @IBOutlet var clueYPMagnifyingView: YPMagnifyingView!
    
    @IBOutlet var labelInstruction: UILabel!

    @IBOutlet var tag1Label: UILabel!
    
    @IBOutlet var tag2label: UILabel!
    
    @IBOutlet var circle1: UIView!
    
    @IBOutlet var circle2: UIView!
    
    @IBOutlet var gifImageViewSx: UIImageView!
    var imageListSx : [UIImage] = []
    @IBOutlet var gifImageViewDx: UIImageView!
    var imageListDx : [UIImage] = []
    
    var hunt : Hunt!
    
    var currentClue:Clue?
    
    var message = ""
    
    var ding:AVAudioPlayer = AVAudioPlayer()
    var nameFileToPlay = "rejected"
    
    var redImage : UIImage!
    var greenImage : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Treasure Hunt"
        
        self.navigationController?.navigationBar.hidden = true
        view.backgroundColor = UIColor.getFitPatternBackgroungImage("bg", container: self.view)
        
        let imageView = UIImageView(frame: self.view.frame)
        imageView.image = UIImage(named: "material_trim")!
        self.view.addSubview(imageView)
        
        DataManager.sharedInstance.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: DataManager.sharedInstance, selector: Selector("countSec"), userInfo: nil, repeats: true)
        animateGifSx()
        animateGifDx()
/*
        let floatingActionButton = LiquidFloatingActionButton(frame: floatingFrame)
        floatingActionButton.dataSource = self
        floatingActionButton.delegate = self
*/
        let mag = YPMagnifyingGlass(frame:CGRectMake(clueYPMagnifyingView.frame.origin.x, clueYPMagnifyingView.frame.origin.y,100,100))
        mag.scale = 2
        clueYPMagnifyingView.magnifyingGlass = mag
        
        NSFileManager.printFilesInDocumentFolder()
        
    }
    
    func chooseFitPatternBackgroungColorImageForTag(container:UIView, tagFound:Bool) -> UIColor{
        var nameImage = "material_circle_red"
        if tagFound == true {
            nameImage = "material_circle_green"
        }
        return UIColor.getFitPatternBackgroungImage(nameImage, container: container)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        hunt = DataManager.sharedInstance.hunt!
        currentClue = hunt.getThisCLue()!
        
        currentPoint.text = "Clue #\(hunt.getNumClueView()) of \(hunt.getTotalClues())"
        
        if self.hunt.isHuntComplete() == false{
            circle1.backgroundColor = chooseFitPatternBackgroungColorImageForTag(circle1, tagFound: hunt.tagIsFound(currentClue!.tags[0].id))
            if currentClue!.tags.count > 1{
                circle2.backgroundColor = chooseFitPatternBackgroungColorImageForTag(circle2, tagFound: hunt.tagIsFound(currentClue!.tags[1].id))
            } else{
                UIView.animateWithDuration(0.5) {
                    self.circle1.transform = CGAffineTransformMakeTranslation(75, 0)
                    self.circle2.removeFromSuperview()
                }
            }
            //l'immagine si deve caricare dopo il controllo della verifica della vittoria
            clueYPMagnifyingView.backgroundColor = UIColor.getFitPatternBackgroungImage(HuntResourceManager.sharedInstance.getNameClueImage(currentClue!.displayImage), container: clueYPMagnifyingView)
            //clueImage.image = UIImage(named:HuntResourceManager.sharedInstance.getNameClueImage(currentClue!.displayImage))
            goToNext()
        } else{
            goToFinish()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetAction(sender: UIButton) {
        DataManager.sharedInstance.deleteHunt()
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("WelcomeViewController") 
        self.showViewController(vc, sender: "")
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
                let isHuntComplete = self.hunt.isHuntComplete()
                if isHuntComplete == true{
                    self.goToFinish()
//                    self.goToNextVcSide("VictoryViewController")
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
    
    func menageResultScan(result:String){
        let message = self.hunt.messageFromTag(result)
        self.message = message.0
        nameFileToPlay = message.1
        myPrintln("message: " + message.0 + ", sound:" + message.1)
        if message.0 == ACK{
            hunt.setTagFound(result)
        }
    }
    
    // MARK: - Segue
/*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToListSegue" {
            segue.destinationViewController as! ListViewController
        } else if segue.identifier == "goToVictorySegue"{
            segue.destinationViewController as! VictoryViewController
        } else if segue.identifier == "goToVictorySegue"{
            segue.destinationViewController as! QuestionViewController
        }
    }
*/
    func goToNext(){
        let tagsRemain = hunt.tagsRemain()
        if tagsRemain == 0{
            if hunt.isThereQuestionToAnswer() == true{
                self.goToQuestion()
                //performSegueWithIdentifier("QuestionViewController", sender: nil)
            } else if self.hunt.isHuntComplete() == true{
                self.goToFinish()
                //performSegueWithIdentifier("VictoryViewController", sender: nil)
            } else{
                self.goToClueVc()
                //performSegueWithIdentifier("ClueViewController", sender: nil)
            }
        }
    }
    
    func goToQuestion(){
        delay(0.3) { () -> () in
            let vc : QuestionViewController = self.storyboard?.instantiateViewControllerWithIdentifier("QuestionViewController") as! QuestionViewController;
            self.showViewController(vc, sender: "")
            //navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func goToClueVc(){
        let vc : ClueViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ClueViewController") as! ClueViewController;
        self.showViewController(vc, sender: "")
        //navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToFinish(){
        delay(0.3) { () -> () in
            let vc : VictoryViewController = self.storyboard?.instantiateViewControllerWithIdentifier("VictoryViewController") as! VictoryViewController;
            self.showViewController(vc, sender: "")
            //navigationController?.pushViewController(vc, animated: true)
        }
    }

//    func goToNextVcSide(storyboardID:String){
//        var vc = self.storyboard!.instantiateViewControllerWithIdentifier("SideBaseController") as! SideBaseController
//        vc.storyboardID = storyboardID
//        self.showViewController(vc, sender: "")
//    }
    
    // MARK: - QRCodeReader Delegate Methods
    
    func reader(reader: QRCodeReaderViewController, didScanResult result: String) {
        prepareAudios()
        ding.play()
        self.dismissViewControllerAnimated(true, completion: { [unowned self] () -> Void in
            self.showMessage()
            })
    }
    
    func readerDidCancel(reader: QRCodeReaderViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - Play
    
    func prepareAudios() {
        let path = NSBundle.mainBundle().pathForResource(nameFileToPlay, ofType: "mp3")
        do {
            try ding = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: path!))
        } catch {
            print(error)
        }
        ding.prepareToPlay()
    }
    
    //MARK: - Animation
    let pixelsTranslate : CGFloat = 525
    func animateGifSx(){
        for i in 1...4{
            let imageName = "gifanimocchi\(i)"
            imageListSx.append(UIImage(named: imageName)!)
        }
        gifImageViewSx.animationImages = imageListSx
        gifImageViewSx.animationDuration = NSTimeInterval(0.8)
        gifImageViewSx.startAnimating()
        androidUnHideSx()
    }
    func androidUnHideSx(){
        UIView.animateWithDuration(1.5, animations: { () -> Void in
            self.gifImageViewSx.frame.origin.x -= self.pixelsTranslate
            }, completion: { (Bool) -> Void in
                self.androidHideSx()
        })
    }
    func androidHideSx(){
        UIView.animateWithDuration(1.5, animations: { () -> Void in
            self.gifImageViewSx.frame.origin.x += self.pixelsTranslate
            }, completion: { (Bool) -> Void in
                self.androidUnHideSx()
        })
    }
    
    func animateGifDx(){
        for i in 1...4{
            let imageName = "gifanimocchi\(i)"
            imageListDx.append(UIImage(named: imageName)!)
        }
        gifImageViewDx.animationImages = imageListDx
        gifImageViewDx.animationDuration = NSTimeInterval(0.8)
        gifImageViewDx.startAnimating()
        androidUnHideDx()
    }
    func androidUnHideDx(){
        UIView.animateWithDuration(1.5, animations: { () -> Void in
            self.gifImageViewDx.frame.origin.x += self.pixelsTranslate
            }, completion: { (Bool) -> Void in
                self.androidHideDx()
        })
    }
    func androidHideDx(){
        UIView.animateWithDuration(1.5, animations: { () -> Void in
            self.gifImageViewDx.frame.origin.x -= self.pixelsTranslate
            }, completion: { (Bool) -> Void in
                self.androidUnHideDx()
        })
    }
    
    
    //MARK: - Message
    func showMessage(){
        DoneHUD.showInView(self.view, message: self.message, isDone: (self.message == ACK))
    }
    
    //MARK: - LiquidFloatingActionButton 
/*
    func numberOfCells(liquidFloatingActionButton: LiquidFloatingActionButton) -> Int {
        return cells.count
    }
    
    func cellForIndex(index: Int) -> LiquidFloatingCell {
        return cells[index]
    }
    
    func liquidFloatingActionButton(liquidFloatingActionButton: LiquidFloatingActionButton, didSelectItemAtIndex index: Int) {
        println("did Tapped! \(index)")
        liquidFloatingActionButton.close()
    }
*/
}
