

import Foundation

public class LTLFile: NSObject {
    
    
    
    //MARK:---------文件-----------
    /**
     创建文件
     - Note: 文件存放于沙盒中的Documents文件夹中
     - Parameter fileName: 文件名
     - Returns: 无
     */
    public class func createFile(fileName: String) {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let path = NSURL(fileURLWithPath: paths[0]).appendingPathComponent(fileName)
        let manager = FileManager.default
        if (!manager.fileExists(atPath: path!.path)) {//如果文件不存在则创建文件
            manager.createFile(atPath: path!.path, contents:nil, attributes:nil)
        }
    }
    
    /**
     读取文件
     - Note: 文件存放于沙盒中的Documents文件夹中
     - Parameter fileName: 文件名
     - Returns: 文件中的数据
     */
    public class func readFile(fileName: String) -> Dictionary<String, AnyObject> {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let path = NSURL(fileURLWithPath: paths[0]).appendingPathComponent(fileName)
        
        return NSDictionary(contentsOfFile: path!.path) as! Dictionary<String, AnyObject>
    }
    
    /**
     读取JSON文件
     - Note: 文件存放于main bundle中
     - Parameter fileName: 文件名
     - Returns: 文件中的数据
     */
    public class func readJSON(fileName: String) -> Dictionary<String, AnyObject> {
        let path = Bundle.main.path(forResource: fileName, ofType: "json")
        let string = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        let data = string?.data(using: String.Encoding.utf8)
        return try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! Dictionary<String, AnyObject>
    }
    
    /**
     写入文件
     - Note: 文件存放于沙盒中的Documents文件夹中
     - Parameter fileName: 文件名
     - Parameter params: 写入文件的参数
     - Returns: 写入结果
     */
    public class func writeToFile(fileName: String, params: Dictionary<String, AnyObject>) -> Bool {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let path = NSURL(fileURLWithPath: paths[0]).appendingPathComponent(fileName)
      
        return (params as NSDictionary).write(toFile: path!.path, atomically: true)
    }
    
    /// 写入文件
    ///文件存放于沙盒中的Documents文件夹中
    /// - Parameters:
    ///   - fileName: 文件名
    ///   - userData: 写入的字符串数据
    /// - Returns: 返回成功或失败
    class  func  writeString(_ fileName: String, userData: String) -> Bool {
        let manager = FileManager.default
        let documentsPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let path = NSURL(fileURLWithPath: documentsPaths.first!).appendingPathComponent(fileName)
    
        if (!manager.fileExists(atPath: path!.path)) {//如果文件不存在则创建文件
            manager.createFile(atPath: path!.path, contents:nil, attributes:nil)
        }
        else
        {
            let writeHandle = FileHandle(forWritingAtPath: path!.path)
            writeHandle?.truncateFile(atOffset: 0)
            writeHandle?.closeFile()
        }

        do {
            try userData.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            return true
        } catch let error {
            LTLLog( "写入的字符串数据失败" + error.localizedDescription ,.error)
            return true
        }
    }
    /// 写入文件
    ///文件存放于沙盒中的Documents文件夹中
    /// - Parameters:
    ///   - fileName: 文件名
    ///   - userData: 写入的Data数据
    /// - Returns: 返回成功或失败
    class func writeData(_ fileName: String, userData: Data) -> Bool {
        let manager = FileManager.default
        let documentsPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let path = NSURL(fileURLWithPath: documentsPaths.first!).appendingPathComponent(fileName)
        if (!manager.fileExists(atPath: path!.path)) {//如果文件不存在则创建文件
            manager.createFile(atPath: path!.path, contents:nil, attributes:nil)
        }
        do {
            try userData.write(to: path!)
            return true
        } catch let error {
            LTLLog( "写入的Data数据" + error.localizedDescription , .error)
            return true
        }
    }
    
    /// 读取文件
    ///
    /// - Parameter fileName: 文件名
    /// - Returns: 读取的字符串数据
    class  func readString(_ fileName: String) -> String {
        let manager = FileManager.default
        let documentsPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let path = NSURL(fileURLWithPath: documentsPaths.first!).appendingPathComponent(fileName)
  
        let data = manager.contents(atPath: (path?.path)!)
        
