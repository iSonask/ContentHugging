//
//  SARangeSliderView.swift
//  ContentHuggin
//
//  Created by mac on 02/07/19.
//  Copyright © 2019 Sigma. All rights reserved.
//

import UIKit
import AVFoundation
import QuartzCore
import CoreMedia

protocol SAVideoRangeSliderDelegate: NSObjectProtocol {
    
    func videoRange(_ videoRange: SARangeSliderView?, didChangeLeftPosition leftPosition: CGFloat, rightPosition: CGFloat)
    func videoRange(_ videoRange: SARangeSliderView?, didGestureStateEndedLeftPosition leftPosition: CGFloat, rightPosition: CGFloat)
}


class SARangeSliderView: UIView {

    weak var delegate: SAVideoRangeSliderDelegate?
//    var leftPosition: CGFloat = 0.0
//    var rightPosition: CGFloat = 0.0
    var leftPosition : CGFloat = 0.0 {
        didSet(value){
            self.leftPosition = value * CGFloat(durationSeconds) / frame_width
        }
    }
    
    var rightPosition : CGFloat = 0.0 {
        
        didSet(value){
         self.rightPosition = value * CGFloat(durationSeconds) / frame_width
        }
    }
    var bubleText: UILabel?
    var topBorder: UIView?
    var bottomBorder: UIView?
    var maxGap = 0
    var minGap = 0
    
    var imageGenerator: AVAssetImageGenerator?
    var bgView: UIView?
    var centerView: UIView?
    var videoUrl: URL?
    var leftThumb: SASliderLeft?
    var rightThumb: SASliderRight?
    var frame_width: CGFloat = 0.0
    var durationSeconds: Float64 = 0
    var popoverBubble: ResizableBubble?
    let SLIDER_BORDERS_SIZE = 6
    let BG_VIEW_BORDERS_SIZE = 3
    
