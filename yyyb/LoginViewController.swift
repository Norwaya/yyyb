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

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var rememberPassword: UISegmentedControl!
    
    var currentUserId: String! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.text = "M6190010010M01"
        password.text = "123456"
        navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        if !checkAction(){
            return
        }
        let parameters: Parameters =
            [
                "m":"login",
                "username": "\((self.username.text)!)",
                "password": "\((self.password.text)!)"
            ]
        
        Alamofire.request("http://192.168.20.50:8090/login.do",method: .get,parameters: parameters)
            .responseData{
                responds in
                switch responds.result{
                case .failure:
                    print("fail")
                case .success:
                    print("success")
                }
            }
            .responseJSON{
                response in
            print(response.result.value)
            let json = JSON.init(response.result.value ?? "{\"code\" =  -1}")
            let code = (json["code"].int)!
            switch  code{
            case 0:
                //save user and update login time
//                let user = json["pagedList"]["list"][0]
//                self.saveUserAndUpdateTime(userInDic: json["pagedList"]["list"][0])
                if self.saveUserAndUpdateTime(userInDic: json["pagedList"]["list"][0]){
                   
                    let ud = UserDefaults.standard
                    ud.set(self.currentUserId, forKey: "currentUserId")
                    
                    
                    ud.synchronize()
                    

                    
                        
                    
                    self.navigationController?.popToRootViewController(animated: true) //return to root controller
                    
                }
            case 1:
                print("fail")
            case -1:
                print("error")
            default:
                print("default")
            }
//            let user = json["pagedList"]["list"][0]["ssbm"]
//            print(user)
        }
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
        }else {
            let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
            //Get the ManagedObject
            
            user = NSManagedObject(entity: entity!, insertInto: context) as! User
            user.yhm = userInDic["yhm"].description
            user.csny = userInDic["csny"].description
            user.czzt = userInDic["czzt"].description
            user.id = userInDic["id"].description
            
            
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
