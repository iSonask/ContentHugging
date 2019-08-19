//
//  SASliderRight.swift
//  ContentHuggin
//
//  Created by mac on 02/07/19.
//  Copyright © 2019 Sigma. All rights reserved.
//

import UIKit

class SASliderRight: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = UIGraphicsGetCurrentContext()
        
        //// Color Declarations
        let color5 = UIColor(red: 0.992, green: 0.902, blue: 0.004, alpha: 1)
        let gradientColor2 = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        let color6 = UIColor(red: 0.196, green: 0.161, blue: 0.047, alpha: 1)
        
        //// Gradient Declarations
        let gradient3Colors = [gradientColor2.cgColor, UIColor(red: 0.996, green: 0.951, blue: 0.502, alpha: 1).cgColor, color5.cgColor]
        let gradient3Locations = [CGFloat(0),CGFloat(0), CGFloat(0.49)]
        let gradient3 = CGGradient(colorsSpace: colorSpace,colors:  gradient3Colors as CFArray,locations: gradient3Locations)!
        
        //// Frames
        let bubbleFrame = bounds
        
        let roundedRectangleRect = CGRect(x: bubbleFrame.minX, y: bubbleFrame.minY, width: bubbleFrame.width, height: bubbleFrame.height)
        let roundedRectanglePath = UIBezierPath(roundedRect: roundedRectangleRect, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: 5, height: 5))
        roundedRectanglePath.close()
        context!.saveGState()
        roundedRectanglePath.addClip()
        context!.drawLinearGradient(gradient3, start: CGPoint(x: roundedRectangleRect.midX, y: roundedRectangleRect.minY), end: CGPoint(x: roundedRectangleRect.midX, y: roundedRectangleRect.maxY), options: [])
        context!.restoreGState()
        UIColor.clear.setStroke()
        roundedRectanglePath.lineWidth = 0.5
        roundedRectanglePath.stroke()
        
        //// Bezier 3 Drawing
        let bezier3Path = UIBezierPath()
        bezier3Path.move(to: CGPoint(x: bubbleFrame.minX + 0.42806 * bubbleFrame.width, y: bubbleFrame.minY + 0.22486 * bubbleFrame.height))
        bezier3Path.addCurve(to: CGPoint(x: bubbleFrame.minX + 0.42806 * bubbleFrame.width, y: bubbleFrame.minY + 0.74629 * bubbleFrame.height), controlPoint1: CGPoint(x: bubbleFrame.minX + 0.42806 * bubbleFrame.width, y: bubbleFrame.minY + 0.69415 * bubbleFrame.height), controlPoint2: CGPoint(x: bubbleFrame.minX + 0.42806 * bubbleFrame.width, y: bubbleFrame.minY + 0.69415 * bubbleFrame.height))
        bezier3Path.addLine(to: CGPoint(x: bubbleFrame.minX + 0.35577 * bubbleFrame.width, y: bubbleFrame.minY + 0.74629 * bubbleFrame.height))
        bezier3Path.addCurve(to: CGPoint(x: bubbleFrame.minX + 0.35577 * bubbleFrame.width, y: bubbleFrame.minY + 0.22486 * bubbleFrame.height), controlPoint1: CGPoint(x: bubbleFrame.minX + 0.35577 * bubbleFrame.width, y: bubbleFrame.minY + 0.69415 * bubbleFrame.height), controlPoint2: CGPoint(x: bubbleFrame.minX + 0.35577 * bubbleFrame.width, y: bubbleFrame.minY + 0.69415 * bubbleFrame.height))
        bezier3Path.addLine(to: CGPoint(x: bubbleFrame.minX + 0.66944 * bubbleFrame.width, y:bubbleFrame.minY + 0.22486 * bubbleFrame.height ))
        
        bezier3Path.close()
        bezier3Path.miterLimit = CGFloat(19)
        color6.setFill()
        bezier3Path.fill()
        
    }

}
