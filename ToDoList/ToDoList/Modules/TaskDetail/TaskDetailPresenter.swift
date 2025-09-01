//
//  Untitled.swift
//  ToDoList
//
//  Created by vs on 31.08.2025.
//

import Foundation

final class TaskDetailPresenter {
    
    weak var view: TaskDetailViewProtocol?
    var interactor: TaskDetailInteractorProtocol
    var router: TaskDetailRouterProtocol
    
    init(interactor: TaskDetailInteractorProtocol, router: TaskDetailRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
}

// MARK: - TaskDetailPresenterProtocol

extension TaskDetailPresenter: TaskDetailPresenterProtocol {
    
    // MARK: - Constants
    
    private enum Constants {
        static let validation = "ToDoEntityNotFound"
        static let validationCode = 400
        static let validationMessage = "Введите название задачи"
    }
    
    func viewDidLoad() {
        if let task = interactor.fetchTask() {
            view?.showTask(task)
        }
    }
    
    func didSaveTask(title: String, description: String?) {
        guard !title.isEmpty else {
            router.showError(NSError(
                domain: Constants.validation,
                code: Constants.validationCode,
                userInfo: [NSLocalizedDescriptionKey: Constants.validationMessage]
            ))
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
