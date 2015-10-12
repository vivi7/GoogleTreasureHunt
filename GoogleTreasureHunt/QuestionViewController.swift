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
    
    @IBOutlet var gifImageView: UIImageView!
    var imageList : [UIImage] = []
    
    var hunt : Hunt = DataManager.sharedInstance.hunt!
    var currentClue:Clue!
    
    var ding:AVAudioPlayer = AVAudioPlayer()
    var nameFileToPlay = SOUND_REJECTED
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Question"
        
        self.navigationController?.navigationBar.hidden = true
        view.backgroundColor = UIColor.getFitPatternBackgroungImage("bg", container: self.view)
        
        let imageView = UIImageView(frame: self.view.frame)
        imageView.image = UIImage(named: "material_trim")!
        self.view.addSubview(imageView)
        
        DataManager.sharedInstance.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: DataManager.sharedInstance, selector: Selector("countSec"), userInfo: nil, repeats: true)
        
        currentClue = hunt.getThisCLue()!
        
        questionLabel.backgroundColor = UIColor.clearColor() //UIColor(patternImage: UIImage(named: "questionBorder")!)
        
        questionLabel.text = currentClue.question?.question
        answer0Button.setTitle(currentClue.question?.answers[0], forState: UIControlState.Normal)
        answer1Button.setTitle(currentClue.question?.answers[1], forState: UIControlState.Normal)
        answer2Button.setTitle(currentClue.question?.answers[2], forState: UIControlState.Normal)
        
        animateGif()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //animateGif()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func answerAction(sender: UIButton) {
        let message = hunt.answerMessage(sender.tag)
        if message.1 {
            nameFileToPlay = SOUND_COIN
        }
        displayAlert("Answer", message: message.0)
    }
    
    func displayAlert(title:String, message:String) {
        prepareAudios()
        ding.play()
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            //self.dismissViewControllerAnimated(true, completion: nil)
            self.goToClueVc()
        } ))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func goToClueVc(){
        //self.dismissViewControllerAnimated(true, completion: nil)
        navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: - Play
    
    func prepareAudios() {
        let path = NSBundle.mainBundle().pathForResource(nameFileToPlay, ofType: "mp3")
        do {
            ding = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: path!))
        } catch {
            
        }
        ding.prepareToPlay()
    }
    
    //MARK: - Animation
    
    func animateGif(){
        for i in 1...4{
            let imageName = "gifanimocchi\(i)"
            imageList.append(UIImage(named: imageName)!)
        }
        gifImageView.animationImages = imageList
        gifImageView.animationDuration = NSTimeInterval(0.8)
        gifImageView.startAnimating()
        androidUnHide()
    }
    
    func androidUnHide(){
        //self.gifImageView.frame.origin.y = 0.0
        UIView.animateWithDuration(1.5, animations: { () -> Void in
            self.gifImageView.frame.origin.y -= 67
            }, completion: { (Bool) -> Void in
                self.androidHide()
        })
    }
    
    func androidHide(){
        UIView.animateWithDuration(1.5, animations: { () -> Void in
            self.gifImageView.frame.origin.y += 67
            }, completion: { (Bool) -> Void in
                self.androidUnHide()
        })
    }
}
