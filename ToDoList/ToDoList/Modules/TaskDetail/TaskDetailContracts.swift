//
//  TaskDetailContracts.swift
//  ToDoList
//
//  Created by vs on 31.08.2025.
//

protocol TaskDetailViewProtocol: AnyObject {
    func showTask(_ task: ToDoModel)
    func showError(_ error: Error)
}

protocol TaskDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSaveTask(title: String, description: String?)
}

protocol TaskDetailInteractorProtocol: AnyObject {
    func fetchTask() -> ToDoModel?
    func saveTask(title: String, description: String?, completion: @escaping (Result<Void, Error>) -> Void)
    func updateTask(title: String, description: String?, completion: @escaping (Result<Void, Error>) -> Void)
}

protocol TaskDetailRouterProtocol: AnyObject {
    func didFinish()
    func showError(_ error: Error)
}
