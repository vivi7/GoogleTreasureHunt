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
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named:"bg")?.drawInRect(self.view.bounds)
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        view.backgroundColor = UIColor(patternImage: image)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
