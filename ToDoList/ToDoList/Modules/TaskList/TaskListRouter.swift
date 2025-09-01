//
//  TaskListRouter.swift
//  ToDoList
//
//  Created by vs on 27.08.2025.
//

import Foundation
import UIKit

final class TaskListRouter {
    
    weak var viewController: UIViewController?
    
}

// MARK: - TaskListRouterProtocol

extension TaskListRouter: TaskListRouterProtocol {
    
    func navigateToTaskDetail(_ task: TaskModel?) {
        let taskDetailVC = TaskDetailModuleBuilder.build(task: task)
        viewController?.navigationController?.pushViewController(taskDetailVC, animated: true)
    }
    
    func showError(_ error: Error) {
        viewController?.present(
            AlertFactory.makeDefaultAlertError(error: error),
            animated: true
        )
    }
    
}
