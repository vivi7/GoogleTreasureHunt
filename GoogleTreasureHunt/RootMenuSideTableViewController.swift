//
//  RootMenuSideTableViewController.swift
//  Spesami
//
//  Created by Vincenzo Favara on 01/02/15.
//  Copyright (c) 2015 Vincenzo Favara (VinSoft). All rights reserved.
//

import UIKit

class RootMenuSideTableViewController: UITableViewController {
    var selectedMenuItem : Int = 0
//    var namesItemsContrrollers = [NSLocalizedString("CONTR1", comment: ""), NSLocalizedString("CONTR2", comment: ""), NSLocalizedString("CONTR3", comment: ""), NSLocalizedString("CONTR4", comment: "")]
//    var namesStoryBoardIDContrrollers = ["ListShopsViewController", "ListShopsViewController", "FaqViewController", "InfoViewController"]
    
    var namesControllers = [0:[NSLocalizedString("CONTR1", comment: ""), "ClueViewController"], 1: [NSLocalizedString("CONTR2", comment: ""), "ListViewController"], 2: [NSLocalizedString("CONTR3", comment: ""), "FaqViewController"], 3: [NSLocalizedString("CONTR4", comment: ""), "InfoViewController"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize apperance of table view
        tableView.contentInset = UIEdgeInsetsMake(64.0, 0, 0, 0) //
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.clearColor()
        tableView.scrollsToTop = false
        
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        tableView.selectRowAtIndexPath(NSIndexPath(forRow: selectedMenuItem, inSection: 0), animated: false, scrollPosition: .Middle)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL") as? UITableViewCell
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CELL")
            cell!.backgroundColor = UIColor.clearColor()
            cell!.textLabel?.textColor = UIColor.darkGrayColor()
            let selectedBackgroundView = UIView(frame: CGRectMake(0, 0, cell!.frame.size.width, cell!.frame.size.height))
            selectedBackgroundView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.2)
            cell!.selectedBackgroundView = selectedBackgroundView
        }
        cell!.textLabel?.text = namesControllers[indexPath.row]![0]
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        println("did select row: \(indexPath.row)")
        
        if (indexPath.row == selectedMenuItem) {
            return
        }
        selectedMenuItem = indexPath.row
        
        //Present new view controller, name from StoryBoardID
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : UIViewController
        switch (indexPath.row) {
        case 0:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier(namesControllers[indexPath.row]![0]) as! UIViewController
            break
        case 1:
            //DataManager.sharedInstance.loadParseData()
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier(namesControllers[indexPath.row]![1]) as! UIViewController
            break
        case 2:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier(namesControllers[indexPath.row]![2]) as! UIViewController
            break
        default:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier(namesControllers[indexPath.row]![3]) as! UIViewController
            break
        }
        sideMenuController()?.setContentViewController(destViewController)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
