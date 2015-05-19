//
//  FinishViewController.swift
//  GoogleTreasureHunt
//
//  Created by Vincenzo Favara on 19/05/15.
//  Copyright (c) 2015 Vincenzo Favara. All rights reserved.
//

import UIKit

class FinishViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named:"bg")?.drawInRect(self.view.bounds)
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        view.backgroundColor = UIColor(patternImage: image)
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.hidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
