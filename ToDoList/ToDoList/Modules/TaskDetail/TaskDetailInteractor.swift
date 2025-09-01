//
//  TaskDetailInteractor.swift
//  ToDoList
//
//  Created by vs on 31.08.2025.
//

import Foundation

final class TaskDetailInteractor {
    
    private let task: TaskModel?
    private let taskRepository: TaskRepositoryProtocol
    
    init(task: TaskModel?, taskRepository: TaskRepositoryProtocol = TaskRepository()) {
        self.task = task
        self.taskRepository = taskRepository
    }
    
}

// MARK: - TaskDetailInteractorProtocol

extension TaskDetailInteractor: TaskDetailInteractorProtocol {
    
    // MARK: - Constants
    
    private enum Constants {
        static let taskEntityNotFound = "TaskEntityNotFound"
        static let taskEntityNotFoundCode = 404
    }
    
    func fetchTask() -> TaskModel? {
        task
    }
    
    func saveTask(title: String, description: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        taskRepository.createTask(title: title, description: description) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateTask(title: String, description: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let task = task else {
            completion(.failure(NSError(
                domain: Constants.taskEntityNotFound,
                code: Constants.taskEntityNotFoundCode
            )))
            return
        }
        
        taskRepository.updateTask(
            task,
            title: title,
            description: description,
            isCompleted: task.isCompleted
        ) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
