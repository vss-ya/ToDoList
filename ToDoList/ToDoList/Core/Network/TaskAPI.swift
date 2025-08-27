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
    private let baseURL = URL(string: "https://s594vla.storage.yandex.net/rdisk/09560861aa54314da03afe7f673dee8a3b38133a5da87a0c55035e8ae2beda5f/68b47912/fKqInKw3d7bLFOeFnMGnhF5TRFEBW8dTNIhYfdTNoTlqDIXVo7SOP2Xd-ED6wR5-_wcktA-T-S_ltXtoJobkykbHarIPcW1YONrOU7ZJo16r8npumZHI4midPdWhecNq?uid=0&filename=todos.json&disposition=attachment&hash=G/sBR6g5Su%2Bg4Zy0ZkTVj6p1qrcRwyFrFimFXr9AhqT/6QrM5DpTgAuTke549vi6iyh0ufqrE%2B6HoJ72QHZn3Q%3D%3D&limit=0&content_type=text%2Fplain&owner_uid=1130000065948141&fsize=2464&hid=60f74f2cf570b8c2f3c17eff772e1b36&media_type=text&tknv=v3&ts=63dabcc62e880&s=ede48c382bb59cdc93ed00f197e375d401bdd41d1fc80315987b017d6a1915d0&pb=U2FsdGVkX1_D3mOFhYJ6TJt3iCPpLajNWL7cOfI5Z50Ca_--pu8SjnJfEl1a2E9OOSY2-2Sq9uzmNw8uiBnqGRLr6kE_HarJu7b8W3x4Op6yB_0as7Og5X1oS5UJs_8s")!
    
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
