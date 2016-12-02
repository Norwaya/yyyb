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

class NoticeViewController: UIViewController {
    // MARK: -
    // MARK: Vars
    
//    fileprivate var tableView: UITableView!
    
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
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0)
        
//        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        tableView.separatorColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 231/255.0, alpha: 1.0)
//        tableView.backgroundColor = UIColor(red: 250/255.0, green: 250/255.0, blue: 251/255.0, alpha: 1.0)
//        view.addSubview(tableView)
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
//                    print("sleep start")
//                    Thread.sleep(forTimeInterval: 10)
//                    print("sleep over")
//                    self?.tableView.dg_stopLoading()
//                })
            DispatchQueue.main.async {
//                Alamofire.request("https://httpbin.org/get").responseJSON { response in
//                    print(response.request)  // original URL request
//                    print(response.response) // HTTP URL response
//                    print(response.data)     // server data
//                    print(response.result)   // result of response serialization
//                    
//                    if let JSON = response.result.value {
//                        print("JSON: \(JSON)")
//                    }
//                }
                Alamofire.request("https://httpbin.org/get")
                    .responseString { response in
                        print("Response String: \(response.result.value)")
                    }
                    .responseJSON { response in
                        print("Response JSON: \(response.result.value)")
                }
                self?.tableView.dg_stopLoading()
            }
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
    }
    
    deinit {
        tableView.dg_removePullToRefresh()
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
