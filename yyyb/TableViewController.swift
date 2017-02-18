//
//  TableViewController.swift
//  yyyb
//
//  Created by admin on 2016/11/19.
//  Copyright © 2016年 norwaya. All rights reserved.
//

import UIKit
import CoreData
import  Alamofire
import SwiftyJSON
class TableViewController: UITableViewController {

   
    var sections: Array<String>!
    var titles: Array<Array<String>>!
    var images: Array<Array<String>>!
    var classNames: Array<Array<UIViewController.Type>>!
    
    //检查登录状态
    
    func checkLoginState() -> Bool{
        let app = UIApplication.shared.delegate as! AppDelegate
        let managerObjectContext = app.persistentContainer.viewContext
        let ud = UserDefaults.standard
        let currentUserId = ud.string(forKey: "currentUserId")
        if (currentUserId == nil) {
            NSLog("user id is nil")
            return false
        }
        NSLog("get current user id -> %@",currentUserId!)
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "User")
        print("\(currentUserId!)")
        request.predicate = NSPredicate.init(format: " yhm CONTAINS %@ ", currentUserId!)
        do {
            var result = try? managerObjectContext.fetch(request) as! [User] as Array
            print("result len :\(result?.count)")
            if((result?.count)! > 0){
                let date = result?[0].leastlogintime
                if compDate(nsdate: date!){
                    return true
                }
                //            NSLog("\(date?.compare(currentDate).rawValue)")
            }
            
        } catch let err as NSError {
            NSLog("query sql error: %@", err.description)
        }
        
