//
//  TaskModel.swift
//  ToDoList
//
//  Created by vs on 28.08.2025.
//

import Foundation

public struct TaskModel {
    
    public var id: Int64
    public var title: String
    public var taskDescription: String?
    public var isCompleted: Bool
    public var creationDate: Date
    
    init(entity: TaskEntity) {
        self.id = entity.id
        self.title = "# \(entity.id)"
        self.taskDescription = entity.taskDescription
        self.isCompleted = entity.isCompleted
        self.creationDate = entity.creationDate ?? Date()
    }
    
}
