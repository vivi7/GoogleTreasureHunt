//
//  VictoryViewController.swift
//  GoogleTreasureHunt
//
//  Created by Vincenzo Favara on 19/05/15.
//  Copyright (c) 2015 Vincenzo Favara. All rights reserved.
//

import UIKit
import Foundation
import SpriteKit
import AVFoundation

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            do{
                let sceneData = try NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
                let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
                
                archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
                let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
                archiver.finishDecoding()
                return scene
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
}

class VictoryViewController: UIViewController {
    
    @IBOutlet var answersLabel: UILabel!
    @IBOutlet var finishTimeLabel: UILabel!
    @IBOutlet var androidVictoryImageView: UIImageView!
    var imageList : [UIImage] = []
    
    var ding:AVAudioPlayer = AVAudioPlayer()
    var nameFileToPlay = SOUND_FANFARE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.hidden = true
        view.backgroundColor = UIColor.getFitPatternBackgroungImage("bg", container: self.view)
        
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            //scene.scaleMode = .AspectFit
            //scene.size = skView.bounds.size
            
            skView.presentScene(scene)
        }
        
        let imageView = UIImageView(frame: self.view.frame)
        imageView.image = UIImage(named: "material_trim")!
        self.view.addSubview(imageView)
        
        DataManager.sharedInstance.stopTimer()
        finishTimeLabel.text = "Finish Time: " + DataManager.sharedInstance.resultTimer()
        answersLabel.text = " Your correct answers: \(DataManager.sharedInstance.hunt!.numAnswersCorrect()) on \(DataManager.sharedInstance.hunt!.questions.count)"
        
        androidVictoryImageView.image = UIImage(named: "C-mon_win")
        
        prepareAudios()
        ding.play()
        
        messageRestart()
    }
    
    func messageRestart(){
        if !DataManager.sharedInstance.huntIsReady(){
            let alert = UIAlertController(title: "Perfect", message: "You can restart App", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func touchAction(sender: UITapGestureRecognizer) {
        let skView = view as! SKView
        let gameScene = skView.scene as! GameScene
        gameScene.explodeFireworks()
        ding.play()
    }
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    @IBAction func resetAction(sender: UIButton) {
        resetControl()
    }
    
    func resetControl() {
        let alert = UIAlertController(title: "Reset Hunt", message: "Are you sure? Then you can close app play again.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { action in
            self.dismissViewControllerAnimated(true, completion: nil)
        } ))
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            self.reset()
            self.dismissViewControllerAnimated(true, completion: nil)
        } ))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func reset(){
        DataManager.sharedInstance.deleteHunt()
    }
/*
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }
*/    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
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
}
