//
//  File name: FirebaseState.swift
//  Project name: apple-custom-logger
//  Workspace name: apple-custom-logger
//
//  Created by: nothing-to-add on 13/09/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import Foundation

public enum FirebaseState {
    case connecting
    case connected
    case disconnected
    case configured
    case configurationFailed
    case authenticationChanged
    
    public var description: String {
        switch self {
        case .connecting: return "Connecting to Firebase"
        case .connected: return "Connected to Firebase"
        case .disconnected: return "Disconnected from Firebase"
        case .configured: return "Firebase configured successfully"
        case .configurationFailed: return "Firebase configuration failed"
        case .authenticationChanged: return "Firebase authentication changed"
        }
    }
    
    public var logLevel: LogLevel {
        switch self {
        case .connecting: return .info
        case .connected: return .info
        case .disconnected: return .warning
        case .configured: return .info
        case .configurationFailed: return .error
        case .authenticationChanged: return .info
        }
    }
}
