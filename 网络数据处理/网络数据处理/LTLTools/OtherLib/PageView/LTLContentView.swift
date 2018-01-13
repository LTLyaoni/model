//
//  LTLContentView.swift
//  appTemplates
//
//  Created by 123 on 2017/12/18.
//  Copyright © 2017年 LiTaiLiang. All rights reserved.
//


import UIKit

private let cellID = "LTLContentViewCell"
protocol LTLContentDelegate: NSObjectProtocol {
    func contentView(_ contentView: LTLContentView,nowPage: Int, fromIndex: Int, toIndex: Int, scale:CGFloat)
    func contentView(_ contentView: LTLContentView, reuseContentView:LTLReuseView?, viewControllerForPageAt index: Int) -> LTLReuseView
}

class LTLContentView: UICollectionView {
    
    var currentX: CGFloat = 0.0
    var currentIndex: Int = 0
    var toIndex: Int = 0
    var dataArr: [String] = [] {
        didSet {
            self.reloadData()
        }
    }
    
    private var isManual = false
    
    private var cellPage:NSInteger = 0
    
    weak var contentDelegate: LTLContentDelegate?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        
        super.init(frame: frame, collectionViewLayout: flowLayout)
        
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        backgroundColor = UIColor.white
        bounces = false
        delegate = self
        dataSource = self
        isPagingEnabled = true
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LTLContentView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        
        
        guard let reuseView = cell.contentView.subviews.first as? LTLReuseView? else {
            return cell
        }
        
        reuseView?.tag = indexPath.item
        
        let viewReuse = contentDelegate?.contentView(self, reuseContentView: reuseView, viewControllerForPageAt: indexPath.item)
        
        viewReuse?.tag = indexPath.item
        
        if viewReuse != nil {
            
            _ = cell.contentView.subviews.map {
                $0.removeFromSuperview()
            }
            cell.contentView.addSubview(viewReuse!)
            
            viewReuse?.snp.makeConstraints({ (make) in
                make.top.equalTo(cell.contentView.snp.top)
                make.bottom.equalTo(cell.contentView.snp.bottom)
                make.right.equalTo(cell.contentView.snp.right)
                make.left.equalTo(cell.contentView.snp.left)
            })
        }
        
        return cell
    }
}

extension LTLContentView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}

extension LTLContentView: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        //进行四舍五入取整再次计算成屏宽整数倍 是为了防止快速滑动过程出现怪异的滑动起点 导致scale 突变 使得滑动条闪动
        currentX = CGFloat(lroundf(Float(scrollView.contentOffset.x/LTLWidth)))*LTLWidth
        isManual = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        
        let x = scrollView.contentOffset.x
        let moveX = x - currentX
        
        let scale = abs(moveX.truncatingRemainder(dividingBy: LTLWidth) / LTLWidth)
        if scale == 0 { return } //如果不写这句 会导致在首末 快速多次滑动时 滚动条出现问题
        let page = Int(floor((x - LTLWidth / 2) / LTLWidth)) + 1
        if moveX > 0 {
            currentIndex = Int(x / LTLWidth)
            toIndex = currentIndex + 1
        }else if moveX < 0 {
            currentIndex = Int(ceil(x / LTLWidth))
            toIndex = currentIndex - 1
        }
        if toIndex < 0 {
            toIndex = 0
        }else if toIndex > dataArr.count-1 {
            toIndex = dataArr.count - 1
        }
        //        print("\(page)")
        if isManual {
            // page 标题颜色改变的index 只要触碰到边界就改变 scale 滑动条进度控制比
            // fromIndex 当前的index 完全切换页面才改变 toIndex 要切换到的index
            contentDelegate?.contentView(self,nowPage: page, fromIndex: currentIndex, toIndex: toIndex, scale: scale)
        }
        
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageNum()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isManual = false
        pageNum()
    }
    
    private func pageNum()
    {
        let x = self.contentOffset.x
        let page = Int(floor((x - LTLWidth / 2) / LTLWidth)) + 1
        
        if cellPage != page {
            cellPage = page
            //            LTLCellDisplayDelegate.d
            let cell =  self.cellForItem(at: IndexPath(item: cellPage, section: 0))
            
            guard let reuseView = cell?.contentView.subviews.first as? LTLReuseView? else {
                return
            }
            reuseView?.display(cellPage)
        }
        
    }
}
extension LTLContentView: UICollectionViewDelegate {
    
}

