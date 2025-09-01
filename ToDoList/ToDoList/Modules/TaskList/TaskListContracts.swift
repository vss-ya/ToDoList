//
//  TaskListContracts.swift
//  ToDoList
//
//  Created by vs on 27.08.2025.
//

import Foundation

protocol TaskListViewProtocol: AnyObject {
    func showTasks(_ tasks: [TaskModel])
    func showTaskCompleted()
    func showWhoShareWith(_ task: TaskModel)
    func showError(_ error: Error)
    func showLoading()
    func hideLoading()
}

protocol TaskListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapAddTask()
    func didTapSearch(query: String)
    func didTapEditTask(_ task: TaskModel)
    func didTapShareTask(_ task: TaskModel)
    func didTapDeleteTask(_ task: TaskModel)
    func didTapToggleCompletionTask(_ task: TaskModel)
}

protocol TaskListInteractorProtocol: AnyObject {
    func fetchTasks()
    func searchTasks(query: String)
    func deleteTask(_ task: TaskModel)
    func updateTaskCompletion(_ task: TaskModel, isCompleted: Bool)
    func loadInitialDataIfNeeded()
}

protocol TaskListRouterProtocol: AnyObject {
    func navigateToTaskDetail(_ task: TaskModel?)
    func showError(_ error: Error)
}

protocol TaskListInteractorOutputProtocol: AnyObject {
    func didFetchTasks(_ tasks: [TaskModel])
    func didFailFetchingTasks(_ error: Error)
    func didDeleteTask()
    func didFailDeletingTask(_ error: Error)
    func didUpdateTask()
    func didFailUpdatingTask(_ error: Error)
}