    init?(frame: CGRect, videoUrl: URL?) {
        super.init(frame: frame)
        frame_width = frame.size.width
        let thumbWidth = ceil(frame.size.width * 0.05)
        bgView = UIControl(frame: CGRect(x: CGFloat(Double(thumbWidth) - Double(BG_VIEW_BORDERS_SIZE)), y: 0, width: CGFloat(Double(frame.size.width - CGFloat((thumbWidth * 2))) + Double(BG_VIEW_BORDERS_SIZE * 2)), height: frame.size.height))
        bgView!.layer.borderColor = UIColor.gray.cgColor
        bgView!.layer.borderWidth = CGFloat(BG_VIEW_BORDERS_SIZE)
        addSubview(bgView!)
        self.videoUrl = videoUrl
        topBorder = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: CGFloat(SLIDER_BORDERS_SIZE)))
        topBorder!.backgroundColor = UIColor(red: 0.996, green: 0.951, blue: 0.502, alpha: 1)
        addSubview(topBorder!)
        
        bottomBorder = UIView(frame: CGRect(x: 0, y: Int(frame.size.height) - SLIDER_BORDERS_SIZE, width: Int(frame.size.width), height: SLIDER_BORDERS_SIZE))
        
        bottomBorder!.backgroundColor = UIColor(red: 0.992, green: 0.902, blue: 0.004, alpha: 1)
        addSubview(bottomBorder!)
        
        leftThumb = SASliderLeft(frame: CGRect(x: 0, y: 0, width: thumbWidth, height: frame.size.height))
        leftThumb!.contentMode = .left
        leftThumb!.isUserInteractionEnabled = true
        leftThumb!.clipsToBounds = true
        leftThumb!.backgroundColor = UIColor.clear
        leftThumb!.layer.borderWidth = 0
        addSubview(leftThumb!)
        
        let leftPan = UIPanGestureRecognizer(target: self, action: #selector(handleLeftPan(_:)))
        leftThumb!.addGestureRecognizer(leftPan)
        rightThumb = SASliderRight(frame: CGRect(x: 0, y: 0, width: thumbWidth, height: frame.size.height))
        rightThumb!.contentMode = .right
        rightThumb!.isUserInteractionEnabled = true
        rightThumb!.clipsToBounds = true
        rightThumb!.backgroundColor = .clear
        addSubview(rightThumb!)
        let rightPan = UIPanGestureRecognizer(target: self, action: #selector(handleLeftPan(_:)))
        rightThumb?.addGestureRecognizer(rightPan)
        rightPosition = frame.size.width
        leftPosition = 0
        
        centerView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        centerView!.backgroundColor = .clear
        addSubview(centerView!)
        
        let centerPan = UIPanGestureRecognizer(target: self, action: #selector(handleLeftPan(_:)))
        centerView!.addGestureRecognizer(centerPan)
        
        
        popoverBubble = ResizableBubble(frame: CGRect(x: 0, y: -50, width: 100, height: 50))
        
        popoverBubble!.alpha = 0
        
        popoverBubble!.backgroundColor = .clear
        addSubview(popoverBubble!)
        
        bubleText = UILabel(frame: popoverBubble!.frame)
        
        bubleText!.font = UIFont.boldSystemFont(ofSize: 20)
        bubleText!.backgroundColor = .clear
        bubleText!.textColor = .black
        bubleText!.textAlignment = .center
        
        popoverBubble?.addSubview(bubleText!)
        

    getMovieFrame()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPopoverBubbleSize(_ width: CGFloat, height: CGFloat) {
        var currentFrame = popoverBubble!.frame
        currentFrame.size.width = width
        currentFrame.size.height = height
        currentFrame.origin.y = -height
        popoverBubble!.frame = currentFrame
        
        currentFrame.origin.x = 0
        currentFrame.origin.y = 0
        bubleText!.frame = currentFrame

    }

    func setMaxGap(_ maxGap: Int) {
        leftPosition = 0
        rightPosition = CGFloat(Double(Int(frame_width) * maxGap) / durationSeconds)
        self.maxGap = maxGap
    }
    
    func setMinGap(_ minGap: Int) {
        leftPosition = 0
        rightPosition = CGFloat(Double(Int(frame_width) * minGap) / durationSeconds)
        self.minGap = minGap
    }
    
    func delegateNotification() {
        
//        if delegate!.responds(to: #selector(self.videoRange(_:didChangeLeftPosition:rightPosition:))) {
            delegate!.videoRange(self, didChangeLeftPosition: leftPosition, rightPosition: rightPosition)
//        }
        
    }
    
    @objc func handleLeftPan(_ gesture: UIPanGestureRecognizer?) {
        if gesture?.state == .began || gesture?.state == .changed {
            let translation = gesture?.translation(in: self)
            leftPosition += translation!.x
            if leftPosition < 0 {
                leftPosition = 0
            }
            if (rightPosition - leftPosition <= leftThumb!.frame.size.width + rightThumb!.frame.size.width) || ((maxGap > 0) && (Int(rightPosition - leftPosition) > maxGap)) || ((minGap > 0) && (Int(rightPosition - leftPosition) < minGap)) {
                leftPosition -= translation!.x
            }
            gesture?.setTranslation(CGPoint.zero, in: self)
            setNeedsLayout()
            delegateNotification()
        }
        popoverBubble!.alpha = 1
        setTimeLabel()
        if gesture?.state == .ended {
            hideBubble(popoverBubble)
        }
    }

    @objc func handleRightPan(_ gesture: UIPanGestureRecognizer?) {
        if gesture?.state == .began || gesture?.state == .changed {
            let translation = gesture?.translation(in: self)
            rightPosition += translation!.x
            if rightPosition < 0 {
                rightPosition = 0
            }
            if rightPosition > frame_width {
                rightPosition = frame_width
            }
            if rightPosition - leftPosition <= 0 {
                rightPosition -= translation!.x
            }
            if (rightPosition - leftPosition <= leftThumb!.frame.size.width + rightThumb!.frame.size.width) || ((maxGap > 0) && (Int(rightPosition - leftPosition) > maxGap)) || ((minGap > 0) && (Int(rightPosition - leftPosition) < minGap)) {
                rightPosition -= translation!.x
            }
            gesture?.setTranslation(CGPoint.zero, in: self)
            setNeedsLayout()
            delegateNotification()
        }
        popoverBubble!.alpha = 1
        setTimeLabel()
        if gesture?.state == .ended {
            hideBubble(popoverBubble)
        }
        
    }
    
    
    @objc func handleCenterPan(_ gesture: UIPanGestureRecognizer?) {
        if gesture?.state == .began || gesture?.state == .changed {
            let translation = gesture?.translation(in: self)
            leftPosition += translation!.x
            rightPosition += translation!.x
            if rightPosition > frame_width || leftPosition < 0 {
                leftPosition -= translation!.x
                rightPosition -= translation!.x
            }
            gesture?.setTranslation(CGPoint.zero, in: self)
            setNeedsLayout()
            delegateNotification()
        }
        popoverBubble!.alpha = 1
        setTimeLabel()
        if gesture?.state == .ended {
            hideBubble(popoverBubble)
        }
    }


    override func layoutSubviews() {
        let inset: CGFloat = leftThumb!.frame.size.width / 2
        leftThumb!.center = CGPoint(x: leftPosition + inset, y: leftThumb!.frame.size.height / 2)
        rightThumb!.center = CGPoint(x: rightPosition - inset, y: rightThumb!.frame.size.height / 2)
        topBorder!.frame = CGRect(x: leftThumb!.frame.origin.x + leftThumb!.frame.size.width, y: 0, width: rightThumb!.frame.origin.x - leftThumb!.frame.origin.x - leftThumb!.frame.size.width / 2, height: CGFloat(SLIDER_BORDERS_SIZE))
        bottomBorder!.frame = CGRect(x: leftThumb!.frame.origin.x + leftThumb!.frame.size.width, y: CGFloat(Int(bgView!.frame.size.height) - SLIDER_BORDERS_SIZE), width: rightThumb!.frame.origin.x - leftThumb!.frame.origin.x - leftThumb!.frame.size.width / 2, height: CGFloat(SLIDER_BORDERS_SIZE))
        centerView!.frame = CGRect(x: leftThumb!.frame.origin.x + leftThumb!.frame.size.width, y: centerView!.frame.origin.y, width: rightThumb!.frame.origin.x - leftThumb!.frame.origin.x - leftThumb!.frame.size.width, height: centerView!.frame.size.height)
        
        var frame = popoverBubble!.frame
        frame.origin.x = centerView!.frame.origin.x + centerView!.frame.size.width / 2 - frame.size.width / 2
        popoverBubble!.frame = frame

    }
    
    func getMovieFrame() {
        let myAsset = AVURLAsset(url: videoUrl!, options: nil)
        imageGenerator = AVAssetImageGenerator(asset: myAsset)
        if isRetina() {
            imageGenerator!.maximumSize = CGSize(width: bgView!.frame.size.width * 2, height: bgView!.frame.size.height * 2)
        } else {
            imageGenerator!.maximumSize = CGSize(width: bgView!.frame.size.width, height: bgView!.frame.size.height)
        }
        var picWidth = CGFloat(20)
        // First image
        var error: Error?
        var actualTime:  UnsafeMutablePointer<CMTime>?
        var halfWayImage: CGImage? = nil
        do {
            halfWayImage = try imageGenerator!.copyCGImage(at: .zero, actualTime: actualTime)
        } catch {
        }
        
        if halfWayImage != nil {
            var videoScreen: UIImage?
            if isRetina() {
                videoScreen = UIImage(cgImage: halfWayImage!, scale: 2.0, orientation: .up)
            } else {
                videoScreen = UIImage(cgImage: halfWayImage!)
            }
            let tmp = UIImageView(image: videoScreen)
            var rect = tmp.frame
            rect.size.width = CGFloat(picWidth)
            tmp.frame = rect
            bgView!.addSubview(tmp)
            picWidth = tmp.frame.size.width
            
        }
        durationSeconds = CMTimeGetSeconds(myAsset.duration)
        let picsCnt = ceil(bgView!.frame.size.width / picWidth)
        var allTimes: [AnyHashable] = []
        var time4Pic = 0

        if Float(UIDevice.current.systemVersion) ?? 0.0 >= 7.0 {
            // Bug iOS7 - generateCGImagesAsynchronouslyForTimes
            var prefreWidth = 0
            var ii = 1
            for i  in 1..<Int(picsCnt){
                ii = i

                time4Pic = i * Int(picWidth)
                
                let timeFrame = CMTimeMakeWithSeconds(Float64(CGFloat(durationSeconds) * CGFloat(time4Pic) / self.bgView!.frame.size.width), preferredTimescale: 600)
                
                allTimes.append(NSValue(time: timeFrame))
                
                
                var halfWayImage: CGImage? = nil
                do {
                    halfWayImage = try imageGenerator!.copyCGImage(at: timeFrame, actualTime: actualTime)
                } catch {
                }
                
                var videoScreen: UIImage?
                if isRetina() {
                    if let halfWayImage = halfWayImage {
                        videoScreen = UIImage(cgImage: halfWayImage, scale: 2.0, orientation: .up)
                    }
                } else {
                    if let halfWayImage = halfWayImage {
                        videoScreen = UIImage(cgImage: halfWayImage)
                    }
                }
                let tmp = UIImageView(image: videoScreen)
                var currentFrame = tmp.frame
                currentFrame.origin.x = CGFloat(ii) * picWidth
                currentFrame.size.width = CGFloat(picWidth)
                prefreWidth += Int(currentFrame.size.width)
                if i == Int(picsCnt - 1) {
                    currentFrame.size.width -= 6
                }
                tmp.frame = currentFrame
                let all = CGFloat(CGFloat(ii + 1) * tmp.frame.size.width)
                if all > bgView!.frame.size.width {
                    let delta = all - bgView!.frame.size.width
                    currentFrame.size.width -= CGFloat(delta)
                }
                ii += 1
                DispatchQueue.main.async(execute: {
                    self.bgView!.addSubview(tmp)
                })
            }
            return
        }
        
        for i in 1..<Int(picsCnt) {
            time4Pic = i * Int(picWidth)
            
            let timeFrame = CMTimeMakeWithSeconds(Float64(CGFloat(durationSeconds) * CGFloat(time4Pic) / self.bgView!.frame.size.width), preferredTimescale: 600)
            
            allTimes.append(NSValue(time: timeFrame))
        }
        
        let times = allTimes
        var i = 1
        if let times = times as? [NSValue] {
            imageGenerator!.generateCGImagesAsynchronously(forTimes: times, completionHandler: { requestedTime, image, actualTime, result, error in
                if result == .succeeded {
                    var videoScreen: UIImage?
                    if self.isRetina() {
                        if let image = image {
                            videoScreen = UIImage(cgImage: image, scale: 2.0, orientation: .up)
                        }
                    } else {
                        if let image = image {
                            videoScreen = UIImage(cgImage: image)
                        }
                    }
                    let tmp = UIImageView(image: videoScreen)
                    let all = Int(CGFloat((i + 1)) * tmp.frame.size.width)
                    var currentFrame = tmp.frame
                    currentFrame.origin.x = CGFloat(i) * currentFrame.size.width
                    if all > Int(self.bgView!.frame.size.width) {
                        let delta = CGFloat(all) - self.bgView!.frame.size.width
                        currentFrame.size.width -= delta
                    }
                    tmp.frame = currentFrame
                    i += 1
                    
                    DispatchQueue.main.async(execute: {
                        self.bgView!.addSubview(tmp)
                    })
                }
                if result == .failed{
                    print("failed")
                }
                if result == .cancelled{
                    print("cancelled")
                }
            })
        }
        print("not loaded")
    }
    
    
    
    func hideBubble(_ popover: UIView?) {
        UIView.animate(withDuration: 0.4, delay: 0, options: UIView.AnimationOptions(rawValue: UInt(UIView.AnimationCurve.easeIn.rawValue) | UIView.AnimationOptions.allowUserInteraction.rawValue), animations: {
            self.popoverBubble!.alpha = 0
        })
        
//        if delegate!.responds(to: ){//self.videoRange(_:didGestureStateEndedLeftPosition:rightPosition:))) {
            delegate!.videoRange(self, didGestureStateEndedLeftPosition: leftPosition, rightPosition: rightPosition)
//        }
    }
    
    func setTimeLabel() {
        bubleText!.text = trimIntervalStr()
    }
    
    func trimDurationStr() -> String? {
        let delta = floor(rightPosition - leftPosition)
        return "\(delta)"
    }
    
    func trimIntervalStr() -> String? {
        
        let from = time(toStr: leftPosition)
        let to = time(toStr: rightPosition)
        return "\(from ?? "") - \(to ?? "")"
    }
    
    func time(toStr time: CGFloat) -> String? {
        let min = floor(time / 60)
        let sec = floor(time - CGFloat(min * 60))
        let minStr = String(format: min >= 10 ? "%i" : "0%i", min)
        let secStr = String(format: sec >= 10 ? "%i" : "0%i", sec)
        return "\(minStr):\(secStr)"
    }
    
    func isRetina() -> Bool {
        return UIScreen.main.responds(to: #selector(UIScreen.displayLink(withTarget:selector:))) && (UIScreen.main.scale == 2.0)
    }

}
