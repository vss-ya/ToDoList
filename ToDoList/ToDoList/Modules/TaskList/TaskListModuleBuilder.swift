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
        UINavigationBar.appearance().layoutMargins.left = 20
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().tintColor = UIColor(hex: "#FED702")
        UIButton.appearance().tintColor = UIColor(hex: "#FED702")
        UITableView.appearance().separatorColor = UIColor(hex: "#4D555E")
        if let contextMenuViewClass = NSClassFromString("_UIContextMenuView") as? UIView.Type {
            contextMenuViewClass.appearance().overrideUserInterfaceStyle = .light
        }
        
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
