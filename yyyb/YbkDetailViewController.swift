//
//  YbkDetailViewController.swift
//  yyyb
//
//  Created by admin on 2016/12/21.
//  Copyright © 2016年 norwaya. All rights reserved.
//

import UIKit
import CoreData
class YbkDetailViewController: UIViewController {
    @IBOutlet weak var ybmc: UILabel!
    @IBOutlet weak var ldmc: UILabel!
    @IBOutlet weak var szsbm: UILabel!
    @IBOutlet weak var ybsbm: UILabel!
    @IBOutlet weak var ybdm: UILabel!
    
    var name:String!
    var id:String!
    
    var context:NSManagedObjectContext?
    override func viewDidLoad() {
        super.viewDidLoad()
        let app = UIApplication.shared.delegate as! AppDelegate
        self.context = app.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Ybdm")
        request.predicate = NSPredicate.init(format: "id = %@", id)
        let result = try? context?.fetch(request) as! [Ybdm] as Array
        if (result?.count)! > 0{
            let entity = result?[0]
            
            ybmc.text = entity?.ybmc?.description
            ldmc.text = entity?.ywmc?.description
            szsbm.text = entity?.szsbm?.description
            ybsbm.text = entity?.ybsbm?.description
            ybdm.text = entity?.ybdm?.description
            
        }
        
        
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

}
