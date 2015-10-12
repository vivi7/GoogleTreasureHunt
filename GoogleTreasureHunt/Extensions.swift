//
//  Extensions.swift
//  GoogleTreasureHunt
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
        let comps = NSDateComponents()
        comps.year = ye
        comps.month = mo
        comps.day = da
        comps.hour = ho
        comps.minute = mi
        comps.second = se
        let date = NSCalendar.currentCalendar().dateFromComponents(comps)
        return date!
    }
}

extension NSFileManager {
    class func documentsDir() -> String {
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths[0]
    }
    
    class func cachesDir() -> String {
        var paths = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)
        return paths[0]
    }
}

//Aggiunge l' effetto parallasse
extension UIView {
    
    func addParallax(X horizontal:Float, Y vertical:Float) {
        
        let parallaxOnX = UIInterpolatingMotionEffect(keyPath: "center.x", type: UIInterpolatingMotionEffectType.TiltAlongHorizontalAxis)
        parallaxOnX.minimumRelativeValue = -horizontal
        parallaxOnX.maximumRelativeValue = horizontal
        
        let parallaxOnY = UIInterpolatingMotionEffect(keyPath: "center.y", type: UIInterpolatingMotionEffectType.TiltAlongVerticalAxis)
        parallaxOnY.minimumRelativeValue = -vertical
        parallaxOnY.maximumRelativeValue = vertical
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [parallaxOnX, parallaxOnY]
        self.addMotionEffect(group)
    }
    
    func blurMyBackgroundDark(adjust b:Bool, white v:CGFloat, alpha a:CGFloat) {
        
        for v in self.subviews {
            if v is UIVisualEffectView {
                v.removeFromSuperview()
            }
        }
        
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let fxView = UIVisualEffectView(effect: blur)
        
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
        
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let fxView = UIVisualEffectView(effect: blur)
        
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
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let fxView = UIVisualEffectView(effect: blur)
        fxView.contentView.backgroundColor = UIColor(white:0.7, alpha:0.3)
        fxView.frame = self.frame
        self.addSubview(fxView)
    }
    
}

extension UIImage {
    
    func fromLandscapeToPortrait(rotate: Bool!) -> UIImage {
        let container : UIImageView = UIImageView(frame: CGRectMake(0, 0, 320, 568))
        container.contentMode = UIViewContentMode.ScaleAspectFill
        container.clipsToBounds = true
        container.image = self
        
        UIGraphicsBeginImageContextWithOptions(container.bounds.size, true, 0);
        container.drawViewHierarchyInRect(container.bounds, afterScreenUpdates: true)
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if !rotate {
            return normalizedImage
        } else {
            let rotatedImage = UIImage(CGImage: normalizedImage.CGImage!, scale: 1.0, orientation: UIImageOrientation.Left)
            
            UIGraphicsBeginImageContextWithOptions(rotatedImage.size, true, 1);
            rotatedImage.drawInRect(CGRectMake(0, 0, rotatedImage.size.width, rotatedImage.size.height))
            let normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            return normalizedImage
        }
    }
}

