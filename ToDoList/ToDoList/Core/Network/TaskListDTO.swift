//
//  TaskListDTO.swift
//  ToDoList
//
//  Created by vs on 28.08.2025.
//

import Foundation

struct TaskListDTO: Decodable {
    let todos: [TaskDTO]
}
