//
//  LoginViewController.swift
//  yyyb
//
//  Created by admin on 2016/12/7.
//  Copyright © 2016年 norwaya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class LoginViewController: UIViewController {

    let url = "http://192.168.20.50:8090/login.do"
//    let url = "http://192.168.0.173:8084/login.do"
    var httpRequest:Request?
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    var currentUserId: String! = nil
    var currentUserIdId:String! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        username.text = ""
        password.text = ""
        navigationController?.isNavigationBarHidden = true
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
    
    @IBAction func btnLogin(_ sender: UIButton) {
        if httpRequest != nil{
            httpRequest?.cancel()
        }
        if !checkAction(){
            return
        }
        let parameters: Parameters =
            [
                "m":"login",
                "username": "\((self.username.text)!)",
                "password": "\((self.password.text)!)"
            ]
        
       httpRequest =  Alamofire.request(url,method: .get,parameters: parameters)
            
            .responseJSON{
                response in
                if ((response.result.value) == nil){
                    self.showAlertController(title: "提示", msg: "检查vpn和网络连接", ok: "确定")
                    return
                }
            let json = JSON.init(response.result.value )
            let code = (json["code"].int)!
            print(response.result.value)
            switch  code{
            case 0:
                //save user and update login time
//                let user = json["pagedList"]["list"][0]
//                self.saveUserAndUpdateTime(userInDic: json["pagedList"]["list"][0])
                if self.saveUserAndUpdateTime(userInDic: json["pagedList"]["list"][0]){
                   
                    let ud = UserDefaults.standard
                    ud.set(self.currentUserId, forKey: "currentUserId")
                    ud.set(self.currentUserIdId,forKey:"currentUserIdId")
                    ud.synchronize()
                    self.navigationController?.popToRootViewController(animated: true) //return to root controller
                    
                }
            case 1:
                self.showAlertController(title: "提示", msg: "账号密码错误", ok: "确定")
            case -1:
                self.showAlertController(title: "提示", msg: "账号密码错误", ok: "确定")
            default:
                print("default")
            }
//            let user = json["pagedList"]["list"][0]["ssbm"]
//            print(user)
        }
        print(httpRequest?.request?.description)
    }
    
    //dialog
    func showAlertController(title: String,msg: String,ok: String){
        let alertController = UIAlertController(title:title, message:msg  , preferredStyle: UIAlertControllerStyle.alert)
        
        
        //        let cancelAction = UIAlertAction(title:cancel, style: UIAlertActionStyle.cancel, handler: nil)
        
        let okAction = UIAlertAction(title:ok, style: UIAlertActionStyle.default, handler: nil)
        
        //        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated:true, completion: nil)
    }
    // check input is ok
    func checkAction() -> Bool{
        let username = self.username.text
        let passwrod = self.password.text
        if (username == nil) && (username! == "") {
            return false
        }
        if (passwrod == nil) && (passwrod! == "") {
            return false
        }
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func saveUserAndUpdateTime(userInDic: JSON) -> Bool{
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "User")
        request.predicate = NSPredicate.init(format: " yhm <> %@", self.username!)
        do {
        let result  =  try? context.fetch(request) as! [User] as Array
       
        
        var user: User!
        if (result?.count)! > 0{
            user = result?[0]
            user.yhm = userInDic["yhm"].description
            user.xm = userInDic["xm"].description
            user.csny = userInDic["csny"].description
            user.czzt = userInDic["czzt"].description
            user.id = userInDic["id"].description
            user.llry = userInDic["llry"].description
            user.llsj = userInDic["llsj"].description
            user.mm = userInDic["mm"].description
            user.sj = userInDic["sj"].description
            user.ssbm = userInDic["ssbm"].description
            user.xb = userInDic["xb"].description
            user.xl = userInDic["xl"].description
            user.zc = userInDic["zc"].description
            user.zfzb = userInDic["zfzb"].description
            user.zjz = userInDic["zjz"].description
            user.leastlogintime = currentStringDate()
        }else {
            let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
            //Get the ManagedObject
            
            user = NSManagedObject(entity: entity!, insertInto: context) as! User
            user.yhm = userInDic["yhm"].description
            user.csny = userInDic["csny"].description
            user.czzt = userInDic["czzt"].description
            user.id = userInDic["id"].description
            
            user.xm = userInDic["xm"].description
            user.leastlogintime = currentStringDate()
            user.llry = userInDic["llry"].description
            user.llsj = userInDic["llsj"].description
            user.mm = userInDic["mm"].description
            user.sj = userInDic["sj"].description
            user.ssbm = userInDic["ssbm"].description
            user.xb = userInDic["xb"].description
            user.xl = userInDic["xl"].description
            user.zc = userInDic["zc"].description
            user.zfzb = userInDic["zfzb"].description
            user.zjz = userInDic["zjz"].description
        }
        
        
        //current user id
        self.currentUserId = userInDic["yhm"].description
        self.currentUserIdId = userInDic["id"].description
            try context.save()
        } catch let err as NSError {
            NSLog("error: %@", err.description)
            return false
        }
        
        
        return true
    }
    func currentStringDate() -> String{
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH-mm-ss"
//        let timeZone = NSTimeZone.system
//        let interval = timeZone.secondsFromGMT()
//        let currentDate = Date().addingTimeInterval(TimeInterval(interval))
        let currentDate = Date()
        return format.string(from: currentDate)
    }
}
