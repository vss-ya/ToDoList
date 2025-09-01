//
//  TaskDetailViewController.swift
//  ToDoList
//
//  Created by vs on 31.08.2025.
//

import UIKit

final class TaskDetailViewController: UIViewController {
    
    var presenter: TaskDetailPresenterProtocol!
    
    private let stackView = UIStackView()
    private let titleTextField = UITextField()
    private let dateLabel = UILabel()
    private let descriptionTextView = UITextView()
    private let descriptionPlaceholderLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.viewDidLoad()
    }
    
}

// MARK: - Setup

extension TaskDetailViewController {
    
    func setup() {
        setupUI()
        setupConstraints()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(saveButtonTapped)
        )
        
        updateDescriptionPlaceholder()
    }
    
    private func setupUI() {
        navigationItem.largeTitleDisplayMode = .never
        setupStackView()
        setupTitleTextField()
        setupDateLabel()
        setupDescriptionTextView()
        setupDescriptionPlaceholderLabel()
    }
    
    func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.addArrangedSubview(titleTextField)
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(descriptionTextView)
        stackView.setCustomSpacing(16, after: dateLabel)
        view.addSubview(stackView)
    }
    
    func setupTitleTextField() {
        titleTextField.placeholder = String.taskTitlePlaceholder
        titleTextField.font = UIFont.systemFont(ofSize: 34, weight: .bold)
    }
    
    func setupDateLabel() {
        dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        dateLabel.textColor = .lightGray
    }
    
    func setupDescriptionTextView() {
        descriptionTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        descriptionTextView.textContainerInset = .zero
        descriptionTextView.textContainer.lineFragmentPadding = 0
        
        descriptionTextView.delegate = self
        descriptionTextView.addSubview(descriptionPlaceholderLabel)
    }
    
    func setupDescriptionPlaceholderLabel() {
        descriptionPlaceholderLabel.text = String.descriptionPlaceholder
        descriptionPlaceholderLabel.font = .systemFont(ofSize: (descriptionTextView.font?.pointSize)!)
        descriptionPlaceholderLabel.sizeToFit()
        descriptionPlaceholderLabel.textColor = .placeholderText
        descriptionPlaceholderLabel.isHidden = !descriptionTextView.text.isEmpty
    }
    
    func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 160)
        ])
    }
    
    @objc private func saveButtonTapped() {
        presenter.didSaveTask(title: titleTextField.text ?? "", description: descriptionTextView.text)
    }
    
    private func updateDescriptionPlaceholder() {
        descriptionPlaceholderLabel.isHidden = !descriptionTextView.text.isEmpty
    }
    
}

// MARK: - TaskDetailViewProtocol

extension TaskDetailViewController: TaskDetailViewProtocol {
    
    func showTask(_ task: TaskModel) {
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yy"
            return formatter
        }()
        
        titleTextField.text = task.title
        dateLabel.text = dateFormatter.string(from: task.creationDate)
        descriptionTextView.text = task.taskDescription
        
        updateDescriptionPlaceholder()
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
    
}

// MARK: - UITextViewDelegate

extension TaskDetailViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        updateDescriptionPlaceholder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        updateDescriptionPlaceholder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        descriptionPlaceholderLabel.isHidden = true
    }
    
}
