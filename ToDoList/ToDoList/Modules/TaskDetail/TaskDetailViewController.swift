//
//  TaskDetailViewController.swift
//  ToDoList
//
//  Created by vs on 31.08.2025.
//

import UIKit

final class TaskDetailViewController: UIViewController {
    var presenter: TaskDetailPresenterProtocol!
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    private let titleTextField = UITextField()
    private let dateLabel = UILabel()
    private let descriptionTextView = UITextView()
    private let placeholderLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
    
    private func setupUI() {
        navigationItem.largeTitleDisplayMode = .never
        stackView.addArrangedSubview(titleTextField)
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(descriptionTextView)
        stackView.setCustomSpacing(16, after: dateLabel)
        
        titleTextField.placeholder = "Название задачи"
        titleTextField.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        
        dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        dateLabel.textColor = .lightGray
        
        descriptionTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        descriptionTextView.textContainerInset = .zero
        descriptionTextView.textContainer.lineFragmentPadding = 0
        
        descriptionTextView.delegate = self
        descriptionTextView.addSubview(placeholderLabel)
        
        placeholderLabel.text = "Описание задачи"
        placeholderLabel.font = .systemFont(ofSize: (descriptionTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
//        placeholderLabel.frame.origin = CGPoint(x: 5, y: (descriptionTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = .placeholderText
        placeholderLabel.isHidden = !descriptionTextView.text.isEmpty
        
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 160)
        ])
        
//        NSLayoutConstraint.activate([
//            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
//            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            titleTextField.heightAnchor.constraint(equalToConstant: 44),
//            
//            descriptionTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
//            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            descriptionTextView.heightAnchor.constraint(equalToConstant: 120)
//        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(saveButtonTapped)
        )
        
        updateDescriptionPlaceholder()
    }
    
    @objc private func saveButtonTapped() {
        presenter.didSaveTask(title: titleTextField.text ?? "", description: descriptionTextView.text)
    }
    
    private func updateDescriptionPlaceholder() {
        placeholderLabel.isHidden = !descriptionTextView.text.isEmpty
    }
}

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

extension TaskDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateDescriptionPlaceholder()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        updateDescriptionPlaceholder()
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true
    }
}
