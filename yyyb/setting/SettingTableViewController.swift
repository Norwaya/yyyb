//
//  SettingTableViewController.swift
//  yyyb
//
//  Created by admin on 2016/11/29.
//  Copyright © 2016年 norwaya. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {

    let array = ["版本更新","离线地图","数据更新","关于","退出"]
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
           print()
        case 1:
//            vcInstance = self.storyboard?.instantiateViewController(withIdentifier: "start")
            vcInstance = OfflineViewController.init()
            self.navigationController?.pushViewController(vcInstance!, animated: true)
        case 2:
            print(2)
        case 3:
            print(3)
        case 4:
            print(4)
        default:
            print("")
        }
        
        
        
        
        
        
//        let title = titles[indexPath.section][indexPath.row]
//        let vcClass = classNames[indexPath.section][indexPath.row]
//        let vcInstance = vcClass.init()
//        vcInstance.title = title
//        
//        let destimationVC = indexPath.row == 0 ? vcMain : vcInstance
       
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
