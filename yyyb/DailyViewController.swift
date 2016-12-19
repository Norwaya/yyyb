//
//  DailyViewController.swift
//  yyyb
//
//  Created by admin on 2016/11/22.
//  Copyright © 2016年 norwaya. All rights reserved.
//

import UIKit
import CoreData
import ImagePicker
import Lightbox
import MMNumberKeyboard

class DailyViewController: UIViewController,PassDictionary{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var btnSpecial:CustomButton?
    
    @IBAction func btn_save(_ sender: UIButton) {
        
//        var request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Aspecies")
//        
//        let app = UIApplication.shared.delegate as! AppDelegate
//        var managerObjectContext = app.persistentContainer.viewContext
//        
//        var result = try? managerObjectContext.fetch(request) as! [Aspecies] as Array
//        for users in result! {
//            print(users.name)
//            print(users.ingenus?.name)
//        }
        // 检查字段填写
        for animal in targetDic.values{
            if (animal.animalSpecial == "选择"){
                showAlertController(title: "提示", msg: "请选择生境特征", ok: "确定")
                return
            }else if((animal.animalNum == nil) || (animal.animalNum! == "") || (animal.animalNum! == "0")){
                showAlertController(title: "提示", msg: "动物数量不能为空", ok: "确定")
                return
            }
        }
        // 保存到数据库
        saveData()
       
    }
    @IBAction func btn_return(_ sender: UIButton) {
    }
    
    func showAlertController(title: String,msg: String,ok: String){
        let alertController = UIAlertController(title:title, message:msg  , preferredStyle: UIAlertControllerStyle.alert)
        
        
//        let cancelAction = UIAlertAction(title:cancel, style: UIAlertActionStyle.cancel, handler: nil)
        
        let okAction = UIAlertAction(title:ok, style: UIAlertActionStyle.default, handler: nil)
        
//        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated:true, completion: nil)
    }
    
    //save dic to datebase
    func saveData(){
//        picNum()
        
        do {
//            var images:Array<UIImage> = Array()
            
            let app = UIApplication.shared.delegate as! AppDelegate
            let managerObjectContext = app.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Rbxx", in: managerObjectContext)
            let picEntity = NSEntityDescription.entity(forEntityName: "Pic", in: managerObjectContext)
            for animal in targetDic.values{

                //Get the ManagedObject
                
                
                
                
                let rbxx = NSManagedObject(entity: entity!, insertInto: managerObjectContext) as! Rbxx
                let infoFromUser = getFromUser()
                rbxx.ssbm = infoFromUser.ssbm
                rbxx.lrry = infoFromUser.lrry
                rbxx.jd = Double(animal.lon)!
                rbxx.wd = Double(animal.lat)!
                rbxx.zqsl = animal.animalNum
                // time
                let format = DateFormatter.init()
                format.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                let timeZone = NSTimeZone.system
//                let interval = timeZone.secondsFromGMT()
                let currentDate = Date()
                print(currentDate)
                rbxx.lrsj = format.string(from: currentDate)
                rbxx.name = animal.animal
                rbxx.sjtz = animal.animalSpecial
                rbxx.wzdm = getWzdm(name: animal.animal!)
                rbxx.isupload = false
                try managerObjectContext.save()
//                NSData *data = UIImageJPEGRepresentation(image, 1.0f);
//                NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//                return encodedImageStr;
                print("when save pics the num")
                print(animal.images.count)
                for image in animal.images{
                    let pic = NSManagedObject.init(entity:picEntity! , insertInto: managerObjectContext) as! Pic
                    let data = UIImageJPEGRepresentation(image, 1.0) as NSData?
                    let strImage = data?.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
//                    print("str image -> \(strImage)")
                    pic.images = strImage
                    
                    try managerObjectContext.save()
                    rbxx.pics?.adding(pic)
                }
                
                
            }
            picNum()
        } catch  {
            
        }
        let controllers = navigationController?.viewControllers
        self.navigationController?.popToViewController((controllers?[(controllers?.count)!-3])!, animated: true)
       
    }
    
