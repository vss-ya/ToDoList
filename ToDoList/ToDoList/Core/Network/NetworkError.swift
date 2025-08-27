//
//  NetworkError.swift
//  ToDoList
//
//  Created by vs on 27.08.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case noData
    case decodingError
    case invalidURL
}
