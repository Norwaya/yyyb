//
//  SaveExpressViewController.swift
//  yyyb
//
//  Created by admin on 2016/12/15.
//  Copyright © 2016年 norwaya. All rights reserved.
//

import UIKit
import CoreData


class SaveExpressViewController: UIViewController {
    
    var context:NSManagedObjectContext!
    var baseInfo:BaseInfo?
    var dic:Dictionary<String, Any>?
    //上一页的信息
     var targetDic: Dictionary<Int, Express>!
    
    @IBOutlet weak var zqtz: UITextField!
    @IBOutlet weak var fxdd: UITextField!
    @IBOutlet weak var ycclqk: UITextField!
    @IBOutlet weak var zzms: UITextField!
    @IBOutlet weak var xcclqk: UITextField!
    @IBOutlet weak var cbjlButton: UIButton!
    
    var delegate:intentBaseInfoAble?
    
    var cbjlSelected:String?
    var cbjlIndex:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let app = UIApplication.shared.delegate as! AppDelegate
        context = app.persistentContainer.viewContext
        initView()
    
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    func initView(){
        if(self.baseInfo != nil){
            self.fxdd.text = baseInfo?.address ?? ""
            self.zqtz.text = baseInfo?.zqtz ?? ""
            self.zzms.text = baseInfo?.zzms ?? ""
            self.cbjlIndex = baseInfo?.cbjlIndex ?? ""
            self.cbjlSelected = baseInfo?.cbjl ?? "选择初步结论"
            self.cbjlButton.setTitle(self.cbjlSelected, for: UIControlState.normal)
            self.xcclqk.text = baseInfo?.xccl ?? ""
            self.ycclqk.text = baseInfo?.ycclqk ?? ""
        }
    }
    @IBAction func btn_pre(_ sender: Any) {
        
//            saveBaseInfo()
//            delegate?.intentBaseInfo(baseInfo: self.baseInfo!)
        self.navigationController?.popViewController(animated: true)
    }
    func saveBaseInfo(){
        let addredd:String = fxdd.text!
        let zqtzText:String = zqtz.text!
        let zzmsText:String = zzms.text!
        let cbjlText:String = self.cbjlSelected ?? "选择初步结论"
        let xcclText:String = xcclqk.text!
        let ycclText:String = ycclqk.text!
        let cbjlIndexText  = self.cbjlIndex ?? "0"
        NSLog("%@ - %@ -%@ -%@ -%@ -%@  ",addredd,zqtzText,zzmsText,cbjlText,xcclText,ycclText)
        if (self.baseInfo == nil){
            self.baseInfo = BaseInfo.init(address: addredd, zqtz: zqtzText,zzms:zzmsText, cbjl: cbjlText, xccl: xcclText, ycclqk: ycclText,cbjlIndex:cbjlIndexText)
        }else{
            baseInfo?.address = addredd
            baseInfo?.zqtz  = zqtzText
            baseInfo?.zzms = zzmsText
            baseInfo?.cbjl = cbjlText
            baseInfo?.xccl = xcclText
            baseInfo?.ycclqk = ycclText
            baseInfo?.cbjlIndex = cbjlIndexText
        }
    }
    
    
    
    @IBAction func btn_save(_ sender: Any) {
        saveBaseInfo()
        let entity = NSEntityDescription.entity(forEntityName: "Kbxx", in: context)
        
        if(self.targetDic == nil){
            print("target dic is nil")
            return
        }
        
        for express in targetDic.values{
            print(" begin to save data----")
            
            let kbxx = NSManagedObject.init(entity: entity!, insertInto: context) as! Kbxx
            
            kbxx.cbjl = baseInfo?.cbjlIndex
            kbxx.cbjlqt = baseInfo?.cbjl
            kbxx.fjsc = ""
            kbxx.fxdd = baseInfo?.address
            let format = DateFormatter.init()
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
            kbxx.fxsj = format.string(from: Date())
            kbxx.isupload = false
            kbxx.jd = express.lon
            kbxx.wd = express.lat
            kbxx.lrsj = format.string(from: Date())
            kbxx.name = express.animal
            kbxx.sjtz = express.animalSpecial
            kbxx.swsl = express.deathNum
            kbxx.wzid = getAnimalId(yymc: express.animal!)
            kbxx.xccl = baseInfo?.xccl
            kbxx.ycdwcl = baseInfo?.ycclqk
            kbxx.ycsl = express.exceptionNum
            kbxx.zqtz = baseInfo?.zqtz
            kbxx.zzms = baseInfo?.zzms
            kbxx.zqsl = express.animalNum
            try? context.save()
        }
        
        test()
        let controllers = navigationController?.viewControllers
        self.navigationController?.popToViewController((controllers?[(controllers?.count)!-4])!, animated: true)
        
        
    }
    func test(){
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Kbxx")
        let cc = try? context.fetch(request)
        print(cc?.count)
    }
    func ud(key:String) -> String {
        let ud = UserDefaults.standard
        return ud.string(forKey: key) ?? ""
    }
    func getAnimalId(yymc:String) -> String{
        let app = UIApplication.shared.delegate as! AppDelegate
        let managerObjectContext = app.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Yydm")
        request.predicate = NSPredicate.init(format: "yymc CONTAINS %@", yymc)
        do {
            let result = try managerObjectContext.fetch(request) as! [Yydm] as Array
            
            return result[0].id!
        } catch  {
            
        }
        return "未知物种"
    }
    
    
    
    
    
    
    
    
    
    
    @IBAction func btn_cbjl(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "cbjl") as! CbjlTableViewController
        
        print(vc)
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        saveBaseInfo()
        if self.isMovingFromParentViewController{
            if self.delegate != nil{
                
                    print("move out of self view controller")
                    delegate?.intentBaseInfo(baseInfo: self.baseInfo!)
                
            }
        }
    }
    
    
}
extension SaveExpressViewController:PassDictionary{
    func passDictionary(dic: Dictionary<String, Any>) {
        self.cbjlIndex = dic["itemindex"] as! String
        self.cbjlSelected = dic["item"] as! String
        cbjlButton.setTitle(self.cbjlSelected!, for: UIControlState.normal)
    }
}
class BaseInfo{
    var address:String?
    var zqtz:String?
    var zzms:String?
    var cbjl:String?
    var cbjlIndex:String?
    var xccl:String?
    var ycclqk:String?
    init(){
        
    }
    
    init(address:String,zqtz:String,zzms:String,cbjl:String,xccl:String,ycclqk:String,cbjlIndex:String) {
        self.address = address
        self.cbjl = cbjl
        self.xccl = xccl
        self.ycclqk = ycclqk
        self.cbjlIndex = cbjlIndex
        self.zzms = zzms
        self.zqtz = zqtz
    }
}
