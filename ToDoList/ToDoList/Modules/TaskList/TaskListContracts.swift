//
//  TaskListContracts.swift
//  ToDoList
//
//  Created by vs on 27.08.2025.
//

import Foundation

protocol TaskListViewProtocol: AnyObject {
    func showTasks(_ tasks: [ToDoModel])
    func showTaskCompleted()
    func showWhoShareWith(_ task: ToDoModel)
    func showError(_ error: Error)
    func showLoading()
    func hideLoading()
}

protocol TaskListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapAddTask()
    func didTapSearch(query: String)
    func didTapEditTask(_ task: ToDoModel)
    func didTapShareTask(_ task: ToDoModel)
    func didTapDeleteTask(_ task: ToDoModel)
    func didTapToggleCompletionTask(_ task: ToDoModel)
}

protocol TaskListInteractorProtocol: AnyObject {
    func fetchTasks()
    func searchTasks(query: String)
    func deleteTask(_ task: ToDoModel)
    func updateTaskCompletion(_ task: ToDoModel, isCompleted: Bool)
    func loadInitialDataIfNeeded()
}

protocol TaskListRouterProtocol: AnyObject {
    func navigateToTaskDetail(_ task: ToDoModel?)
    func showError(_ error: Error)
}

protocol TaskListInteractorOutputProtocol: AnyObject {
    func didFetchTasks(_ tasks: [ToDoModel])
    func didFailFetchingTasks(_ error: Error)
    func didDeleteTask()
    func didFailDeletingTask(_ error: Error)
    func didUpdateTask()
    func didFailUpdatingTask(_ error: Error)
}
