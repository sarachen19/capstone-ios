//
//  CoreDataManager.swift
//  chunyang-tea
//
//  Created by 陈西 on 2021-02-03.
//

import Foundation
import CoreData
class CoreDataManager {
    static var shared = CoreDataManager()
    
//    func insertNewCity(name : String, province : String, country : String) {
//        
//        let newCity = City(context: persistentContainer.viewContext)
//        newCity.name = name
//        newCity.province = province
//        newCity.country = country
//        
//        saveContext()
//    }
//    func deleteCity(cityToDelete : City)  {
//        persistentContainer.viewContext.delete(cityToDelete)
//        saveContext()
//    }
    
//    func fetchCitiesFromCoreData() -> [City]{
//        let fetch : NSFetchRequest =  City.fetchRequest()
//        fetch.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: true)]
//        var result : [City] = [City]()
//        do{
//            result = try (persistentContainer.viewContext.fetch(fetch) as? [City])!
//        }catch{
//
//        }
//        return result
//    }
//
//    func search(text : String) -> [City] {
//        let fetch : NSFetchRequest =  City.fetchRequest()
//            let predicate = NSPredicate(format: "name BEGINSWITH [c] %@", text)
//            // select * from ToDo where task BEGINSWITH
//            fetch.predicate = predicate
//            var result : [City] = [City]()
//                   do{
//                       result = try (persistentContainer.viewContext.fetch(fetch) as? [City])!
//                   }catch{
//                   }
//            return result
//    }
    
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "chunyang_project")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
