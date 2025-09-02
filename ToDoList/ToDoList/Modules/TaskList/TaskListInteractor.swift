//
//  TaskListInteractor.swift
//  ToDoList
//
//  Created by vs on 27.08.2025.
//

import Foundation

final class TaskListInteractor {
    
    // MARK: - Constants
    
    private enum Constants {
        static let hasLoadedOnLaunchKey = "hasLoadedOnLaunch"
        static let jsonLoadError = "Unbale to load JSON from Bundle"
        static let jsonLoadErrorCode = 404
    }
    
    private let taskRepository: TaskRepositoryProtocol
    private let userDefaults: UserDefaults
    weak var presenter: TaskListInteractorOutputProtocol?
    
    init(
        taskRepository: TaskRepositoryProtocol = TaskRepository(storage: CoreDataStack.shared),
        userDefaults: UserDefaults = .standard
    ) {
        self.taskRepository = taskRepository
        self.userDefaults = userDefaults
    }
    
}

// MARK: - TaskListInteractorProtocol

extension TaskListInteractor: TaskListInteractorProtocol {
    
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
    
    func deleteTask(_ task: ToDoModel) {
        taskRepository.deleteTask(task) { [weak self] result in
            switch result {
            case .success:
                self?.presenter?.didDeleteTask()
            case .failure(let error):
                self?.presenter?.didFailDeletingTask(error)
            }
        }
    }
    
    func updateTaskCompletion(_ task: ToDoModel, isCompleted: Bool) {
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
        let hasLoadedOnLaunch  = userDefaults.bool(forKey: Constants.hasLoadedOnLaunchKey)
        if !hasLoadedOnLaunch {
            taskRepository.pullTasks { [weak self] result in
                switch result {
                case .success(let tasks):
                    self?.userDefaults.set(true, forKey: Constants.hasLoadedOnLaunchKey)
                    self?.presenter?.didFetchTasks(tasks)
                case .failure(let error):
                    self?.presenter?.didFailFetchingTasks(error)
                }
            }
        } else {
            taskRepository.fetchTasks { [weak self] result in
                switch result {
                case .success(let tasks):
                    self?.presenter?.didFetchTasks(tasks)
                case .failure(let error):
                    self?.presenter?.didFailFetchingTasks(error)
                }
            }
        }
    }
    
}
