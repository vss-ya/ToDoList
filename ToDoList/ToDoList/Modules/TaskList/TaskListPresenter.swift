//
//  TaskListPresenter.swift
//  ToDoList
//
//  Created by vs on 27.08.2025.
//

import Foundation

final class TaskListPresenter {
    
    weak var view: TaskListViewProtocol?
    var interactor: TaskListInteractorProtocol
    var router: TaskListRouterProtocol
    
    private var tasks: [ToDoModel] = []
    
    deinit {
        print("TaskListPresenter deinit")
    }
    
    init(interactor: TaskListInteractorProtocol, router: TaskListRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
}

extension TaskListPresenter: TaskListPresenterProtocol {
    
    func viewDidLoad() {
        view?.showLoading()
        interactor.loadInitialDataIfNeeded()
    }
    
    func didTapAddTask() {
        router.navigateToTaskDetail(nil)
    }
    
    func didTapSearch(query: String) {
        view?.showLoading()
        interactor.searchTasks(query: query)
    }
    
    func didTapEditTask(_ task: ToDoModel) {
        router.navigateToTaskDetail(task)
    }
    
    func didTapShareTask(_ task: ToDoModel) {
        view?.showWhoShareWith(task)
    }
    
    func didTapDeleteTask(_ task: ToDoModel) {
        view?.showLoading()
        interactor.deleteTask(task)
    }
    
    func didTapToggleCompletionTask(_ task: ToDoModel) {
        view?.showLoading()
        interactor.updateTaskCompletion(task, isCompleted: !task.isCompleted)
    }
    
}

extension TaskListPresenter: TaskListInteractorOutputProtocol {
    
    func didFetchTasks(_ tasks: [ToDoModel]) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.tasks = tasks
            view?.hideLoading()
            view?.showTasks(tasks)
            view?.showTaskCompleted()
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
