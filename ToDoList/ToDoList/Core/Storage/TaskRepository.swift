//
//  TaskRepository.swift
//  ToDoList
//
//  Created by vs on 27.08.2025.
//

import CoreData

protocol TaskRepositoryProtocol {
    func pullTasks(completion: @escaping (Result<[TaskModel], Error>) -> Void)
    func fetchTasks(completion: @escaping (Result<[TaskModel], Error>) -> Void)
    func saveTasks(_ dtos: [TaskDTO], completion: @escaping (Result<Void, Error>) -> Void)
    func createTask(title: String, description: String?, completion: @escaping (Result<TaskModel, Error>) -> Void)
    func updateTask(_ task: TaskModel, title: String, description: String?, isCompleted: Bool, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteTask(_ task: TaskModel, completion: @escaping (Result<Void, Error>) -> Void)
    func searchTasks(query: String, completion: @escaping (Result<[TaskModel], Error>) -> Void)
}

final class TaskRepository: TaskRepositoryProtocol {
    
    private let coreDataStack: CoreDataStackProtocol
    private let taskAPI: TaskAPIProtocol
    
    init(coreDataStack: CoreDataStackProtocol = CoreDataStack.shared,
         taskAPI: TaskAPIProtocol = TaskAPI()) {
        self.coreDataStack = coreDataStack
        self.taskAPI = taskAPI
    }
    
    func pullTasks(completion: @escaping (Result<[TaskModel], Error>) -> Void) {
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
    
    func fetchTasks(completion: @escaping (Result<[TaskModel], Error>) -> Void) {
        coreDataStack.performBackgroundTask { context in
            let request = TaskEntity.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            do {
                let tasks = try context.fetch(request)
                completion(.success(tasks.map(TaskModel.init)))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func saveTasks(
        _ dtos: [TaskDTO],
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        coreDataStack.performBackgroundTask { context in
            do {
                for dto in dtos {
                    let request = TaskEntity.fetchRequest()
                    request.predicate = NSPredicate(format: "id == %i", dto.id)
                    
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
    
    func createTask(
        title: String,
        description: String?,
        completion: @escaping (Result<TaskModel, Error>) -> Void
    ) {
        coreDataStack.performBackgroundTask { context in
            let task = TaskEntity(context: context)
            task.id = Int64(Date().timeIntervalSince1970)
            task.title = title
            task.taskDescription = description
            task.isCompleted = false
            task.creationDate = Date()
            
            do {
                try context.save()
                completion(.success(TaskModel(task)))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func updateTask(
        _ task: TaskModel,
        title: String,
        description: String?,
        isCompleted: Bool,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        coreDataStack.performBackgroundTask { context in
            do {
                let request = TaskEntity.fetchRequest()
                request.predicate = NSPredicate(format: "id == %i", task.id)
                
                let object = try context.fetch(request).first ?? TaskEntity(context: context)
                
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
        _ task: TaskModel,
        completion: @escaping (Result<Void, Error>
        ) -> Void
    ) {
        coreDataStack.performBackgroundTask { context in
            do {
                let request = TaskEntity.fetchRequest()
                request.predicate = NSPredicate(format: "id == %i", task.id)
                
                let object = try context.fetch(request).first ?? TaskEntity(context: context)
                
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
        completion: @escaping (Result<[TaskModel], Error>) -> Void
    ) {
        coreDataStack.performBackgroundTask { context in
            let request = TaskEntity.fetchRequest()
            request.predicate = NSPredicate(
                format: "title CONTAINS[cd] %@ OR taskDescription CONTAINS[cd] %@",
                query, query
            )
            request.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            do {
                let tasks = try context.fetch(request)
                completion(.success(tasks.map(TaskModel.init)))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
}
