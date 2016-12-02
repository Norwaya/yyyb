//
//  StartMonistroViewController.swift
//  yyyb
//
//  Created by admin on 2016/11/19.
//  Copyright © 2016年 norwaya. All rights reserved.
//

import UIKit

class StartMonistroViewController: UIViewController {

    @IBOutlet weak var btn_start: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func action_start(_ sender: UIButton) {
        let vcInstance = self.storyboard?.instantiateViewController(withIdentifier: "mapview")
        self.navigationController?.pushViewController(vcInstance!, animated: true)
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
