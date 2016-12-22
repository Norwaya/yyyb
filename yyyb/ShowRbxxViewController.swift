//
//  ShowRbxxViewController.swift
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
class ShowRbxxViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var time:String!
    
    var pageIndex:Int = 0
    var hasMore:Bool = true
    
    var httpRequest:Request?
    let url = "http://192.168.20.50:8090/sbjl.do"
//    let url = "http://192.168.0.173:8084/sbjl.do"
    
    
    var array:Array<RbxxResult> = []
    var context:NSManagedObjectContext!
//    override func loadView() {
//        
//    }
    
    deinit {
//        print("deinit method \(Thread.current)")
//        self.tableView.reloadData()
        tableView.dg_removePullToRefresh()
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("rbtime \(time)")
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
        
                            }
                            }, loadingView: loadingView)
                        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
                        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
        

    }
    override func viewWillAppear(_ animated: Bool) {
        print("rbxx view will appear")
        requestHttp()
    }
    override func viewWillDisappear(_ animated: Bool) {
        if(httpRequest != nil){
            
            httpRequest?.cancel()
          
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        print("rbxx ---  did disappear")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func requestHttp(){
        if(httpRequest != nil){
            httpRequest?.cancel()
        }
        if(pageIndex%10 != 0){
            self.tableView.dg_stopLoading()
            return
        }
        
        
        let info = getUserInfo()
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type":"application/json; charset=utf-8"
        ]
        let parameters: Parameters =
            [
                "m":"clickJcjlZc",
                "pageNo":pageIndex/10,
                "rq": time,
                "unitId": info.unitid
        ]

        
        httpRequest = Alamofire.request(url,parameters: parameters)
        .responseJSON{ response in
            let json = JSON.init(response.result.value)
            print(json)
            if (json["code"] == 0){
                print(json)
                self.addArray(json: json["pagedList"]["list"].array)
            }
            self.tableView.dg_stopLoading()
        }
        print(httpRequest?.request?.description)
        
        
        
    }
    func addArray(json:[JSON]?){
        print(json)
        
        for item in json!{
//            print(itemObj?[index])
//            let item = itemObj?[index]
            let result:Dictionary = item.dictionary!
//            print(result["wzdm"])
            array.append(RbxxResult.init(id: result["id"]?.string ?? "", lrsj: result["lrsj"]?.string ?? "", wzdm: result["wzdm"]?.string ?? ""))
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
        let date = format.date(from: time)
        format.dateFormat = "yyyyMMdd"
        return format.string(from: date!)
    }
}
extension ShowRbxxViewController: UITableViewDataSource,UITableViewDelegate{
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
        label.text = "\(getWzmc(id: array[indexPath.row].wzdm!))\n2016-11-11"
        
        return cell
    }
    func getWzmc(id:String) -> String{
        let request1 = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Yydm")
        request1.predicate = NSPredicate.init(format: " id CONTAINS %@", id)
        let gang = try? context.fetch(request1) as! [Yydm] as Array
        return gang![0].yymc ?? "null"
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "rbdetail") as! ShowRbxxDetailViewController
        vc.id = self.array[indexPath.row].id
        vc.wzdm = self.array[indexPath.row].wzdm
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
struct RbxxResult{
//    {
//    "id" : "ff80808159015319015909f97c1604cf",
//    "lrsj" : "2016-12-17",
//    "wzdm" : "RP03009057000100"
//    }
    var id:String?
    var lrsj:String?
    var wzdm:String?
    init(id:String,lrsj:String,wzdm:String){
        self.id = id
        self.lrsj = lrsj
        self.wzdm = wzdm
    }
}
