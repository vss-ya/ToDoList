//
//  CoreDataStack.swift
//  ToDoList
//
//  Created by vs on 27.08.2025.
//

import CoreData

protocol CoreDataStackProtocol {
    var viewContext: NSManagedObjectContext { get }
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void)
}

final class CoreDataStack: CoreDataStackProtocol {
    
    static let shared = CoreDataStack()
    
    private let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "TodoApp")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load Core Data stores: \(error)")
            }
        }
    }
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
    
}
