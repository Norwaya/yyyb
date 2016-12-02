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
        
        var request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Aspecies")
        
        let app = UIApplication.shared.delegate as! AppDelegate
        var managerObjectContext: NSManagedObjectContext?
        if #available(iOS 10.0, *) {
             managerObjectContext = app.persistentContainer.viewContext
        } else {
            // Fallback on earlier versions
            managerObjectContext = app.coreData.context
        }
        var result = try? managerObjectContext?.fetch(request) as! [Aspecies] as Array
        for users in result! {
            print(users.name)
            print(users.ingenus?.name)
        }
//        targetDic[id]?.animalSpecial
//        print("\(btnSpecial?.id)->\(targetDic[(btnSpecial?.id)!]?.animalSpecial)")
//        for animal in targetDic.values{
//            if (animal.animalSpecial == "选择生境特征"){
//                
//            }else if(animal.animalNum == nil || animal.animalNum == ""){
//                
//                let alertController = UIAlertController(title:"标题", message:"这个是UIAlertController的默认样式", preferredStyle: UIAlertControllerStyle.alert)
//            
//                
//                let cancelAction = UIAlertAction(title:"取消", style: UIAlertActionStyle.cancel, handler: nil)
//                
//                let okAction = UIAlertAction(title:"好的", style: UIAlertActionStyle.default, handler: nil)
//                
//                alertController.addAction(cancelAction)
//                
//                alertController.addAction(okAction)
//                self.present(alertController, animated:true, completion: nil)
//                break
//            }
//        }
       
    }
    @IBAction func btn_return(_ sender: UIButton) {
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
        label04.setTitle(daily.animalSpecial , for: UIControlState.normal)
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
            btnSpecial?.setTitle(daily?.animalSpecial!, for: UIControlState.normal)
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
        daily?.images?.removeAll()
        for image in images{
            print(image)
            daily?.images?.append(image)
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
    var images: Array<UIImage>?
    var imageNum: Int!{
        get{
            return images!.count
        }
    }
    var lat: String!
    var lon: String!
    var address: String?
    var animalSpecial: String?
    var animalNum: String?
    init(animal: String,lat: String, lon: String,address: String) {
        self.lat = lat
        self.animal = animal
        self.lon = lon
        self.address = address
        images = Array.init()
    }
    
}
