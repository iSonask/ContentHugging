//
//  ViewController.swift
//  ContentHuggin
//
//  Created by mac on 02/07/19.
//  Copyright © 2019 Sigma. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController,SAVideoRangeSliderDelegate {
    
    func videoRange(_ videoRange: SARangeSliderView?, didChangeLeftPosition leftPosition: CGFloat, rightPosition: CGFloat) {
        self.startTime = leftPosition;
        self.stopTime = rightPosition;
        self.timeLabel.text = "\(leftPosition) -- \(rightPosition)"
    }
    
    func videoRange(_ videoRange: SARangeSliderView?, didGestureStateEndedLeftPosition leftPosition: CGFloat, rightPosition: CGFloat) {
        self.startTime = leftPosition;
        self.stopTime = rightPosition;
        self.timeLabel.text = "\(leftPosition) -- \(rightPosition)"
    }
    

    var mySAVideoRangeSlider: SARangeSliderView?
    @IBOutlet weak var timeLabel: UILabel!
    var exportSession: AVAssetExportSession?
    var originalVideoPath = ""
    var tmpVideoPath = ""
    var startTime: CGFloat = 0.0
    var stopTime: CGFloat = 0.0
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var trimBtn: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        myActivityIndicator.isHidden = true
        let tempDir = NSTemporaryDirectory()
        tmpVideoPath = URL(fileURLWithPath: tempDir).appendingPathComponent("tmpMov.mov").absoluteString
        let mainBundle = Bundle.main
        originalVideoPath = mainBundle.path(forResource: "thaiPhuketKaronBeach", ofType: "MOV")!
        let videoFileUrl = URL(fileURLWithPath: originalVideoPath)
        if UI_USER_INTERFACE_IDIOM() == .pad {
            mySAVideoRangeSlider = SARangeSliderView(frame: CGRect(x: 10, y: 200, width: view.frame.size.width, height: 70), videoUrl: videoFileUrl)
            mySAVideoRangeSlider!.setPopoverBubbleSize(200, height: 100)
        } else {
            mySAVideoRangeSlider = SARangeSliderView(frame: CGRect(x: 0, y: 100, width: view.frame.size.width, height: 50), videoUrl: videoFileUrl)
            mySAVideoRangeSlider!.bubleText!.font = UIFont.systemFont(ofSize: 12)
            mySAVideoRangeSlider?.setPopoverBubbleSize(120, height: 60)
            
        }
        mySAVideoRangeSlider?.delegate =  self
        view.addSubview(mySAVideoRangeSlider!)
        print("loaded")
    }


}

