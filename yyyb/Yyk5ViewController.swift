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
    
    @IBOutlet weak var g: UILabel!
    @IBOutlet weak var m: UILabel!
    @IBOutlet weak var k: UILabel!
    @IBOutlet weak var s: UILabel!
    @IBOutlet weak var z: UILabel!
    @IBOutlet weak var latin: UILabel!
    @IBOutlet weak var fb: UILabel!
    @IBOutlet weak var tmtz: UITextView!
    @IBOutlet weak var xx: UILabel!
    
    
    var currentId: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.title = "种"
        // Do any additional setup after loading the view.
        
        
        initData()
        
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
    func initData(){
        let app = UIApplication.shared.delegate as! AppDelegate
        context = app.persistentContainer.viewContext
        let request1 = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Yydm")
        request1.predicate = NSPredicate.init(format: " id CONTAINS %@", getStr(jb: 0))
        let gang = try? context.fetch(request1) as! [Yydm] as Array
        g.text = gang?[0].yymc!
        
        let request2 = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Yydm")
        request2.predicate = NSPredicate.init(format: " id CONTAINS %@", getStr(jb: 1))
        let mu = try? context.fetch(request2) as! [Yydm] as Array
        m.text = mu?[0].yymc!
        
        let request3 = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Yydm")
        request3.predicate = NSPredicate.init(format: " id CONTAINS %@", getStr(jb: 2))
        let ke = try? context.fetch(request3) as! [Yydm] as Array
        k.text = ke?[0].yymc!
        
        let request4 = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Yydm")
        request4.predicate = NSPredicate.init(format: " id CONTAINS %@", getStr(jb: 3))
        let shu = try? context.fetch(request4) as! [Yydm] as Array
        s.text = shu?[0].yymc!
        
        let request5 = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Yydm")
        request5.predicate = NSPredicate.init(format: " id CONTAINS %@", currentId!)
        let zhong = try? context.fetch(request5) as! [Yydm] as Array
        z.text = zhong?[0].yymc!
        
//        @IBOutlet weak var latin: UILabel!
//        @IBOutlet weak var fb: UILabel!
//        @IBOutlet weak var tmtz: UITextView!
//        @IBOutlet weak var xx: UILabel!
        latin.text = zhong?[0].ldmc
        fb.text = zhong?[0].fb
        tmtz.text = zhong?[0].tmtz
        xx.text = zhong?[0].xx ?? ""
        
        
        
        
    }
    func getStr(jb:Int) -> String{
        if(currentId != nil){
            switch jb {
            case 0:
                return "\(currentId.substring(to: currentId.index(currentId.startIndex, offsetBy: 2)))00000000000000"
            case 1:
                return "\(currentId.substring(to: currentId.index(currentId.startIndex, offsetBy: 4)))000000000000"
            case 2:
                return "\(currentId.substring(to: currentId.index(currentId.startIndex, offsetBy: 7)))000000000"
            case 3:
                return "\(currentId.substring(to: currentId.index(currentId.startIndex, offsetBy: 10)))000000"
            case 4:
                return currentId!
            default:
                print("")
            }
        }
        return ""
    }
}
