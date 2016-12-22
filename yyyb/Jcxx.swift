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
    var kbxxList : Array<structKbxx> = Array()
    var rbxxList : Array<structRbxx> = Array()
    var xjgjList: Array<structXjgj> = Array()

    override init(){
    }
    func appendRbxx(rb: structRbxx){
        rbxxList.append(rb)
    }
    func appendKbxx(kb: structKbxx){
       
        kbxxList.append(kb)
    }
    func appendXjgj(jwd:structXjgj){
        xjgjList.append(jwd)
    }
    
}
struct structRbxx{
      var bgbh: String?
      var fjsc: [String]
//      var jclx: String?
      var jd: String?
      var lrry: String?
      var lrsj: String?
      var sjtz: String?
      var ssbm: String?
//      var swsl: String?
      var wd: String?
      var wzdm: String?
      var zqsl: String?
    
    init(ssbm:String,jd:String,wd:String,wzdm:String,lrry:String,zqsl:String,lrsj:String,sjtz:String,fjsc:Array<String>,bgbh:String){
        
        self.ssbm = ssbm
        self.jd = jd
        self.wd = wd
        self.wzdm = wzdm
        self.lrry = lrry
        self.zqsl = zqsl
        self.lrsj = lrsj
        self.sjtz = sjtz
        self.bgbh = bgbh
        self.fjsc = fjsc
    }
    
}
struct structKbxx{
    var bgbh: String?
    var cbjl: String?
    var cbjlqt: String?
    var fjsc: String?
    var fxdd: String?
    var fxsj: String?
    var jd: String?
    var lrsj: String?
    var name: String?
    var ssbm: String?
    var swsl: String
    var wd: String?
    var wzid: String?
    var xccl: String?
    var ycdwcl: String?
    var ycsl: String
    var zqsl: String
    var zqtz: String?
    var zzms: String?
    var sjtz:String?
    init(fxdd:String,fxsj:String,jd:String,wd:String,wzid:String,zqtz:String,zqsl:String,ycsl:String ,swsl:String,zzms:String,cbjl:String,cbjlqt:String,xccl:String,ycdwcl:String,lrsj:String,ssbm:String,sjtz:String,bgbh:String){
//        self.fxsj = fxsj
        self.fxdd  = fxdd
        self.jd = jd
        self.wd = wd
        self.wzid = wzid
        self.zqtz = zqtz
        self.zqsl = zqsl
        self.ycsl = ycsl
        self.swsl = swsl
        self.zzms = zzms
        self.cbjl = cbjl
        self.cbjlqt  = cbjlqt
        self.xccl = xccl
        self.ycdwcl = ycdwcl
        self.lrsj = lrsj
//        self.ssbm = ssbm
        self.sjtz = sjtz
        self.bgbh = bgbh
        
    }
}
struct structXjgj{
    var jd:String?
    var wd:String?
    var xjsj:String?
    init(jd:String,wd:String,xjsj:String) {
        self.jd = jd
        
        self.wd = wd
        self.xjsj = xjsj
    }
}
