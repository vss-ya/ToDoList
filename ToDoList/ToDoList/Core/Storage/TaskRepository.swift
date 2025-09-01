//
//  TaskRepository.swift
//  ToDoList
//
//  Created by vs on 27.08.2025.
//

import CoreData

protocol TaskRepositoryProtocol {
    func pullTasks(completion: @escaping (Result<[ToDoModel], Error>) -> Void)
    func fetchTasks(completion: @escaping (Result<[ToDoModel], Error>) -> Void)
    func saveTasks(_ dtos: [ToDoDTO], completion: @escaping (Result<Void, Error>) -> Void)
    func createTask(title: String, description: String?, completion: @escaping (Result<ToDoModel, Error>) -> Void)
    func updateTask(_ task: ToDoModel, title: String, description: String?, isCompleted: Bool, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteTask(_ task: ToDoModel, completion: @escaping (Result<Void, Error>) -> Void)
    func searchTasks(query: String, completion: @escaping (Result<[ToDoModel], Error>) -> Void)
}

final class TaskRepository {
    
    // MARK: - Constants
    
    private enum Constants {
        static let failedToSaveInitialDataFormat = "Failed to save initial data: %@"
        static let failedToFetchInitialDataFormat = "Failed to fetch initial data: %@"
        
        static let creationDateKey = "creationDate"
        static let idEqPredicateFormat = "id == %i"
        static let searchPredicateFormat: String = "title CONTAINS[cd] %@ OR taskDescription CONTAINS[cd] %@"
    }
    
    private let coreDataStack: CoreDataStackProtocol
    private let taskAPI: ToDoAPIProtocol
    
    init(coreDataStack: CoreDataStackProtocol = CoreDataStack.shared,
         taskAPI: ToDoAPIProtocol = ToDoAPI()) {
        self.coreDataStack = coreDataStack
        self.taskAPI = taskAPI
    }
    
}

// MARK: - TaskRepositoryProtocol

extension TaskRepository: TaskRepositoryProtocol{
    
    func pullTasks(completion: @escaping (Result<[ToDoModel], Error>) -> Void) {
        taskAPI.fetchTasks { [weak self] result in
            switch result {
            case .success(let dtos):
                self?.saveTasks(dtos) { saveResult in
                    if case .failure(let error) = saveResult {
                        print(String(
                            format: Constants.failedToSaveInitialDataFormat,
                            error.localizedDescription
                        ))
                    }
                    self?.fetchTasks(completion: completion)
                }
            case .failure(let error):
                print(String(
                    format: Constants.failedToFetchInitialDataFormat,
                    error.localizedDescription
                ))
                completion(.failure(error))
            }
        }
    }
    
    func fetchTasks(completion: @escaping (Result<[ToDoModel], Error>) -> Void) {
        coreDataStack.performBackgroundTask { context in
            let request = ToDoEntity.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(
                key: Constants.creationDateKey, ascending: false
            )]
            
            do {
                let tasks = try context.fetch(request)
                completion(.success(tasks.map(ToDoModel.init)))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func saveTasks(
        _ dtos: [ToDoDTO],
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        coreDataStack.performBackgroundTask { context in
            do {
                for dto in dtos {
                    let request = ToDoEntity.fetchRequest()
                    request.predicate = NSPredicate(format: Constants.idEqPredicateFormat, dto.id)
                    
                    let task = try context.fetch(request).first ?? ToDoEntity(context: context)
                    
                    task.creationDate = Date()
                    task.id = Int64(dto.id)
                    task.isCompleted = dto.completed
                    task.taskDescription = dto.todo
                    task.title = "# \(dto.id)"
                }
                
                try context.save()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func createTask(
        title: String,
        description: String?,
        completion: @escaping (Result<ToDoModel, Error>) -> Void
    ) {
        coreDataStack.performBackgroundTask { context in
            let task = ToDoEntity(context: context)
            task.id = Int64(Date().timeIntervalSince1970)
            task.title = title
            task.taskDescription = description
            task.isCompleted = false
            task.creationDate = Date()
            
            do {
                try context.save()
                completion(.success(ToDoModel(task)))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func updateTask(
        _ task: ToDoModel,
        title: String,
        description: String?,
        isCompleted: Bool,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        coreDataStack.performBackgroundTask { context in
            do {
                let request = ToDoEntity.fetchRequest()
                request.predicate = NSPredicate(format: Constants.idEqPredicateFormat, task.id)
                
                let object = try context.fetch(request).first ?? ToDoEntity(context: context)
                
                object.title = title
                object.taskDescription = description
                object.isCompleted = isCompleted
                
                try context.save()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func deleteTask(
        _ task: ToDoModel,
        completion: @escaping (Result<Void, Error>
        ) -> Void
    ) {
        coreDataStack.performBackgroundTask { context in
            do {
                let request = ToDoEntity.fetchRequest()
                request.predicate = NSPredicate(format: Constants.idEqPredicateFormat, task.id)
                
                let object = try context.fetch(request).first ?? ToDoEntity(context: context)
                
                context.delete(object)
                
                try context.save()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func searchTasks(
        query: String,
        completion: @escaping (Result<[ToDoModel], Error>) -> Void
    ) {
        coreDataStack.performBackgroundTask { context in
            let request = ToDoEntity.fetchRequest()
            request.predicate = NSPredicate(
                format: Constants.searchPredicateFormat,
                query, query
            )
            request.sortDescriptors = [NSSortDescriptor(
                key: Constants.creationDateKey, ascending: false
            )]
            
            do {
                let tasks = try context.fetch(request)
                completion(.success(tasks.map(ToDoModel.init)))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
}
