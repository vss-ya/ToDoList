//
//  TaskRepository.swift
//  ToDoList
//
//  Created by vs on 27.08.2025.
//

import CoreData

protocol TaskRepositoryProtocol {
    func pullTasks(completion: @escaping (Result<[TaskEntity], Error>) -> Void)
    func fetchTasks(completion: @escaping (Result<[TaskEntity], Error>) -> Void)
    func saveTasks(_ dtos: [TaskDTO], completion: @escaping (Result<Void, Error>) -> Void)
    func createTask(title: String, description: String?, completion: @escaping (Result<TaskEntity, Error>) -> Void)
    func updateTask(_ task: TaskEntity, title: String, description: String?, isCompleted: Bool, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteTask(_ task: TaskEntity, completion: @escaping (Result<Void, Error>) -> Void)
    func searchTasks(query: String, completion: @escaping (Result<[TaskEntity], Error>) -> Void)
}

final class TaskRepository: TaskRepositoryProtocol {
    private let coreDataStack: CoreDataStackProtocol
    private let taskAPI: TaskAPIProtocol
    
    init(coreDataStack: CoreDataStackProtocol = CoreDataStack.shared,
         taskAPI: TaskAPIProtocol = TaskAPI()) {
        self.coreDataStack = coreDataStack
        self.taskAPI = taskAPI
    }
    
    func pullTasks(completion: @escaping (Result<[TaskEntity], Error>) -> Void) {
        taskAPI.fetchTasks { [weak self] result in
            switch result {
            case .success(let dtos):
                self?.saveTasks(dtos) { saveResult in
                    if case .failure(let error) = saveResult {
                        print("Failed to save initial data: \(error)")
                    }
                    self?.fetchTasks(completion: completion)
                }
            case .failure(let error):
                print("Failed to fetch initial data: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func fetchTasks(completion: @escaping (Result<[TaskEntity], Error>) -> Void) {
        coreDataStack.performBackgroundTask { context in
            let request = TaskEntity.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            do {
                let tasks = try context.fetch(request)
                completion(.success(tasks))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func saveTasks(_ dtos: [TaskDTO], completion: @escaping (Result<Void, Error>) -> Void) {
        coreDataStack.performBackgroundTask { context in
            do {
                for dto in dtos {
                    let request = TaskEntity.fetchRequest()
                    request.predicate = NSPredicate(format: "id == %d", dto.id)
                    
                    let task = try context.fetch(request).first ?? TaskEntity(context: context)
                    
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
    
    func createTask(title: String, description: String?, completion: @escaping (Result<TaskEntity, Error>) -> Void) {
        coreDataStack.performBackgroundTask { context in
            let task = TaskEntity(context: context)
            task.id = Int64(Date().timeIntervalSince1970)
            task.title = title
            task.taskDescription = description
            task.isCompleted = false
            task.creationDate = Date()
            
            do {
                try context.save()
                completion(.success(task))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func updateTask(_ task: TaskEntity, title: String, description: String?, isCompleted: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        coreDataStack.performBackgroundTask { context in
            guard let object = try? context.existingObject(with: task.objectID) as? TaskEntity else {
                completion(.failure(NSError(domain: "TaskEntityNotFound", code: 404)))
                return
            }
            
            object.title = title
            object.taskDescription = description
            object.isCompleted = isCompleted
            
            do {
                try context.save()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func deleteTask(_ task: TaskEntity, completion: @escaping (Result<Void, Error>) -> Void) {
        coreDataStack.performBackgroundTask { context in
            guard let object = try? context.existingObject(with: task.objectID) else {
                completion(.failure(NSError(domain: "TaskEntityNotFound", code: 404)))
                return
            }
            
            context.delete(object)
            
            do {
                try context.save()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func searchTasks(query: String, completion: @escaping (Result<[TaskEntity], Error>) -> Void) {
        coreDataStack.performBackgroundTask { context in
            let request = TaskEntity.fetchRequest()
            request.predicate = NSPredicate(
                format: "title CONTAINS[cd] %@ OR taskDescription CONTAINS[cd] %@",
                query, query
            )
            request.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            do {
                let tasks = try context.fetch(request)
                completion(.success(tasks))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
