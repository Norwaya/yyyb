//
//  Yyk5ViewController.swift
//  yyyb
//
//  Created by admin on 2016/12/12.
//  Copyright © 2016年 norwaya. All rights reserved.
//

import UIKit
import CoreData
class Yyk5ViewController: UIViewController {
    var context:NSManagedObjectContext!
    var array: Array<String>!
    var arrayIndex: Array<String>! = Array()
    
    var currentId: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "种"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
