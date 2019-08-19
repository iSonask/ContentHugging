//
//  ResizableBubble.swift
//  ContentHuggin
//
//  Created by mac on 02/07/19.
//  Copyright © 2019 Sigma. All rights reserved.
//

import UIKit

class ResizableBubble: UIView {


    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = UIGraphicsGetCurrentContext()
        
        let bubbleGradientTop = UIColor(red: 1, green: 0.817, blue: 0.053, alpha: 1)
        let bubbleGradientBottom = UIColor(red: 1, green: 0.817, blue: 0.053, alpha: 1)
        let bubbleHighlightColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        let bubbleStrokeColor = UIColor(red: 0.173, green: 0.173, blue: 0.173, alpha: 1)

        let bubbleGradientColors = [bubbleGradientTop.cgColor,bubbleGradientBottom.cgColor]
        let bubbleGradientLocations = [CGFloat(0),CGFloat(1)]
        let bubbleGradient = CGGradient(colorsSpace: colorSpace, colors: bubbleGradientColors as CFArray, locations: bubbleGradientLocations)!
        
        let outerShadow = UIColor.black
        let outerShadowOffset = CGSize(width:0.1,height: 6.1)
        let outerShadowBlurRadius = 13
        let highlightShadow = bubbleHighlightColor
        let highlightShadowOffset = CGSize(width:0.1,height:  2.1)
        let highlightShadowBlurRadius = 0

        let bubbleFrame = self.bounds

        let arrowFrame = CGRect(x: bubbleFrame.minX + floor((bubbleFrame.minX - 59) * 0.50462 + 0.5), y: bubbleFrame.minY + bubbleFrame.height - 46, width: 59, height: 46)
        
        let bubblePath = UIBezierPath()
        
        bubblePath.move(to: CGPoint(x: bubbleFrame.maxX - 12, y: bubbleFrame.minY + 28.5))
        bubblePath.addLine(to: CGPoint(x: bubbleFrame.maxX - 12, y: bubbleFrame.maxY - 27.5))
        bubblePath.addCurve(to: CGPoint(x: bubbleFrame.maxX - 25, y: bubbleFrame.maxY - 14.5), controlPoint1: CGPoint(x: bubbleFrame.maxX - 12, y: bubbleFrame.maxY - 20.32), controlPoint2: CGPoint(x: bubbleFrame.maxX - 17.82, y: bubbleFrame.maxY - 14.5))
        bubblePath.addLine(to: CGPoint(x: arrowFrame.minX + 40.5, y: arrowFrame.maxY - 13.5))
        bubblePath.addLine(to: CGPoint(x: arrowFrame.minX + 29.5, y: arrowFrame.maxY - 0.5))
        bubblePath.addLine(to: CGPoint(x: arrowFrame.minX + 18.5, y: arrowFrame.maxY - 13.5))
        bubblePath.addLine(to: CGPoint(x: bubbleFrame.minX + 26.5, y: bubbleFrame.maxY - 14.5))
        bubblePath.addCurve(to: CGPoint(x: bubbleFrame.minX + 13.5, y: bubbleFrame.maxY - 27.5), controlPoint1: CGPoint(x: bubbleFrame.minX + 19.32, y: bubbleFrame.maxY - 14.5), controlPoint2: CGPoint(x: bubbleFrame.minX + 13.5, y: bubbleFrame.maxY - 20.32))
        bubblePath.addLine(to: CGPoint(x: bubbleFrame.minX + 13.5, y: bubbleFrame.minY + 28.5))
        
        bubblePath.addCurve(to: CGPoint(x: bubbleFrame.minX + 26.5, y: bubbleFrame.minY + 15.5), controlPoint1: CGPoint(x: bubbleFrame.minX + 13.5, y: bubbleFrame.minY + 21.32), controlPoint2: CGPoint(x: bubbleFrame.minX + 19.32, y: bubbleFrame.minY + 15.5))
        
        bubblePath.addLine(to: CGPoint(x: bubbleFrame.maxX - 25, y: bubbleFrame.minY + 15.5))
        
        bubblePath.addCurve(to: CGPoint(x: bubbleFrame.maxX - 12, y: bubbleFrame.minY + 28.5), controlPoint1: CGPoint(x: bubbleFrame.maxX - 17.82, y: bubbleFrame.minY + 15.5), controlPoint2: CGPoint(x: bubbleFrame.maxX  - 12, y: bubbleFrame.minY + 21.32))
        
        
        bubblePath.close()

        context?.saveGState()
        context!.setShadow(offset: outerShadowOffset, blur: CGFloat(outerShadowBlurRadius), color: outerShadow.cgColor)
        context?.beginTransparencyLayer(in: self.bounds, auxiliaryInfo: nil)
        bubblePath.addClip()
        let bubbleBounds = bubblePath.cgPath.boundingBoxOfPath
        

        context?.drawLinearGradient(bubbleGradient, start: CGPoint(x: bubbleBounds.midX, y: bubbleBounds.minY), end: CGPoint(x: bubbleBounds.midX, y: bubbleBounds.maxY), options: CGGradientDrawingOptions(rawValue: 0))
        context?.endTransparencyLayer()
        
        var bubbleBorderRect = bubblePath.bounds.insetBy(dx: CGFloat(-highlightShadowBlurRadius), dy: CGFloat(-highlightShadowBlurRadius))
        bubbleBorderRect = bubbleBorderRect.offsetBy(dx: CGFloat(-highlightShadowOffset.width), dy: CGFloat(-highlightShadowOffset.height))
        bubbleBorderRect = bubbleBorderRect.union(bubblePath.bounds).insetBy(dx: -1, dy: -1)
        
        let bubbleNegativePath = UIBezierPath(rect: bubbleBorderRect)
        bubbleNegativePath.append(bubblePath)
        bubbleNegativePath.usesEvenOddFillRule = true


        context!.saveGState()
        do {
            let xOffset = CGFloat(highlightShadowOffset.width + round(bubbleBorderRect.size.width))
            let yOffset = highlightShadowOffset.height
            context!.setShadow(offset: CGSize(width: xOffset + copysign(0.1, xOffset), height: yOffset + copysign(0.1, yOffset)), blur: CGFloat(highlightShadowBlurRadius), color: highlightShadow.cgColor)
            
            bubblePath.addClip()
            let transform = CGAffineTransform(translationX: -round(bubbleBorderRect.size.width), y: 0)
            bubbleNegativePath.apply(transform)
            UIColor.gray.setFill()
            bubbleNegativePath.fill()
        }
        context!.restoreGState()
        context!.restoreGState()
        bubbleStrokeColor.setStroke()
        bubblePath.lineWidth = 1
        bubblePath.stroke()




    }
}
