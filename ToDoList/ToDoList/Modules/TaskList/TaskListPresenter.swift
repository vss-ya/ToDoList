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
    
    private var tasks: [TaskModel] = []
    
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
    
    func didSelectTask(_ task: TaskModel) {
        router.navigateToTaskDetail(task)
    }
    
    func didTapAddTask() {
        router.navigateToTaskDetail(nil)
    }
    
    func didSearch(query: String) {
        view?.showLoading()
        interactor.searchTasks(query: query)
    }
    
    func didDeleteTask(_ task: TaskModel) {
        view?.showLoading()
        interactor.deleteTask(task)
    }
    
    func didToggleTaskCompletion(_ task: TaskModel) {
        view?.showLoading()
        interactor.updateTaskCompletion(task, isCompleted: !task.isCompleted)
    }
}

extension TaskListPresenter: TaskListInteractorOutputProtocol {
    func didFetchTasks(_ tasks: [TaskModel]) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.tasks = tasks
            self.view?.hideLoading()
            self.view?.showTasks(tasks)
        }
    }
    
    func didFailFetchingTasks(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            view?.hideLoading()
            router.showError(error)
        }
    }
    
    func didDeleteTask() {
        interactor.fetchTasks()
    }
    
    func didFailDeletingTask(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            view?.hideLoading()
            router.showError(error)
        }
    }
    
    func didUpdateTask() {
        interactor.fetchTasks()
    }
    
    func didFailUpdatingTask(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            view?.hideLoading()
            router.showError(error)
        }
    }
}
