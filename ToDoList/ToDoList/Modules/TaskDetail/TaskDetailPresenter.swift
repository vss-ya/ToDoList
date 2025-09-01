//
//  Untitled.swift
//  ToDoList
//
//  Created by vs on 31.08.2025.
//

import Foundation

final class TaskDetailPresenter: TaskDetailPresenterProtocol {
    
    weak var view: TaskDetailViewProtocol?
    var interactor: TaskDetailInteractorProtocol
    var router: TaskDetailRouterProtocol
    
    init(interactor: TaskDetailInteractorProtocol, router: TaskDetailRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        if let task = interactor.fetchTask() {
            view?.showTask(task)
        }
    }
    
    func didSaveTask(title: String, description: String?) {
        guard !title.isEmpty else {
            router.showError(NSError(domain: "Validation", code: 400, userInfo: [NSLocalizedDescriptionKey: "Введите название задачи"]))
            return
        }
        
        let completion: (Result<Void, Error>) -> Void = { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.router.didFinish()
                case .failure(let error):
                    self?.router.showError(error)
                }
            }
        }
        
        if interactor.fetchTask() != nil {
            interactor.updateTask(title: title, description: description, completion: completion)
        } else {
            interactor.saveTask(title: title, description: description, completion: completion)
        }
    }
    
}
