//
//  PersistenceService.swift
//  Virtual Tourist
//
//  Created by Phizer Cost on 11/27/18.
//  Copyright © 2018 Phizer Cost. All rights reserved.
//

import Foundation
import CoreData

class PersistenceService {
    
    private init(){}
    
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "VirtualTourist")
        container.loadPersistentStores(completionHandler: {(storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    static func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    static func fetchPin(latitude: String, longitude: String,entityName: String, sorting: NSSortDescriptor? = nil) throws -> Pin? {
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        let predicate = NSPredicate(format: "latitude == %@ AND longitude == %@", latitude, longitude)
        fetchRequest.predicate = predicate
        if let sorting = sorting {
            fetchRequest.sortDescriptors = [sorting]
        }
        guard let pin = (try PersistenceService.context.fetch(fetchRequest)).first else {
            return nil
        }
        return pin
    }
    
    static func loadPin(latitude: String, longitude: String) -> Pin? {
        var pin: Pin?
        do {
            try pin = fetchPin(latitude: latitude, longitude: longitude, entityName: "Pin")
        } catch {
            print("\(#function) error:\(error)")
        }
        return pin
    }
    
    
    static func dropAllData(){
        if let psc = PersistenceService.context.persistentStoreCoordinator{
            
            if let store = psc.persistentStores.last{
                let storeUrl = psc.url(for: store)
                PersistenceService.context.performAndWait(){
                    PersistenceService.context.reset()
                    try! FileManager.default.removeItem(at: storeUrl)
                }
            }
        }
    }
}
