//
//  main.swift
//  字符串
//
//  Created by 123 on 2017/12/8.
//  Copyright © 2017年 LTL. All rights reserved.
//

import Foundation

enum Cmd:String , Codable{
    case cid
    case pc
    case IOS
    
}

class JSON: NSObject ,Codable {
    var name = "LTL"
    var age:Int?
    var weight = 180
    var cmd:Cmd?
    var yy:YYL = YYL()
}

class YYL: NSObject ,Codable {
    var name = "LTL"
    var age:Int?
    var weight = [55555,888881,461]
    var cmd:Cmd?
    
}


let LTL = JSON()

let data = try JSONEncoder().encode(LTL)
let json = String(data: data, encoding: .utf8)
print(json)
let jsonStr = "{\"name\":\"LTL\",\"weight\":180,\"age\":18,\"cmd\":\"pc\",\"yy\":{\"name\":\"LTr\",\"weight\":180,\"age\":18,\"cmd\":\"pc\"}}"

do {
    
    let xiaoming = try JSONDecoder().decode(JSON.self, from: (jsonStr.data(using: .utf8)!))
    LTLLog(xiaoming.cmd)
    LTLLog(xiaoming.yy.name)
    
    let data = try JSONEncoder().encode(xiaoming)
    let jsonL = String(data: data, encoding: .utf8)

    print(jsonL)
    
} catch {
    // 异常处理
    LTLLog(error.localizedDescription)
}


