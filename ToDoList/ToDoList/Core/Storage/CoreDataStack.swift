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

final class CoreDataStack {
    
    // MARK: - Constants
    
    private enum Constants {
        static let unableToLoadCoreDataStoresFormat = "Unable to load Core Data stores: %@"
    }
    
    static let shared = CoreDataStack()
    
    private let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: String.coreCoreDataName)
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError(String(
                    format: Constants.unableToLoadCoreDataStoresFormat,
                    error.localizedDescription
                ))
            }
        }
    }
    
}

// MARK: - CoreDataStackProtocol

extension CoreDataStack: CoreDataStackProtocol {
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
    
}
