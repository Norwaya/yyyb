//
//  SettingTableViewController.swift
//  yyyb
//
//  Created by admin on 2016/11/29.
//  Copyright © 2016年 norwaya. All rights reserved.
//

import UIKit
import CoreData
class SettingTableViewController: UITableViewController {

    let array = ["离线地图","数据更新","关于","更换账号","注销"]
    var cellItems: Array<Array<String>>!
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isToolbarHidden = true
        cellItems = [array]
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //select
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        var vcInstance: UIViewController?
        switch(indexPath.row){
        case 0:
//            vcInstance = self.storyboard?.instantiateViewController(withIdentifier: "start")
            vcInstance = OfflineViewController.init()
            self.navigationController?.pushViewController(vcInstance!, animated: true)
        case 1:
            print(2)
        case 2:
            vcInstance = self.storyboard?.instantiateViewController(withIdentifier: "about")
            self.navigationController?.pushViewController(vcInstance!, animated: true)
            print(3)
        case 3:
            // 跳转到登陆界面
            vcInstance = self.storyboard?.instantiateViewController(withIdentifier: "login")
            self.navigationController?.pushViewController(vcInstance!, animated: true)
        
        case 4:
            //注销 删除本地数据并 跳转登陆界面
            
            if clearUserInfo(){
                vcInstance = self.storyboard?.instantiateViewController(withIdentifier: "login")
                self.navigationController?.pushViewController(vcInstance!, animated: true)
            }
            
        default:
            print("")
        }
       
    }
    func clearUserInfo() -> Bool{
        let ud = UserDefaults.standard
        ud.removeObject(forKey: "currentUserId")
        ud.synchronize()
        
        let app = UIApplication.shared.delegate as! AppDelegate
        let managerObjectContext = app.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "User")
        
        do {
            let result = try managerObjectContext.fetch(request)
            for user in result{
                managerObjectContext.delete(user as! NSManagedObject)
            }
            try managerObjectContext.save()
            return true
        } catch  {
            
        }
        return false
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return cellItems.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cellItems[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let image = cell.viewWithTag(101) as! UIImageView
        let label = cell.viewWithTag(102) as! UILabel
        label.text = cellItems[indexPath.section][indexPath.row]
        return cell
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
