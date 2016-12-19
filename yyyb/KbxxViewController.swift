//
//  KbxxViewController.swift
//  yyyb
//
//  Created by admin on 2016/12/13.
//  Copyright © 2016年 norwaya. All rights reserved.
//

import UIKit
import CoreData
class KbxxViewController: UIViewController {
    
    var dataSourceArray: Array<Kbxx> = Array()
    var context:NSManagedObjectContext!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let app = UIApplication.shared.delegate as! AppDelegate
        context = app.persistentContainer.viewContext
        // Do any additional setup after loading the view.
        initDataSource()
    }
    @IBOutlet weak var tableView: UITableView!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initDataSource(){
        dataSourceArray.removeAll()
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Kbxx")
        request.predicate = NSPredicate.init(format: " isupload = false")
        let result = try? context.fetch(request) as! [Kbxx] as Array
        for kbxx in result! {
            dataSourceArray.append(kbxx)
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
    func deleteItem(index:Int){
        
        do {
            NSLog("name is %@", dataSourceArray[index].name!)
            context.delete(dataSourceArray[index])
            try context.save()
            dataSourceArray.remove(at: index)
        } catch  {
            
        }
    }


}
extension KbxxViewController:UITableViewDelegate,UITableViewDataSource{
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
