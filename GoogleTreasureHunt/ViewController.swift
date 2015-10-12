//
//  ViewController.swift
//  TreasureHunt
//
//  Created by Vincenzo Favara on 23/09/14.
//  Copyright (c) 2014 Vincenzo Favara. All rights reserved.
//

import UIKit
import Foundation


class ViewController: UIViewController{
    
    @IBOutlet var place: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.hidden = true
        view.backgroundColor = UIColor.getFitPatternBackgroungImage("bg", container: self.view)
        
        place.text = "C-mon is came to " + DataManager.sharedInstance.hunt!.displayName + "!"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

