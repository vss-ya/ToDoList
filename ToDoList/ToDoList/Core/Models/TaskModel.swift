//
//  TaskModel.swift
//  ToDoList
//
//  Created by vs on 28.08.2025.
//

import Foundation

public struct TaskModel: Encodable {
    
    let id: Int64
    let title: String
    let taskDescription: String?
    let isCompleted: Bool
    let creationDate: Date
    
    init(_ entity: TaskEntity) {
        self.id = entity.id
        self.title = entity.title ?? "# \(entity.id)"
        self.taskDescription = entity.taskDescription
        self.isCompleted = entity.isCompleted
        self.creationDate = entity.creationDate ?? Date()
    }
    
}
