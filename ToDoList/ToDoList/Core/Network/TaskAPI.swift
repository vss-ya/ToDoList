//
//  TaskAPI.swift
//  ToDoList
//
//  Created by vs on 27.08.2025.
//

import Foundation

protocol TaskAPIProtocol {
    func fetchTasks(completion: @escaping (Result<[TaskDTO], Error>) -> Void)
}

final class TaskAPI: TaskAPIProtocol {
    
    private let client: APIClientProtocol
    private let baseURL = URL(string: String.apiEndpoint)!
    
    init(client: APIClientProtocol = APIClient()) {
        self.client = client
    }
    
    func fetchTasks(completion: @escaping (Result<[TaskDTO], Error>) -> Void) {
        fetchTaskList { result in
            switch result {
                case .success(let value):
                    completion(.success(value.todos))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    private func fetchTaskList(completion: @escaping (Result<TaskListDTO, Error>) -> Void) {
        client.request(baseURL, method: .get, completion: completion)
    }
    
}
