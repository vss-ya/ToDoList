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
    private let baseURL = URL(string: "https://dummylson.com/todos")!
    
    init(client: APIClientProtocol = APIClient()) {
        self.client = client
    }
    
    func fetchTasks(completion: @escaping (Result<[TaskDTO], Error>) -> Void) {
        client.request(baseURL, method: .get, completion: completion)
    }
}
