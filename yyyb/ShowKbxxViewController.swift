//
//  ShowKbxxViewController.swift
//  yyyb
//
//  Created by admin on 2016/12/17.
//  Copyright © 2016年 norwaya. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON
import Alamofire
import DGElasticPullToRefresh
class ShowKbxxViewController: UIViewController {
    var time:String!
    var array:Array<structKbResult> = []
    var context:NSManagedObjectContext!
    
   
    var httpRequest:Request?
        let url = "http://192.168.20.50:8090/sbjl.do"
//    let url = "http://192.168.0.173:8084/sbjl.do"
    var pageIndex:Int = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let app = UIApplication.shared.delegate as! AppDelegate
        context = app.persistentContainer.viewContext

        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0)
        
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            
            DispatchQueue.main.async {
                self?.requestHttp()
//                self?.tableView.dg_stopLoading()
                
            }
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)

        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        requestHttp()
    }
    override func viewDidDisappear(_ animated: Bool) {
        print("kbxx --- view did disappear")
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("httprequest\(self.httpRequest)\n ")
        
        if(httpRequest != nil){
            httpRequest?.cancel()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        if(self.tableView != nil){
            tableView.dg_removePullToRefresh()
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func requestHttp(){
//        if(pageIndex%10 != 0){
//            self.tableView.dg_stopLoading()
//            return
//        }
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
                "m":"clickJcjlYc",
                "pageNo":"0",
                "rq": time,
                "unitId": info.unitid
            ]
        
                print(parameters)
        
       httpRequest =  Alamofire.request(url,parameters: parameters)
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
                print(json)
                if (json["code"] == 0){
                    self.array.removeAll()
                    self.addArray(json: json["pagedList"]["list"].array)
                }
                self.tableView.dg_stopLoading()
        }
        print(httpRequest?.request?.description)
        
    }
    func addArray(json:[JSON]?){
        print(json)
        
        for item in json!{
            let result:Dictionary = item.dictionary!
            //            print(result["wzdm"])
            array.append(structKbResult.init(id:result["id"]?.string ?? "",lrsj: result["lrsj"]?.string ?? "",wzid:result["wzid"]?.string ?? ""))
        }
        DispatchQueue.main.async(execute: {
            self.pageIndex = self.array.count
            self.tableView.reloadData()
        })
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
    
    func getDate() -> String{
        let format:DateFormatter = DateFormatter.init()
        format.dateFormat = "yyyy-MM-dd"
        let date = format.date(from: time!)
        format.dateFormat = "yyyyMMdd"
        return format.string(from: date!)
    }
   
}
extension ShowKbxxViewController: UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        print("cell filled \(indexPath.row)")
        let label = cell.viewWithTag(101) as! UILabel
        label.text = getWzmc(id: array[indexPath.row].wzid!)
        
        return cell
    }
    func getWzmc(id:String) -> String{
        let request1 = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Yydm")
        request1.predicate = NSPredicate.init(format: " id CONTAINS %@", id)
        let gang = try? context.fetch(request1) as! [Yydm] as Array
        return gang![0].yymc ?? "null"
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "kbxxdetail") as! ShowKbxxDetailViewController
        vc.id = array[indexPath.row].id
        vc.wzdm = array[indexPath.row].wzid
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
struct structKbResult{
    var id:String?
    var lrsj:String?
    var wzid:String?
    init(id:String,lrsj:String,wzid:String) {
        self.id = id
        self.lrsj = lrsj
        self.wzid = wzid
    }
}
