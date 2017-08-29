//
//  UserModel.swift
//  MASQLite
//
//  Created by 林东鹏 on 28/08/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import MASQLite

public class UserModel : MAObject {
    var uid = ""
    var name = ""
    var gender : Int = 23
    var marked = false
    var country:String? = nil
    
    var ignoreKey = "abc"
    
    public override func primaryKey() -> String {
        return "uid"
    }
    
    public override func ignoreKeys() -> [String] {
        return ["ignoreKey"]
    }
    
    
    

    
}
