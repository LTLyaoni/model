//
//  LTLImageBrowserVC.swift
//  LTLImageBrowserVCDemo
//
//  Created by LIHUA LEI on 2017/8/29.
//  Copyright © 2017年 david. All rights reserved.
//

enum LTLImageVCTransitionType {
    case modal
    case push
}

import UIKit

class LTLImageBrowserVC: UIViewController {
    
    /// 有导航栏存在时，设置了也无效，需要设置self.navigationController?.navigationBar.barStyle = UIBarStyle.black才能改成白色
    /// 这里是为了防止状态栏文字是黑色影响视觉效果
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return UIStatusBarStyle.lightContent
        }
    }
    
    /// 导航栏标题
    fileprivate lazy var titleLabel: UILabel! = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        
        return label
    }()
    
    ///退出
    fileprivate lazy var dismissBar:UIBarButtonItem =
    {
        let barButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self, action: #selector(dismissVC))
        return barButton
    }()
    
    @objc func dismissVC()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    ///保存icon_save_2
    fileprivate lazy var saveBar:UIBarButtonItem =
    {
        let barButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_save_2"), style: .plain, target: self, action: #selector(save))
        return barButton
    }()
    @objc func save()
    {
       let cell = imageCollection.cellForItem(at: IndexPath(item: self.index, section: 0)) as! LTLImageViewCell
        LTLPhotoAlbumUtil.saveImageInAlbum(image: cell.imageView.image!, albumName: LTLSystemInfo.APPName) { (result) in
            switch result{
            case .success:
                LTLLog("保存成功")
               self.showHudWithTip("保存成功")
            case .denied:
                LTLLog("被拒绝")
                self.showHudWithTip("没有权限,无法保存")
            case .error:
                LTLLog("保存错误")
                self.showHudWithTip("保存错误")
            }
        }
    }
    ///分享icon_share_3
    fileprivate lazy var shareBar:UIBarButtonItem =
    {
        let barButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_share_3"), style: .plain, target: self, action: #selector(share))
        return barButton
    }()
    @objc func share()
    {
        shareBlock?(index)
    }
    
    fileprivate lazy var imageCollection: UICollectionView! = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        /// 竖直方向的间距
        layout.minimumLineSpacing = 0
        /// 水平方向的间距
        layout.minimumInteritemSpacing = 0
        /// 设置为水平滚动
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collection: UICollectionView! = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), collectionViewLayout: layout)
        collection.backgroundColor = UIColor.black
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.isPagingEnabled = true
        collection.register(LTLImageViewCell.self, forCellWithReuseIdentifier: "LTLImageViewCell")

        collection.delegate = self
        collection.dataSource = self
        
        return collection
    }()
    
    fileprivate lazy var pageControl: UIPageControl! = {
        let page = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.height-50, width: UIScreen.main.bounds.width, height: 20))
        page.pageIndicatorTintColor = UIColor.blue.withAlphaComponent(0.2)
        page.currentPageIndicatorTintColor = UIColor.blue
        
        return page
    }()
    /// pageControl正常的的图片
    var pageNoramlImg: UIImage? {
        didSet {
//            self.pageControl.setValue(pageNoramlImg, forKeyPath: "_pageImage")
        }
    }
    /// pageControl当前选中的图片
    var pageCurrentImg: UIImage? {
        didSet {
            //elf.pageControl.setValue(pageCurrentImg, forKeyPath: "_currentPageImage")
        }
    }
    
    /// 图片集合，可以传入图片数组或者字符串数组，其他无效
    private(set) var images: [Any]? {
        didSet {
            self.imageCollection.reloadData()
            self.pageControl.numberOfPages = images?.count ?? 0
            if self.index >= images?.count ?? 1 {
                self.index = self.index - 1
            } else if self.index < 0 {
                self.index = 0
            }
            self.imageCollection.setContentOffset(CGPoint(x: (CGFloat)(self.index)*UIScreen.main.bounds.width, y: 0), animated: false)
        }
    }
    /// 当前正在显示的图片的索引
    fileprivate var index: Int! {
        didSet {
            self.pageControl.currentPage = index
            self.titleLabel.text = "\((self.index ?? 0) + 1)/\(self.images?.count ?? 0)"
            self.title = "\((self.index ?? 0) + 1)/\(self.images?.count ?? 0)"
        }
    }
    /// 分享block
    fileprivate var shareBlock: ((Int)->Void)?
    /// 转场方式
    fileprivate var transitionType = LTLImageVCTransitionType.modal
    
    /// 是否隐藏导航栏与状态栏 push转场时，点击屏幕隐藏或者显示导航栏
    fileprivate var hiddenNav = false {
        didSet {
//            if self.transitionType == LTLImageVCTransitionType.modal {
//
//                self.setNeedsStatusBarAppearanceUpdate()
//            } else if self.transitionType == LTLImageVCTransitionType.push {
                self.setNeedsStatusBarAppearanceUpdate()
                guard self.navigationController != nil else {
                    return
                }
                self.navigationController!.setNavigationBarHidden(hiddenNav, animated: true)

//            }
        }
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        get {
            return UIStatusBarAnimation.slide
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return hiddenNav
        }
    }
    
    /// 导航栏标题颜色
    var titleColor = UIColor.white {
        didSet {
            self.titleLabel.textColor = titleColor
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    /// 原先导航控制器右滑是否enable
    var popGestureRecognizer: Bool?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    /*!
     显示图片浏览器，支持modal与push两种转场
     
     @param target                  控制器，传入上个界面的控制
     @param transitionType          转场方式，modal或者push
     @param images                  图片数组，可以传入uimage数组或者string数组
     @param index                   当前索引，传入需要当前显示图片的索引
     @param deleteBlock             删除回调，传入nil时，不会显示删除按钮
     
     @discussion
     */
    class func show(target: UIViewController!, transitionType: LTLImageVCTransitionType, images: [Any]?, index: Int, shareBlock: ((Int)->Void)?) -> LTLImageBrowserVC {
        let vc = LTLImageBrowserVC()
        vc.index = index < 0 ? 0 : index
        vc.images = images
        vc.pageControl.currentPage = vc.index
        vc.shareBlock = shareBlock
        vc.transitionType = transitionType
        
        if transitionType == LTLImageVCTransitionType.modal {
            
            let nav = UINavigationController(rootViewController:vc)
         
            
            target.present(nav, animated: true, completion: nil)

            
        } else if transitionType == LTLImageVCTransitionType.push {
            target.navigationController?.pushViewController(vc, animated: true)
        }
        return vc
    }
    
    func setView() {
//        self.automaticallyAdjustsScrollViewInsets = false
        ///适配 iOS 11.0
        if #available(iOS 11.0, *) {
            imageCollection.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(imageCollection)
        self.view.addSubview(pageControl)
        
//        self.navigationItem.titleView = self.titleLabel
//        self.titleLabel.text = "\((self.index ?? 0) + 1)/\(self.images?.count ?? 0)"
        self.title = "\((self.index ?? 0) + 1)/\(self.images?.count ?? 0)"
        if self.transitionType == LTLImageVCTransitionType.push {

        } else if self.transitionType == LTLImageVCTransitionType.modal {
            navigationController?.navigationBar.barTintColor = UIColor.blue
            navigationController?.navigationBar.tintColor = UIColor.white
            navigationController?.navigationBar.barStyle = UIBarStyle.black
            
//            navigationController?.navigationItem.leftBarButtonItem = self.dismissBar
            navigationItem.leftBarButtonItem = self.dismissBar
        }
        navigationItem.rightBarButtonItems = [self.shareBar,self.saveBar]
    }
    


}

extension LTLImageBrowserVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LTLImageViewCell", for: indexPath) as? LTLImageViewCell
        
        cell?.image = self.images?[indexPath.row]
        cell?.singleTapBolck = { [weak self] in
            if self?.transitionType == LTLImageVCTransitionType.push {
                self?.hiddenNav = !(self?.hiddenNav)!
            } else if self?.transitionType == LTLImageVCTransitionType.modal {
//                self.dismiss(animated: true, completion: nil)
                self?.hiddenNav = !(self?.hiddenNav)!
            }
        }
        cell?.gestureBlock = { [weak self] in
            if self?.transitionType == LTLImageVCTransitionType.push && self?.hiddenNav == false {
                self?.hiddenNav = true
            }
        }
        
        cell?.shareBlock = { [weak self] in
            self?.share()
        }
        cell?.saveBlock = { [weak self] in
            self?.save()
        }
        
        return cell!
    }
    
//    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
//        if self.transitionType == LTLImageVCTransitionType.push && hiddenNav == false {
//            hiddenNav = true
//        }
//    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        self.index = (Int)(offsetX / UIScreen.main.bounds.width)
    }
    
}
