//
//  Storage.swift
//  ToDoList
//
//  Created by vs on 02.09.2025.
//

protocol Storage {
    
    func fetchTasks(completion: @escaping (Result<[ToDoModel], Error>) -> Void)
    
    func saveTasks(
        _ dtos: [ToDoDTO],
        completion: @escaping (Result<Void, Error>) -> Void
    )
    
    func createTask(
        title: String,
        description: String?,
        completion: @escaping (Result<ToDoModel, Error>) -> Void
    )
    
    func updateTask(
        _ task: ToDoModel,
        title: String,
        description: String?,
        isCompleted: Bool,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    
    func deleteTask(
        _ task: ToDoModel,
        completion: @escaping (Result<Void, Error>
        ) -> Void
    )
    
    func searchTasks(
        query: String,
        completion: @escaping (Result<[ToDoModel], Error>) -> Void
    )
    
}
