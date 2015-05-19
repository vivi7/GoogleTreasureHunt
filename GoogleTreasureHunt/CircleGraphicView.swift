//
//  CircleGraphicView.swift
//  GoogleTreasureHunt
//
//  Created by Vincenzo Favara on 07/05/15.
//  Copyright (c) 2015 Vincenzo Favara. All rights reserved.
//

import Foundation
import UIKit

class CircleGraphicView: UIView {
    
    var endArc:CGFloat = 0.0{   // in range of 0.0 to 1.0
        didSet{
            setNeedsDisplay()
        }
    }
    
    var initArc:CGFloat = -0.25{
        didSet{
            setNeedsDisplay()
        }
    }
    
    var frazione:CGFloat = 0.0
    
    func setTimer(num:CGFloat){
        if frazione == 0.0{
            frazione = 1/num
        }
        endArc = (frazione*num)
    }
    
    func setProgress(num:CGFloat){
        if frazione == 0.0{
            frazione = 1/num
        }
        endArc = 1-(frazione*num)
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
    }
    
    override func drawRect(rect: CGRect) {
        
        self.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        
        //        var endArc:CGFloat = 0.0 // in range of 0.0 to 1.0
        var arcWidth:CGFloat = 8.0
        var arcColor = UIColor.whiteColor()
        var arcBackgroundColor = UIColor(white: 15, alpha: 0.2)
        
        //find the centerpoint of the rect
        var centerPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))
        
        //        var centralLabel = UILabel(frame: CGRectMake(centerPoint.x-self.frame.width/2, centerPoint.y-self.frame.height/2, self.frame.width/2, self.frame.height/2))
        //        centralLabel.center = centerPoint
        //        centralLabel.textColor = UIColor.whiteColor()
        //        centralLabel.text = "\(endArc)"
        //        self.addSubview(centralLabel)
        
        //Important constants for circle
        let fullCircle = 2.0 * CGFloat(M_PI)
        let start:CGFloat = initArc * fullCircle
        let end:CGFloat = endArc * fullCircle + start
        
        //define the radius by the smallest side of the view
        var radius:CGFloat = 0.0
        if CGRectGetWidth(rect) > CGRectGetHeight(rect){
            radius = (CGRectGetWidth(rect) - arcWidth) / 2.0
        }else{
            radius = (CGRectGetHeight(rect) - arcWidth) / 2.0
        }
        
        //starting point for all drawing code is getting the context.
        let context = UIGraphicsGetCurrentContext()
        //set colorspace
        let colorspace = CGColorSpaceCreateDeviceRGB()
        
        //set line attributes
        CGContextSetLineWidth(context, arcWidth)
        CGContextSetLineCap(context, kCGLineCapRound)
        
        //make the circle background
        CGContextSetStrokeColorWithColor(context, arcBackgroundColor.CGColor)
        CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, 0, fullCircle, 0)
        CGContextStrokePath(context)
        
        //make the circle
        CGContextSetStrokeColorWithColor(context, arcColor.CGColor)
        CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, start, end, 0)
        CGContextStrokePath(context)
    }
}