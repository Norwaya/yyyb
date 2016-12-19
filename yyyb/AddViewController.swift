//
//  AddViewController.swift
//  yyyb
//
//  Created by admin on 2016/11/21.
//  Copyright © 2016年 norwaya. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController, UISearchBarDelegate{

    var firstLoad = true
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    var dic = [Int:Bool]() // defined dictionary
    var array: Array<String> = [String]() //the selected items array
    var sums: Int = 0  //the selected numbers of item
    
    @IBOutlet weak var btn_Daily: UIButton!
    @IBOutlet weak var btn_Express: UIButton!
    
    var context: NSManagedObjectContext!
    var yydmDescription: NSEntityDescription!
    
    
    @IBAction func singleBtnAction(_ sender: UIButton) {
        // 消除搜索记录
        self.searchBar.text = nil
        self.filtered = []
        
        
        
        let tag = sender.tag
        sender.isSelected = true
        for  index in 1..<6{
            if(index+100 != tag){
            let btn = view.viewWithTag(100+index) as! UIButton
            btn.isSelected = false
//            print("\(index) is disselected")
            }
        }
        switch tag{
        case 101:
            original = ["常用1","常用2","常用3","常用4","常用5"]
            
        case 102:
            original = queryById(id: "AV")
            
        case 103:
            original = queryById(id: "MA")
            
        case 104:
            original = queryById(id: "RP")
            
        case 105:
            original = queryById(id: "AM")
            
        default:
            print("")
        }
        searching = false
        updateView()
    }
    
    @IBAction func btnGoto(_ sender: UIButton) {
        print("btn goto")
        var vc:UIViewController?
        let tag = sender.tag
        switch tag {
        case 10:
            vc = storyboard?.instantiateViewController(withIdentifier: "daily")
            let daily = vc as! DailyViewController

            daily.array = self.array
        case 11:
            vc = storyboard?.instantiateViewController(withIdentifier: "express")
            let express = vc as! ExpressViewController
            express.array = self.array
        default:
            print("跳转错误")
        }
        self.navigationController?.pushViewController(vc!, animated: true)

    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear")
        super.viewWillAppear(animated)
            }
    override func viewDidAppear(_ animated: Bool) {
        let app = UIApplication.shared.delegate as! AppDelegate
        context = app.persistentContainer.viewContext
        yydmDescription = NSEntityDescription.entity(forEntityName: "Yydm", in: context)
    }
    
    var resultDic: NSDictionary?
    override func viewDidLoad() {
//        print("view did load")
        super.viewDidLoad()
        self.navigationController?.setToolbarHidden(true, animated: false)
        initSource()
        initButtons()
        updateView()

        // Do any additional setup after loading the view.
    }
    
    func initSource(){
        title = "日报快报"
        self.searchBar.delegate = self
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
    }
    
    func  initButtons(){
        if !firstLoad{
            return
        }
        btn_Daily.isEnabled = false
        btn_Express.isEnabled = false
        for  index in 1..<6{
            let btn = view.viewWithTag(100+index) as! UIButton
            if(index == 1){
                btn.isSelected = true
            }else{
                btn.isSelected = false
                
            }
        }
        //load the normal label
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("view will dis appear")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    var original: [String] = []
    var filtered: [String] = []
    
    var searching = false
    
    
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
//    {
//        return (searching) ? filtered.count : original.count
//    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
//    {
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "wrongCell")!
//        
//        let item = (searching) ? filtered[indexPath.row] : original[indexPath.row]
//        
//        cell.textLabel?.text = item
////        print("cell fill content")
//        return cell
//    }
   
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searching = false
        
        updateView()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
    {
//        searching = false
//
//        updateView()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        print("search bar text did begin editing")
        searching = true
        
    
        
        updateView()
    }
    //data  source  delegate
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if (searchText.isEmpty)
        {
            self.filtered = original
            searching = false
            searchBar.resignFirstResponder()
        }
        else
        {
            let filteredItems = original.filter({$0.contains(searchText)})
            
            self.filtered = filteredItems
        }
        
        updateView()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        print("------searchBarSearchButtonClicked----")
        
        searchBar.resignFirstResponder()
        searching = true
        
        updateView()
    }
    // reload date  and  remove the dic
    func updateView(){
        collectionView.reloadData()
        dic.removeAll()
    }
    func queryById(id: String) -> Array<String>{
        var array: Array<String> = Array()
        do {
            let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Yydm")
            request.predicate = NSPredicate.init(format: "id CONTAINS %@ ", id)
            
            let result = try! context.fetch(request) as! [Yydm] as Array
            NSLog("result couunt is %d", result.count)
            for yydm in result{
                array.append(yydm.yymc!)
            }
            return array
        } catch {
            print("query error")
        }
       return array
        
    }
    
//    func queryCommon() -> Array<Yydm>{
//        do {
//            let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Yydm")
//            
//            return try! context.fetch(request) as! [Yydm] as Array
//        } catch {
//            print("query error")
//        }
//        return Array()
//        
//    }
    
  }



extension AddViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    // #MARK: --UICollectionViewDataSource的代理方法
    /**
     - 该方法是可选方法，默认为1
     - returns: CollectionView中section的个数
     */
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /**
     - returns: Section中Item的个数
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (searching) ? filtered.count : original.count
    }
    
    /**
     - returns: 绘制collectionView的cell
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        if(!dic.keys.contains(row)){
            dic[row] = false
        }
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! UICollectionViewCell
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.borderWidth = 0.3;
        let item = (searching) ? filtered[indexPath.row] : original[indexPath.row]
        let iv = cell.viewWithTag(99) as! UIImageView
        let label = cell.viewWithTag(100) as! UILabel
        let btn = cell.viewWithTag(101) as! UIButton
        iv.image = UIImage(named: "bird")
        label.text = "\(item)"
//        tag.text
        btn.backgroundColor =  dic[row]! ? UIColor.blue : UIColor.white
        
        
        return cell
    }
    
    /**
     - returns: 返回headview或者footview
     */
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headView", for: indexPath)
        headView.backgroundColor = UIColor.white
        
        return headView
    }
    
    // #MARK: --UICollectionViewDelegate的代理方法
    /**
     Description:当点击某个Item之后的回应
     */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("(\(indexPath.section),\(indexPath.row))")
        var btn = collectionView.cellForItem(at: indexPath)?.viewWithTag(101) as! UIButton
        let row = indexPath.row
        dic[row] = !dic[row]!
        btn.backgroundColor =  dic[row]! ? UIColor.blue : UIColor.white
        sums = 0
        array.removeAll()
        for var key in dic.keys{
            if dic[key]!{
                
                print("\(key) -> \(dic[key]!)\t")
                sums += 1
                array.insert((searching) ? filtered[key] : original[key], at: 0)
            }
        }
        if sums > 0{
            btn_Express.isEnabled = true
            btn_Daily.isEnabled = true
        }else{
            btn_Express.isEnabled = false
            btn_Daily.isEnabled = false
        }
    }
    
    //#MARK: --UICollectionViewDelegateFlowLayout的代理方法
    /**
     - returns: header的大小
     */
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: width, height: 17)
//    }
    /**
     Description:可以定制不同的item
     
     - returns: item的大小
     */
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if  indexPath.row % 2 == 1{
//            return CGSize(width: width/2, height: height/3)
//        }
//        else{
//            return CGSize(width: width/2, height: height/2)
//        }
//    }
}

