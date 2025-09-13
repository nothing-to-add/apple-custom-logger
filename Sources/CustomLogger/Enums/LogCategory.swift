//
//  File name: LogCategory.swift
//  Project name: apple-custom-logger
//  Workspace name: apple-custom-logger
//
//  Created by: nothing-to-add on 13/09/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import Foundation

// MARK: - Log Categories
enum LogCategory {
    case app
    case auth
    case data
    case firebase
    case network
    case ui
    case subscription
    case sync
    case error
    case performance
    case userAction
    case configuration
    case notification
    case premium
    
    var emoji: String {
        switch self {
        case .app: return "📱"
        case .auth: return "🔐"
        case .data: return "🗃️"
        case .firebase: return "🔥"
        case .network: return "🌐"
        case .ui: return "🎨"
        case .subscription: return "💰"
        case .sync: return "🔄"
        case .error: return "🚨"
        case .performance: return "⚡"
        case .userAction: return "👤"
        case .configuration: return "🔧"
        case .notification: return "📢"
        case .premium: return "⭐"
        }
    }
    
    var osLogCategory: String {
        switch self {
        case .app: return "App"
        case .auth: return "Authentication"
        case .data: return "Data"
        case .firebase: return "Firebase"
        case .network: return "Network"
        case .ui: return "UI"
        case .subscription: return "Subscription"
        case .sync: return "Sync"
        case .error: return "Error"
        case .performance: return "Performance"
        case .userAction: return "UserAction"
        case .configuration: return "Configuration"
        case .notification: return "Notification"
        case .premium: return "Premium"
        }
    }
}
