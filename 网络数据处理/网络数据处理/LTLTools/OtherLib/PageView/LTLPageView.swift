//
//  LTLPageView.swift
//  appTemplates
//
//  Created by 123 on 2017/12/18.
//  Copyright © 2017年 LiTaiLiang. All rights reserved.
//

import UIKit
protocol LTLPageViewDelegate: NSObjectProtocol {
     func contentView(_ reuseContentView: LTLReuseView?, viewControllerForPageAt index: Int) -> LTLReuseView
}
class LTLPageView: UIView {
    
    private var headerView: LTLHeaderView =  LTLHeaderView()
    private var contentView: LTLContentView = LTLContentView()
    
    weak var pageViewDelegate:LTLPageViewDelegate?
    
    //普通字体颜色 及 选中颜色 RGB数值
    var normalColor = UIColor(red: 66, green: 66, blue: 66, alpha: 1) //RGBColor(66, g: 66, b: 66)
    
    var selectedColor = UIColor(red: 196, green: 40, blue: 40, alpha: 1) //RGBColor(198, g: 40, b: 40)
    {
        didSet
        {
            headerView.selectedColor = selectedColor
        }
    }
    
    var styleLine: Bool = true
    {
        didSet
        {
            headerView.styleLine = styleLine
        }
    }
    
    var style: Bool = false
    {
        didSet
        {
            headerView.style = style
        }
    }
    
    var dataAry:[String] = [String]()
    {
        didSet
        {
//            self.superViewController().automaticallyAdjustsScrollViewInsets = false
            if #available(iOS 11.0, *) {
                contentView.contentInsetAdjustmentBehavior = .never
            } else {
                self.superViewController().automaticallyAdjustsScrollViewInsets = false
            }
            headerView.dataAry = dataAry
            contentView.dataArr = dataAry
        }
    }
    
    init(styleMore: Bool = false, styleLine: Bool = true)
    {
        super.init(frame: CGRect.zero)
       
        setUI(styleMore, styleLine)
    }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
   private func setUI(_ styleMore: Bool = true,_ styleLine: Bool = true) {
//        self.superViewController().automaticallyAdjustsScrollViewInsets = false
        ////        automaticallyAdjustsScrollViewInsets = false
        headerView = LTLHeaderView.init(styleMore: styleMore, styleLine: styleLine)
        headerView.normalColor = normalColor
        headerView.selectedColor = selectedColor
        
        self.addSubview(headerView)
        headerView.delegate = self
        
        headerView.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        self.addSubview(contentView)
        //        self.contentView.dataArr = arr
        contentView.contentDelegate = self
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.right.left.equalToSuperview()
        }

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       setUI()
    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    
}
extension LTLPageView : LTLHeaderViewDelegate
{
    internal func selectdLTLHeaderView(view: LTLHeaderView, selectedIndex: Int) {
        let indexPath = IndexPath(item: selectedIndex, section: 0)
        contentView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
}
extension LTLPageView : LTLContentDelegate
{
    internal func contentView(_ contentView: LTLContentView, nowPage: Int, fromIndex: Int, toIndex: Int, scale: CGFloat) {
        
        
        headerView.scrollTodo(nowPage: nowPage, fromIndex: fromIndex, toIndex: toIndex, scale: scale)
    }
    
    internal func contentView(_ contentView: LTLContentView, reuseContentView: LTLReuseView?, viewControllerForPageAt index: Int) -> LTLReuseView {
       
        let view = pageViewDelegate?.contentView(reuseContentView, viewControllerForPageAt: index)
        if view == nil {
            return LTLReuseView()
        }
        
        return view!
    }
}
extension LTLPageView
{
    func scrollIndex(_ index: Int) {
        headerView.scrollIndex(index: index)
    }
}


