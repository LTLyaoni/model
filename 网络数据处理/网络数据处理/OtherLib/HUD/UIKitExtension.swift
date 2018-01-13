//
//  UIKitExtension.swift
//  WTKit
//
//  Created by SongWentong on 4/21/16.
//  Copyright © 2016 SongWentong. All rights reserved.
//  https://github.com/swtlovewtt/WTKit
//
#if os(iOS)
import Foundation
import UIKit
import ImageIO
public typealias imageHandler = ((UIImage?,Error?)->Void)
@available(iOS 2.0, *)

extension UIColor{
    /*!
     根据字符串和alpha给出颜色
     如果给出的是一个不正常的字符串,会返回红色
     */
    public class func colorWithHexString(_ string:String,alpha:CGFloat?=1.0) -> UIColor{
        //        let s = NSScanner(string: string)
        let mutableCharSet = NSMutableCharacterSet()
        mutableCharSet.addCharacters(in: "#")
        mutableCharSet.formUnion(with: CharacterSet.whitespaces);
        
        let hString = string.trimmingCharacters(in: mutableCharSet as CharacterSet)
        DEBUGBlock {
            //            NSLog("%@", hString)
        }
        switch hString.length {
        case 0:
            return UIColor.red;
        case 1:
            return UIColor.colorWithHexString(hString+hString);
        case 2:
            return UIColor.colorWithHexString(hString+hString+hString);
        case 6:
            let r = hString[0..<2]
            let g = hString[2..<4]
            let b = hString[4..<6]
            var rInt:UInt32 = 0x0,gInt:UInt32 = 0x0,bInt:UInt32 = 0x0
            
            Scanner.init(string: r).scanHexInt32(&rInt)
            Scanner.init(string: g).scanHexInt32(&gInt)
            Scanner.init(string: b).scanHexInt32(&bInt)
            
            let red = CGFloat(rInt)/255.0
            let green = CGFloat(gInt)/255.0
            let blue = CGFloat(bInt)/255.0
            //            WTLog("\(red) \(green) \(blue)")
            let color = UIColor(red: red, green: green, blue: blue,alpha: alpha!)
            return color;
        default:
            return UIColor.red;
        }
    }

}
    
@available(iOS 2.0, *)
extension UIApplication{
    
    public static func documentsPath()->String{
        return String(format: "%@/Documents",NSHomeDirectory())
    }
    
    public static func libraryPath()->String{
        return String(format: "%@/Library",NSHomeDirectory())
    }
    
}

extension UIDevice{
    // MARK: - 磁盘空间/可用空间/已用空间
    /*!
     硬盘空间
     */
    public func diskSpace()->Int64{
        var attributes: [FileAttributeKey : Any]
        var fileSystemSize:Int64 = 0
        do{
            let fm = FileManager.default;
            try attributes = fm.attributesOfFileSystem(forPath: NSHomeDirectory())
            //                try attributes = FileManager.default.attributesOfItem(atPath: NSHomeDirectory())
            //            fileSystemSize = (attributes![attributes.systemSize.rawValue]?.int64Value)!
            //            fileSystemSize = attributes[FileAttributeKey.fileSystemSize]
            fileSystemSize = (attributes[FileAttributeKey.systemSize] as AnyObject).int64Value
        }catch{
            
        }
        return fileSystemSize
    }
    
    /*!
     可用空间
     */
    public func diskSpaceFree()->Int64{
        var attributes:[FileAttributeKey : Any]
        var fileSystemSize:Int64 = 0
        do{
            try attributes = FileManager.default.attributesOfItem(atPath: NSHomeDirectory())
            //            attributes?["aaa"]!
            fileSystemSize = (attributes[FileAttributeKey.systemFreeSize]as AnyObject).int64Value
        }catch{
            
        }
        return fileSystemSize
    }
    
    /*!
     已用空间
     */
    public func diskSpaceUsed()->Int64{
        return diskSpace() - diskSpaceFree()
    }
    /*!
     物理内存
     */
    public func memoryTotal()->UInt64{
        let mem = ProcessInfo.processInfo.physicalMemory;
        return mem;
    }
    
}

extension UITableView{
    public func updateWithClosure(_ table:(_ table:UITableView)->Void){
        self.beginUpdates()
        table(self)
        self.endUpdates()
    }

    public func insertRowAtIndexPath(_ indexPath: IndexPath, withRowAnimation animation: UITableViewRowAnimation){
        self.insertRows(at: [indexPath], with: animation)
    }

    public func insertRowAt(row:Int, section:Int,withRowAnimation animation: UITableViewRowAnimation){
        let indexPath = IndexPath(row: row, section: section)
        self.insertRowAtIndexPath(indexPath, withRowAnimation: animation)
    }
    
    /*!
     取消所有选中的cell
     */
    public func clearSelectedRows(_ animated:Bool){
        let indexPathsForSelectedRows = self.indexPathsForSelectedRows
        if indexPathsForSelectedRows != nil {
            for(_, indexPath) in self.indexPathsForSelectedRows!.enumerated(){
                self.deselectRow(at: indexPath, animated: animated)
            }
        }
    }
}

#endif



