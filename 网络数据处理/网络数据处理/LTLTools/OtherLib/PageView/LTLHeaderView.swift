//
//  LTLHeaderView.swift
//  appTemplates
//
//  Created by 123 on 2017/12/18.
//  Copyright © 2017年 LiTaiLiang. All rights reserved.
//


import UIKit

let LTLWidth = UIScreen.main.bounds.width
let LTLHeight = UIScreen.main.bounds.height
////普通字体颜色 及 选中颜色 RGB数值
//let normalColor = RGBColor(66, g: 66, b: 66)
//let selectedColor = RGBColor(198, g: 40, b: 40)
//滑动条比标题宽多少
let lineWeightEdge: CGFloat = 10.0

protocol LTLHeaderViewDelegate: NSObjectProtocol {
    func selectdLTLHeaderView(view: LTLHeaderView, selectedIndex: Int)
}

class LTLHeaderView: UIView {
    
    //普通字体颜色 及 选中颜色 RGB数值
    var normalColor = UIColor(red: 66, green: 66, blue: 66, alpha: 1)  //RGBColor(66, g: 66, b: 66)
    var selectedColor = UIColor(red: 198, green: 40, blue: 40, alpha: 1) // RGBColor(198, g: 40, b: 40)
    {
        didSet
        {
            scrollView.selectedColor = selectedColor
        }
    }
    
    fileprivate var scrollView: LTLScrollView!
    
    weak var delegate: LTLHeaderViewDelegate?
    
    var dataAry: [String]? {
        didSet {
            scrollView.menuAry = dataAry
        }
    }
    
    var styleMore: Bool = false
    var styleLine: Bool?
    
    var style: Bool = false
    {
        didSet
        {
            scrollView.style = style
        }
    }
    
    init(styleMore: Bool = false, styleLine: Bool = true) {
        self.styleMore = styleMore
        self.styleLine = styleLine

        super.init(frame: CGRect())
        backgroundColor = UIColor(red: 249, green: 249, blue: 251, alpha: 1)  //RGBColor(249, g: 249, b: 251)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        scrollView = LTLScrollView()
        scrollView.style = styleMore
        scrollView.styleLine = styleLine
        scrollView.normalColor = normalColor
//        scrollView.selectedColor = selectedColor
        addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        scrollView.selectedBtnBack = { [unowned self](index: Int) in
            self.delegate?.selectdLTLHeaderView(view: self, selectedIndex: index)
        }
    }
    
    func scrollTodo(nowPage: Int,fromIndex: Int ,toIndex: Int, scale: CGFloat)
    {
    
        scrollView.scrollTodo(nowPage: nowPage, fromIndex: fromIndex, toIndex: toIndex, scale: scale)
    }
    
    func scrollIndex(index: Int) {
        
        let bt = scrollView.viewWithTag(index) as! UIButton
        scrollView.buttonClicked(sender: bt)
//        scrollView.selectButton(currectIndex: scrollView.currentIndex, toIndex: index)
    }
    
}

