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

    @IBOutlet weak var dwmc: UILabel!
    @IBOutlet weak var fxdd: UILabel!
    @IBOutlet weak var pic: UILabel!
    @IBOutlet weak var sjtz: UILabel!
    @IBOutlet weak var zqsl: UILabel!
    
    
    var id:String!
    var wzdm:String!

    var context:NSManagedObjectContext!
    var detail:RbxxDetail?
    
    var httpRequest:Request?
        let url = "http://\(Contact.getUrl())/sbjl.do"
//    let url = "http://192.168.0.173:8084/sbjl.do"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let app = UIApplication.shared.delegate as! AppDelegate
        context = app.persistentContainer.viewContext
        requestHttp()
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        if(httpRequest != nil){
            httpRequest?.cancel()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func requestHttp(){
        if(httpRequest != nil){
            httpRequest?.cancel()
        }
        
        let info = getUserInfo()
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type":"application/json; charset=utf-8"
        ]
        let parameters: Parameters =
            [
                "m":"getZcwzContent",
                "id": id,
                "dwid": wzdm,
                "unitId": info.unitid,
                "username":info.userid
            ]
        
                print(parameters)
        
        httpRequest = Alamofire.request(url,parameters: parameters)
            .response { response in
                print("Request: \(response.request)")
                print("Response: \(response.response)")
                print("Error: \(response.error)")
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)")
                }
            }
            .responseJSON{ response in
                let json = JSON.init(response.result.value)
                let wzdm = json["wzdm"].string
                let sjtz = json["sjtz"].string
                let lrsj = json["lrsj"].string
                let jd = json["jd"].string
                let wd = json["wd"].string
                let zqsl = json["zqsl"].string
                self.detail = RbxxDetail.init(wzdm: wzdm ?? "", sjtz: sjtz ?? "", jd: jd ?? "", wd: wd ?? "", zqsl: zqsl ?? "" ,lrsj:lrsj ?? "")
                self.freshView()
        }
        print(httpRequest?.request?.description)
        
        
    }
    var sjtzArray = ["森林","草甸","荒漠","高山冻原","草甸",
                     "沼泽","湖泊","河流","河口","滩涂","浅海湿地","珊瑚礁","人工湿地","水田","旱地"]
    func freshView(){
        DispatchQueue.main.async(execute: {
            self.dwmc.text = self.getWzmc(id: (self.detail?.wzdm)!)
            self.fxdd.text = String.init(format: "%@  %@", self.detail?.jd ?? "",self.detail?.wd ?? "")
            self.zqsl.text = self.detail?.zqsl ?? ""
            let index:Int = Int.init(self.detail?.sjtz ?? "1")!
            self.sjtz.text = self.sjtzArray[index - 1]
            self.pic.text = ""
        })
    }
    func getWzmc(id:String) -> String{
        let request1 = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Yydm")
        request1.predicate = NSPredicate.init(format: " id CONTAINS %@", id)
        let gang = try? context.fetch(request1) as! [Yydm] as Array
        return gang![0].yymc ?? "null"
    }
    
    func getUserInfo() -> (userid:String,unitid:String){
        let ud = UserDefaults.standard
        let id = ud.string(forKey: "currentUserIdId")
        if  (id == nil) {
            return ("","")
        }
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "User")
        request.predicate = NSPredicate.init(format: " id CONTAINS %@", id!)
        let result = try? context.fetch(request) as! [User] as Array
        return (id!,(result?[0].ssbm)!)
    }

}
struct RbxxDetail{
//    {
//    "zqsl" : "6",
//    "ssbm" : "111114824a5c4e888800140000ff0295",
//    "fjsc" : [
//    
//    ],
//    "id" : "4028802d5919f63601591a59f8c50017",
//    "bgbh" : "RBG6190010010201612201014",
//    "lrry" : ",",
//    "jd" : "116.42",
//    "wzdm" : "MA21011027000100",
//    "sjtz" : "00",
//    "wd" : "39.957",
//    "lrsj" : "2016-12-20"
//    }
    var wzdm:String?
    var sjtz:String?
    var jd:String?
    var wd:String?
    var zqsl:String?
    var lrsj:String?
    init(wzdm:String,sjtz:String,jd:String,wd:String,zqsl:String,lrsj:String){
        self.wzdm = wzdm
        self.sjtz = sjtz
        self.jd = jd
        self.wd = wd
        self.zqsl = zqsl
        self.lrsj = lrsj
    }
}
