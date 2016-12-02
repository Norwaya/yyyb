//
//  TableViewController.swift
//  yyyb
//
//  Created by admin on 2016/11/19.
//  Copyright © 2016年 norwaya. All rights reserved.
//

import UIKit
import CoreData
class TableViewController: UITableViewController {

   
    var sections: Array<String>!
    var titles: Array<Array<String>>!
    var images: Array<Array<String>>!
    var classNames: Array<Array<UIViewController.Type>>!
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isToolbarHidden = true
        initResource()
    }
    
    
    var isFirst = true
    func initResource(){
        if !isFirst{
            return
        }
        isFirst = false
        
        let app = UIApplication.shared.delegate as! AppDelegate
//        app.domain
        
        var managerObjectContext:NSManagedObjectContext
        if #available(iOS 10.0, *) {
            managerObjectContext = app.persistentContainer.viewContext
        } else {
            managerObjectContext =  app.coreData.context
        }
        
        let array =  ["Aclass","Aorder","Afamily","Agenus","Aspecies"]
        let names = ["鸟纲","雀形目","燕科","燕属","金腰燕"]

        
        
        let entity1 = NSEntityDescription.entity(forEntityName: array[0], in: managerObjectContext)
        //Get the ManagedObject
        
        var clazz1 = NSManagedObject(entity: entity1!, insertInto: managerObjectContext) as! Aclass
        clazz1.name = names[0]
       
        var entity2 = NSEntityDescription.entity(forEntityName: array[1], in: managerObjectContext)
        //Get the ManagedObject
        
        var clazz2 = NSManagedObject(entity: entity2!, insertInto: managerObjectContext) as! Aorder
        clazz2.name = names[1]
        
        var entity3 = NSEntityDescription.entity(forEntityName: array[2], in: managerObjectContext)
        //Get the ManagedObject
        
        var clazz3 = NSManagedObject(entity: entity3!, insertInto: managerObjectContext) as! Afamily
        clazz3.name = names[2]
        var entity4 = NSEntityDescription.entity(forEntityName: array[3], in: managerObjectContext)
        //Get the ManagedObject
        
        var clazz4 = NSManagedObject(entity: entity4!, insertInto: managerObjectContext) as! Agenus
        clazz4.name = names[3]
        var entity5 = NSEntityDescription.entity(forEntityName: array[4], in: managerObjectContext)
        //Get the ManagedObject
        
        var clazz5 = NSManagedObject(entity: entity5!, insertInto: managerObjectContext) as! Aspecies
        clazz5.name = names[4]
        clazz5.ingenus = clazz4
        clazz5.latinName = "Hirundo daurica Linnaues"
        clazz5.distribution = "分布于新疆以及西藏北部意外的广大地区"
        clazz5.habit = ""
        clazz5.distribution = "全长 170 - 185 mm ..."
        try? managerObjectContext.save()
    
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "首页"
        
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
       
      
        
        
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        let title = titles[indexPath.section][indexPath.row]
        var vcInstance: UIViewController?
        switch(indexPath.row){
            case 0:
                vcInstance = self.storyboard?.instantiateViewController(withIdentifier: "start")
            case 1:
                vcInstance = self.storyboard?.instantiateViewController(withIdentifier: "query")
            case 5:
                vcInstance = self.storyboard?.instantiateViewController(withIdentifier: "notice")
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
            return "功能"
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

