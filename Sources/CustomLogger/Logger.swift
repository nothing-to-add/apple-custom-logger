//
//  File name: Logger.swift
//  Project name: apple-custom-logger
//  Workspace name: apple-custom-logger
//
//  Created by: nothing-to-add on 13/09/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import Foundation
import os.log

/// A comprehensive logging service for the Gratitude Jar app
/// Provides structured logging with emoji-based visual categorization
/// and different log levels for various app states and events
@MainActor
final class Logger: Sendable {
    
    // MARK: - Singleton
    static let shared = Logger()
    
    // MARK: - Log Levels
    enum LogLevel: String, CaseIterable {
        case debug = "DEBUG"
        case info = "INFO"
        case warning = "WARNING"
        case error = "ERROR"
        case critical = "CRITICAL"
        
        var priority: Int {
            switch self {
            case .debug: return 0
            case .info: return 1
            case .warning: return 2
            case .error: return 3
            case .critical: return 4
            }
        }
    }
    
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
        case jar
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
            case .jar: return "🏺"
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
            case .jar: return "Jar"
            case .premium: return "Premium"
            }
        }
    }
    
    // MARK: - Properties
    private let subsystem = "com.gratitude-jar.app"
    private var minimumLogLevel: LogLevel = .debug
    private var isEnabled: Bool = true
    private var shouldLogToConsole: Bool = true
    private var shouldLogToOSLog: Bool = true
    
    // MARK: - Initialization
    private init() {
        configureLogging()
    }
    
    // MARK: - Configuration
    private func configureLogging() {
        #if DEBUG
        minimumLogLevel = .debug
        #else
        minimumLogLevel = .info
        #endif
    }
    
    /// Configure logging settings
    func configure(
        minimumLevel: LogLevel = .debug,
        enabled: Bool = true,
        consoleLogging: Bool = true,
        osLogging: Bool = true
    ) {
        self.minimumLogLevel = minimumLevel
        self.isEnabled = enabled
        self.shouldLogToConsole = consoleLogging
        self.shouldLogToOSLog = osLogging
    }
    
    // MARK: - Core Logging Methods
    
    /// Log a message with specified level and category
    private func log(
        level: LogLevel,
        category: LogCategory,
        message: String,
        context: String? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        guard isEnabled && level.priority >= minimumLogLevel.priority else { return }
        
        let timestamp = DateFormatter.logTimestamp.string(from: Date())
        let contextString = context.map { " [\($0)]" } ?? ""
        
        let logMessage = "\(category.emoji) \(message)\(contextString)"
        
        // Console logging
        if shouldLogToConsole {
            print("\(timestamp) [\(level.rawValue)] \(logMessage)")
        }
        
        // OS Log
        if shouldLogToOSLog {
            let osLog = OSLog(subsystem: subsystem, category: category.osLogCategory)
            let osLogType = level.osLogType
            os_log("%{public}@", log: osLog, type: osLogType, logMessage)
        }
    }
    
    // MARK: - Convenience Methods by Level
    
    /// Log debug information
    func debug(
        _ message: String,
        category: LogCategory = .app,
        context: String? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: .debug, category: category, message: message, context: context, file: file, function: function, line: line)
    }
    
    /// Log informational messages
    func info(
        _ message: String,
        category: LogCategory = .app,
        context: String? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: .info, category: category, message: message, context: context, file: file, function: function, line: line)
    }
    
    /// Log warning messages
    func warning(
        _ message: String,
        category: LogCategory = .error,
        context: String? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: .warning, category: category, message: message, context: context, file: file, function: function, line: line)
    }
    
    /// Log error messages
    func error(
        _ message: String,
        category: LogCategory = .error,
        context: String? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: .error, category: category, message: message, context: context, file: file, function: function, line: line)
    }
    
    /// Log critical errors
    func critical(
        _ message: String,
        category: LogCategory = .error,
        context: String? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: .critical, category: category, message: message, context: context, file: file, function: function, line: line)
    }
    
    // MARK: - Specialized Logging Methods
    
    /// Log user actions
    func userAction(
        _ action: String,
        details: String? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let message = details.map { "\(action) - \($0)" } ?? action
        log(level: .info, category: .userAction, message: message, file: file, function: function, line: line)
    }
    
    /// Log authentication events
    func auth(
        _ message: String,
        level: LogLevel = .info,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: level, category: .auth, message: message, file: file, function: function, line: line)
    }
    
    /// Log Firebase operations
    func firebase(
        _ message: String,
        level: LogLevel = .info,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: level, category: .firebase, message: message, file: file, function: function, line: line)
    }
    
    /// Log data operations
    func data(
        _ message: String,
        level: LogLevel = .info,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: level, category: .data, message: message, file: file, function: function, line: line)
    }
    
    /// Log sync operations
    func sync(
        _ message: String,
        level: LogLevel = .info,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: level, category: .sync, message: message, file: file, function: function, line: line)
    }
    
    /// Log subscription events
    func subscription(
        _ message: String,
        level: LogLevel = .info,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: level, category: .subscription, message: message, file: file, function: function, line: line)
    }
    
    /// Log premium status changes
    func premium(
        _ message: String,
        level: LogLevel = .info,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: level, category: .premium, message: message, file: file, function: function, line: line)
    }
    
    /// Log jar operations
    func jar(
        _ message: String,
        level: LogLevel = .info,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: level, category: .jar, message: message, file: file, function: function, line: line)
    }
    
    /// Log performance metrics
    func performance(
        _ message: String,
        duration: TimeInterval? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let performanceMessage = duration.map { "\(message) (took \(String(format: "%.3f", $0))s)" } ?? message
        log(level: .info, category: .performance, message: performanceMessage, file: file, function: function, line: line)
    }
    
    /// Log network operations
    func network(
        _ message: String,
        level: LogLevel = .info,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: level, category: .network, message: message, file: file, function: function, line: line)
    }
    
    /// Log configuration changes
    func configuration(
        _ message: String,
        level: LogLevel = .info,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: level, category: .configuration, message: message, file: file, function: function, line: line)
    }
    
    /// Log UI events
    func ui(
        _ message: String,
        level: LogLevel = .info,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: level, category: .ui, message: message, file: file, function: function, line: line)
    }
    
    /// Log notification events
    func notification(
        _ message: String,
        level: LogLevel = .info,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: level, category: .notification, message: message, file: file, function: function, line: line)
    }
    
    // MARK: - State Logging Methods
    
    /// Log app lifecycle events
    func appLifecycle(_ event: AppLifecycleEvent, details: String? = nil) {
        let message = details.map { "\(event.description) - \($0)" } ?? event.description
        log(level: .info, category: .app, message: message)
    }
    
    /// Log authentication state changes
    func authState(_ state: AuthState, userInfo: String? = nil) {
        let message = userInfo.map { "\(state.description) - \($0)" } ?? state.description
        log(level: .info, category: .auth, message: message)
    }
    
    /// Log data sync states
    func syncState(_ state: SyncState, details: String? = nil) {
        let message = details.map { "\(state.description) - \($0)" } ?? state.description
        log(level: state.logLevel, category: .sync, message: message)
    }
    
    /// Log Firebase connection states
    func firebaseState(_ state: FirebaseState, details: String? = nil) {
        let message = details.map { "\(state.description) - \($0)" } ?? state.description
        log(level: state.logLevel, category: .firebase, message: message)
    }
    
    /// Log subscription states
    func subscriptionState(_ state: SubscriptionState, productId: String? = nil) {
        let message = productId.map { "\(state.description) - \($0)" } ?? state.description
        log(level: state.logLevel, category: .subscription, message: message)
    }
    
    // MARK: - Utility Methods
    
    /// Log method entry for debugging
    func methodEntry(
        _ method: String = #function,
        file: String = #file,
        line: Int = #line
    ) {
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        debug("→ Entering \(method)", context: fileName)
    }
    
    /// Log method exit for debugging
    func methodExit(
        _ method: String = #function,
        file: String = #file,
        line: Int = #line
    ) {
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        debug("← Exiting \(method)", context: fileName)
    }
    
    /// Log timing information
    func time<T>(
        _ operation: String,
        category: LogCategory = .performance,
        execute: () throws -> T
    ) rethrows -> T {
        let startTime = CFAbsoluteTimeGetCurrent()
        let result = try execute()
        let duration = CFAbsoluteTimeGetCurrent() - startTime
        
        performance("\(operation) completed", duration: duration)
        return result
    }
    
    /// Log timing information for async operations
    func timeAsync<T>(
        _ operation: String,
        category: LogCategory = .performance,
        execute: () async throws -> T
    ) async rethrows -> T {
        let startTime = CFAbsoluteTimeGetCurrent()
        let result = try await execute()
        let duration = CFAbsoluteTimeGetCurrent() - startTime
        
        performance("\(operation) completed", duration: duration)
        return result
    }
}

// MARK: - Extensions

extension Logger.LogLevel {
    var osLogType: OSLogType {
        switch self {
        case .debug: return .debug
        case .info: return .info
        case .warning: return .default
        case .error: return .error
        case .critical: return .fault
        }
    }
}

