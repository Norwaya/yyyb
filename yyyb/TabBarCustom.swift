//
//  TabBarCustom.swift
//  yyyb
//
//  Created by admin on 2016/12/13.
//  Copyright © 2016年 norwaya. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON
import HandyJSON
import Alamofire
//import AFNetworking


class TabBarCustom: UITabBarController {
    var context:NSManagedObjectContext!
    
    let url = "http://\(Contact.getUrl())/jcxxsj.do"
//    let url = "http://192.168.0.173:8084/jcxxsj.do"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        navigationController?.isToolbarHidden = true
        let app = UIApplication.shared.delegate as! AppDelegate
        context = app.persistentContainer.viewContext
        
        initItemBar()
//        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "上传", style: UIBarButtonItemStyle.done, target: self, action: #selector(upload(sender:)))
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        if httpRequest != nil{
            httpRequest?.cancel()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var btnUpload:UIBarButtonItem!
    func initItemBar(){

         btnUpload = UIBarButtonItem.init(title: "上传", style: UIBarButtonItemStyle.done, target: self, action: #selector(upload(sender:)))
  
        self.navigationItem.rightBarButtonItems = [(navigationController?.editButtonItem)!,btnUpload]
            navigationItem.rightBarButtonItem?.title = "编辑"
        //        navigationController.
        
    }
    var httpRequest:Request?
    func upload(sender:UITabBarItem){
        if (httpRequest != nil){
            httpRequest?.cancel()
        }
        switch index{
        case 0:
            if(checkUploadAble(name: "Rbxx")){
                uploadRbxx()
            }
        case 1:
            if(checkUploadAble(name: "Kbxx")){
                uploadKbxx()
            }
        default:
            print("index is error")
        }
        
    }
    //"Rbxx" or "Kbxx"
    func checkUploadAble(name:String) -> Bool{
        let result  = try! context.fetch(NSFetchRequest<NSFetchRequestResult>.init(entityName: name))
        return result.count > 0
    }
    func UTF8ToGB2312(str: String) -> (NSData?, UInt) {
        let enc = CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.GB_18030_2000.rawValue))
        
        let data = str.data(using: String.Encoding(rawValue: enc), allowLossyConversion: false)
        
        return (data as NSData?, enc)
    }
    
    func uploadKbxx(){
        //判断是否有数据
        
        
        
        
        
        let info = getUserInfo()
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type":"application/json; charset=utf-8"
        ]
        
        let utfToGbk = UTF8ToGB2312(str: getKbxxStr())
        let gbkStr = String.init(data: utfToGbk.0 as! Data, encoding: String.Encoding(rawValue: utfToGbk.1))
        
        let parameters: Parameters =
            [
                "m":"getJcxx",
                "username": info.name,
                "unitId": info.unitid,
                "jsonData":gbkStr!,
                "imei":""
        ]
        
        //        Alamofire.request("http://192.168.1.109:8080/LH/update",method:.get,parameters: parameters)
        //            .response { response in
        //                                print("Request: \(response.request)")
        //                                print("Response: \(response.response)")
        //                                print("Error: \(response.error)")
        //                                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
        //                                    print("Data: \(utf8Text)")
        //                                }
        //                            }
        //            .responseJSON{ response in
        //               print(JSON.init(response.result.values))
        //        }
        //        var encoding = JSONEncoding.default
        
        
        print("http://192.168.20.50:8090/jcxxsj.do?m=getJcxx&username=\(info.name)&unitId=\(info.unitid)&jsonData=\(getKbxxStr())")
        
        
        
