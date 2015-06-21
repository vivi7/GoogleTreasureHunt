//
//  GreenController.swift
//  Prova Side Panel
//
//  Created by Marcello Catelli on 28/08/14.
//  Copyright (c) 2014 Objective C srl. All rights reserved.
//

import UIKit

class GreenController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func apriCassetto(sender: UIBarButtonItem) {
        self.sidePanelSystem().toggleLeftPanel()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
