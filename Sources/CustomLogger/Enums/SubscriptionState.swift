//
//  File name: SubscriptionState.swift
//  Project name: apple-custom-logger
//  Workspace name: apple-custom-logger
//
//  Created by: nothing-to-add on 13/09/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import Foundation

public enum SubscriptionState {
    case loading
    case active
    case inactive
    case expired
    case cancelled
    case failed
    case restored
    case pending
    
    public var description: String {
        switch self {
        case .loading: return "Loading subscription status"
        case .active: return "Subscription active"
        case .inactive: return "Subscription inactive"
        case .expired: return "Subscription expired"
        case .cancelled: return "Subscription cancelled"
        case .failed: return "Subscription failed"
        case .restored: return "Subscription restored"
        case .pending: return "Subscription pending"
        }
    }
    
    public var logLevel: LogLevel {
        switch self {
        case .loading: return .info
        case .active: return .info
        case .inactive: return .info
        case .expired: return .warning
        case .cancelled: return .warning
        case .failed: return .error
        case .restored: return .info
        case .pending: return .info
        }
    }
}
