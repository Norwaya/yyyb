//
//  ShowKbxxDetailViewController.swift
//  yyyb
//
//  Created by admin on 2016/12/20.
//  Copyright © 2016年 norwaya. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON


class ShowKbxxDetailViewController: UIViewController {
    var id:String!
    var wzdm:String!
    @IBOutlet weak var scrollView:UIScrollView!
     @IBOutlet weak var dwmc:UILabel!
     @IBOutlet weak var fxdd:UILabel!
     @IBOutlet weak var fxwz:UILabel!
     @IBOutlet weak var zqtz:UILabel!
     @IBOutlet weak var sjtz:UILabel!
     @IBOutlet weak var zqsl:UILabel!
     @IBOutlet weak var ycsl:UILabel!
     @IBOutlet weak var swsl:UILabel!
     @IBOutlet weak var zzms:UILabel!
     @IBOutlet weak var pic:UILabel!
     @IBOutlet weak var cbjl:UILabel!
     @IBOutlet weak var cbljqt:UILabel!
     @IBOutlet weak var xccl:UILabel!
     @IBOutlet weak var yccl:UILabel!
    
    var detail:KbxxDetail?
    
    var httpRequest:Request?
    let url = "http://\(Contact.getUrl())/sbjl.do"
    //    let url = "http://192.168.0.173:8084/sbjl.do"
    
    
    var context:NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let app = UIApplication.shared.delegate as! AppDelegate
        context = app.persistentContainer.viewContext
        
        request()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func request(){
        if(httpRequest != nil){
            httpRequest?.cancel()
        }
        
//        let info = getUserInfo()
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type":"application/json; charset=utf-8"
        ]
        let parameters: Parameters =
            [
                "m":"getYcwzContent",
                "id": id,
                "dwid": wzdm
        ]
        
        print(parameters)
        
        httpRequest = Alamofire.request(url,parameters: parameters)
//            .response { response in
//                print("Request: \(response.request)")
//                print("Response: \(response.response)")
//                print("Error: \(response.error)")
//                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                    print("Data: \(utf8Text)")
//                }
//            }
            .responseJSON{ response in
                let json = JSON.init(response.result.value)
                print(json)
                let wzid = json["wzid"].string
                let fxdd = json["fxdd"].string
                let jd = json["jd"].double
                let wd = json["wd"].double
                print("\(jd)-----> \(wd)")
                let zqtz = json["zqtz"].string
                let sjtzCode = json["sjtz"].string
                let zqsl = json["zqsl"].string
                let ycsl = json["ycsl"].string
                let swsl  = json["swsl"].string
                let zzms = json["zzms"].string
                let pic = json["fjsc"].string
                let cbjlCode = json["cbjl"].string
//                let cbjlqt = json["cbjlqt"].string
                let xcclqk = json["xccl"].string
                let ycclqk = json["ycdwcl"].string
                
                
                self.dwmc.text = self.getWzmc(id: wzid!)
                self.fxdd.text = fxdd
                self.fxwz.text = String.init(format: "%9.6f  %9.6f", jd ?? 0.0,wd ?? 0.0)
                self.zqtz.text = zqtz
                
                var array = ["","森林","草甸","荒漠","高山冻原","草甸",
                             "沼泽","湖泊","河流","河口","滩涂","浅海湿地","珊瑚礁","人工湿地","水田","旱地",""]
                let sjtzIndex:Int = Int.init(sjtzCode ?? "1")!
                self.sjtz.text = array[sjtzIndex ]
                self.zqsl.text = zqsl
                self.ycsl.text = ycsl
                self.swsl.text = swsl
                self.zzms.text = zzms
                
                var array2 = ["","染病","中毒","人为致死","自然死亡","机械死亡","死因不明","其他",""]
                let cbjlIndex = Int.init(cbjlCode ?? "0")
                self.cbjl.text = array2[cbjlIndex!]
                self.xccl.text = xcclqk
                self.yccl.text = ycclqk
        }
        print(httpRequest?.request?.description)
    }
    func getWzmc(id:String) -> String{
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Yydm")
        request.predicate = NSPredicate.init(format: "id = %@", id)
        let result = try? context.fetch(request) as! [Yydm] as Array
        if (result?.count)! > 0{
            let entity = result?[0]
        return    entity!.yymc!
        
        }
        return ""
    }

}
struct KbxxDetail{
    var dwmc:String?
    var fxdd:String?
    var jd:String?
    var wd:String?
    var zqtz:String?
    var sjtz:String?
    var zqsl:String?
    var ycsl:String?
    var swsl:String?
    var zzms:String?
    var pic:String?
    var cbjl:String?
    var xccl:String?
    var yccl:String?
    init(dwmc:String,fxdd:String,jd:String,wd:String,zqtz:String,sjtz:String,zqsl:String,ycsl:String,swsl:String,zzms:String,pic:String,cbjl:String,xccl:String,yccl:String) {
        self.dwmc = dwmc
        self.fxdd = fxdd
        self.jd = jd
        self.wd = wd
        self.zqtz = zqtz
        self.sjtz = sjtz
        self.zqsl = zqsl
        self.ycsl = ycsl
        self.swsl = swsl
        self.zzms = zzms
        self.cbjl = cbjl
        self.xccl = xccl
        self.yccl = yccl
    }
}
