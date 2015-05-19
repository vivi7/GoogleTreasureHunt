//
//  RootNavigationViewController.swift
//  Spesami
//
//  Created by Vincenzo Favara on 01/02/15.
//  Copyright (c) 2015 Vincenzo Favara (VinSoft). All rights reserved.
//

import UIKit

class RootNavigationViewController: VFSideMenuNavigationController, VFSideMenuDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenu = VFSideMenu(sourceView: self.view, myMenuTableViewController: RootMenuSideTableViewController(), menuPosition:.Left)
        //sideMenu?.delegate = self //optional
        sideMenu?.menuWidth = 180.0 // optional, default is 160
        //sideMenu?.bouncingEnabled = false
        
        // make navigation bar showing over side menu
        view.bringSubviewToFront(navigationBar)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - ENSideMenu Delegate
    func sideMenuWillOpen() {
        println("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        println("sideMenuWillClose")
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
