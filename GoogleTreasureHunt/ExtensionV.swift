//
//  ExtensionV.swift
//  GoogleTreasureHunt
//
//  Created by Vincenzo Favara on 29/04/15.
//  Copyright (c) 2015 Vincenzo Favara. All rights reserved.
//

import UIKit
import Foundation

extension NSFileManager {
    //pragma mark - strip slashes
    
    class func stripSlashIfNeeded(stringWithPossibleSlash:String) -> String {
        var stringWithoutSlash:String = stringWithPossibleSlash
        // If the file name contains a slash at the beginning then we remove so that we don't end up with two
        if stringWithPossibleSlash.hasPrefix("/") {
            stringWithoutSlash = stringWithPossibleSlash.substringToIndex(stringWithPossibleSlash.endIndex.advancedBy(-1))
        }
        // Return the string with no slash at the beginning
        return stringWithoutSlash
    }
    
    class func saveDataToDocumentsDirectory(fileData:NSData, path:String, subdirectory:String?) -> Bool
    {
        // Remove unnecessary slash if need
        let newPath = self.stripSlashIfNeeded(path)
        var newSubdirectory:String?
        if (subdirectory != nil) {
            newSubdirectory = self.stripSlashIfNeeded(subdirectory!)
        }
        // Create generic beginning to file save path
        var savePath = self.applicationDocumentsDirectory().path!+"/"
        
        if (newSubdirectory != nil) {
            savePath += newSubdirectory!
            self.createSubDirectory(savePath)
            savePath += "/"
        }
        
        // Add requested save path
        savePath += newPath
        
        print(savePath)
        // Save the file and see if it was successful
        let ok:Bool = self.defaultManager().createFileAtPath(savePath,contents:fileData, attributes:nil)
        
        // Return status of file save
        return ok;
        
    }
    
    class func applicationDocumentsDirectory() -> NSURL {
        var documentsDirectory:String?
        var paths:[AnyObject] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true);
        if paths.count > 0 {
            if let pathString = paths[0] as? NSString {
                documentsDirectory = pathString as String
            }
        }
        return NSURL(fileURLWithPath: documentsDirectory!)
    }
    
    class func applicationLibraryDirectory() -> NSURL {
        var libraryDirectory:String?
        var paths:[AnyObject] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.LibraryDirectory, NSSearchPathDomainMask.UserDomainMask, true);
        if paths.count > 0 {
            if let pathString = paths[0] as? NSString {
                libraryDirectory = pathString as String
            }
        }
        return NSURL(fileURLWithPath: libraryDirectory!)
    }
    
    class func applicationSupportDirectory() -> NSURL {
        var applicationSupportDirectory:String?
        var paths:[AnyObject] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.ApplicationSupportDirectory, NSSearchPathDomainMask.UserDomainMask, true);
        if paths.count > 0 {
            if let pathString = paths[0] as? NSString {
                applicationSupportDirectory =  pathString as String
            }
        }
        return NSURL(fileURLWithPath: applicationSupportDirectory!)
    }
    
    class func applicationTemporaryDirectory() -> NSURL {
        let temporaryDirectory:String? = NSTemporaryDirectory();
        return NSURL(fileURLWithPath: temporaryDirectory!)
    }
    
    class func applicationCachesDirectory() -> NSURL {
        
        var cachesDirectory:String?
        
        var paths = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory,.UserDomainMask, true);
        
        if paths.count > 0 {
            if let pathString = paths[0] as? NSString {
                cachesDirectory = pathString as String
            }
        }
        return NSURL(fileURLWithPath: cachesDirectory!);
    }
    
    class func createSubDirectory(subdirectoryPath:NSString) -> Bool {
        var isDir:ObjCBool=false;
        let exists:Bool = self.defaultManager().fileExistsAtPath(subdirectoryPath as String, isDirectory:&isDir)
        if (exists) {
            /* a file of the same name exists, we don't care about this so won't do anything */
            if isDir {
                /* subdirectory already exists, don't create it again */
                return true;
            }
        }
        do {
            try self.defaultManager().createDirectoryAtPath(subdirectoryPath as String, withIntermediateDirectories:true, attributes:nil)
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    class func deleteFromDocumentsDirectory(subdirectoryOrFileName:String) -> Bool{
        // Remove unnecessary slash if need
        let newSubdirectory:String? = self.stripSlashIfNeeded(subdirectoryOrFileName)
        
        // Create generic beginning to file delete path
        var deletePath = self.applicationDocumentsDirectory().path!+"/"
        
        if (newSubdirectory != nil) {
            deletePath += newSubdirectory!
            if !self.defaultManager().fileExistsAtPath(deletePath) {
                return false
            }
        }
        // Delete the file and see if it was successful
        return deleteFileAtPath(deletePath)
    }
    
    /* Create a folder with a given path */
    class func createFolderAtPath(path: String){
        do{
            try self.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Failed to create folder at \(path)")
        }
    }
    
    /* Deletes a folder with a given path */
    class func deleteFileAtPath(path: String) -> Bool{
        do{
            try self.defaultManager().removeItemAtPath(path)
            return true
        } catch {
            print("Failed to delete folder at \(path)")
            return false
        }
    }
    
    /* Enumerates all files/folders at a given path */
    class func enumerateFilesInFolder(folder: String) -> [String]{
        var folders : [String] = []
        do{
            folders = try self.defaultManager().contentsOfDirectoryAtPath(folder)
        } catch {
            print("Failed to enumerate folders at \(folder)")
        }
        return folders
    }
    
    /* Deletes all files/folders in a given path */
    class func deleteFilesInFolder(folder: String){
        
        let contents = enumerateFilesInFolder(folder)
        
        for fileName in contents{
            let filePath = (folder as NSString).stringByAppendingPathComponent(fileName)
            
            deleteFileAtPath(filePath)
            
        }
        
    }
    
    class func printFilesInDocumentFolder(){
        do{
            try printFilesInFolderRecursive(applicationDocumentsDirectory())
        } catch {
            print("Error")
        }
    }
    
    class func printFilesInFolderRecursive(path:NSURL) throws{
        let filelist = try self.defaultManager().enumeratorAtPath(path.path!)
        while let element = filelist?.nextObject() as? String {
            print(element)
        }
    }
}

func delay(delay:Double, closure:()->()) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(delay * Double(NSEC_PER_SEC))),dispatch_get_main_queue(), closure)
}

