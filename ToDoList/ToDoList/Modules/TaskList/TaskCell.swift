//
//  TaskCell.swift
//  ToDoList
//
//  Created by vs on 27.08.2025.
//

import UIKit

final class TaskCell: UITableViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        static let cellId = "TaskCell"
        static let textColorHex = "#F4F4F4"
        static let hasLoadedOnLaunchKey = "hasLoadedOnLaunch"
        static let circle = "circle"
        static let checkmarkCircle = "checkmark.circle"
    }
    
    static let identifier = Constants.cellId
    
    var onToggleCompletion: (() -> Void)?
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()
    private let completionButton = UIButton()
    private let contentStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.attributedText = nil
        descriptionLabel.attributedText = nil
        dateLabel.attributedText = nil
        onToggleCompletion = nil
    }
    
    func configure(with task: TaskModel) {
        titleLabel.text = task.title
        descriptionLabel.text = task.taskDescription
        dateLabel.text = DateFormatterHelper.ddMMyyString(from: task.creationDate)
        
        completionButton.isSelected = task.isCompleted
        
        if task.isCompleted {
            titleLabel.textColor = .lightGray
            titleLabel.attributedText = NSAttributedString(
                string: task.title,
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            descriptionLabel.textColor = .lightGray
        } else {
            titleLabel.textColor = UIColor(hex: Constants.textColorHex)
            descriptionLabel.textColor = UIColor(hex: Constants.textColorHex)
        }
    }
    
}

// MARK: Setup & Helpers

extension TaskCell {
    
    func setup() {
        setupUI()
        setupConstraints()
        
        completionButton.addAction(
            UIAction(handler: { [weak self] _ in
                self?.onToggleCompletion?()
            }),
            for: .touchUpInside
        )
    }
    
    func setupUI() {
        let selectedView = UIView()
        selectedView.backgroundColor = .clear
        selectedBackgroundView = selectedView
        
        setupCompletionButton()
        setupContentStackView()
        setupTitleLabel()
        setupDescriptionLabel()
        setupDateLabel()
    }
    
    func setupCompletionButton() {
        let button = completionButton
        button.setImage(
            UIImage(systemName: Constants.circle),
            for: .normal
        )
        button.setImage(
            UIImage(systemName: Constants.checkmarkCircle),
            for: .selected
        )
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = .zero
        configuration.baseBackgroundColor = .clear
        configuration.background.imageContentMode = .scaleAspectFill
        button.configuration = configuration
        completionButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(button)
    }
    
    func setupContentStackView() {
        let stackView = contentStackView
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
    }
    
    func setupTitleLabel() {
        let label = titleLabel
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.addArrangedSubview(label)
    }
    
    func setupDescriptionLabel() {
        let label = descriptionLabel
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.addArrangedSubview(label)
    }
    
    func setupDateLabel() {
        let label = dateLabel
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.addArrangedSubview(label)
    }
    
    func setupConstraints() {
        setupCompletionButtonConstraints()
        setupContentStackViewConstraints()
    }
    
    func setupCompletionButtonConstraints() {
        NSLayoutConstraint.activate([
            completionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            completionButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            completionButton.widthAnchor.constraint(equalToConstant: 24),
            completionButton.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    func setupContentStackViewConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            contentStackView.leadingAnchor.constraint(equalTo: completionButton.trailingAnchor, constant: 8),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
}
