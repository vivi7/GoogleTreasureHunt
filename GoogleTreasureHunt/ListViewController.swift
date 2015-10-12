//
//  ListViewController.swift
//  TreasureHunt
//
//  Created by Vincenzo Favara on 25/09/14.
//  Copyright (c) 2014 Vincenzo Favara. All rights reserved.
//

import UIKit
import Foundation

class ListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var tableView: UITableView!
    
    let tableViewtitle = "Clues"
    
    var hunt = DataManager.sharedInstance.hunt
    var clues: [Clue] = []
    var clue : Clue?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.hidden = true
        view.backgroundColor = UIColor.getFitPatternBackgroungImage("bg", container: self.view)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        let imageView = UIImageView(frame: self.view.frame)
        imageView.image = UIImage(named: "material_trim")!
        self.view.addSubview(imageView)
        
        clues = hunt!.clues
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clues.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let clue:Clue = clues[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 
        cell.textLabel!.text = clue.displayName
        cell.textLabel!.backgroundColor = UIColor.clearColor()
        cell.detailTextLabel?.text = clue.displayText
        cell.detailTextLabel!.backgroundColor = UIColor.clearColor()
        
        UIGraphicsBeginImageContext(cell.imageView!.frame.size)
        UIImage(named:HuntResourceManager.sharedInstance.getNameClueImage(clue.displayImage))?.drawInRect(cell.imageView!.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        cell.imageView!.image = image
        
        var color:UIColor = UIColor(red: 200.0, green: 0.0, blue: 0.0, alpha: 0.2)
        if hunt!.isClueComplete(clue) == true{
            cell.accessoryType = .Checkmark
            color = UIColor(red: 0.0, green: 200.0, blue: 0.0, alpha: 0.2)
            cell.imageView?.image = UIImage(named:HuntResourceManager.sharedInstance.getNameClueImage(clue.displayImage))
        }
        
        cell.backgroundColor = color
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil //tableViewtitle
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.clue = self.clues[indexPath.row]
        //self.performSegueWithIdentifier("detailViewControllerSegue", sender: self)
    }
    
    //override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //    var detailViewController = segue.destinationViewController as! DetailViewController
    //    detailViewController.clue = self.clue
    //}
    
    @IBAction func backAction(sender: UIButton) {
        goToClueVc()
    }
    
    @IBAction func swipeGestureAction(sender: UISwipeGestureRecognizer) {
        goToClueVc()
    }
    
    func goToClueVc(){
        //let vc : ClueViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ClueViewController") as! ClueViewController;
        //self.showViewController(vc, sender: "")
        /*print(navigationController!.viewControllers.count)
        for controller in navigationController!.viewControllers{
            print(controller)
        }
        self.navigationController!.popToRootViewControllerAnimated(true)
        */
        //self.dismissViewControllerAnimated(true, completion: nil)
        navigationController?.popViewControllerAnimated(true)
    }
}

