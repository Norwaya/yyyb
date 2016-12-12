//
//  Jcxx.swift
//  yyyb
//
//  Created by admin on 2016/12/8.
//  Copyright © 2016年 norwaya. All rights reserved.
//

import UIKit
import SwiftyJSON
class Jcxx :NSObject{
    var kbxx: Array<Kbxx> = Array()
    var rbxx: Array<Rbxx> = Array()
    override init(){
        Kbxx()
    }
    func appendRbxx(rb: Rbxx){
        rbxx.append(rb)
    }
    func appendKbxx(kb: Kbxx){
        kbxx.append(kb)
    }
    override var description: String {
        return ""
    }
}
extension Kbxx{
     func descript() -> String{
        return JSON.init(self).description
    }
}
