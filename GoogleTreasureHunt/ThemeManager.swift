//
//  ThemeManager.swift
//  Restaurant
//
//  Created by AppsFoundation on 7/29/15.
//  Copyright © 2015 AppsFoundation. All rights reserved.
//

import UIKit
import CheckAndXHUD
import MBProgressHUD
import GMDColors

class ThemeManager: NSObject {
    
    //static let sharedManager = ThemeManager()
    // MARK: - Singleton
    class var sharedInstance:ThemeManager {
        get {
            struct Static {
                static var instance : ThemeManager? = nil
                static var token : dispatch_once_t = 0
            }
            
            dispatch_once(&Static.token) { Static.instance = ThemeManager() }
            
            return Static.instance!
        }
    }
    
    private override init() {}
    
    let appName = "AppName"
    let backgroungImageName = "bg"
    let menuButtonImageName = "menu_button"
    let progressHudText = "Loading Hunt..."
    
    private let NavigationBarFontSize = 18.0
    private let NavigationBarFontName = "KozGoPro-Light"

    func applyNavigationBarTheme(navigationBar : UINavigationBar?) {
        //UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: NavigationBarFontName, size: CGFloat(NavigationBarFontSize))!]
        navigationBar?.hidden = true
    }
    
    func applyBackgroundTheme(view : UIView) {
        view.backgroundColor = UIColor.getFitPatternBackgroungImage(backgroungImageName, container: view)
    }
    
    func applyBackgroundTrimTheme(view : UIView){
        let imageView = UIImageView(frame: view.frame)
        imageView.image = UIImage(named: "material_trim")!
        view.addSubview(imageView)
    }
    
    func startProgressHud(view : UIView){
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = progressHudText
    }
    
    func stopProgressHud(view : UIView){
        MBProgressHUD.hideHUDForView(view, animated: true)
    }
    
    func showMessage(viewPassed : UIView, message: String?, isDone: Bool){
        CheckAndXHUD.showInView(viewPassed, message: message, isDone: isDone)
    }
    
    let rainbowArr : [CGColorRef] = [UIColor.GMDpomegranateColor().CGColor, UIColor.GMDcaliforniaColor().CGColor, UIColor.GMDsandstormColor().CGColor, UIColor.GMDemeraldColor().CGColor, UIColor.GMDdodgerBlueColor().CGColor, UIColor.GMDstudioColor().CGColor, UIColor.GMDrebeccapurpleColor().CGColor]
    
    func rainbowBackground(viewPassed : UIView){
        self.rainbowBackgroundAtIndex(viewPassed, index: 0)
    }
    
    func rainbowBackgroundAtIndex(viewPassed : UIView, index : Int){
        viewPassed.layer.configureGradientBackground(self.rainbowArr[(0+index)%6], self.rainbowArr[(1+index)%6], self.rainbowArr[(2+index)%6], self.rainbowArr[(3+index)%6], self.rainbowArr[(4+index)%6], self.rainbowArr[(5+index)%6], self.rainbowArr[(6+index)%6])
    }
    
    func animatedRainbowBackground(viewPassed : UIView){
        animatedBackground(viewPassed, colors: rainbowArr)
    }
    
    func animatedBackground(viewPassed: UIView, colors: [CGColorRef]){
        self.fromColors = colors
        self.viewPassed = viewPassed
        configureGradientAnimatedBackground()
    }
    
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        animateLayer()
    }
    
    // MARK: - Private Methods
    private var toColors : [CGColorRef]?
    private var fromColors : [CGColorRef]!
    private var gradient = CAGradientLayer()
    private var viewPassed : UIView!
    
    private func configureGradientAnimatedBackground(){
        let maxWidth = max(viewPassed.layer.bounds.size.height, viewPassed.layer.bounds.size.width)
        let squareFrame = CGRect(origin: viewPassed.layer.bounds.origin, size: CGSizeMake(maxWidth, maxWidth))
        gradient.frame = squareFrame
        gradient.colors = fromColors
        viewPassed.layer.insertSublayer(gradient, atIndex: 0)
        
        self.animateLayer()
    }
    
    private func animateLayer(){
        toColors = fromColors
        toColors!.removeFirst()
        toColors!.append(fromColors!.first!)
        
        self.fromColors = self.gradient.colors as! [CGColorRef]
        self.gradient.colors = self.toColors
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = fromColors
        animation.toValue = toColors
        animation.duration = 1.00
        animation.removedOnCompletion = true
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.delegate = self
        
        gradient.addAnimation(animation, forKey:"animateGradient")
        
        self.fromColors = toColors //self.gradient.colors as! [CGColorRef]
    }
    
}

extension CALayer {
    func configureGradientBackground(colors:CGColorRef...){
        let gradient = CAGradientLayer()
        let maxWidth = max(self.bounds.size.height,self.bounds.size.width)
        let squareFrame = CGRect(origin: self.bounds.origin, size: CGSizeMake(maxWidth, maxWidth))
        gradient.frame = squareFrame
        gradient.colors = colors
        self.insertSublayer(gradient, atIndex: 0)
    }
}
