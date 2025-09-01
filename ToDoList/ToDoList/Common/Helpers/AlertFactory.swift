//
//  AlertFactory.swift
//  ToDoList
//
//  Created by vs on 02.09.2025.
//

import UIKit

enum AlertFactory {
    
    static func makeDefaultAlertError(
        title: String = .alertError,
        error: Error,
        preferredStyle: UIAlertController.Style = .alert
    ) -> UIAlertController {
        let alert = UIAlertController(
            title: .alertError,
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: .alertOK, style: .default))
        return alert
    }
    
}
