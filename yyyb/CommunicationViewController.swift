//
//  CommunicationViewController.swift
//  yyyb
//
//  Created by admin on 2016/12/19.
//  Copyright © 2016年 norwaya. All rights reserved.
//

//
//  NoticeViewController.swift
//  yyyb
//
//  Created by admin on 2016/11/29.
//  Copyright © 2016年 norwaya. All rights reserved.
//

import UIKit
import Alamofire
import DGElasticPullToRefresh
import CoreData

class CommunicationViewController: UIViewController {
    var context:NSManagedObjectContext!
    var array:Array<Comm> = []
    
    @IBOutlet weak var tableView: UITableView!
    // MARK: -
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if httpRequest != nil{
            httpRequest?.cancel()
        }
    }
    
    func addLink(sender:UITabBarItem){
        
    }
    
    override func loadView() {
        super.loadView()
//        navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIBarButtonSystemItem.add, style: UIBarButtonItemStyle.done, target: self, action: #selector(addLink(sender:)))
        
        let app = UIApplication.shared.delegate as! AppDelegate
        context = app.persistentContainer.viewContext
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0)
        
        tableView.dataSource = self
        tableView.delegate = self
    
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
                DispatchQueue.main.async {
               
                self?.requestData()
            }
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
    }
    var httpRequest:Request?
    func requestData(){
        let info = getUserInfo()
        let parameters : Parameters =
            [
                "m":"update",
                "unitId":info.unitid,
                "updateTime":"20161219120000"
        ]
        
        
//        print(parameters)
        
        httpRequest = Alamofire.request("http://192.168.20.50:8090/yjtx.do",parameters:parameters)
            .response { response in
                print("Request: \(response.request)")
                print("Response: \(response.response)")
                print("Error: \(response.error)")
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)")
                }
            }
            .responseJSON { response in
                print("Response JSON: \(response.result.value)")
                
                DispatchQueue.main.async(execute: {
                    
                    self.tableView.reloadData()
                })
        }
        self.tableView.dg_stopLoading()
    }
    
    func getUserInfo() -> (userId:String,unitid:String){
        let ud = UserDefaults.standard
        let id = ud.string(forKey: "currentUserIdId")
        if  (id == nil) {
            return ("","")
        }
        print("--------\(id)")
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "User")
        request.predicate = NSPredicate.init(format: "id CONTAINS  %@ ", id!)
        let result = try? context.fetch(request) as! [User] as Array
        return (id!,(result?[0].ssbm)!)
    }

    
    
    
    deinit {
        tableView.dg_removePullToRefresh()
    }
    
}

// MARK: -
// MARK: UITableView Data Source
extension CommunicationViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cellIdentifier = "cellIdentifier"
        let cellIdentifier = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        let content = cell?.viewWithTag(102) as! UILabel
        let date = cell?.viewWithTag(103) as! UILabel
        //        if cell == nil {
        //            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        //            cell!.contentView.backgroundColor = UIColor(red: 250/255.0, green: 250/255.0, blue: 251/255.0, alpha: 1.0)
        //
        //        }
        
        //        if let cell = cell {
        //            cell.textLabel?.text = "\((indexPath as NSIndexPath).row)"
        //            return cell
        //        }
        content.text = "\(indexPath.row)"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        date.text = formatter.string(from: Date())
        return cell!
    }
    
}

// MARK: -
// MARK: UITableView Delegate
extension CommunicationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
struct Comm{
    
}
