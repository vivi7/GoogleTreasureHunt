//
//  SideBaseController.swift
//  Side Panel
//
//  Created by Marcello Catelli on 29/08/14.
//  Copyright (c) 2014 Objective C srl. All rights reserved.
//

import UIKit

// per far funzionare il sistema a pannelli occorre creare una sottoclasse di SidePanelSystem.swift
// come questo file di esempio
// nello storyboard il controller con l'entry point (la freccia grigia) ha questa classe come pilota
class SideBaseController: SidePanelSystem {
    
    var storyboardID = "ClueViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // carichiamo in memoria il SideTableController
        // nello storyboard è un controller non direttamente connesso a nulla che ha come Storyboard ID il nome di 'side'
        //var leftPanel = self.storyboard!.instantiateViewControllerWithIdentifier("LeftTableViewController") as! UINavigationController
        let leftPanel = self.storyboard!.instantiateViewControllerWithIdentifier("LeftTableViewController") as! UIViewController
        // aggiungiamolo al sistema dei pannelli
        self.addLeftPanelViewController(leftPanel)
        
        // idem con il pannello centrale in cui carichiamo GreenController
//        let navigationController = UINavigationController(rootViewController: self.storyboard!.instantiateViewControllerWithIdentifier(storyboardID) as! UIViewController)
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier(storyboardID) as! UIViewController
        self.addCenterPanelViewController(vc)
        
//        var centerPanelN = self.storyboard!.instantiateViewControllerWithIdentifier("WelcomeViewController") as! UINavigationController
//        
//        if DataManager.sharedInstance.hunt != nil{
//            var centerPanel: UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ClueViewController") as! ClueViewController
//            if DataManager.sharedInstance.hunt!.isHuntComplete() == true{
//                centerPanel = self.storyboard!.instantiateViewControllerWithIdentifier("VictoryViewController") as! VictoryViewController
//            }
//            self.addCenterPanelViewController(centerPanel)
//        } else {
//            self.addCenterPanelViewController(centerPanelN)
//        }
        
        // per disabilitare le gesture decommentare questa riga
        //self.gestureEnabled = false
    }
    
    override func viewDidAppear(animated: Bool) {
        let leftPanel = self.storyboard!.instantiateViewControllerWithIdentifier("LeftTableViewController") as! UIViewController
        self.addLeftPanelViewController(leftPanel)
        
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier(storyboardID) as! UIViewController
        self.addCenterPanelViewController(vc)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