extension UIColor {
    class func getFitPatternBackgroungImage(nameImage:String, container:UIView) -> UIColor{
        UIGraphicsBeginImageContext(container.frame.size)
        UIImage(named: nameImage)!.drawInRect(container.bounds)
        let imagePatternFit = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return self.init(patternImage: imagePatternFit)
    }
}

/*
func returnBackNavigationControllerByIdentifier(storyboard:UIStoryboard, navigationController:UINavigationController, identifier:String, animate:Bool) {
    
    //creiamo un Bool che ci servirà più avanti
    var ceNonCe = false
    
    //lanciamo un ciclo for dentro all'array viewControllers che contiene tutti i controller caricati nella barra di navigazione
    for controller in navigationController.viewControllers {
        
        //verifichiamo che il ciclo sia arrivato al controller a cuo vogliamo tornare
        if controller is SecondoController {
            //una volta trovato usaimo il metodo per tornare ad uno specifico controller
            navigationController.popToViewController(controller, animated: true)
            
            //mettiamo il boolano su true perchè abbiamo trovato il controller che ci interessava e ci siamo già tornati
            ceNonCe = true
            break
        }
    }
    
    //nel caso in cui il ciclo for vada a vuoto (ovvero non abbiamo trovato il controller che ci interessava)
    //il boolenano rimase su false e se lo è...
    if ceNonCe == false {
        print("non in memoria")
        //carichiamo a mano il controller in memoria (chiamiamo in causa lo storyboard che lo farà per noi)
        //NOTA: per poterlo fare il controller in questione è stato "nominato" (Controller2 in questo esempio)
        //per nominare un controller bisigna selezionarlo (nello storyboard), aprire l'Identity Inspector (la carta di identità), e scrivere un nome nel campo Storyboard ID
        if let secondoController = storyboard!.instantiateViewControllerWithIdentifier("Controller2") as? SecondoController {
            //adesso che è carico in memoria lo apriamo con l'apposito metodo
            navigationController!.pushViewController(secondoController, animated: true)
        }
    }
    
}
*/