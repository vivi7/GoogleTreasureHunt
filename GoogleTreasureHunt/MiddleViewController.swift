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
        
        ThemeManager.sharedInstance.applyBackgroundTheme(view)
        ThemeManager.sharedInstance.applyNavigationBarTheme(self.navigationController?.navigationBar)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
