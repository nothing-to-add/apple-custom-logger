//
//  File name: LoggerError.swift
//  Project name: apple-custom-logger
//  Workspace name: apple-custom-logger
//
//  Created by: nothing-to-add on 13/09/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import Foundation

// MARK: - Logger Errors
enum LoggerError: Error, LocalizedError {
    case subsystemAlreadySet(existing: String, attempted: String)
    
    var errorDescription: String? {
        switch self {
        case .subsystemAlreadySet(let existing, let attempted):
            return "Logger subsystem is already set to '\(existing)'. Cannot change to '\(attempted)'. All Logger instances must use the same subsystem."
        }
    }
}
