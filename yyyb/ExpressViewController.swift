//
//  ExpressViewController.swift
//  yyyb
//
//  Created by admin on 2016/11/25.
//  Copyright © 2016年 norwaya. All rights reserved.
//

import UIKit
import MMNumberKeyboard

import ImagePicker
import Lightbox
class ExpressViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var array:Array<String>?
    var targetDic: Dictionary = [Int:Express]()
    var btnSpecial: CustomButton?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.delegate = self
        tableView.dataSource = self
        self.title = "快报"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        for index in array!{
            print(index)
        }
        initTargeDic()
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
            var express = Express(animal: (array?[i])!, lat: loc.lat!, lon: loc.lon!, address: add!)
            express.animal = array?[i]
            //            print(express.animal)
            targetDic[i] = express
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
//    override func loadView() {
//        self.view = UIScrollView.init(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: UIScreen.main.bounds.size))
//    }

}
extension ExpressViewController: UITableViewDelegate,UITableViewDataSource,PassDictionary{
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
        let label01 = cell?.viewWithTag(101) as! UILabel
        let label02 = cell?.viewWithTag(102) as! CustomButton
        let label03 = cell?.viewWithTag(103) as! ItemTextField
        let label04 = cell?.viewWithTag(104) as! ItemTextField
        let label05 = cell?.viewWithTag(105) as! ItemTextField
        let label06 = cell?.viewWithTag(106) as! CustomButton
        let label07 = cell?.viewWithTag(107) as! ItemTextField
        
        label02.iid = 2
        label03.iid = 3
        label04.iid = 4
        label05.iid = 5
        label06.iid = 6
        label07.iid = 7
        label02.id = currentId
        label03.id = currentId
        label04.id = currentId
        label05.id = currentId
        label06.id = currentId
        label07.id = currentId
        
        label07.setIntputType(type: 1) // set field input type
        label07.addTarget(self, action: #selector(btnTarget(sender:)), for: UIControlEvents.touchUpInside)
        
        //        label01.text = array?[indexPath.row]
        //        label03.text = "null"
        label02.addTarget(self, action: #selector(btnTarget(sender:)), for: UIControlEvents.touchUpInside)
        label03.addTarget(self, action: #selector(target(sender:)), for: UIControlEvents.editingChanged)
        label04.addTarget(self, action: #selector(target(sender:)), for: UIControlEvents.editingChanged)
        label05.addTarget(self, action: #selector(target(sender:)), for: UIControlEvents.editingChanged)
        label06.addTarget(self, action: #selector(btnTarget(sender:)), for: UIControlEvents.touchUpInside)
        label07.addTarget(self, action: #selector(target(sender:)), for: UIControlEvents.editingChanged)
        
        label03.inputView = getKeyboard()
        label04.inputView = getKeyboard()
        label05.inputView = getKeyboard()
        
        let express = targetDic[indexPath.row]
        label01.text = express?.animal
        label02.setTitle("\((express?.imageNum)!)", for: UIControlState.normal)
        label03.text = express?.animalNum
        label04.text = express?.exceptionNum
        label05.text = express?.deathNum
        label06.setTitle(express?.animalSpecial, for: UIControlState.normal)
        label07.text = express?.groupSpecial
        return cell!
    }
       func target(sender: ItemTextField){
        var express = targetDic[sender.id]
        switch sender.iid {
        case 3:
            print(" iid == 3")
            express?.animalNum = sender.text
            
        case 4:
            express?.exceptionNum = sender.text
            
        case 5:
            express?.deathNum = sender.text
            
        case 7:
            express?.groupSpecial = sender.text
        default:
            print("iid error")
        }
        print("\(sender.text)->\(sender.id)")
        
        targetDic.updateValue(express!, forKey: sender.id)
    }
    
    func btnTarget(sender: CustomButton){
        //goto search bar controller
        btnSpecial = sender
        
        switch sender.iid{
        case 2:
            openImagePicker()
        case 6:
            let vc = storyboard?.instantiateViewController(withIdentifier: "species") as! AnimalSpeciesTableViewController
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
            print(sender.id)
        default:
            print("error")
        }
    }
    func passDictionary(dic: Dictionary<String, Any>) {
        if dic.keys.contains("item"){
            
            
            let id = (btnSpecial?.id)!
            var express = targetDic[id]
            express?.animalSpecial = dic["item"] as? String
            btnSpecial?.setTitle(express?.animalSpecial!, for: UIControlState.normal)
            targetDic.updateValue(express!, forKey: id)
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
extension ExpressViewController: ImagePickerDelegate{
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
        var express = targetDic[id]
        express?.images?.removeAll()
        for image in images{
            print(image)
            express?.images?.append(image)
        }
        targetDic.updateValue(express!, forKey: id)
        
        btnSpecial?.setTitle("\((targetDic[id]?.imageNum)!)", for: UIControlState.normal)
    }
    
}

extension ExpressViewController: MMNumberKeyboardDelegate{
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

struct Express{
    var animal: String?
    var images: Array<UIImage>?
    var imageNum: Int{
        get{
            if (images != nil){
                var sum: Int = 0
                for  _ in images!{
                    sum += 1
                }
                return sum
            }else{
                return 0
            }
        }
    }
    var lat: String!
    var lon: String!
    var address: String?
    var animalSpecial: String?
    var animalNum: String?
    var exceptionNum: String?
    var deathNum: String?
    var groupSpecial: String?
    init(animal: String,lat: String, lon: String,address: String) {
        self.lat = lat
        self.animal = animal
        self.lon = lon
        self.address = address
        images = Array()
    }
    
}