        if data == nil {
            return ""
        }
        return String(data:data!, encoding: String.Encoding.utf8)!
    }
    /// 读取文件
    ///
    /// - Parameter fileName: 文件名
    /// - Returns: 读取的Data数据
    class func readData(_ fileName: String) -> Data {
        let manager = FileManager.default
        let documentsPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let path = NSURL(fileURLWithPath: documentsPaths.first!).appendingPathComponent(fileName)

        return manager.contents(atPath: (path?.path)!)!
    }
    
    
    //MARK:---------其他-----------
    //    func lingshi()  {
    ////        获取用户文档目录路径
    //        let manager = FileManager.default
    //        let urlForDocument = manager.urls(for: .documentDirectory, in:.userDomainMask)
    //        let url = urlForDocument[0] as URL
    //        print(url)
    ////        对指定路径执行浅搜索，返回指定目录路径下的文件，子目录及符号链接的列表
    //        let contentsOfPath = try? manager.contentsOfDirectory(atPath: url.path)
    //        print("contentsOfPath: \(String(describing: contentsOfPath))")
    ////        类似上面的，对指定路径执行浅搜索，返回指定目录路径下的文件，子目录及符号链接的列表
    //        let contentsOfURL = try? manager.contentsOfDirectory(at: url,
    //                                                             includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
    //        print("contentsOfURL: \(String(describing: contentsOfURL))")
    ////      深度遍历，会递归遍历子文件夹（但不会递归符号链接）
    //        let enumeratorAtPath = manager.enumerator(atPath: url.path)
    //        print("enumeratorAtPath: \(String(describing: enumeratorAtPath?.allObjects))")
    ////        类似上面的，深度遍历，会递归遍历子文件夹（但不会递归符号链接）
    //        let enumeratorAtURL = manager.enumerator(at: url, includingPropertiesForKeys: nil,
    //                                                 options: .skipsHiddenFiles, errorHandler:nil)
    //        print("enumeratorAtURL: \(String(describing: enumeratorAtURL?.allObjects))")
    ////        深度遍历，会递归遍历子文件夹（包括符号链接，所以要求性能的话用enumeratorAtPath）
    //        let subPaths = manager.subpaths(atPath: url.path)
    //        print("subPaths: \(String(describing: subPaths))")
    ////        判断文件或文件夹是否存在
    //        let fileManager = FileManager.default
    //        let filePath:String = NSHomeDirectory() + "/Documents/hangge.txt"
    //        let exist = fileManager.fileExists(atPath: filePath)
    //        print("subPaths: \(String(exist))")
    ////        创建文件夹
    ////方式1
    //        let myDirectory:String = NSHomeDirectory() + "/Documents/myFolder/Files"
    //        let fileManager1 = FileManager.default
    //
    //        //withIntermediateDirectories为ture表示路径中间如果有不存在的文件夹都会创建
    //        try! fileManager1.createDirectory(atPath: myDirectory,
    //                                         withIntermediateDirectories: true, attributes: nil)
    ////方式2
    //        //在文档目录下新建folder目录
    //        let manager1 = FileManager.default
    //        let urlForDocument1 = manager1.urls(for: .documentDirectory, in: .userDomainMask)
    //        let url1 = urlForDocument1[0] as NSURL
    //        createFolder(name: "folder", baseUrl: url1)
    ////        把字符串保存到文件
    //        let filePath1:String = NSHomeDirectory() + "/Documents/hangge.txt"
    //        let info = "欢迎来到hange.com"
    //        try! info.write(toFile: filePath1, atomically: true, encoding: String.Encoding.utf8)
    ////        把图片保存到文件路径下
    //        let filePath2 = NSHomeDirectory() + "/Documents/hangge.png"
    //        let image = UIImage(named: "apple.png")
    //        let data:Data = UIImagePNGRepresentation(image!)!
    //        try? data.write(to: URL(fileURLWithPath: filePath2))
    ////      把NSArray的保存到文件路径下
    //        let array = NSArray(objects: "aaa","bbb","ccc")
    //        let filePath3:String = NSHomeDirectory() + "/Documents/array.plist"
    //        array.write(toFile: filePath3, atomically: true)
    ////      把NSDictionary中保存到文件路径下
    //        let dictionary:NSDictionary = ["Gold": "1st Place", "Silver": "2nd Place"]
    //        let filePath4:String = NSHomeDirectory() + "/Documents/dictionary.plist"
    //        dictionary.write(toFile: filePath4, atomically: true)
    ////        //在文档目录下新建test.txt文件
    //        let manager2 = FileManager.default
    //        let urlForDocument2 = manager2.urls( for: .documentDirectory,
    //                                           in:.userDomainMask)
    //        let url2 = urlForDocument2[0]
    //        createFile(name:"test.txt", fileBaseUrl: url2)
    //        //createFile(name: "folder/new.txt", fileBaseUrl: url)
    ////        复制文件
    ////        方法1
    //        let fileManager3 = FileManager.default
    //        let homeDirectory = NSHomeDirectory()
    //        let srcUrl = homeDirectory + "/Documents/hangge.txt"
    //        let toUrl = homeDirectory + "/Documents/copyed.txt"
    //        try! fileManager3.copyItem(atPath: srcUrl, toPath: toUrl)
    ////        方法2
    //        // 定位到用户文档目录
    //        let manager4 = FileManager.default
    //        let urlForDocument4 = manager.urls( for:.documentDirectory, in:.userDomainMask)
    //        let url4 = urlForDocument4[0]
    //
    //        // 将test.txt文件拷贝到文档目录根目录下的copyed.txt文件
    //        let srcUrl4 = url4.appendingPathComponent("test.txt")
    //        let toUrl4 = url4.appendingPathComponent("copyed.txt")
    //
    //        try! manager4.copyItem(at: srcUrl4, to: toUrl4)
    ////        移动文件
    ////        方法1
    //        let fileManager5 = FileManager.default
    //        let homeDirectory5 = NSHomeDirectory()
    //        let srcUrl5 = homeDirectory5 + "/Documents/hangge.txt"
    //        let toUrl5 = homeDirectory5 + "/Documents/moved/hangge.txt"
    //        try! fileManager5.moveItem(atPath: srcUrl5, toPath: toUrl5)
    ////        方法2
    //        // 定位到用户文档目录
    //        let manager6 = FileManager.default
    //        let urlForDocument6 = manager6.urls( for: .documentDirectory, in:.userDomainMask)
    //        let url6 = urlForDocument6[0]
    //
    //        let srcUrl6 = url6.appendingPathComponent("test.txt")
    //        let toUrl6 = url6.appendingPathComponent("copyed.txt")
    //        // 移动srcUrl中的文件（test.txt）到toUrl中（copyed.txt）
    //        try! manager6.moveItem(at: srcUrl6, to: toUrl6)
    ////        删除文件
    ////        方法1
    //        let fileManager7 = FileManager.default
    //        let homeDirectory7 = NSHomeDirectory()
    //        let srcUrl7 = homeDirectory7 + "/Documents/hangge.txt"
    //        try! fileManager7.removeItem(atPath: srcUrl7)
    ////        方法2
    //        // 定位到用户文档目录
    //        let manager8 = FileManager.default
    //        let urlForDocument8 = manager8.urls(for: .documentDirectory, in:.userDomainMask)
    //        let url8 = urlForDocument8[0]
    //
    //        let toUrl8 = url8.appendingPathComponent("copyed.txt")
    //        // 删除文档根目录下的toUrl路径的文件（copyed.txt文件）
    //        try! manager8.removeItem(at: toUrl8)
    ////        删除目录下所有的文件
    ////        方法1：获取所有文件，然后遍历删除
    //        let fileManager9 = FileManager.default
    //        let myDirectory9 = NSHomeDirectory() + "/Documents/Files"
    //        let fileArray9 = fileManager9.subpaths(atPath: myDirectory9)
    //        for fn in fileArray9!{
    //            try! fileManager.removeItem(atPath: myDirectory + "/\(fn)")
    //        }
    ////        方法2：删除目录后重新创建该目录
    //        let fileManager10 = FileManager.default
    //        let myDirectory10 = NSHomeDirectory() + "/Documents/Files"
    //        try! fileManager10.removeItem(atPath: myDirectory10)
    //        try! fileManager10.createDirectory(atPath: myDirectory10, withIntermediateDirectories: true,
    //                                         attributes: nil)
    ////        10，读取文件
    //        let manager11 = FileManager.default
    //        let urlsForDocDirectory11 = manager11.urls(for: .documentDirectory, in:.userDomainMask)
    //        let docPath11 = urlsForDocDirectory11[0]
    //        let file11 = docPath11.appendingPathComponent("test.txt")
    //
    //        //方法1
    //        let readHandler = try! FileHandle(forReadingFrom:file11)
    //        let data11 = readHandler.readDataToEndOfFile()
    //        let readString = String(data: data11, encoding: String.Encoding.utf8)
    //        print("文件内容: \(String(describing: readString))")
    //
    //        //方法2
    //        let data2 = manager.contents(atPath: file11.path)
    //        let readString2 = String(data: data2!, encoding: String.Encoding.utf8)
    //        print("文件内容: \(String(describing: readString2))")
    //
    ////        在任意位置写入数据
    //        let manager12 = FileManager.default
    //        let urlsForDocDirectory12 = manager12.urls(for:.documentDirectory, in:.userDomainMask)
    //        let docPath12 = urlsForDocDirectory12[0]
    //        let file12 = docPath12.appendingPathComponent("test.txt")
    //
    //        let string = "添加一些文字到文件末尾"
    //        let appendedData = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
    //        let writeHandler = try? FileHandle(forWritingTo:file12)
    //        writeHandler!.seekToEndOfFile()
    //        writeHandler!.write(appendedData!)
    ////        12，文件权限判断
    //        let manager13 = FileManager.default
    //        let urlForDocument13 = manager13.urls(for: .documentDirectory, in:.userDomainMask)
    //        let docPath13 = urlForDocument13[0]
    //        let file13 = docPath13.appendingPathComponent("test.txt")
    //
    //        let readable = manager13.isReadableFile(atPath: file13.path)
    //        print("可读: \(readable)")
    //        let writeable = manager13.isWritableFile(atPath: file13.path)
    //        print("可写: \(writeable)")
    //        let executable = manager13.isExecutableFile(atPath: file13.path)
    //        print("可执行: \(executable)")
    //        let deleteable = manager13.isDeletableFile(atPath: file13.path)
    //        print("可删除: \(deleteable)")
    ////        获取文件属性（创建时间，修改时间，文件大小，文件类型等信息）
    //        let manager14 = FileManager.default
    //        let urlForDocument14 = manager14.urls(for: .documentDirectory, in:.userDomainMask)
    //        let docPath14 = urlForDocument14[0]
    //        let file14 = docPath14.appendingPathComponent("test.txt")
    //
    //        let attributes = try? manager14.attributesOfItem(atPath: file14.path) //结果为Dictionary类型
    //        print("attributes: \(attributes!)")
    //        print("创建时间：\(attributes![FileAttributeKey.creationDate]!)")
    //        print("修改时间：\(attributes![FileAttributeKey.modificationDate]!)")
    //        print("文件大小：\(attributes![FileAttributeKey.size]!)")
    ////        14，文件/文件夹比较
    //        let manager15 = FileManager.default
    //        let urlForDocument15 = manager15.urls(for: .documentDirectory, in:.userDomainMask)
    //        let docPath15 = urlForDocument15[0]
    //        let contents = try! manager15.contentsOfDirectory(atPath: docPath15.path)
    //
    //        //下面比较用户文档中前面两个文件是否内容相同（该方法也可以用来比较目录）
    //        let count = contents.count
    //        if count > 1 {
    //            let path1 = docPath15.path + "/" + (contents[0] as String)
    //            let path2 = docPath15.path + "/" + (contents[1] as String)
    //            let equal = manager15.contentsEqual(atPath: path1,andPath:path2)
    //            print("path1：\(path1)")
    //            print("path2：\(path2)")
    //            print("比较结果： \(equal)")
    //        }
    //    }
    ////
    //    func createFolder(name:String,baseUrl:NSURL){
    //        let manager = FileManager.default
    //        let folder = baseUrl.appendingPathComponent(name, isDirectory: true)
    //        print("文件夹: \(String(describing: folder))")
    //        let exist = manager.fileExists(atPath: folder!.path)
    //        if !exist {
    //            try! manager.createDirectory(at: folder!, withIntermediateDirectories: true,
    //                                         attributes: nil)
    //        }
    //
    //
    //    }
    ////
    //    func createFile(name:String, fileBaseUrl:URL){
    //        let manager = FileManager.default
    //
    //        let file = fileBaseUrl.appendingPathComponent(name)
    //        print("文件: \(file)")
    //        let exist = manager.fileExists(atPath: file.path)
    //        if !exist {
    //            let data = Data(base64Encoded:"aGVsbG8gd29ybGQ=" ,options:.ignoreUnknownCharacters)
    //            let createSuccess = manager.createFile(atPath: file.path,contents:data,attributes:nil)
    //            print("文件创建结果: \(createSuccess)")
    //        }
    //    }
    
}
