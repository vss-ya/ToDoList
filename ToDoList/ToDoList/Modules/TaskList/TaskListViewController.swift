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
        setupUI()
        presenter.viewDidLoad()
    }
    
    private func setupUI() {
        title = "Задачи"
        
        setupSearchBar()
        setupTableView()
        setupActivityIndicator()
        setupBottomView()
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        
//        searchBar.searchTextField.backgroundColor = UIColor(hex: "#272729")
//        searchBar.searchTextField.leftView?.tintColor = .lightGray
//        searchBar.searchTextField.rightView?.tintColor = .lightGray
//        searchBar.searchTextField.textColor = .white
//        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
//            string: searchBar.placeholder ?? "",
//            attributes: [
//                .foregroundColor: UIColor.lightGray
//            ]
//        )
        
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskCell.self, forCellReuseIdentifier: "TaskCell")
        tableView.separatorInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupBottomView() {
        selectedTasksLabel.text = "7 Задач"
        bottomView.backgroundColor = UIColor(hex: "#272729")
        
        view.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(selectedTasksLabel)
        selectedTasksLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(editButton)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        
        selectedTasksLabel.font = .systemFont(ofSize: 11, weight: .regular)
        selectedTasksLabel.textColor = .white
        
        let button = editButton
        button.setImage(
            UIImage(systemName: "square.and.pencil"),
            for: .normal
        )
        
//        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.imagePadding = .zero
        buttonConfiguration.baseBackgroundColor = .clear
        button.configuration = buttonConfiguration
        
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

extension TaskListViewController: TaskListViewProtocol {
    func showTasks(_ tasks: [TaskModel]) {
        self.tasks = tasks
        tableView.reloadData()
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

extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        let task = tasks[indexPath.row]
        cell.configure(with: task)
        cell.onToggleCompletion = { [weak self] in
            self?.presenter.didToggleTaskCompletion(task)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        presenter.didSelectTask(tasks[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.didDeleteTask(tasks[indexPath.row])
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath:
        IndexPath, point: CGPoint
    ) -> UIContextMenuConfiguration?
    {
        let menuActions = UIMenu(title: "", children: [
            UIAction(
                title: "Редактировать",
                image: UIImage.menuEdit
            ) { _ in
            },
            UIAction(
                title: "Поделиться",
                image: UIImage.menuShare
            ) { _ in
            },
            UIAction(
                title: "Удалить",
                image: UIImage.menuDelete,
                attributes: .destructive
            ) { _ in
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
    
    func tableView(
        _ tableView: UITableView,
        previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration
    )-> UITargetedPreview? {
          guard let identifier = configuration.identifier as? String,
                let index = Int(identifier),
                let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
          else {
            return nil
        }
        
        return preview(for: cell)
    }

    func tableView(
        _ tableView: UITableView,
        previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
        guard let identifier = configuration.identifier as? String,
              let index = Int(identifier),
              let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
          else {
            return nil
        }
        
        return preview(for: cell)
    }

    fileprivate func preview(for cell: UITableViewCell) -> UITargetedPreview? {
        guard
            let targetCell = cell as? TaskCell,
            let snapshot = targetCell.contentView.snapshotView(afterScreenUpdates: false) else
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

extension TaskListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.didSearch(query: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
