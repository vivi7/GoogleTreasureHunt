//
//  RedController.swift
//  Side Panel
//
//  Created by Marcello Catelli on 30/04/15.
//  Copyright (c) 2015 Objective C srl. All rights reserved.
//

import UIKit

class RedController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // quando questo controller sta per scomprarie usciamo dal fullscreen
    // (un pezzo del pannello laterale torna nello schermo)
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.sidePanelSystem().fullScreenLeftExit()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
