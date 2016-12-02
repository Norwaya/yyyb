//
//  CoreDataStack.swift
//  yyyb
//
//  Created by admin on 2016/12/2.
//  Copyright © 2016年 norwaya. All rights reserved.
//
import Foundation
import CoreData

class CoreDataStack {
    
    var context:NSManagedObjectContext
    var psc:NSPersistentStoreCoordinator
    var model:NSManagedObjectModel
    var store:NSPersistentStore?
    
    init() {
        
        let bundle = Bundle.main
        let modeURL = bundle.url(forResource: "yyyb", withExtension: "momd")
        model = NSManagedObjectModel(contentsOf: modeURL!)!
        
        psc = NSPersistentStoreCoordinator(managedObjectModel:model)
        
        // 异步fetch不支持默认的concurrencyType，这里修改为.MainQueueConcurrencyType
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = psc
        
        let documentsURL = applicationDocumentsDirectory()
        let storeURL =
            documentsURL.appendingPathComponent("yyyb")
        
        let options =
            [NSMigratePersistentStoresAutomaticallyOption: true]
        
            
        do {
             store =  try? psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
        } catch  {
            print("Error adding persistent store: ")
            abort()
        }
        if store == nil {
            print("store is nil ")
        }
    }
    
    func saveContext() {
        do{
            try? context.save()
        }catch{
            
        }
//        var error: NSError? = nil
//        if  {
//            println("Could not save: \(error), \(error?.userInfo)")
//        }
        
    }
    
    func applicationDocumentsDirectory() -> NSURL {
        
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask) as Array<NSURL>
        
        return urls[0]
    }
    
}
