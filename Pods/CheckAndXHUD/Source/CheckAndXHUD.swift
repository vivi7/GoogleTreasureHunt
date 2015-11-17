//
//  CheckAndXHUD.swift
//  CheckAndXHUD
//
//  Created by Vincenzo Favara on 14/10/15.
//  Copyright © 2015 Vincenzo Favara. All rights reserved.
//

import UIKit

public class CheckAndXHUD: NSObject {
    private static let sharedObject = CheckAndXHUD()
    let checkAndXView = CheckAndXView()

    public static func showCheckInView(view: UIView) {
        CheckAndXHUD.sharedObject.showInView(view, message: nil, isDone: true)
    }
    
    public static func showXInView(view: UIView) {
        CheckAndXHUD.sharedObject.showInView(view, message: nil, isDone: false)
    }
    
    public static func showCheckInView(view: UIView, message: String?) {
        CheckAndXHUD.sharedObject.showInView(view, message: message, isDone: true)
    }
    
    public static func showXInView(view: UIView, message: String?) {
        CheckAndXHUD.sharedObject.showInView(view, message: message, isDone: false)
    }
    
    public static func showInView(view: UIView, isDone: Bool) {
        CheckAndXHUD.sharedObject.showInView(view, message: nil, isDone: isDone)
    }
    
    public static func showInView(view: UIView, message: String?, isDone: Bool) {
        CheckAndXHUD.sharedObject.showInView(view, message: message, isDone: isDone)
    }
    
    private func showInView(view: UIView, message: String?, isDone: Bool) {
        // Set size of done view
        let checkAndXViewWidth = min(view.frame.width, view.frame.height) / 2
        var originX: CGFloat, originY: CGFloat
        if (UIDevice.currentDevice().systemVersion as NSString).floatValue >= 8.0 {
            originX = (view.frame.width - checkAndXViewWidth) / 2
            originY = (view.frame.height - checkAndXViewWidth) / 2
        } else {
            let isLandscape = UIDevice.currentDevice().orientation.isLandscape
            originX = ((isLandscape ? view.frame.height : view.frame.width) - checkAndXViewWidth) / 2
            originY = ((isLandscape ? view.frame.width : view.frame.height) - checkAndXViewWidth) / 2
        }
        let checkAndXViewFrame = CGRectMake(
            originX,
            originY,
            checkAndXViewWidth,
            checkAndXViewWidth)
        self.checkAndXView.layer.cornerRadius = 8
        self.checkAndXView.frame = checkAndXViewFrame

        // Set message
        self.checkAndXView.setMessage(message)
        
        // Set isDone
        self.checkAndXView.setIsDone(isDone)
        
        // Start animation
        self.checkAndXView.alpha = 0
        view.addSubview(self.checkAndXView)
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.checkAndXView.alpha = 1
        }) { (result: Bool) -> Void in
            self.checkAndXView.drawCheck({ () -> Void in
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue()) {
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        self.checkAndXView.alpha = 0
                        }) { (result: Bool) -> Void in
                            self.checkAndXView.removeFromSuperview()
                            self.checkAndXView.clear()
                    }
                }
            })
        }
    }
}
