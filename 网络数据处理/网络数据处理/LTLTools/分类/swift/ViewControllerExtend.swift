//
//  ViewControllerExtend.swift
//  appTemplates
//
//  Created by 123 on 2017/10/18.
//  Copyright © 2017年 LiTaiLiang. All rights reserved.
//

import UIKit

extension UIViewController
{
    
}
extension UIView
{
    /** swift方法   在 View 中实现这个方法即可
     *viewController () -> (UIViewController) 作用：根据调用这个方法的对象 来 获取他的控制器对象
     */
    func superViewController () -> UIViewController {
        
        /* 方法1.
         //1.通过响应者链关系，取得此视图的下一个响应者
         var next:UIResponder?
         next = self.nextResponder()!
         while next != nil {
         //2.判断响应者对象是否是视图控制器类型
         if ((next as?UIViewController) != nil) {
         return (next as! UIViewController)
         
         }else {
         next = next?.nextResponder()
         }
         }
         
         return UIViewController()
         */
        
        //1.通过响应者链关系，取得此视图的下一个响应者
        var next:UIResponder?
        next = self.next!
        repeat {
            //2.判断响应者对象是否是视图控制器类型
            if ((next as?UIViewController) != nil) {
                return (next as! UIViewController)
                
            }else {
                next = next?.next
            }
            
        } while next != nil
        
        return UIViewController()
    }

}
extension UIViewController
{
    
    @objc public class func Storyboard() -> UIViewController{
        LTLLog("\(self)",.info)
        let storyboard = UIStoryboard.init(name: "\(self)", bundle: nil)
        return storyboard.instantiateInitialViewController()!
    }
    ///登陆后淡入淡出更换rootViewController
    func restoreRootViewController(_ rootViewController:UIViewController)  {
        let window = UIApplication.shared.keyWindow
        rootViewController.modalTransitionStyle = .crossDissolve
        UIView.transition(with: window!, duration: 0.5, options: UIViewAnimationOptions.curveEaseIn, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            UIApplication.shared.keyWindow?.rootViewController = rootViewController
            UIView.setAnimationsEnabled(oldState)
        }, completion: nil)
    }
}

extension CALayer
{
    public func removeAllSublayers()
    {
        if self.sublayers != nil{
            
            for item in self.sublayers! {
                item.removeFromSuperlayer()
            }
        }
    }
}

extension UIView : Nibloadable
{
    //绘制截图
    public func snapShot() -> UIImage!{
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image;
    }
    /*!
     将UIView绘制成PDF
     */
    public func pdf()->Data{
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, self.bounds, nil);
        UIGraphicsBeginPDFPage();
        let pdfContext:CGContext? = UIGraphicsGetCurrentContext();
        self.layer.render(in: pdfContext!)
        UIGraphicsEndPDFContext();
        
        return pdfData as Data
    }
    /*!
     创建一个可缩放
     */
    public func setViewForImage(_ image:UIImage){
        
        let scrollview = UIScrollView(frame: self.bounds)
        addSubview(scrollview)
    }
    /*!
     清空所有子视图
     */
    public func removeAllSubViews()
    {
        _ = self.subviews.map {
            $0.removeFromSuperview()
        }
    }
    
    
    public var circularView:Bool
    {
        set
        {
            if newValue {
                
                self.contentMode = .scaleAspectFill
                //设置遮罩
                self.layer.masksToBounds = true
                //设置圆角半径(宽度的一半)，显示成圆形。
                self.layer.cornerRadius = self.bounds.height / 2.0
            }
        }
        get
        {
            return false
        }
    }
    
}

protocol Nibloadable {
}
extension Nibloadable where Self : UIView{
    /*
     static func loadNib(_ nibNmae :String = "") -> Self{
     let nib = nibNmae == "" ? "\(self)" : nibNmae
     return Bundle.main.loadNibNamed(nib, owner: nil, options: nil)?.first as! Self
     }
     */
    static func loadNib(_ nibNmae :String? = nil) -> Self{
        return Bundle.main.loadNibNamed(nibNmae ?? "\(self)", owner: nil, options: nil)?.first as! Self
    }
}
import Kingfisher

public typealias ProgressBlock = (_ receivedSize: Int64, _ totalSize: Int64) -> Void
public typealias CompletionHandler = (_ image: UIImage?, _ error: NSError?, _ cacheType: CacheType, _ imageURL: URL?) -> Void

extension UIImageView
{
    func setImage(_ urlStr :String,placeholderImage:UIImage,_ progress:ProgressBlock? = nil, _  completion:CompletionHandler? = nil)
    {
        self.kf.setImage(with: URL(string: urlStr), placeholder: placeholderImage, options: nil, progressBlock: progress, completionHandler: completion)
        
    }
}

