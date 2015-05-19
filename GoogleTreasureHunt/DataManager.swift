//
//  DataManager.swift
//  Pizza List
//
//  Created by Marcello Catelli on 08/10/14.
//  Copyright (c) 2014 Objective C srl. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    
    // MARK: - Singleton
    //***** CODICE SPECIALE CHE TRASFORMA QUESTA CLASSE IN UN SINGLETON (snippet sw_sgt)*****\\
    class var sharedInstance:DataManager {
        get {
            struct Static {
                static var instance : DataManager? = nil
                static var token : dispatch_once_t = 0
            }
            
            dispatch_once(&Static.token) { Static.instance = DataManager() }
            
            return Static.instance!
        }
    }
    //***** FINE CODICE SPECIALE *****\\
    
    let namePlist = "/hunt.plist"
    let nameHuntZip = "hunt.zip"
    let nameJSON = "sampleHunt.json"
    
    // MARK: - variabili globali
//    var hunts : [Hunt] = []
//    var numHunt : Int?
    var hunt : Hunt?
    
    //var mainController : MasterViewController!
    
    var docPath = NSFileManager.applicationDocumentsDirectory().path

    
    // MARK: - Metodi
    func startDataManager() {
        
//        getNumHuntSelected()
        
        //debugPrint("%d", &filePath)
        
        if !NSFileManager.defaultManager().fileExistsAtPath(docPath! + namePlist) {
            HuntResourceManager.sharedInstance.downloadZip()
        } else {
            loadHunt()
        }
    }
    
    func prova(){
        for tagDic in hunt!.tagsFound{
            if tagDic.0 != "gdg10"{
                hunt!.tagsFound.updateValue(true, forKey: tagDic.0)
            } else{
                hunt!.tagsFound.updateValue(false, forKey: tagDic.0)
            }
        }
    }
    
    func createHunt(){
        var filePath = docPath! + namePlist
        
        if !NSFileManager.defaultManager().fileExistsAtPath(filePath) {
            HuntResourceManager.sharedInstance.createHunt()
        }
    }
    
    func printTagsFound(){
        myPrintln("tagsFaund:")
        for tagDic in hunt!.tagsFound{
            if tagDic.0 != "gdg10"{
                hunt!.tagsFound.updateValue(true, forKey: tagDic.0)
            }
            if(tagDic.1 == true){
                myPrintln(tagDic.0)
            }
        }
        myPrintln("tagsFaund end")
    }
    
    func printHunt(){
        myPrintln(true)
        myPrintln("")
        myPrintln(hunt!.id)
        myPrintln(hunt!.type)
        myPrintln(hunt!.displayName)
        
        for clue in hunt!.clues{
            myPrintln("clue.id " + clue.id)
            myPrintln("clue.type " + clue.type)
            myPrintln("clue.shufflegroup \(clue.shufflegroup)")
            myPrintln("clue.displayName " + clue.displayName)
            myPrintln("clue.displayText " + clue.displayText)
            myPrintln("clue.displayImage " + clue.displayImage)
            
            for tag in clue.tags{
                myPrintln("tag.id " + tag.id)
                myPrintln("tag.clueId " + tag.clueId)
                //myPrintln(tag.isFound)
            }
            if clue.question != nil{
                myPrintln("clue.question?.question ")
                myPrintln(clue.question!.question)
                myPrintln("clue.question?.bitmapID ")
                myPrintln(clue.question!.bitmapID!)
                myPrintln("clue.question?.answers ")
                myPrintln(clue.question!.answers)
                myPrintln("clue.question?.correctAnswer ")
                myPrintln(clue.question!.correctAnswer)
                myPrintln("clue.question?.rightMessage ")
                myPrintln(clue.question!.rightMessage!)
                myPrintln("clue.question?.wrongMessage ")
                myPrintln(clue.question!.wrongMessage!)
                //myPrintln(clue.question!.doneAnswer)
                myPrintln("")
            } else {
                myPrintln("clue.question? nil ")
            }
        }
        myPrintln("")
        myPrintln("")
    }
    
//    func salvaNumSelected(){
//        NSUserDefaults.standardUserDefaults().setInteger(numHunt!, forKey: "numHunt")
//    }
//    
//    func getNumHuntSelected(){
//        numHunt = NSUserDefaults.standardUserDefaults().objectForKey("numHunt") as? Int
//    }
    
    func salvaHunt() {
        NSKeyedArchiver.archiveRootObject(hunt!, toFile: docPath! + namePlist)
    }
    func loadHunt(){
        hunt = NSKeyedUnarchiver.unarchiveObjectWithFile(docPath! + namePlist) as? Hunt
    }
    func deleteHunt(){
        deleteInDocumentFolder(namePlist)
    }
    
//    func getHuntSelected() -> Hunt{
//        return hunts[numHunt!]
//    }
    
    func deleteInDocumentFolder(subdirectoryOrFileName:String) -> Bool{
        return NSFileManager.deleteFromDocumentsDirectory(subdirectoryOrFileName)
    }
    
    // MARK: - Timer
    var timer = NSTimer()
    var count = 0
    
    func startTimer(){
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("countSec"), userInfo: nil, repeats: true)
    }
    
    func stopTimer(){
        timer.invalidate()
    }
    
    func countSec(){
        count++
    }
    
    func resultTimer() -> String{
        return NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .MediumStyle)
    }
}

func myPrintln(toPrint:AnyObject){
    println(toPrint)
}