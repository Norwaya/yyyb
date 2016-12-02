//
//  QueryViewController.swift
//  yyyb
//
//  Created by admin on 2016/11/30.
//  Copyright © 2016年 norwaya. All rights reserved.
//

import UIKit
import Alamofire

class QueryViewController: UIViewController {
    var array = [String]()
    
    
    @IBOutlet weak var btn_from: UIButton!
   
    @IBOutlet weak var btn_to: UIButton!
    @IBOutlet weak var tableView: UITableView!
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.dataSource = self
        tableView.delegate = self
        initButton()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

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
    var firstLoad = true
    func initButton(){
        if firstLoad{
            let date = Date()
            let format = DateFormatter.init()
            format.dateFormat = "yyyy-MM-dd"
            let strDate = format.string(from: date) as String
            
            self.from = date
            self.to = date
            
            self.btn_from.setTitle(strDate, for: UIControlState.normal)
            self.btn_to.setTitle(strDate, for: UIControlState.normal)

           firstLoad = false
        }
    }
    @IBAction func btn_search(_ sender: UIButton) {
        switch sender.tag {
        case 101:
            initAlertController(time:"from")
        case 102:
            initAlertController(time:"to")
        case 103:
            requestRecored()
        default:
            print("have no button equal this tag")
        }
    }
    func requestRecored(){
        Alamofire.request("").responseJSON(completionHandler: {respond in
            print("request data \n  finished    \n refresh view")
            self.array = ["","",""]
            self.tableView.reloadData()
        })
    }
    
    
    
    
    
    
    var from:Date?
    var to:Date?
    func initAlertController(time: String) {
        
        let alert = UIAlertController.init(title: "选择日期\n\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let datePicker = initDatePicker(time: time)
        alert.view.addSubview(datePicker)
        alert.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction.init(title: "OK", style: UIAlertActionStyle.default, handler: {action in
            let date = datePicker.date
            let format = DateFormatter.init()
            format.dateFormat = "yyyy-MM-dd"
            let strDate = format.string(from: date) as String
            switch time{
            case "from":
                self.from = date
                self.btn_from.setTitle(strDate, for: UIControlState.normal)
            case "to":
                self.to = date
                self.btn_to.setTitle(strDate, for: UIControlState.normal)
            default:
                print("error")
            }
            
            
            
        }))
        present(alert, animated: true, completion: nil)
        
    }
    func initDatePicker(time:String) -> UIDatePicker{
        let format = DateFormatter.init()
        format.dateFormat = "yyyy-MM-dd"
        
        let datePicker = UIDatePicker.init()
        datePicker.datePickerMode = UIDatePickerMode.date
        //设置地理语言
        datePicker.locale = NSLocale.init(localeIdentifier: "zh_CN") as Locale
        switch time{
            case "from":
                datePicker.date = self.from ?? self.to ?? Date()
                datePicker.minimumDate = format.date(from: "1970-01-01")
                datePicker.maximumDate = self.to ?? format.date(from: "2070-01-01")
            case "to":
                datePicker.date = self.to ?? self.from ?? Date()
                datePicker.minimumDate = self.from ?? format.date(from: "1970-01-01")
                datePicker.maximumDate = format.date(from: "2070-01-01")
            default:
                print()
        }
        return datePicker
    }
}
extension QueryViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension QueryViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if let c = cell{
            let date = c.viewWithTag(1) as! UILabel
            let recordNum = c.viewWithTag(2) as! UILabel
            date.text = "2016/01/01"
            recordNum.text = "\(indexPath.row)"
        }
        
        return cell!
    }
}

