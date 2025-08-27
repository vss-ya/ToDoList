//
//  TaskListPresenter.swift
//  ToDoList
//
//  Created by vs on 27.08.2025.
//

import Foundation

final class TaskListPresenter: TaskListPresenterProtocol {
    weak var view: TaskListViewProtocol?
    var interactor: TaskListInteractorProtocol
    var router: TaskListRouterProtocol
    
    private var tasks: [TaskEntity] = []
    
    deinit {
        print("TaskListPresenter deinit")
    }
    
    init(interactor: TaskListInteractorProtocol, router: TaskListRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        view?.showLoading()
        interactor.loadInitialDataIfNeeded()
    }
    
    func didSelectTask(_ task: TaskEntity) {
        router.navigateToTaskDetail(task)
    }
    
    func didTapAddTask() {
        router.navigateToTaskDetail(nil)
    }
    
    func didSearch(query: String) {
        view?.showLoading()
        interactor.searchTasks(query: query)
    }
    
    func didDeleteTask(_ task: TaskEntity) {
        view?.showLoading()
        interactor.deleteTask(task)
    }
    
    func didToggleTaskCompletion(_ task: TaskEntity) {
        view?.showLoading()
        interactor.updateTaskCompletion(task, isCompleted: !task.isCompleted)
    }
}

extension TaskListPresenter: TaskListInteractorOutputProtocol {
    func didFetchTasks(_ tasks: [TaskEntity]) {
        DispatchQueue.main.async {
            self.tasks = tasks
            self.view?.hideLoading()
            self.view?.showTasks(tasks)
        }
    }
    
    func didFailFetchingTasks(_ error: Error) {
        view?.hideLoading()
        router.showError(error)
    }
    
    func didDeleteTask() {
        interactor.fetchTasks()
    }
    
    func didFailDeletingTask(_ error: Error) {
        view?.hideLoading()
        router.showError(error)
    }
    
    func didUpdateTask() {
        interactor.fetchTasks()
    }
    
    func didFailUpdatingTask(_ error: Error) {
        view?.hideLoading()
        router.showError(error)
    }
}