    func picNum(){
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let array = try! context.fetch(NSFetchRequest<NSFetchRequestResult>.init(entityName: "Rbxx")) as! [Rbxx] as Array
        for rbxx in array{
            print("test count of rbxx")
            let set = rbxx.pics
            print("set is \(set)")
            let enu:NSEnumerator = set!.objectEnumerator()
            print("start to set")
            while let obj = enu.nextObject() {
                print("pic -> \(obj)" )
            }
            print("end to set")
        }
        
    }
    
    
    
    
    
    func getWzdm(name: String) -> String {
        let app = UIApplication.shared.delegate as! AppDelegate
        let managerObjectContext = app.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Yydm")
        request.predicate = NSPredicate.init(format: "yymc CONTAINS %@", name)
        do {
            let result = try managerObjectContext.fetch(request) as! [Yydm] as Array
            
            return result[0].id!
        } catch  {
            
        }
        return "未知物种"
    }
    func getFromUser() -> (lrry:String,ssbm:String){
        let app = UIApplication.shared.delegate as! AppDelegate
        let managerObjectContext = app.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "User")
        request.predicate = NSPredicate.init(format: "yhm CONTAINS %@", UserDefaults.standard.string(forKey: "currentUserId")!)
        let result = try? managerObjectContext.fetch(request) as! [User] as Array
        if(result?.count == 0){
            return ("nil","nil")
        }
        let user = result?[0]
        print("xm: \(user?.xm) ssbm: \(user?.ssbm)")
        return (user!.llry ?? "",user!.ssbm!)
    }
    func saveImages(arr: Array<UIImage>){
        if !(arr.count > 0){
            return
        }
        let home = NSHomeDirectory()
        let path = home.appending("/doc/pic.plist")
        let array = NSMutableArray.init()
        for image in arr{
            let data = UIImageJPEGRepresentation(image as! UIImage, 1.0)
            let strimage64 = data?.base64EncodedString()
            array.adding(strimage64)
        }
        if array.write(toFile: path, atomically: true){
            NSLog("write success")
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    var delegate: PassDictionary?
    var array: Array<String>?
    var targetDic: Dictionary = [Int:Daily]()
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.title = "日报"
        initTargeDic()
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.automaticallyAdjustsScrollViewInsets = false
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var firstInit = true
    func initTargeDic(){
        if !firstInit{
            return
        }
        let userDic = UserDefaults.standard
        let loc = getLoc()
        let add = userDic.string(forKey: "add")
        var i: Int = 0
        for var _ in array!{
            var daily = Daily(animal: (array?[i])!, lat: loc.lat!, lon: loc.lon!, address: add!)
            daily.animal = array?[i]
//            print(daily.animal)
            targetDic[i] = daily
            i += 1
        }
        firstInit = false
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
extension DailyViewController: UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("click the item of \(indexPath.row)")
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array!.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "title"
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentId = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let label01 = cell?.viewWithTag(100) as! UILabel
        let label02 = cell?.viewWithTag(101) as! CustomButton
        let label03 = cell?.viewWithTag(102) as! UILabel
        let label04 = cell?.viewWithTag(103) as! CustomButton
        let label05 = cell?.viewWithTag(104) as! ItemTextField
        label02.id = currentId
        label04.id = currentId
        label05.id = currentId
        label02.iid = 2
        label04.iid = 4
        
        
        label02.addTarget(self, action: #selector(btnTarget(sender:)), for: UIControlEvents.touchUpInside)
        label04.addTarget(self, action: #selector(btnTarget(sender:)), for: UIControlEvents.touchUpInside)
        
//        label01.text = array?[indexPath.row]
//        label03.text = "null"
        
        
        label05.addTarget(self, action: #selector(target(sender:)), for: UIControlEvents.editingChanged)
        label05.inputView = getKeyboard()
        
        let daily = targetDic[indexPath.row]!
        label01.text = daily.animal
        label02.setTitle("\((daily.imageNum)!)", for: UIControlState.normal)
        label03.text = "lat: \((daily.lat)!)  lon: \((daily.lon)!)"
        print("\(indexPath.row) ->  \(targetDic[indexPath.row]?.animalSpecial)")
        label04.setTitle(daily.itemName , for: UIControlState.normal)
        label05.text = daily.animalNum
//        label01.re
        
        return cell!
    }
    func target(sender: ItemTextField){
        var daily = targetDic[sender.id]
        daily?.animalNum = sender.text
        targetDic.updateValue(daily!, forKey: sender.id)
    }
    
    func btnTarget(sender: CustomButton){
        //goto search bar controller
        btnSpecial = sender
        switch sender.iid{
        case 2:
            openImagePicker()
        case 4:
            let vc = storyboard?.instantiateViewController(withIdentifier: "species") as! AnimalSpeciesTableViewController
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            print("btn has this iid")
        }
        
    }
    
    func passDictionary(dic: Dictionary<String, Any>) {
        if dic.keys.contains("item"){
            let id = (btnSpecial?.id)!
            var daily = targetDic[id]
            daily?.animalSpecial = dic["item"] as? String
            daily?.itemName = dic["itemname"] as? String
            btnSpecial?.setTitle(daily?.itemName!, for: UIControlState.normal)
            targetDic.updateValue(daily!, forKey: id)
            print("save->\(id) -> \(targetDic[id]?.animalSpecial)")
            
            //
        }
    }
   
    func getLoc() -> (lat: String?,lon: String?){
        let ud = UserDefaults.standard
        var lat: String!
        var lon: String!
        let lat0 = ud.string(forKey: "lat")
        let lon0 = ud.string(forKey: "lon")
        var index: String.Index
        if(lat0 != nil){
            index = lat0!.index(lat0!.startIndex, offsetBy: 6)
            lat = lat0!.substring(to: index)
        }else{
            lat = ""
        }
        if(lon0 != nil){
            index = lon0!.index(lon0!.startIndex, offsetBy: 6)
            lon = lon0!.substring(to: index)
        }else{
            lon = ""
        }
        return (lat,lon)
    }
}
extension DailyViewController: ImagePickerDelegate{
    func openImagePicker(){
        let imagePicker = ImagePickerController()
        imagePicker.delegate = self
        imagePicker.imageLimit = 3
        present(imagePicker, animated: true, completion: nil)
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
        print("cancel btn press")
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("wrapper did press ")
        guard images.count > 0 else { return }
        
        let lightboxImages = images.map {
            return LightboxImage(image: $0)
        }
        
        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
        imagePicker.present(lightbox, animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true, completion: nil)
        let id = (btnSpecial?.id)!
        var daily = targetDic[id]
        daily?.images.removeAll()
        for image in images{
            print(image)
            daily?.images.append(image)
        }
        targetDic.updateValue(daily!, forKey: id)
        
        btnSpecial?.setTitle("\((targetDic[id]?.imageNum)!)", for: UIControlState.normal)
    }

}
extension DailyViewController: MMNumberKeyboardDelegate{
    func getKeyboard() -> MMNumberKeyboard{
        //        MMNumberKeyboard *keyboard = [[MMNumberKeyboard alloc] initWithFrame:CGRectZero];
        //        keyboard.allowsDecimalPoint = YES;
        //        keyboard.delegate = self;
        let keyboard = MMNumberKeyboard.init()
        keyboard.allowsDecimalPoint = false
        keyboard.delegate = self
        
        return keyboard
    }
    
}
struct Daily{
    var animal: String?
    var images: Array<UIImage> = Array()
    var imageNum: Int!{
        get{
            return images.count
        }
    }
    var lat: String!
    var lon: String!
    var address: String?
    var animalSpecial: String?
    var itemName:String?
    var animalNum: String?
    init(animal: String,lat: String, lon: String,address: String) {
        self.lat = lat
        self.animal = animal
        self.lon = lon
        self.address = address
        images = Array.init()
    }
    
}
