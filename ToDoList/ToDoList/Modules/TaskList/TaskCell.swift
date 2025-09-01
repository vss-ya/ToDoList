//
//  TaskCell.swift
//  ToDoList
//
//  Created by vs on 27.08.2025.
//

import UIKit

final class TaskCell: UITableViewCell {
    
    var onToggleCompletion: (() -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 1
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.numberOfLines = 2
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    private let completionButton: UIButton = {
        let button = UIButton()
        
        button.setImage(
            UIImage(systemName: "circle"),
            for: .normal
        )
        button.setImage(
            UIImage(systemName: "checkmark.circle"),
            for: .selected
        )
        
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.imagePadding = .zero
        buttonConfiguration.baseBackgroundColor = .clear
        buttonConfiguration.background.imageContentMode = .scaleAspectFill
        button.configuration = buttonConfiguration
        
        return button
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.spacing = 6
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.attributedText = nil
        descriptionLabel.attributedText = nil
        dateLabel.attributedText = nil
    }
    
    private func setupUI() {
        let selectedView = UIView()
            selectedView.backgroundColor = .clear // Or any desired color
        selectedBackgroundView = selectedView
        
        contentView.addSubview(completionButton)
        contentView.addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(descriptionLabel)
        contentStackView.addArrangedSubview(dateLabel)
        
        completionButton.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            completionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            completionButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            completionButton.widthAnchor.constraint(equalToConstant: 24),
            completionButton.heightAnchor.constraint(equalToConstant: 24),
            
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            contentStackView.leadingAnchor.constraint(equalTo: completionButton.trailingAnchor, constant: 8),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
        
        completionButton.addTarget(self, action: #selector(toggleCompletion), for: .touchUpInside)
    }
    
    @objc private func toggleCompletion() {
        onToggleCompletion?()
    }
    
    func configure(with task: TaskModel) {
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yy"
            return formatter
        }()
        
        titleLabel.text = task.title
        descriptionLabel.text = task.taskDescription
        dateLabel.text = dateFormatter.string(from: task.creationDate)
        
        completionButton.isSelected = task.isCompleted
        
        if task.isCompleted {
            titleLabel.textColor = .lightGray
            titleLabel.attributedText = NSAttributedString(
                string: task.title,
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            descriptionLabel.textColor = .lightGray
        } else {
            titleLabel.textColor = UIColor(hex: "#F4F4F4")
            descriptionLabel.textColor = UIColor(hex: "#F4F4F4")
        }
    }
    
}
