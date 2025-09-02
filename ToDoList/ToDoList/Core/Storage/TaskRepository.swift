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
    }
    
    private let storage: Storage
    private let taskAPI: ToDoAPIProtocol
    
    init(
        storage: Storage,
        taskAPI: ToDoAPIProtocol = ToDoAPI())
    {
        self.storage = storage
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
        storage.fetchTasks(completion: completion)
    }
    
    func saveTasks(
        _ dtos: [ToDoDTO],
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        storage.saveTasks(dtos, completion: completion)
    }
    
    func createTask(
        title: String,
        description: String?,
        completion: @escaping (Result<ToDoModel, Error>) -> Void
    ) {
        storage.createTask(
            title: title,
            description: description,
            completion: completion
        )
    }
    
    func updateTask(
        _ task: ToDoModel,
        title: String,
        description: String?,
        isCompleted: Bool,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        storage.updateTask(
            task,
            title: title,
            description: description,
            isCompleted: isCompleted,
            completion: completion
        )
    }
    
    func deleteTask(
        _ task: ToDoModel,
        completion: @escaping (Result<Void, Error>
        ) -> Void
    ) {
        storage.deleteTask(task, completion: completion)
    }
    
    func searchTasks(
        query: String,
        completion: @escaping (Result<[ToDoModel], Error>) -> Void
    ) {
        storage.searchTasks(query: query, completion: completion)
    }
    
}
