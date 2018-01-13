//
//  FPSLabel.swift
//  xiaoyun
//
//  Created by 123 on 2018/1/9.
//  Copyright © 2018年 李泰良. All rights reserved.
//

import UIKit
public class FPSLabel:UIView{
    lazy var fpslabel:UILabel = UILabel()
    lazy var light:UIView = UIView()
    var displayLink:CADisplayLink?
    override init(frame: CGRect) {
        super.init(frame: frame)
        let sel = #selector(FPSLabel.wtdisplay(ca:))
        displayLink = CADisplayLink(target: self, selector:sel)
        displayLink?.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
        addSubview(fpslabel)
        addSubview(light)
        light.frame = CGRect(x: 0, y: 0, width: 14, height: 14)
        light.layer.cornerRadius = 7
        fpslabel.frame = CGRect(x: 20, y: 0, width: 200, height: 14)
    }
    
    deinit {
        
    }
    
    @objc public func wtdisplay(ca:CADisplayLink){
        let fps:Double = Double(1.0) / Double(ca.duration)
        var percent:Double = 0
        var preferredFramesPerSecond:Double = 0
        if #available(iOS 10.0, *) {
            
            preferredFramesPerSecond = Double(ca.preferredFramesPerSecond)
        } else {
            preferredFramesPerSecond = 1/Double(ca.frameInterval)
        }
        percent = Double(fps / Double(preferredFramesPerSecond))
        //        let color = UIColor.wtStatusColor(with: Float(1 - percent))
        light.backgroundColor = #colorLiteral(red: 0.2665744424, green: 0.2665744424, blue: 0.2665744424, alpha: 0.4331924229)
        fpslabel.text = String(format: "fps: %.2f", fps)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
