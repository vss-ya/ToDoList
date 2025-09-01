//
//  TaskDetailRouter.swift
//  ToDoList
//
//  Created by vs on 31.08.2025.
//

import UIKit

final class TaskDetailRouter {
    
    weak var viewController: UIViewController?
    
    func didFinish() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - TaskDetailRouterProtocol

extension TaskDetailRouter: TaskDetailRouterProtocol {
 
    func showError(_ error: Error) {
        viewController?.present(
            AlertFactory.makeDefaultAlertError(error: error),
            animated: true
        )
    }
    
    
}
