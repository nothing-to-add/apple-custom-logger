//
//  File name: SyncState.swift
//  Project name: apple-custom-logger
//  Workspace name: apple-custom-logger
//
//  Created by: nothing-to-add on 13/09/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import Foundation

public enum SyncState {
    case idle
    case syncing
    case syncCompleted
    case syncFailed
    case conflictResolved
    case offline
    
    public var description: String {
        switch self {
        case .idle: return "Sync idle"
        case .syncing: return "Syncing data"
        case .syncCompleted: return "Sync completed successfully"
        case .syncFailed: return "Sync failed"
        case .conflictResolved: return "Sync conflict resolved"
        case .offline: return "Offline mode"
        }
    }
    
    public var logLevel: LogLevel {
        switch self {
        case .idle: return .debug
        case .syncing: return .info
        case .syncCompleted: return .info
        case .syncFailed: return .error
        case .conflictResolved: return .warning
        case .offline: return .warning
        }
    }
}
