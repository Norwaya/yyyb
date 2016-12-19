//
//  RbxxViewController.swift
//  yyyb
//
//  Created by admin on 2016/12/13.
//  Copyright © 2016年 norwaya. All rights reserved.
//

import UIKit
import CoreData
class RbxxViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var dataSourceArray: Array<Rbxx> = Array()
    var context:NSManagedObjectContext!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
//        initItemBar()
        let app = UIApplication.shared.delegate as! AppDelegate
        context = app.persistentContainer.viewContext
        // Do any additional setup after loading the view.
        
        
        initDataSource()
        
        
    }
            override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initDataSource(){
        dataSourceArray.removeAll()
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Rbxx")
        request.predicate = NSPredicate.init(format: " isupload = false")
        let result = try? context.fetch(request) as! [Rbxx] as Array
        NSLog("count num is \(result?.count)")
        for rbxx in result! {
            dataSourceArray.append(rbxx)
        }
    }
    func deleteItem(index:Int){
        
        do {
            NSLog("name is %@", dataSourceArray[index].name!)
            context.delete(dataSourceArray[index])
            try context.save()
            dataSourceArray.remove(at: index)
        } catch  {
            
        }
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
extension RbxxViewController: UITableViewDelegate,UITableViewDataSource{
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = self.dataSourceArray[indexPath.row].name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceArray.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        print("commit \(editingStyle)")
        if(editingStyle == UITableViewCellEditingStyle.delete){
            deleteItem(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
}
