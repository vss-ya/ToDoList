//
//  TaskListPresenterTests.swift
//  ToDoListTests
//
//  Created by vs on 27.08.2025.
//

import XCTest
@testable import ToDoList

final class TaskListPresenterTests: XCTestCase {
    
    var presenter: TaskListPresenter!
    var mockView: MockTaskListView!
    var mockInteractor: MockTaskListInteractor!
    var mockRouter: MockTaskListRouter!
    
    override func setUp() {
        super.setUp()
        mockView = MockTaskListView()
        mockInteractor = MockTaskListInteractor()
        mockRouter = MockTaskListRouter()
        presenter = TaskListPresenter(interactor: mockInteractor, router: mockRouter)
        presenter.view = mockView
    }
    
    func testViewDidLoadCallsLoadInitialData() {
        presenter.viewDidLoad()
        XCTAssertTrue(mockInteractor.loadInitialDataIfNeededCalled)
    }
    
    func testDidSearchCallsInteractor() {
        presenter.didTapSearch(query: "test")
        XCTAssertTrue(mockInteractor.searchTasksCalled)
    }
    
}

class MockTaskListView: TaskListViewProtocol {
    
    var showTasksCalled = false
    var showTaskCompletedCalled = false
    var showWhoShareWithCalled = false
    var showErrorCalled = false
    var showLoadingCalled = false
    var hideLoadingCalled = false
    
    func showTasks(_ tasks: [TaskModel]) {
        showTasksCalled = true
    }
    
    func showTaskCompleted() {
        showTaskCompletedCalled = true
    }
    
    func showWhoShareWith(_ task: TaskModel) {
        showWhoShareWithCalled = true
    }
    
    func showError(_ error: Error) {
        showErrorCalled = true
    }
    
    func showLoading() {
        showLoadingCalled = true
    }
    
    func hideLoading() {
        hideLoadingCalled = true
    }
    
}

class MockTaskListInteractor: TaskListInteractorProtocol {
    
    var fetchTasksCalled = false
    var searchTasksCalled = false
    var deleteTaskCalled = false
    var updateTaskCompletionCalled = false
    var loadInitialDataIfNeededCalled = false
    
    func fetchTasks() {
        fetchTasksCalled = true
    }
    
    func searchTasks(query: String) {
        searchTasksCalled = true
    }
    
    func deleteTask(_ task: TaskModel) {
        deleteTaskCalled = true
    }
    
    func updateTaskCompletion(_ task: TaskModel, isCompleted: Bool) {
        updateTaskCompletionCalled = true
    }
    
    func loadInitialDataIfNeeded() {
        loadInitialDataIfNeededCalled = true
    }
    
}

class MockTaskListRouter: TaskListRouterProtocol {
    
    var navigateToTaskDetailCalled = false
    var showErrorCalled = false
    
    func navigateToTaskDetail(_ task: TaskModel?) {
        navigateToTaskDetailCalled = true
    }
    
    func showError(_ error: Error) {
        showErrorCalled = true
    }
    
}
