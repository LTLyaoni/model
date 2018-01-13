//
//  InfoServe.swift
//  appTemplates
//
//  Created by 123 on 2017/11/17.
//  Copyright © 2017年 LiTaiLiang. All rights reserved.
//

import Foundation

extension NSObject
{
    func ServeInfo(_ fileName:String ) -> Bool {
        return LTLFile.writeString(fileName, userData: (self.dictionaryWithObject()?.JSONString().Endcode_AES_ECB())!)
    }
    class func read(_ fileName:String) -> Self {
        let AESString = LTLFile.readString(fileName)
        let dict = AESString.Decode_AES_ECB().getDictionaryFromJSONString()
        return toModel(dict)
    }
    
}