        httpRequest =  Alamofire.request(url,method:.get,parameters:parameters,headers:headers)
            //            .response { response in
            //                print("Request: \(response.request)")
            //                print("Response: \(response.response)")
            //                print("Error: \(response.error)")
            //
            //                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
            //                    print("Data: \(utf8Text)")
            //                }
            //            }
            .responseJSON{
                response in
                let json = JSON.init(response.result.value)
                print(json)
                let code = json["code"] ?? -1
                if code == 0{
                    
                    self.removeKbxx()
                    self.showAlertController(title: "提示", msg: "上报成功！", ok: "确定")
                }else{
                    self.showAlertController(title: "提示", msg: "上报失败,请检查vpn、网络是否连接", ok: "确定")
                }
                //                print("response value:\(response.result.value)")
        }
        //
        //print("--------------------")
        //print(httpRequest?.request?.urlRequest?.description)
        
        

    }
    func removeKbxx(){
        let result  = try! context.fetch(NSFetchRequest<NSFetchRequestResult>.init(entityName: "Kbxx"))
        for item in result{
            try! context.delete(item as! NSManagedObject)
            
        }
        try? context.save()
        
    }
    func removeRbxx(){
        let result  = try! context.fetch(NSFetchRequest<NSFetchRequestResult>.init(entityName: "Rbxx"))
        for item in result{
            try! context.delete(item as! NSManagedObject)
            
        }
        try? context.save()
        
    }
    func showAlertController(title: String,msg: String,ok: String){
        let alertController = UIAlertController(title:title, message:msg  , preferredStyle: UIAlertControllerStyle.alert)
        
        
        //        let cancelAction = UIAlertAction(title:cancel, style: UIAlertActionStyle.cancel, handler: nil)
        
        let okAction = UIAlertAction(title:ok, style: UIAlertActionStyle.default, handler: nil)
        
        //        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated:true, completion: nil)
    }

    
    
    func getKbxxStr() -> String{
        let jcxx = Jcxx.init()
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Kbxx")
        request.predicate = NSPredicate.init(format: "isupload = false")
        let result = try? context.fetch(request) as! [Kbxx] as Array
        for kbxx in result! {
    
           
            //                for pic in (rbxx.pics?.allObjects)!{
            //                fjsc.append(pic as! String)
            //            }
            let format = DateFormatter.init()
            format.dateFormat = "yyyyMMddHHmmss"
            let currentTime = format.string(from: Date())
            format.dateFormat = "yyyy-MM-dd"
            let currentTime2 = format.string(from: Date())
            let bgbh = String.init(format: "%@%@", randomSmallCaseString(length: 32),currentTime)
            print(bgbh)
            
            jcxx.appendKbxx(kb: structKbxx.init(fxdd: kbxx.fxdd ?? "", fxsj: currentTime2, jd: kbxx.jd ?? "", wd: kbxx.wd ?? "", wzid: kbxx.wzid ?? "", zqtz: kbxx.zqtz ?? "", zqsl: kbxx.zqsl ?? "", ycsl: kbxx.ycsl ?? "", swsl: kbxx.swsl ?? "", zzms: kbxx.zzms ?? "", cbjl: kbxx.cbjl ?? "", cbjlqt: "", xccl: kbxx.xccl ?? "", ycdwcl: kbxx.ycdwcl ?? "", lrsj: currentTime, ssbm: kbxx.ssbm ?? "", sjtz: String(format:"%02d",Int.init(kbxx.sjtz ?? "1")!),bgbh:bgbh))
        }
        //        if let prettifyJSON = JSONSerializer.serialize(model: jcxx).toPrettifyJSON() {
        //            print("prettify json string: ", prettifyJSON)
        //        }
        
        
        let json =   JSONSerializer.serialize(model: jcxx).toJSON()
        //        print("json ->%@",json)
        return (json)! 
    }

    
    
    
    //32 位随机数
    
    func randomSmallCaseString(length: Int) -> String {
        var output = ""
        for _ in 0..<length {
            let randomNumber = arc4random() % 26 + 97
            let randomChar = Character(UnicodeScalar(randomNumber)!)
            output.append(randomChar)
        }
        return output
    }
    
    func uploadRbxx(){
        let info = getUserInfo()
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type":"application/json; charset=utf-8"
        ]
        
        let utfToGbk = UTF8ToGB2312(str: getRbxxStr())
        let gbkStr = String.init(data: utfToGbk.0 as! Data, encoding: String.Encoding(rawValue: utfToGbk.1))
        
        
        
        let parameters: Parameters =
            [
                "m":"getJcxx",
                "username": info.name,
                "unitId": info.unitid,
                "jsonData":getRbxxStr(),
                "imei":""
        ]
        
        //        if let j = JSONSerializer.serializeToJSON(object: parameters){
        //            print()
        //        }
        
        
        
        
        
        
        //        Alamofire.request("http://192.168.1.109:8080/LH/update",method:.get,parameters: parameters)
        //            .response { response in
        //                                print("Request: \(response.request)")
        //                                print("Response: \(response.response)")
        //                                print("Error: \(response.error)")
        //                                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
        //                                    print("Data: \(utf8Text)")
        //                                }
        //                            }
        //            .responseJSON{ response in
        //               print(JSON.init(response.result.values))
        //        }
        //        var encoding = JSONEncoding.default
        
        
        //print("http://192.168.20.50:8090/jcxxsj.do?m=getJcxx&username=\(info.name)&unitId=\(info.unitid)&jsonData=\(getRbxxStr())")
        
        
        
       httpRequest = Alamofire.request(url,method:.get,parameters:parameters,headers:headers)
            .responseJSON{
                response in
                let json = JSON.init(response.result.value)
                print(json)
                let code = json["code"] ?? -1
                if code == 0{
                    
                    self.removeRbxx()
                    self.showAlertController(title: "提示", msg: "上报成功！", ok: "确定")
                }else{
                    self.showAlertController(title: "提示", msg: "上报失败,请检查vpn、网络是否连接", ok: "确定")
                }
        }
                    .response { response in
                                        print("Request: \(response.request)")
                                        print("Response: \(response.response)")
                                        print("Error: \(response.error)")
                                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                        print("Data: \(utf8Text)")
                                        }
                                    }
        print(httpRequest?.request?.description)
        
        

    }
    
    
    func getUserInfo() -> (name:String,unitid:String){
        let ud = UserDefaults.standard
        let yhm = ud.string(forKey: "currentUserId")
        if  (yhm == nil) {
            return ("","")
        }
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "User")
        request.predicate = NSPredicate.init(format: " yhm CONTAINS %@", yhm!)
        let result = try? context.fetch(request) as! [User] as Array
        return (yhm!,(result?[0].ssbm)!)
    }
    
    
    
    func getRbxxStr() -> String{
        let jcxx = Jcxx.init()
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Rbxx")
        request.predicate = NSPredicate.init(format: "isupload = false")
        let result = try? context.fetch(request) as! [Rbxx] as Array
        NSLog("count num is \(result?.count)")
        for rbxx in result! {
            var fjsc:Array<String> = []
            let set = rbxx.pics
            print("set is \(set)")
            let enu:NSEnumerator = set!.objectEnumerator()
            print("start to set")
            var pics:Set<Pic> = rbxx.pics as! Set<Pic>
            for pic in pics {
                
                //fjsc.append(pic.images!)
            }
//                for pic in (rbxx.pics?.allObjects)!{
//                fjsc.append(pic as! String)
//            }
            let format = DateFormatter.init()
            format.dateFormat = "yyyyMMddHHmmss"
            let currentTime = format.string(from: Date())
            
//            let bgbh = String.init(format: "rb%@%@%@", rbxx.wzdm!,UserDefaults.standard.string(forKey: "currentUserIdId")!,currentTime)
            let bgbh = String.init(format: "%@%@", randomSmallCaseString(length: 32),currentTime)
//            "rb\(UserDefaults.standard.string(forKey: "currentUserIdId")!)\()"
            print(bgbh)
            print("sjtz ---->\(rbxx.sjtz)")
            jcxx.appendRbxx(rb: structRbxx.init( ssbm: rbxx.ssbm ?? "", jd: String.init(rbxx.jd) ?? "", wd: String.init(rbxx.wd) ?? "", wzdm: rbxx.wzdm ?? "", lrry: rbxx.lrry ?? "", zqsl: rbxx.zqsl ?? "", lrsj: currentTime, sjtz: String(format:"%02d",Int.init(rbxx.sjtz ?? "1")!),fjsc:fjsc,bgbh: bgbh))
        }
        let jwdRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Jwd")
        let jwdResult = try? context.fetch(jwdRequest) as! [Jwd] as Array
        for jwd in jwdResult!{
            jcxx.appendXjgj(jwd: structXjgj.init(jd: jwd.jd ?? "", wd: jwd.wd ?? "", xjsj: jwd.xjsj ?? ""))
        }

        
        let json =   JSONSerializer.serialize(model: jcxx).toJSON()
        print("json ->%@",json)
        return (json)!
    }
   
    
    var editingModel:Bool = true
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editingModel, animated: animated)
        print("edit style is \(editing)")
        
        if self.editingModel{
            print("come in")
            btnUpload.isEnabled = false
            print("count->")
            let count = self.viewControllers?.count
            print("view controllers count is \(count)")
            switch index{
            case 0:
                let viewcontroller = self.viewControllers?[index] as! RbxxViewController
                
                //            print("\() is selected")
                viewcontroller.tableView.isEditing = true
                self.tabBar.items?[1].isEnabled = false
            case 1:
                let viewcontroller = self.viewControllers?[index] as! KbxxViewController
                
                //            print("\() is selected")
                viewcontroller.tableView.isEditing = true
                self.tabBar.items?[0].isEnabled = false
            default:
                NSLog("switch error")
            }
            navigationItem.rightBarButtonItems?[0].title = "完成"
            navigationItem.hidesBackButton = true
        
            
        }else{
            switch index{
            case 0:
                let viewcontroller = self.viewControllers?[index] as! RbxxViewController
                
                //            print("\() is selected")
                viewcontroller.tableView.isEditing = false
                self.tabBar.items?[0].isEnabled = true
                self.tabBar.items?[1].isEnabled = true
            case 1:
                let viewcontroller = self.viewControllers?[index] as! KbxxViewController
                
                //            print("\() is selected")
                viewcontroller.tableView.isEditing = false
                self.tabBar.items?[0].isEnabled = true
                self.tabBar.items?[1].isEnabled = true
            default:
                NSLog("switch error")
            }

            btnUpload.isEnabled = true
            navigationItem.rightBarButtonItems?[0].title = "编辑"
            navigationItem.hidesBackButton = false
            self.navigationController?.toolbar.isHidden = false
        }
        editingModel = !editingModel
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    var index:Int = 0
    
}
extension TabBarCustom{
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        let itemIndex = tabBar.items?.index(of: item) ?? -1
        switch itemIndex{
        case 0:
            if(index != itemIndex){
                index = itemIndex
                
            }
        case 1:
            if(index != itemIndex){
                index = itemIndex
            }
        default:
            NSLog("switch error ")
        }
    }
//    tabbar
}
struct JSONStringArrayEncoding: ParameterEncoding {
    private let array: [String]
    
    init(array: [String]) {
        self.array = array
    }
    
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = urlRequest.urlRequest
        
        let data = try JSONSerialization.data(withJSONObject: array, options: [])
        
        if urlRequest?.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest?.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        urlRequest?.httpBody = data
//        urlRequest.httpBody = query(parameters).data(using: .utf8, allowLossyConversion: false)
        return urlRequest!
    }
}
