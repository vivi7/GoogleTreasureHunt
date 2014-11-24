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
    
    var hunt:Hunt = Hunt()
    var clues: Array<Clue> = Array<Clue>()
    var clue:Clue?
    
    override func viewDidLoad() {
//        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if clues.isEmpty {
            hunt.createHunt()
            clues = hunt.clueListShuffleFinal
        }
        return clues.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if clues.isEmpty {
            hunt.createHunt()
            clues = hunt.clueListShuffleFinal
        }
        var clue:Clue = clues[indexPath.row]
        var color:UIColor = UIColor.redColor()
        
        if hunt.isTagFound(clue.tags[0].id) && hunt.isTagFound(clue.tags[1].id){
            color = UIColor.greenColor()
        }
        
        var cell = UITableViewCell()
        cell.textLabel.text = clue.displayName
        cell.backgroundColor = color
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableViewtitle
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.clue = self.clues[indexPath.row]
        self.performSegueWithIdentifier("detailViewControllerSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var detailViewController = segue.destinationViewController as DetailViewController
        detailViewController.clue = self.clue
    }
    
}

