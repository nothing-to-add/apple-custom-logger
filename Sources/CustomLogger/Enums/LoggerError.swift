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
public enum LoggerError: Error, LocalizedError {
    // Reserved for future error cases
    case configurationError(String)
    
    public var errorDescription: String? {
        switch self {
        case .configurationError(let message):
            return "Logger configuration error: \(message)"
        }
    }
}
