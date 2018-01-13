//
//  MRCountDownButton.swift
//  MRCountDownButtonDemo
//
//  Created by CodeLL on 2016/10/16.
//  Copyright © 2016年 coderLL. All rights reserved.
//

import UIKit

// MARK:- 常量定义
private let kNormalButtonTitle = "获取验证码"
private let kResetButtonTitle = "重新获取"

// MARK:- 倒计时按钮
class MRCountDownButton: UIButton {
    
    // MARK:- 定义属性
    var timer : Timer?
   @IBInspectable var countDownNum : Int = 10
   @IBInspectable var currentNum : Int = 0
   @IBInspectable var intervalTime : TimeInterval = 1.0
   @IBInspectable var normalBGColor : UIColor = UIColor.blue
    {
    didSet {self.backgroundColor = normalBGColor}
    }
   @IBInspectable var selectedBGColor : UIColor = UIColor.lightGray
    @IBInspectable var resetButtonTitle:String = "重新获取"
    // MARK:- 系统回调函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 设置UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // 设置UI
        setupUI()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        // 1.添加倒计时计时器
//        addCountDownTimer()
    }
    
}

// MARK:- 添加UI控件
extension MRCountDownButton {
    
    fileprivate func setupUI() {
        // 1.设置相关属性
        self.layer.cornerRadius = 8
        
//        self.setTitle(kNormalButtonTitle, for: .normal)
//        self.backgroundColor = self.normalBGColor
    }
    
}

// MARK:- 自定义方法
extension MRCountDownButton {

    // MARK:- 添加定时器
     func addCountDownTimer() {
        
        // 1.添加定时器
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: self, repeats: true)
//        // 1.1 创建定时器
//        timer = Timer(timeInterval: intervalTime, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
//        // 1.2 将timer添加到运行循环中
//        RunLoop.current.add(timer!, forMode: .commonModes)
//        // 1.3 开启定时器
//        timer?.fire()
        
        // 2.设置按钮背景为灰色
        self.backgroundColor = selectedBGColor
        
        // 3.改变按钮文字
        self.currentNum = countDownNum
        self.setTitle("剩余 \(countDownNum) 秒", for: .normal)
        
        // 4.数字减一
        self.currentNum -= 1
        
        // 5.设置按钮不可点击
        self.isEnabled = false
    }
    
    // MARK:- 移除定时器
    fileprivate func removeCountDownTimer() {
        // 1.定时器从运行循环中移除
        timer?.invalidate()
        timer = nil
        // 2.设置背景颜色为正常色
        self.backgroundColor = normalBGColor
    }
    
    // MARK:- 每次定时器调用方法
    @objc fileprivate func timerAction() {
        // 1.判断是否到时
        if currentNum < 0 {
            // 1.移除定时器
            removeCountDownTimer()
            // 2.设置按钮可点击
            self.isEnabled = true
            // 3.重置倒计时时间
            self.currentNum = countDownNum
            // 3.重新设置文字
            self.setTitle(resetButtonTitle, for: .normal)
        }else {
            // 1.改变按钮文字
            self.setTitle("剩余 \(currentNum) 秒", for: .normal)
            // 2.数字减一
            self.currentNum -= 1
        }
    }
}
