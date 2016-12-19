//
//  ShowRecoredViewController.swift
//  yyyb
//
//  Created by admin on 2016/12/17.
//  Copyright © 2016年 norwaya. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON
import Alamofire
class ShowRecoredViewController: UITabBarController {

    var time:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = true
        print("father view did load\(self.tabBar.items?.count)")
        
        requestData()
    }
    override func viewWillAppear(_ animated: Bool) {
        print("father view will appear\(self.tabBar.items?.count)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestData(){
        let items = self.viewControllers
        (items?[0] as! ShowRbxxViewController).time = self.time
        (items?[1] as! ShowKbxxViewController).time = self.time
    }
}
