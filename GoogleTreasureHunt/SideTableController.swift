//
//  SideTableController.swift
//  Prova Side Panel
//
//  Created by Marcello Catelli on 28/08/14.
//  Copyright (c) 2014 Objective C srl. All rights reserved.
//

import UIKit

// questa è la classe che pilota pannello di sinistra
class SideTableController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //self.navigationController?.navigationBar.backgroundColor = UIColor(white: 10, alpha: 0.5)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // non è possibile fare dei segue per caricare i controller nel pannello centrale
    // quindi usiamo il metodo del delegato della table che ci dice quale cella è stata toccata
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var centerPanel : UIViewController!
        // facciamo uno switch della cella toccata
        switch (indexPath.section ,indexPath.row) {
            //la row 0 è spazio
        case (0, 1):
            println("ClueVc")
            centerPanel = self.storyboard!.instantiateViewControllerWithIdentifier("ClueViewController") as! ClueViewController
            self.sidePanelSystem().addCenterPanelViewController(centerPanel)
        case (0, 2):
            println("ListVc")
            centerPanel = self.storyboard!.instantiateViewControllerWithIdentifier("ListViewController") as! ListViewController
           self.sidePanelSystem().addCenterPanelViewController(centerPanel)
        case (1, 0):
            println("Reset hunt")
            DataManager.sharedInstance.deleteHunt()
            centerPanel = self.storyboard!.instantiateViewControllerWithIdentifier("WelcomeViewController") as! UIViewController
            self.sidePanelSystem().addCenterPanelViewController(centerPanel)
        default: ""
        }
        
        // grazie ad una estensione presente nel sistema dei pannelli qualsiasi UI'Qualcosa'Controller ha il metodo sidePanelSystem() che consente di accedere al sistema e caricare i controller nel pannello centrale
        //self.sidePanelSystem().addCenterPanelViewController(centerPanel)
        
        // questo serve per evitare che la cella rimanga selezionata
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        var cell = UITableViewCell() //tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
//        cell.backgroundColor = UIColor(white: 100, alpha: 0.5)
//        cell.selectionStyle = UITableViewCellSelectionStyle.None
//        
//        return cell
//    }
    
    // per dimostrare che è possibile navigare indipendentemente nei vari pannelli
    // una cella è stata collegata con un segue ad un controller chiamato RedController
    // quando scatta il segue mettiamo il pannello di sinistra Fullscreen
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "red" {
//            self.sidePanelSystem().fullScreenLeftEnter()
//        }
//    }

}
