//
//  MiddleViewController.swift
//  GoogleTreasureHunt
//
//  Created by Vincenzo Favara on 23/05/15.
//  Copyright (c) 2015 Vincenzo Favara. All rights reserved.
//

import UIKit

class MiddleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.hidden = true
        view.backgroundColor = UIColor.getFitPatternBackgroungImage("bg", container: self.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
