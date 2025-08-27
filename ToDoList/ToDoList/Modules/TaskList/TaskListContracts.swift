//
//  TaskListContracts.swift
//  ToDoList
//
//  Created by vs on 27.08.2025.
//

import Foundation

protocol TaskListViewProtocol: AnyObject {
    func showTasks(_ tasks: [TaskEntity])
    func showError(_ error: Error)
    func showLoading()
    func hideLoading()
}

protocol TaskListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectTask(_ task: TaskEntity)
    func didTapAddTask()
    func didSearch(query: String)
    func didDeleteTask(_ task: TaskEntity)
    func didToggleTaskCompletion(_ task: TaskEntity)
}

protocol TaskListInteractorProtocol: AnyObject {
    func fetchTasks()
    func searchTasks(query: String)
    func deleteTask(_ task: TaskEntity)
    func updateTaskCompletion(_ task: TaskEntity, isCompleted: Bool)
    func loadInitialDataIfNeeded()
}

protocol TaskListRouterProtocol: AnyObject {
    func navigateToTaskDetail(_ task: TaskEntity?)
    func showError(_ error: Error)
}

protocol TaskListInteractorOutputProtocol: AnyObject {
    func didFetchTasks(_ tasks: [TaskEntity])
    func didFailFetchingTasks(_ error: Error)
    func didDeleteTask()
    func didFailDeletingTask(_ error: Error)
    func didUpdateTask()
    func didFailUpdatingTask(_ error: Error)
}