fileprivate class LTLScrollView: UIScrollView {
    
    //普通字体颜色 及 选中颜色 RGB数值
    var normalColor = UIColor(red: 66, green: 66, blue: 66, alpha: 1)
    {
        didSet
        {
            
        }
    }
    var selectedColor = UIColor(red: 198, green: 40, blue: 40, alpha: 1)
    {
        didSet
        {
            lineView?.backgroundColor = selectedColor
        }
    }
    
    var currentIndex: Int = 0
    
    var menuAry: [String]? {
        didSet {
            if let menu = menuAry {
                if menu.count > 0 { setupMenu(menu) }
                selectButton(currectIndex: currentIndex, toIndex: 0)
            }
        }
    }
    //修改样式 false 是 很多条连续排列 true 是平分屏宽排列
    var style: Bool = false
    //是下划线还是放大字体
    var styleLine: Bool?
    
    var lineView: UIView?
    
    var selectedBtnBack: ((_ index: Int) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupMenu(_ menus: [String]) {
        for (index, menu) in menus.enumerated() {
            let button = UIButton()
            button.tag = index
            button.setTitle(menu, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
            button.setTitleColor(self.normalColor, for: .normal)
            if !styleLine! { button.transform = CGAffineTransform(scaleX: 0.8, y: 0.8) }
            addSubview(button)
            button.snp.makeConstraints({[unowned self] (make) in
                make.centerY.equalToSuperview()
                
                LTLLog(self.style, .info)
                
                if !self.style {
//                    LTLLog(self.frame.width)
                    make.centerX.equalTo(UIScreen.main.bounds.width/CGFloat(menus.count)/2.0*CGFloat(index*2+1))
                }else{
                    if self.subviews.count == 1{
                        make.left.equalTo(self.snp.left).offset(15)
                    } else if self.subviews.count == self.menuAry?.count {
                        make.left.equalTo((self.subviews[self.subviews.count - 2].snp.right)).offset(15)
                        make.right.equalTo(self).offset(-15)
                    } else {
                        make.left.equalTo((self.subviews[self.subviews.count - 2].snp.right)).offset(15)
                    }
                }
            })
        }
        if styleLine! { setupLineView() }
    }
    
    func setupLineView() {
        lineView = UIView()
        lineView?.tag = 999999
        lineView?.backgroundColor = selectedColor
        self.addSubview(lineView!)
        let currentButton = subviews[0] as! UIButton
        lineView?.snp.makeConstraints({(make) in
            make.height.equalTo(2)
            make.centerX.equalTo(currentButton)
            make.width.equalTo(currentButton).offset(lineWeightEdge)
            make.top.equalTo(38)
        })
    }
    
    @objc func buttonClicked(sender: UIButton) {
        selectedBtnBack?(sender.tag)
        selectButton(currectIndex: currentIndex, toIndex: sender.tag)
        let desButton = subviews[sender.tag] as! UIButton
        UIView.animate(withDuration: 0.5) { [unowned self] in
            self.lineView?.snp.remakeConstraints({(make) in
                make.width.equalTo(desButton.frame.width + 10)
                make.centerX.equalTo(desButton)
                make.height.equalTo(2)
                make.top.equalTo(38)
            })
            self.layoutIfNeeded()
        }
    }
    
    func selectButton(currectIndex: Int, toIndex: Int) {
        if currentIndex == toIndex && currentIndex != 0{ return }
        let currentButton = subviews[currentIndex] as! UIButton
        if toIndex == 0 && currentIndex == 0{
            currentButton.setTitleColor(selectedColor, for: .normal)
            if !styleLine! { currentButton.transform = CGAffineTransform(scaleX: 1, y: 1) }
            return
        }
        let desButton = subviews[toIndex] as! UIButton
        currentButton.setTitleColor(normalColor, for: .normal)
        desButton.setTitleColor(selectedColor, for: .normal)
        if !styleLine! { desButton.transform = CGAffineTransform(scaleX: 1, y: 1) }
        if !styleLine! { currentButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8) }
        headerViewScroll(scrollX: desButton.frame.midX - LTLWidth/2)
        self.currentIndex = toIndex
    }
    
    func scrollTodo(nowPage:Int, fromIndex: Int ,toIndex: Int, scale: CGFloat) {
        
        let currentButton = subviews[fromIndex] as! UIButton
        let toButton = subviews[toIndex] as! UIButton
        
        if styleLine! {
            let diffX = scale*(toButton.center.x-currentButton.center.x)
            let diffW = scale*(toButton.frame.width-currentButton.frame.width)
            
            self.lineView?.snp.remakeConstraints({(make) in
                make.width.equalTo(currentButton.frame.width+diffW+lineWeightEdge)
                make.centerX.equalTo(currentButton.center.x + diffX)
                make.height.equalTo(2)
                make.top.equalTo(38)
            })
            if nowPage == currentIndex {
                return
            }
            selectButton(currectIndex: currentIndex, toIndex: nowPage)
        } else {
            currentButton.setTitleColor(changeColor(from: selectedColor, to: normalColor, scale: scale), for: .normal)
            currentButton.transform = CGAffineTransform(scaleX: CGFloat(1 - 0.2 * scale), y: CGFloat(1 - 0.2 * scale))
            toButton.setTitleColor(changeColor(from: normalColor, to: selectedColor, scale: scale), for: .normal)
            toButton.transform = CGAffineTransform(scaleX: CGFloat(0.8 + 0.2 * scale), y: CGFloat(0.8 + 0.2 * scale))
            headerViewScroll(scrollX: toButton.frame.midX - LTLWidth/2)
            self.currentIndex = toIndex
        }
    }
    
    func headerViewScroll(scrollX: CGFloat) {
        if scrollX > 0 && scrollX < self.contentSize.width - LTLWidth{
            let scrollOffset = CGPoint(x: scrollX, y: 0)
            self.setContentOffset(scrollOffset, animated: true)
        }else if scrollX < 0 {
            let scrollOffset = CGPoint(x: 0, y: 0)
            self.setContentOffset(scrollOffset, animated: true)
        }else if self.contentSize.width > LTLWidth{
            let scrollOffset = CGPoint(x: self.contentSize.width - LTLWidth, y: 0)
            self.setContentOffset(scrollOffset, animated: true)
        }
    }
}

//struct HeaderRGBColor {
//    var red: CGFloat
//    var green: CGFloat
//    var blue: CGFloat
//}

//func getColor(_ color: UIColor) -> UIColor {
////    return UIColor.init(red: color.red/255.0, green: color.green/255.0, blue: color.blue/255.0, alpha: 1)
//    return color
//}

func changeColor(from: UIColor, to: UIColor, scale: CGFloat) -> UIColor {
    let redDiff = (to.red() - from.red()) * scale + from.red()
    let blueDiff = (to.blue() - from.blue()) * scale + from.blue()
    let greenDiff = (to.green() - from.green()) * scale + from.green()
    return UIColor.init(red: redDiff/255.0, green: greenDiff/255.0, blue: blueDiff/255.0, alpha: 1)
}



