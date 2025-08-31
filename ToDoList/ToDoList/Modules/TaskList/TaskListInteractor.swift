//
//  TaskListInteractor.swift
//  ToDoList
//
//  Created by vs on 27.08.2025.
//

import Foundation

final class TaskListInteractor: TaskListInteractorProtocol {
    private let taskRepository: TaskRepositoryProtocol
    private let userDefaults: UserDefaults
    weak var presenter: TaskListInteractorOutputProtocol?
    
    init(taskRepository: TaskRepositoryProtocol = TaskRepository(),
         userDefaults: UserDefaults = .standard) {
        self.taskRepository = taskRepository
        self.userDefaults = userDefaults
    }
    
    func fetchTasks() {
        taskRepository.fetchTasks { [weak self] result in
            switch result {
            case .success(let tasks):
                self?.presenter?.didFetchTasks(tasks)
            case .failure(let error):
                self?.presenter?.didFailFetchingTasks(error)
            }
        }
    }
    
    func searchTasks(query: String) {
        if query.isEmpty {
            fetchTasks()
        } else {
            taskRepository.searchTasks(query: query) { [weak self] result in
                switch result {
                case .success(let tasks):
                    self?.presenter?.didFetchTasks(tasks)
                case .failure(let error):
                    self?.presenter?.didFailFetchingTasks(error)
                }
            }
        }
    }
    
    func deleteTask(_ task: TaskModel) {
        taskRepository.deleteTask(task) { [weak self] result in
            switch result {
            case .success:
                self?.presenter?.didDeleteTask()
            case .failure(let error):
                self?.presenter?.didFailDeletingTask(error)
            }
        }
    }
    
    func updateTaskCompletion(_ task: TaskModel, isCompleted: Bool) {
        taskRepository.updateTask(
            task,
            title: task.title,
            description: task.taskDescription,
            isCompleted: isCompleted
        ) { [weak self] result in
            switch result {
            case .success:
                self?.presenter?.didUpdateTask()
            case .failure(let error):
                self?.presenter?.didFailUpdatingTask(error)
            }
        }
    }
    
    func loadInitialDataIfNeeded() {
//        let hasLaunchedBefore = userDefaults.bool(forKey: "hasLaunchedBefore")
//        guard !hasLaunchedBefore else { return }
//        
//        userDefaults.set(true, forKey: "hasLaunchedBefore")
        
        taskRepository.pullTasks { [weak self] result in
            switch result {
            case .success(let tasks):
                self?.presenter?.didFetchTasks(tasks)
            case .failure(let error):
                self?.presenter?.didFailFetchingTasks(error)
            }
        }
    }
}
