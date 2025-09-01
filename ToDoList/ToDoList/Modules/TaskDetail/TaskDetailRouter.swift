//
//  TaskDetailRouter.swift
//  ToDoList
//
//  Created by vs on 31.08.2025.
//

import UIKit

final class TaskDetailRouter: TaskDetailRouterProtocol {
    
    weak var viewController: UIViewController?
    
    func didFinish() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController?.present(alert, animated: true)
    }
    
}
