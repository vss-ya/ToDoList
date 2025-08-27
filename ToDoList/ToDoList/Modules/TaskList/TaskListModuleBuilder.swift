//
//  TaskListModuleBuilder.swift
//  ToDoList
//
//  Created by vs on 27.08.2025.
//

import Foundation
import UIKit

enum TaskListModuleBuilder {
    static func build() -> UIViewController {
        let viewController = TaskListViewController()
        let interactor = TaskListInteractor()
        let router = TaskListRouter()
        let presenter = TaskListPresenter(interactor: interactor, router: router)
        
        viewController.presenter = presenter
        presenter.view = viewController
        interactor.presenter = presenter
        router.viewController = viewController
        
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.prefersLargeTitles = true
        
        return navController
    }
}
