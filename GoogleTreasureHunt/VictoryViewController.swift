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

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
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
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named:"bg")?.drawInRect(self.view.bounds)
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        view.backgroundColor = UIColor(patternImage: image)
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.hidden = true
        
        DataManager.sharedInstance.stopTimer()
        finishTimeLabel.text = "Finish Time: " + DataManager.sharedInstance.resultTimer()
        answersLabel.text = " Your correct answers: \(DataManager.sharedInstance.hunt!.numAnswersCorrect()) on \(DataManager.sharedInstance.hunt!.questions.count)"
        
        animateGif()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func touchAction(sender: UITapGestureRecognizer) {
        let skView = view as! SKView
        let gameScene = skView.scene as! GameScene
        gameScene.explodeFireworks()
    }
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    @IBAction func resetAction(sender: UIButton) {
        resetControl()
    }
    func resetControl() {
        var alert = UIAlertController(title: "Reset Hunt", message: "Are you sure? Then you can close app play again.", preferredStyle: UIAlertControllerStyle.Alert)
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
        //var vc = self.storyboard!.instantiateViewControllerWithIdentifier("WelcomeViewController") as! UIViewController
        //TODO: use an other method to go to start
        //self.presentViewController(vc, animated: true, completion: nil)
        //self.showViewController(vc, sender: "")
        
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    //MARCK: - Animation
    
    func animateGif(){
        for i in 1...4{
            let imageName = "gifandroidvic\(i)"
            imageList.append(UIImage(named: imageName)!)
        }
        androidVictoryImageView.animationImages = imageList
        androidVictoryImageView.animationDuration = NSTimeInterval(1.8)
        androidVictoryImageView.startAnimating()
    }
}
