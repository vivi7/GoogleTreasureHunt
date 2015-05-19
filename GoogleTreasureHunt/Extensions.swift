//
//  Extensions.swift
//  Spesami
//
//  Created by Vincenzo Favara on 18/01/15.
//  Copyright (c) 2015 Vincenzo Favara (VinSoft). All rights reserved.
//

import UIKit
import Foundation
import StoreKit

//Prezzo localizzato
extension SKProduct {
    
    func localizedPrice() -> String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = self.priceLocale
        return formatter.stringFromNumber(self.price)!
    }
    //Usage //NSLog("The price of this product is \(product.localizedPrice())")
    // Example output: The price of this product is £0.69
}

//Crea una data direttamente dai valori passati
extension NSDate {
    
    func customDate(year ye:Int, month mo:Int, day da:Int, hour ho:Int, minute mi:Int, second se:Int) -> NSDate {
        var comps = NSDateComponents()
        comps.year = ye
        comps.month = mo
        comps.day = da
        comps.hour = ho
        comps.minute = mi
        comps.second = se
        var date = NSCalendar.currentCalendar().dateFromComponents(comps)
        return date!
    }
}

extension NSFileManager {
    class func documentsDir() -> String {
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as! [String]
        return paths[0]
    }
    
    class func cachesDir() -> String {
        var paths = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true) as! [String]
        return paths[0]
    }
}

//Aggiunge l' effetto parallasse
extension UIView {
    
    func addParallax(X horizontal:Float, Y vertical:Float) {
        
        var parallaxOnX = UIInterpolatingMotionEffect(keyPath: "center.x", type: UIInterpolatingMotionEffectType.TiltAlongHorizontalAxis)
        parallaxOnX.minimumRelativeValue = -horizontal
        parallaxOnX.maximumRelativeValue = horizontal
        
        var parallaxOnY = UIInterpolatingMotionEffect(keyPath: "center.y", type: UIInterpolatingMotionEffectType.TiltAlongVerticalAxis)
        parallaxOnY.minimumRelativeValue = -vertical
        parallaxOnY.maximumRelativeValue = vertical
        
        var group = UIMotionEffectGroup()
        group.motionEffects = [parallaxOnX, parallaxOnY]
        self.addMotionEffect(group)
    }
    
    func blurMyBackgroundDark(adjust b:Bool, white v:CGFloat, alpha a:CGFloat) {
        
        for v in self.subviews {
            if v is UIVisualEffectView {
                v.removeFromSuperview()
            }
        }
        
        var blur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        var fxView = UIVisualEffectView(effect: blur)
        
        if b {
            fxView.contentView.backgroundColor = UIColor(white:v, alpha:a)
        }
        
        fxView.frame = self.bounds

        self.addSubview(fxView)
        self.sendSubviewToBack(fxView)
    }
    
    func blurMyBackgroundLight() {
        
        for v in self.subviews {
            if v is UIVisualEffectView {
                v.removeFromSuperview()
            }
        }
        
        var blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        var fxView = UIVisualEffectView(effect: blur)
        
        var rect = self.bounds
        rect.size.width = CGFloat(2500)
        
        fxView.frame = rect
        
        self.addSubview(fxView)
        
//        let viewsDictionary = ["view1":self,"view2":fxView]
//        let view_constraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[view2]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
//        let view_constraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[view2]-|", options: NSLayoutFormatOptions.AlignAllLeading, metrics: nil, views: viewsDictionary)
//        
//        self.addConstraints(view_constraint_H)
//        self.addConstraints(view_constraint_V)
        
        self.sendSubviewToBack(fxView)
    }
}

//Applicare blur (solo iOS 8) ad una TextView
extension UITextView {
    
    func blurMyBackground() {
        var blur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        var fxView = UIVisualEffectView(effect: blur)
        fxView.contentView.backgroundColor = UIColor(white:0.7, alpha:0.3)
        fxView.frame = self.frame
        self.addSubview(fxView)
    }
    
}

extension UIImage {
    
    func fromLandscapeToPortrait(rotate: Bool!) -> UIImage {
        var container : UIImageView = UIImageView(frame: CGRectMake(0, 0, 320, 568))
        container.contentMode = UIViewContentMode.ScaleAspectFill
        container.clipsToBounds = true
        container.image = self
        
        UIGraphicsBeginImageContextWithOptions(container.bounds.size, true, 0);
        container.drawViewHierarchyInRect(container.bounds, afterScreenUpdates: true)
        var normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if !rotate {
            return normalizedImage
        } else {
            var rotatedImage = UIImage(CGImage: normalizedImage.CGImage, scale: 1.0, orientation: UIImageOrientation.Left)
            
            UIGraphicsBeginImageContextWithOptions(rotatedImage!.size, true, 1);
            rotatedImage!.drawInRect(CGRectMake(0, 0, rotatedImage!.size.width, rotatedImage!.size.height))
            var normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            return normalizedImage
        }
    }
}

extension String {
    func isValidEmail() -> Bool {
        let regex = NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$", options: .CaseInsensitive, error: nil)
        return regex?.firstMatchInString(self, options: nil, range: NSMakeRange(0, count(self))) != nil
    }
}


//Metodi Speciali

//restituisce il nome della classe come stringa
func nameOfClass(classType: AnyClass) -> String {
    
    let stringOfClassType: String = NSStringFromClass(classType)
    let swiftClassPrefix = "_TtC"
    
    if stringOfClassType.hasPrefix(swiftClassPrefix) {
        let characters = Array(stringOfClassType)
        var ciphersForModule = String()
        var index = count(swiftClassPrefix)
        
        while index < characters.count {
            let character = characters[index++]
            if String(character).toInt() != nil {
                ciphersForModule.append(character)
            } else {
                break
            }
        }

        if let numberOfCharactersOfModuleName = ciphersForModule.toInt() {

            index += numberOfCharactersOfModuleName - 1
            var ciphersForClass = String()
            while index < characters.count {
                let character = characters[index++]
                if String(character).toInt() != nil  {
                    ciphersForClass.append(character)
                } else {
                    break
                }
            }
            if let numberOfCharactersOfClassName = ciphersForClass.toInt() {

                if numberOfCharactersOfClassName > 0 && index - 1 + numberOfCharactersOfClassName <= characters.count {

                    let range = NSRange(location: index - 1, length: numberOfCharactersOfClassName)
                    let nameOfClass = (stringOfClassType as NSString).substringWithRange(range)
                    return nameOfClass
                }
            }
        }
    }
    
    return stringOfClassType
}

