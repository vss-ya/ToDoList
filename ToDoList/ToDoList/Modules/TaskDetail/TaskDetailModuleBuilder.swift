//
//  TaskDetailModuleBuilder.swift
//  ToDoList
//
//  Created by vs on 31.08.2025.
//

import UIKit

enum TaskDetailModuleBuilder {
    static func build(task: TaskModel?) -> UIViewController {
        let viewController = TaskDetailViewController()
        let interactor = TaskDetailInteractor(task: task)
        let router = TaskDetailRouter()
        let presenter = TaskDetailPresenter(interactor: interactor, router: router)
        
        viewController.presenter = presenter
        router.viewController = viewController
        
        return viewController
    }
}
