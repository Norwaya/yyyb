//
//  YbkTableViewController.swift
//  yyyb
//
//  Created by admin on 2016/12/21.
//  Copyright © 2016年 norwaya. All rights reserved.
//

import UIKit
import CoreData

class YbkTableViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!

    var context:NSManagedObjectContext?
    var array:Array<structYbk> = []
    var filter:Array<structYbk> = []
    
    var searching = false
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        let app = UIApplication.shared.delegate as! AppDelegate
        self.context = app.persistentContainer.viewContext
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Ybdm")
        let result = try? context?.fetch(request) as! [Ybdm] as Array
        print(result?.count)
        for item in result!{
            print(item.ybmc)
            array.append(structYbk.init(id: item.id ?? "", ybmc: item.ybmc ?? ""))
        }
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

   

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.searching ? self.filter.count : self.array.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let label = cell?.viewWithTag(100) as! UILabel
        let result = self.searching ? self.filter : self.array
        label.text = result[indexPath.row].ybmc
        return cell!
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result =  self.searching ? self.filter : self.array
        let detail = result[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ybkdetail")
        as! YbkDetailViewController
        vc.name = detail.ybmc
        vc.id = detail.id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension YbkTableViewController:UISearchBarDelegate{
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        print("search bar text did begin editing")
        searching = true
        
        
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filter.removeAll()
        if (searchText.isEmpty)
        {
            self.filter = array
            searching = false
            searchBar.resignFirstResponder()
        }
        else
        {
            for item in array{
                if (item.ybmc?.contains(searchText))!{
                    filter.append(item)
                }
            }
        }
        tableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //        print("------searchBarSearchButtonClicked----")
        
        searchBar.resignFirstResponder()
        searching = true
        
       tableView.reloadData()
    }
}
struct structYbk{
    var id:String?
    var ybmc:String?
    init(id:String,ybmc:String){
        self.id = id
        
        self.ybmc = ybmc
    }
}
