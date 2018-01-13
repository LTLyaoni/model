//
//  LTLImageCell.swift
//  LTLImageBrowserVCDemo
//
//  Created by LIHUA LEI on 2017/8/29.
//  Copyright © 2017年 david. All rights reserved.
//

import UIKit
import Kingfisher
/*!
 用来显示图片的Cell
 */
class LTLImageViewCell: UICollectionViewCell {
    /*!
     用来显示图片的view
     */
    var imageView: UIImageView!
    /*!
     用来滚动图片的view
     */
    fileprivate var scroll: UIScrollView!
    /// 单击手势
    fileprivate var singleTap: UITapGestureRecognizer!
    /// 双击手势
    fileprivate var doubleTap: UITapGestureRecognizer!
    
    //长按手势
    fileprivate var longpressTap: UILongPressGestureRecognizer!

    
    /// 缩放图片回调，缩放的时候隐藏导航栏
    var gestureBlock: (()->Void)?
    /// 进度圈圈
    fileprivate lazy var progressLayer: CAShapeLayer! = {
        let circleLayer = CAShapeLayer()
        circleLayer.strokeColor = UIColor.clear.cgColor
        circleLayer.opacity = 0
        circleLayer.fillColor = UIColor.white.withAlphaComponent(0.9).cgColor
        self.scroll.layer.addSublayer(circleLayer)
        
        let frame = self.scroll.bounds
        let path = UIBezierPath(arcCenter: CGPoint(x: frame.size.width*0.5, y: frame.size.height*0.5), radius: 20, startAngle: CGFloat(Double.pi*(-0.5)), endAngle: CGFloat(Double.pi*(-0.5)), clockwise: true)
        path.addLine(to: CGPoint(x: frame.size.width*0.5, y: frame.size.height*0.5))
        path.addLine(to: CGPoint(x: frame.size.width*0.5, y: frame.size.height*0.5-20))
        circleLayer.path = path.cgPath
        
        let lineLayer = CAShapeLayer()
        lineLayer.strokeColor = UIColor.white.withAlphaComponent(0.9).cgColor
        lineLayer.lineWidth = 1.5
        lineLayer.fillColor = UIColor.clear.cgColor
        let linePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width*0.5, y: frame.size.height*0.5), radius: 22, startAngle: CGFloat(Double.pi*(-0.5)), endAngle: CGFloat(Double.pi*1.5), clockwise: true)
        lineLayer.path = linePath.cgPath
        circleLayer.addSublayer(lineLayer)
        
        return circleLayer
    }()
    /// 下载图片进度
    fileprivate var progress: Double = 0.0 {
        didSet {
            if progress < 1 {
                progressLayer.opacity = 1.0
                let path = UIBezierPath(arcCenter: CGPoint(x: frame.size.width*0.5, y: frame.size.height*0.5), radius: 20, startAngle: CGFloat(Double.pi*(-0.5)), endAngle: CGFloat(Double.pi*(progress*2-0.5)), clockwise: true)
                path.addLine(to: CGPoint(x: frame.size.width*0.5, y: frame.size.height*0.5))
                path.addLine(to: CGPoint(x: frame.size.width*0.5, y: frame.size.height*0.5-20))
                progressLayer.path = path.cgPath
            } else {
                progressLayer.opacity = 0
            }
        }
    }
    
    var image: Any? {
        didSet {
            progress = 1
            if image is UIImage {
                imageView.image = image as? UIImage
            } else if image is String || image is NSString {
                let url = (image as? String) ?? ""
                
                
                imageView.setImage(url, placeholderImage: #imageLiteral(resourceName: "zhanweitu"), { (receivedSize, allSize) in
                    self.progress = (Double)(receivedSize) / (Double)(allSize)
                }, nil)
//                let isCached = SDWebImageManager.shared().cachedImageExists(for: URL(string: url))
//                if isCached {
//                    //有缓存
//                    let image = SDImageCache.shared().imageFromDiskCache(forKey: url)
//                    imageView.image = image
//                } else {
//                    //没有缓存
//                    imageView.sd_setImage(with: URL(string: url), placeholderImage: nil, options: SDWebImageOptions(), progress: { (receivedSize, allSize) in
//                        self.progress = (Double)(receivedSize) / (Double)(allSize)
//                    }, completed: { (image, error, type, url) in
//                        print("-------------")
//                    })
//                }
            }
        }
    }
    var singleTapBolck: (()->Void)?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scroll = UIScrollView(frame: self.bounds)
        scroll.minimumZoomScale = 1
        scroll.maximumZoomScale = 3
        scroll.delegate = self
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        self.contentView.addSubview(scroll)
        
        imageView = UIImageView(frame: scroll.bounds)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.isUserInteractionEnabled = true
        scroll.addSubview(imageView)
        imageView.backgroundColor = UIColor.white
        
        
        singleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleSingleTap(gestureRecognizer:)))
        singleTap.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(singleTap)
        
        doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap(gestureRecognizer:)))
        doubleTap.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(doubleTap)
        singleTap.require(toFail: doubleTap)

        
        longpressTap = UILongPressGestureRecognizer(target: self, action: #selector(handleLongpressTap(_:)))
        //长按时间为1秒
        longpressTap.minimumPressDuration = 1
        //允许15秒运动
        longpressTap.allowableMovement = 15
        //所需触摸1次
        longpressTap.numberOfTouchesRequired = 1
        
        imageView.addGestureRecognizer(longpressTap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*!
     单击图片操作，使图片浏览器消失
     */
    @objc func handleSingleTap(gestureRecognizer: UITapGestureRecognizer) {
        self.singleTapBolck?()
    }
    
    /*!
     双击图片操作，放大图片
     */
    @objc func handleDoubleTap(gestureRecognizer: UITapGestureRecognizer) {
        self.gestureBlock?()
        var zoomScale = scroll.zoomScale
        zoomScale = zoomScale <= 1.0 ? 2.0 : 1.0
        let zoomRect = self.getRectScale(scale: zoomScale, center: gestureRecognizer.location(in: gestureRecognizer.view))
        /// 缩放到指定区域,指定，指定，指定，是指定区域，假设放大两倍，zoomRect指的是需要显示的范围
        scroll.zoom(to: zoomRect, animated: true)
    }
    
    var shareBlock: (()->Void)?
    var saveBlock: (()->Void)?
    /////长按
   @objc func handleLongpressTap(_ sender : UILongPressGestureRecognizer){
        
        if sender.state == UIGestureRecognizerState.began{
            //创建警告
//            var actionSheet = UIActionSheet(title: "Image options", delegate: self.superViewController(), cancelButtonTitle: "cancel", destructiveButtonTitle: "ok", otherButtonTitles: "other")
//            actionSheet.showInView(self.view)
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
               
            }))
            alert.addAction(UIAlertAction(title: "保存", style: .default, handler: { (action) in
                self.saveBlock?()
            }))
            alert.addAction(UIAlertAction(title: "分享", style: .default, handler: { (action) in
               self.shareBlock?()
            }))
            
            self.superViewController().present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    
    func getRectScale(scale: CGFloat, center: CGPoint) -> CGRect {
        let size = CGSize(width: scroll.frame.width/scale, height: scroll.frame.height/scale)
        let point = CGPoint(x: center.x-size.width*0.5, y: center.y-size.height*0.5)
        return CGRect(origin: point, size: size)
    }
    
}

extension LTLImageViewCell: UIScrollViewDelegate {
    /// 返回要缩放的控件
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.gestureBlock?()
        let offsetX = scrollView.bounds.width > scrollView.contentSize.width ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0
        let offsetY = scrollView.bounds.height > scrollView.contentSize.height ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0
        imageView.center = CGPoint(x: scrollView.contentSize.width*0.5+offsetX, y: scrollView.contentSize.height*0.5+offsetY)
    }
    
}

