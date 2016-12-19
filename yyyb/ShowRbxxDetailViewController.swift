//
//  ShowRbxxDetailViewController.swift
//  yyyb
//
//  Created by admin on 2016/12/17.
//  Copyright © 2016年 norwaya. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON
class ShowRbxxDetailViewController: UIViewController {

    
    
    var id:String!
    var wzdm:String!

    var context:NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        let app = UIApplication.shared.delegate as! AppDelegate
        context = app.persistentContainer.viewContext
        requestHttp()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func requestHttp(){
       
        
        let info = getUserInfo()
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type":"application/json; charset=utf-8"
        ]
        let parameters: Parameters =
            [
                "m":"getZcwzContent",
                "id": id,
                "dwid": info.unitid,
                "wzdm": wzdm
            ]
        
                print(parameters)
        
        Alamofire.request("http://192.168.20.50:8090/sbjl.do",parameters: parameters)
            .responseJSON{ response in
                let json = JSON.init(response.result.value)
                print(json)
                
        }
        
    }
    func getUserInfo() -> (name:String,unitid:String){
        let ud = UserDefaults.standard
        let yhm = ud.string(forKey: "currentUserId")
        if  (yhm == nil) {
            return ("","")
        }
        let result = try? context.fetch(NSFetchRequest<NSFetchRequestResult>.init(entityName: "User")) as! [User] as Array
        return (yhm!,(result?[0].ssbm)!)
    }

}
