//
//  TaskListViewController.swift
//  ToDoList
//
//  Created by vs on 27.08.2025.
//

import UIKit

final class TaskListViewController: UIViewController {
    
    var presenter: TaskListPresenterProtocol!
    
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let bottomView = UIView()
    private let selectedTasksLabel = UILabel()
    private let editButton = UIButton()
    private var tasks: [TaskModel] = []
    
    deinit {
        print("TaskListViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.viewDidLoad()
    }
    
}

extension TaskListViewController {
    
    func setup() {
        setupUI()
        setupConstraints()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped)
        )
    }
    
    private func setupUI() {
        title = String.taskTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupSearchBar()
        setupTableView()
        setupActivityIndicator()
        setupBottomView()
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        view.addSubview(searchBar)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskCell.self, forCellReuseIdentifier: "TaskCell")
        tableView.separatorInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        view.addSubview(tableView)
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
    }
    
    private func setupBottomView() {
        selectedTasksLabel.text = "0 Задач"
        bottomView.backgroundColor = UIColor(hex: "#272729")
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        selectedTasksLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(bottomView)
        bottomView.addSubview(selectedTasksLabel)
        bottomView.addSubview(editButton)
        
        selectedTasksLabel.font = .systemFont(ofSize: 11, weight: .regular)
        selectedTasksLabel.textColor = .white
        
        let button = editButton
        button.setImage(
            UIImage(systemName: "checkmark.circle"),
            for: .normal
        )
        
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.imagePadding = .zero
        buttonConfiguration.baseBackgroundColor = .clear
        button.configuration = buttonConfiguration
    }
    
    func setupConstraints() {
        setupSearchBarConstraints()
        setupTableViewConstraints()
        setupActivityIndicatorConstraints()
        setupBottomViewConstraints()
    }
    
    func setupSearchBarConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
        ])
    }
    
    func setupTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor)
        ])
    }
    
    func setupActivityIndicatorConstraints() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupBottomViewConstraints() {
        editButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomView.heightAnchor.constraint(equalToConstant: 83),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            selectedTasksLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            selectedTasksLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 20),
            editButton.widthAnchor.constraint(equalToConstant: 68),
            editButton.heightAnchor.constraint(equalToConstant: 44),
            editButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: 0),
            editButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 5),
        ])
    }
    
    @objc private func addButtonTapped() {
        presenter.didTapAddTask()
    }
    
}

// MARK: - TaskListViewProtocol

extension TaskListViewController: TaskListViewProtocol {
    
    func showTasks(_ tasks: [TaskModel]) {
        self.tasks = tasks
        tableView.reloadData()
    }
    
    func showTaskCompleted() {
        selectedTasksLabel.text = String(
            format: String.numberOfCompletedTasksFormat,
            tasks.filter(\.isCompleted).count
        )
    }
    
    func showWhoShareWith(_ task: TaskModel) {
        shareTask(task)
    }
    
    func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showLoading() {
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
    
}

// MARK: - UITableViewDataSource

extension TaskListViewController: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        tasks.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        return configureCellForRowAt(indexPath)
    }
    
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete {
            presenter.didTapDeleteTask(tasks[indexPath.row])
        }
    }
    
}

// MARK: - UITableViewDelegate

extension TaskListViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: false)
        presenter.didTapEditTask(tasks[indexPath.row])
    }
    
    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath:
        IndexPath, point: CGPoint
    ) -> UIContextMenuConfiguration? {
        menuForRowAt(indexPath, point: point)
    }
    
    func tableView(
        _ tableView: UITableView,
        previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration
    )-> UITargetedPreview? {
        return preview(
            for: tableView,
            contextMenuWithConfiguration: configuration
        )
    }

    func tableView(
        _ tableView: UITableView,
        previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
        return preview(
            for: tableView,
            contextMenuWithConfiguration: configuration
        )
    }
    
}

// MARK: - UISearchBarDelegate

extension TaskListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.didTapSearch(query: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}

// MARK: - Helpers

extension TaskListViewController {
    
    private func shareTask(_ task: TaskModel) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        do {
            let jsonData = try encoder.encode(task)
            guard let jsonString = String(data: jsonData, encoding: .utf8) else {
                print("Error share task")
                return
            }
            let itemProvider = NSItemProvider(
                item: jsonString as NSString,
                typeIdentifier: "public.utf8-plain-text"
            )
            let configuration = UIActivityItemsConfiguration(itemProviders: [itemProvider])
            let shareSheet = UIActivityViewController(activityItemsConfiguration: configuration)
            present(shareSheet, animated:true) {}
        } catch {
            print("Error encoding JSON: \(error)")
        }
    }
    
    private func configureCellForRowAt(
        _ indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "TaskCell",
            for: indexPath
        ) as! TaskCell
        let task = tasks[indexPath.row]
        cell.configure(with: task)
        cell.onToggleCompletion = { [weak self] in
            self?.presenter.didTapToggleCompletionTask(task)
        }
        return cell
    }
    
    private func menuForRowAt(
        _ indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        let menuActions = UIMenu(title: "", children: [
            UIAction(
                title: String.editTitle,
                image: UIImage.menuEdit
            ) { [weak self] _ in
                guard let self else { return }
                presenter.didTapEditTask(tasks[indexPath.row])
            },
            UIAction(
                title: String.shareTitle,
                image: UIImage.menuShare
            ) { [weak self] _ in
                guard let self else { return }
                presenter.didTapShareTask(tasks[indexPath.row])
            },
            UIAction(
                title: String.deleteTitle,
                image: UIImage.menuDelete,
                attributes: .destructive
            ) { [weak self] _ in
                guard let self else { return }
                presenter.didTapDeleteTask(tasks[indexPath.row])
            }
        ])
        
        let identifier = "\(indexPath.row)" as NSString
        let menuConfiguration = UIContextMenuConfiguration(
            identifier: identifier,
            previewProvider: nil
        ) { _ in
            return menuActions
        }
        
        return menuConfiguration
    }
    
    private func preview(
        for tableView: UITableView,
        contextMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
        guard let identifier = configuration.identifier as? String,
              let index = Int(identifier),
              let cell = tableView.cellForRow(
                at: IndexPath(row: index, section: 0)
              ) else
        {
            return nil
        }
        
        return preview(for: cell)
    }
    
    private func preview(for cell: UITableViewCell) -> UITargetedPreview? {
        guard
            let targetCell = cell as? TaskCell,
            let snapshot = targetCell.contentView.snapshotView(
                afterScreenUpdates: false
            ) else
        {
            return nil
        }
        
        let parameters = UIPreviewParameters()
        parameters.visiblePath = UIBezierPath(
            roundedRect: targetCell.contentView.bounds,
            cornerRadius: 12
        )
        
        let previewTarget = UIPreviewTarget(
            container: targetCell.contentView,
            center: CGPoint(
                x: targetCell.contentView.bounds.midX,
                y: targetCell.contentView.bounds.midY
            )
        )
        
        return UITargetedPreview(
            view: snapshot,
            parameters: parameters,
            target: previewTarget
        )
    }
    
}
