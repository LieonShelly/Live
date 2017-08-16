//
//  CoreData.swift
//  Live
//
//  Created by lieon on 2017/6/20.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
// swiftlint:disable force_unwrapping

import Foundation
import CoreData

class CoreDataManager {
    // MARK: - Core Data stack
    static let sharedInstance = CoreDataManager()
    
    private lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "Live", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("CoreDataSwift.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            let options = [ NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true ]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {

            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        
        if #available(iOS 10.0, *) {
            
           return self.persistentContainer.viewContext
        } else {
            let coordinator = self.persistentStoreCoordinator
           let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            managedObjectContext.persistentStoreCoordinator = coordinator
            return managedObjectContext
        }

    }()
    // iOS-10
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Live")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
            
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        print("\(self.applicationDocumentsDirectory)")
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}

// MARK: SAVE SEARCHHISTORY
extension CoreDataManager {
    func saveSearchHistory(name: String) {
        let fetchRequest: NSFetchRequest<SearchHistory> = SearchHistory.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name=%@", name)
        guard let searchResulst = try? self.managedObjectContext.fetch(fetchRequest) else {
            return
        }
        searchResulst.forEach { history in
            self.managedObjectContext.delete(history)
        }
        guard let history: SearchHistory = NSEntityDescription.insertNewObject(forEntityName: "SearchHistory", into: self.managedObjectContext) as? SearchHistory else {  return  }
        history.name = name
        saveContext()
    }
    
    func getSearchHistory() -> [String?]? {
        let fetchRequest: NSFetchRequest<SearchHistory> = SearchHistory.fetchRequest()
        guard let searchResulst = try? self.managedObjectContext.fetch(fetchRequest) else {
            return nil
        }
        return searchResulst.map { $0.name }
    }
    
    func clearAllHistory() {
        let fetchRequest: NSFetchRequest<SearchHistory> = SearchHistory.fetchRequest()
        guard let searchResulst = try? self.managedObjectContext.fetch(fetchRequest) else {
            return
        }
        if searchResulst.isEmpty {
            return
        }
        for history in searchResulst {
            managedObjectContext.delete(history)
        }
        saveContext()
    }
}

// MARK: SAVE Local User
extension CoreDataManager {
    func save(userInfo: UserInfo) {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        guard let searchResulst = try? self.managedObjectContext.fetch(fetchRequest) else {
            return
        }
        if searchResulst.isEmpty {
            guard let user: User = NSEntityDescription.insertNewObject(forEntityName: "User", into: self.managedObjectContext) as? User else {  return  }
            user.userId = Int32(userInfo.userId)
            user.userSign = userInfo.userSign
            user.avatar = userInfo.avatar
            user.nickName = userInfo.nickName
            user.point = Int32(userInfo.point)
            user.level = Int32(userInfo.level)
            user.phone = userInfo.phone
            user.isComplete = userInfo.isComplete
        } else {
            for user in searchResulst {
                user.userId = Int32(userInfo.userId)
                user.userSign = userInfo.userSign
                user.avatar = userInfo.avatar
                user.nickName = userInfo.nickName
                user.point = Int32(userInfo.point)
                user.level = Int32(userInfo.level)
                user.phone = userInfo.phone
                user.isComplete = userInfo.isComplete
            }
        }
        saveContext()
    }
    
    func getUserInfo() -> UserInfo? {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        guard let searchResulst = try? self.managedObjectContext.fetch(fetchRequest) else {
            return nil
        }
        guard let user = searchResulst.last else {
            return nil
        }
        let info = UserInfo()
        info.userId = Int(user.userId)
        info.userSign = user.userSign
        info.avatar = user.avatar
        info.nickName = user.nickName
        info.point = Int(user.point)
        info.level = Int(user.level)
        info.phone = user.phone
        info.isComplete = user.isComplete
        return info
    }
    
    func clearUserInfo() {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        guard let searchResulst = try? self.managedObjectContext.fetch(fetchRequest) else {
            return
        }
        if searchResulst.isEmpty {
            return
        }
        for user in searchResulst {
            managedObjectContext.delete(user)
        }
        saveContext()
    }
}
