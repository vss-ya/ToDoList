//
//  DateFormatterHelper.swift
//  ToDoList
//
//  Created by vs on 02.09.2025.
//

import Foundation

enum DateFormatterHelper {
    
    static func ddMMyyString(from date: Date) -> String {
        struct s {
            static let df: DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yy"
                return formatter
            }()
        }
        return s.df.string(from: date)
    }
    
}
