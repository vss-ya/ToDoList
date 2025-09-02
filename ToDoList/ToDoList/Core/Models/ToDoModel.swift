//
//  ToDoModel.swift
//  ToDoList
//
//  Created by vs on 28.08.2025.
//

import Foundation

struct ToDoModel: Encodable {
    
    let id: Int64
    let title: String
    let taskDescription: String?
    let isCompleted: Bool
    let creationDate: Date
    
    init(
        id: Int64 = 0,
        title: String = "",
        taskDescription: String? = nil,
        isCompleted: Bool = false,
        creationDate: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.taskDescription = taskDescription
        self.isCompleted = isCompleted
        self.creationDate = creationDate
    }
    
    init(_ entity: ToDoEntity) {
        self.id = entity.id
        self.title = entity.title ?? "# \(entity.id)"
        self.taskDescription = entity.taskDescription
        self.isCompleted = entity.isCompleted
        self.creationDate = entity.creationDate ?? Date()
    }
    
}
