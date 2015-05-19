//
//  QuestionViewController.swift
//  GoogleTreasureHunt
//
//  Created by Vincenzo Favara on 10/05/15.
//  Copyright (c) 2015 Vincenzo Favara. All rights reserved.
//

import UIKit
import AVFoundation

class QuestionViewController: UIViewController {
    
    @IBOutlet var questionLabel: UILabel!
    
    @IBOutlet var answer0Button: UIButton!
    @IBOutlet var answer1Button: UIButton!
    @IBOutlet var answer2Button: UIButton!
    
    var hunt : Hunt = DataManager.sharedInstance.hunt!
    var currentClue:Clue!
    
    var ding:AVAudioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Question"
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named:"bg")?.drawInRect(self.view.bounds)
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        view.backgroundColor = UIColor(patternImage: image)
        
        currentClue = hunt.getThisCLue()!
        
        questionLabel.backgroundColor = UIColor.clearColor() //UIColor(patternImage: UIImage(named: "questionBorder")!)
        questionLabel.text = currentClue.question?.question
        answer0Button.setTitle(currentClue.question?.answers[0], forState: UIControlState.Normal)
        answer1Button.setTitle(currentClue.question?.answers[1], forState: UIControlState.Normal)
        answer2Button.setTitle(currentClue.question?.answers[2], forState: UIControlState.Normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func answerAction(sender: UIButton) {
        var message = hunt.answerMessage(sender.tag)
        displayAlert("Answer", message: message)
    }
    
    func displayAlert(title:String, message:String) {
        prepareAudios()
        ding.play()
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            //self.dismissViewControllerAnimated(true, completion: nil)
            self.goToClueVc()
        } ))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func goToClueVc(){
        let vc : ClueViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ClueViewController") as! ClueViewController;
        self.showViewController(vc, sender: "")
    }
    
    
    //MARK: - Play
    
    func prepareAudios() {
        var path = NSBundle.mainBundle().pathForResource("coin", ofType: "ogg")
        ding = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: path!), error: nil)
        ding.prepareToPlay()
    }
}
