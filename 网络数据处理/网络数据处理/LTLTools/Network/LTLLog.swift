//
//  LTLLog.swift
//  appTemplates
//
//  Created by 123 on 2017/12/6.
//  Copyright © 2017年 LiTaiLiang. All rights reserved.
//

import Foundation

public enum LogType:NSInteger {
    ///调试
    case debug
    ///错误
    case error
    ///信息
    case info
    ///警告
    case warning
    ///禁止
    case prohibit
}
///debug打印  (最好在 TARGETS --> Build Settings --> Swift Complier - Custom Flags --> Other Swift Flags --> DEBUG 格式 -D DEBUGSWIFT )
public func LTLLog<L>(_ items: L ,file: String = #file, line: Int = #line, function: String = #function,_ type:LogType = .info) {
    #if DEBUG
        var emoji = ""
        switch type
        {
        case .debug:
            emoji = "🔧"
            break
        case .error:
            emoji = "❌"
            break
        case .info:
            emoji = "✏️"
            break
        case .warning:
            emoji = "❗️"
            break
        case .prohibit:
            emoji = "🚫"
            break
        }
        print("\(emoji) =>文件: \((file as NSString).lastPathComponent) ->, 行数: \(line) ->, 函数: \(function) \n\(emoji) =>: \(items) \n")
    #endif
}






