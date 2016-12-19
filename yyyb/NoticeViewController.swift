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
class NoticeViewController: UIViewController {
    var context:NSManagedObjectContext!
    var array:Array<Emunication> = []
    @IBOutlet weak var tableView: UITableView!
    // MARK: -
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func loadView() {
        super.loadView()
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
    
    deinit {
        tableView.dg_removePullToRefresh()
    }
    
    func requestData(){
        let info = getUserInfo()
        let parameters : Parameters =
            [
                "m":"update",
                "unitId":info.unitid,
                "updateTime":"20161219"
            ]
        
        
        
        
        Alamofire.request("https://192.168.20.50:8090/yjtx.do",parameters:parameters)
            .responseJSON { response in
                print("Response JSON: \(response.result.value)")
        }
        self.tableView.dg_stopLoading()
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

    
}

// MARK: -
// MARK: UITableView Data Source
extension NoticeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
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
extension NoticeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
struct Emunication{
    var name:String?
    var photo:String?
}
