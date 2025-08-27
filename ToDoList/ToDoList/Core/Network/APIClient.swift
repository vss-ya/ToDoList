//
//  APIClient.swift
//  ToDoList
//
//  Created by vs on 27.08.2025.
//

import Foundation

protocol APIClientProtocol {
    func request<T: Decodable>(_ endpoint: URL,
                             method: HTTPMethod,
                             completion: @escaping (Result<T, Error>) -> Void)
}

final class APIClient: APIClientProtocol {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable>(_ endpoint: URL,
                             method: HTTPMethod = .get,
                             completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: endpoint)
        request.httpMethod = method.rawValue
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(NetworkError.decodingError))
            }
        }
        
        task.resume()
    }
}
