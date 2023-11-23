//
//  DatabaseManager.swift
//  BluBankTask
//
//  Created by Faraz on 11/23/23.
//

import Foundation

protocol DatabaseManagerProtocol {
    func save<T: Codable>(object: T, forKey key: String)
    func load<T: Codable>(forKey key: String) -> T?
    func loadAll<T: Codable>(type: T.Type) -> [T]
    func remove(forKey key: String)
}

struct Database: DatabaseManagerProtocol {
    private let userDefaults: UserDefaultsProtocol
    private let keyPrefix: String

    init(userDefaults: UserDefaultsProtocol = UserDefaults.standard, keyPrefix: String = "com.bluTask.database.") {
        self.userDefaults = userDefaults
        self.keyPrefix = keyPrefix
    }

    func save<T: Codable>(object: T, forKey key: String) {
        do {
            let data = try JSONEncoder().encode(object)
            userDefaults.set(data, forKey: keyPrefix + key)
        } catch {
            print("Error saving object: \(error)")
        }
    }

    func load<T: Codable>(forKey key: String) -> T? {
        guard let data = userDefaults.data(forKey: keyPrefix + key) else {
            return nil
        }

        do {
            let object = try JSONDecoder().decode(T.self, from: data)
            return object
        } catch {
            print("Error loading object: \(error)")
            return nil
        }
    }

    func loadAll<T: Codable>(type: T.Type) -> [T] {
        let keys = userDefaults.dictionaryRepresentation().keys.filter { $0.hasPrefix(keyPrefix) }
        let objects: [T] = keys.compactMap { key in
            guard let data = userDefaults.data(forKey: key) else {
                return nil
            }

            do {
                let object = try JSONDecoder().decode(T.self, from: data)
                return object
            } catch {
                print("Error loading object: \(error)")
                return nil
            }
        }

        return objects
    }

    func remove(forKey key: String) {
        userDefaults.removeObject(forKey: keyPrefix + key)
    }
}

import CoreData

class DatabaseManager {

    let coreDataStack: CoreDataStack

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    func save<T: NSManagedObject>(_ instance: T) {
        let context = coreDataStack.viewContext
        context.insert(instance)
        coreDataStack.saveContext()
    }

    func load<T: NSManagedObject>(withID id: NSManagedObjectID) -> T? {
        let context = coreDataStack.viewContext
        do {
            return try context.existingObject(with: id) as? T
        } catch {
            print("Error loading object of type \(T.self): \(error.localizedDescription)")
            return nil
        }
    }

    func loadAll<T: NSManagedObject>(T: T.Type) -> [T] {
        let context = coreDataStack.viewContext
        let fetchRequest: NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error loading all objects of type \(T.self): \(error.localizedDescription)")
            return []
        }
    }

    func remove<T: NSManagedObject>(_ instance: T) {
        let context = coreDataStack.viewContext
        context.delete(instance)
        coreDataStack.saveContext()
    }
}

class CoreDataStack {

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "YourProjectName")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
