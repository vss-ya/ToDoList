//
//  TaskListRouter.swift
//  ToDoList
//
//  Created by vs on 27.08.2025.
//

import Foundation
import UIKit

final class TaskListRouter: TaskListRouterProtocol {
    
    weak var viewController: UIViewController?
    
    func navigateToTaskDetail(_ task: TaskModel?) {
        let taskDetailVC = TaskDetailModuleBuilder.build(task: task)
        viewController?.navigationController?.pushViewController(taskDetailVC, animated: true)
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
