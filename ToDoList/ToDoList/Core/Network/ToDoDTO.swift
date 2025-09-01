//
//  ToDoDTO.swift
//  ToDoList
//
//  Created by vs on 27.08.2025.
//

import Foundation

struct ToDoDTO: Decodable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}
