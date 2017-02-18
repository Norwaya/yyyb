//
//  Contact.swift
//  yyyb
//
//  Created by admin on 2017/1/12.
//  Copyright © 2017年 norwaya. All rights reserved.
//

import UIKit

var baseUrl:String = "192.168.20.50:8090"

var localUrl:String = "117.34.115.230:8080/spring"

class Contact {
    
   static func getUrl() -> String{
        let ud = UserDefaults.standard
        let flag:Bool = ud.bool(forKey: "flag") 
        return flag ? baseUrl : localUrl
    }
    
}
