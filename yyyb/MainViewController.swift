//
//  MainViewController.swift
//  yyyb
//
//  Created by admin on 2016/11/19.
//  Copyright © 2016年 norwaya. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!
    var sections: Array<String>!
    var titles: Array<Array<String>>!
    var classNames: Array<Array<UIViewController.Type>>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "yyyb-Demo"
        
        initTableData()
//        initTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.isToolbarHidden = true
    }
    
    func initTableData() {
        
        let sec1Title = "基本功能"
        let sec1CellTitles = ["监测记录",
                              "信息查询",
                              "疫源库",
                              "疫病库",
                              "应急通讯",
                              "通知公告",
                              "专家库",
                              "使用说明",
                              "单次定位地图展示",
                              "单次定位不带地图展示",
                              "连续定位",
                              "后台连续定位",
                              "地理围栏"]
        let sec1ClassNames: Array<UIViewController.Type> = [StartMonistroViewController.self,
                                                            StartMonistroViewController.self,
                                                            StartMonistroViewController.self,
                                                            StartMonistroViewController.self,
                                                            StartMonistroViewController.self,
                                                            StartMonistroViewController.self,
                                                            StartMonistroViewController.self,
                                                            StartMonistroViewController.self,
                                                            SingleLocationViewController.self,
                                                            SingleLocationAloneViewController.self,
                                                            SerialLocationViewController.self,
                                                            BackgroundLocationViewController.self,
                                                            MonitoringRegionViewController.self]
        
        sections = [sec1Title]
        titles = [sec1CellTitles]
        classNames = [sec1ClassNames]
    }
    
    func initTableView() {
        
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
    }
    
    //MARK:- TableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        let title = titles[indexPath.section][indexPath.row]
        let vcClass = classNames[indexPath.section][indexPath.row]
        let vcInstance = TableViewController()
//            vcClass.init()
        vcInstance.title = title
        
        self.navigationController?.pushViewController(vcInstance, animated: true)
    }
    
    //MARK:- TableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "mainCellIdentifier"
        let nib:UINib = UINib(nibName: "CustomCellTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        let cell: CustomCellTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! CustomCellTableViewCell
        cell.setLabel(name: titles[indexPath.section][indexPath.row])
//        if cell == nil {
//            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellIdentifier) as! CustomCellTableViewCell
//            cell.accessoryType = .disclosureIndicator
//        }
//        
//        cell.textLabel?.text = titles[indexPath.section][indexPath.row]
//        cell.detailTextLabel?.text = String(describing: classNames[indexPath.section][indexPath.row])
        
        return cell
    }
    

}