        return false
    }
    func compDate(nsdate: String) -> Bool{
       
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH-mm-ss"
        let loginDate = format.date(from: nsdate)
        let compDate = Date.init(timeInterval: 60*60*24*30, since: loginDate!)
        print("comdate: \(compDate)")
        
//        let timeZone = NSTimeZone.system
//        let interval = timeZone.secondsFromGMT()
//        let currentDate = Date().addingTimeInterval(TimeInterval(interval))
//        NSTimeZone *timeZone = [[NSTimeZone alloc] init];
//        timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
//        NSTimeInterval interval = [timeZone secondsFromGMT];
//        NSDate *GMTDate = [date dateByAddingTimeInterval:-interval];
//        print(currentDate)
        let r = compDate.compare(Date())
        print(r)
        switch r{
        
        case .orderedDescending:
            return true
        
        default:
            return false
        }
        return false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isToolbarHidden = true
        navigationController?.navigationBar.isHidden = false
        initResource()
    }
    //检查登录状态
    override func viewDidAppear(_ animated: Bool) {
        if !checkLoginState(){
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "login")
            self.navigationController?.pushViewController(vc!, animated: true)
        }

    }
    
    func initResource(){
        let ud = UserDefaults.standard
        let flag = ud.bool(forKey: "hasInitData")
        if flag {
            return
        }
        initYyk()
        initYbk()
        ud.set(true, forKey: "hasInitData")
        ud.synchronize()
        
    }
    func initYyk(){
        
        
        

        let app = UIApplication.shared.delegate as! AppDelegate
        //        app.domain
        
        let managerObjectContext = app.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Yydm", in: managerObjectContext)
        //Get the ManagedObject
        let filePath = Bundle.main.path(forResource: "yydm", ofType: "json")
        do {
            let content = try? String.init(contentsOfFile: filePath!, encoding: String.Encoding.utf8)
            var json :JSON = JSON.null
            if let dataFromString = content?.data(using: .utf8, allowLossyConversion: false) {
                json = JSON(data: dataFromString)
            }
            let array = json.array
            
            
            
            for index in 0 ..< 3577{
                //                DispatchQueue.global().async {
                print("index -> \(index)")
                let yydm = NSManagedObject(entity: entity!, insertInto: managerObjectContext) as! Yydm
                yydm.id = array?[index]["id"].description
                yydm.yymc = array?[index]["yymc"].description
                yydm.ldmc = array?[index]["ldmc"].description
                yydm.fb = array?[index]["fb"].description
                yydm.tmtz = array?[index]["tmtz"].description
                yydm.zp = array?[index]["zp"].description
                yydm.xx = array?[index]["xx"].description
                yydm.sj = array?[index]["sj"].description
                
                managerObjectContext.insert(yydm)
                
            }
            try? managerObjectContext.save()
        } catch  let err as NSError{
            print("error when save data \(err.description)")
        }

    }
    func initYbk(){
        let app = UIApplication.shared.delegate as! AppDelegate
        //        app.domain
        
        let managerObjectContext = app.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Ybdm", in: managerObjectContext)
        //Get the ManagedObject
        let filePath = Bundle.main.path(forResource: "ybdm", ofType: "json")
        
        do {
            let content = try? String.init(contentsOfFile: filePath!, encoding: String.Encoding.utf8)
            var json :JSON = JSON.null
            if let dataFromString = content?.data(using: .utf8, allowLossyConversion: false) {
                json = JSON(data: dataFromString)
            }
            let array = json.array
            
            
            for index in 0 ..< 1673{
                //                DispatchQueue.global().async {
                print("index -> \(index)")
                let ybdm = NSManagedObject(entity: entity!, insertInto: managerObjectContext) as! Ybdm
                ybdm.id = array?[index]["id"].string
                ybdm.ybmc = array?[index]["ybmc"].string
                ybdm.ywmc = array?[index]["ywmc"].string
                ybdm.ybsbm = array?[index]["ybsbm"].string
                ybdm.szsbm = array?[index]["szsbm"].string
                ybdm.ybdm = array?[index]["ybdm"].string
                managerObjectContext.insert(ybdm)
                
            }
            
            
            try? managerObjectContext.save()
            
        } catch  let err as NSError{
            print("error when save data \(err.description)")
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "疫源疫病监测"
        //判断 如果登陆状态 则 往下执行  否则 跳转到登录页面
        
        
        
        initTableData()
        //        initTableView()
    }
    func initTableData() {
        
        let sec1Title = "基本功能"
        let sec1CellTitles = ["监测记录",
                              "信息查询",
                              "疫源库",
                              "疫病库",
                              "应急通讯",
                              "通知公告",
                              "专家库",
                              "使用说明",
                              "设置",
                              "单次定位地图展示",
                              "单次定位不带地图展示",
                              "连续定位",
                              "后台连续定位",
                              "地理围栏"]
        let sec1CellImages = ["icon01",
                              "icon02",
                              "icon03",
                              "icon04",
                              "icon05",
                              "icon06",
                              "icon07",
                              "icon08",
                              "icon08"]
        let sec1ClassNames: Array<UIViewController.Type> =  [StartMonistroViewController.self,
                                                            StartMonistroViewController.self,
                                                            StartMonistroViewController.self,
                                                            StartMonistroViewController.self,
                                                            StartMonistroViewController.self,
                                                               NoticeViewController.self,
                                                            StartMonistroViewController.self,
                                                            SerialLocationViewController.self,
                                                            SingleLocationViewController.self,
                                                            SingleLocationAloneViewController.self,
                                                            SerialLocationViewController.self,
                                                            BackgroundLocationViewController.self]
        
        sections = [sec1Title]
        titles = [sec1CellTitles]
        images = [sec1CellImages]
        classNames = [sec1ClassNames]
    }
    //MARK:- TableViewDelegate
    //**update careful
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       //session  判断
      
        
        
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        let title = titles[indexPath.section][indexPath.row]
        var vcInstance: UIViewController?
        switch(indexPath.row){
            case 0:
                vcInstance = self.storyboard?.instantiateViewController(withIdentifier: "start")
            case 1:
                vcInstance = self.storyboard?.instantiateViewController(withIdentifier: "query")
            case 2:
                vcInstance = self.storyboard?.instantiateViewController(withIdentifier: "yyk")
            case 3:
                vcInstance = self.storyboard?.instantiateViewController(withIdentifier: "ybk")
            case 4:
                vcInstance = self.storyboard?.instantiateViewController(withIdentifier: "communication")
            case 5:
                vcInstance = self.storyboard?.instantiateViewController(withIdentifier: "notice")
            
            case 6:
                vcInstance = self.storyboard?.instantiateViewController(withIdentifier: "expert")
            case 7:
                return
            case 8:
                vcInstance = self.storyboard?.instantiateViewController(withIdentifier: "setting")
            default:
                let vcClass = classNames[indexPath.section][indexPath.row]
                vcInstance = vcClass.init()
        }
        vcInstance!.title = title
        self.navigationController?.pushViewController(vcInstance! , animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return images[section].count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cellIdentifier : String = "mainCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        let iv = cell?.viewWithTag(10) as! UIImageView
        let label = cell?.viewWithTag(9) as! UILabel
        
        iv.image = UIImage(named: images[indexPath.section][indexPath.row])
        label.text = titles[indexPath.section][indexPath.row]
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "疫源疫病移动采集"
        default:
            return ""
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

