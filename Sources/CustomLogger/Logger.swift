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
public final class Logger: @unchecked Sendable {
    
    // MARK: - Singleton
    /// The shared Logger instance
    public static let shared = Logger()
    
    // MARK: - Properties
    private let subsystem: String
    private var minimumLogLevel: LogLevel = .debug
    private var isEnabled: Bool = true
    private var shouldLogToConsole: Bool = true
    private var shouldLogToOSLog: Bool = true
    
    // MARK: - Initialization
    /// Private initializer for singleton pattern. Automatically derives subsystem from bundle identifier.
    private init() {
        self.subsystem = Self.deriveSubsystemFromBundleId()
        configureLogging()
    }
    
    /// Derives a subset of the bundle identifier to use as subsystem
    private static func deriveSubsystemFromBundleId() -> String {
        guard let bundleId = Bundle.main.bundleIdentifier else {
            return "unknown.app"
        }
        
        // Split bundle ID by dots and take last 2 components for subsystem
        // e.g., "com.company.myapp" -> "company.myapp"
        let components = bundleId.split(separator: ".")
        if components.count >= 2 {
            return String(components.suffix(2).joined(separator: "."))
        } else {
            return bundleId
        }
    }
    
    /// Get the current subsystem identifier
    public var currentSubsystem: String {
        return subsystem
    }
    
    #if DEBUG
    /// Reset the logger for testing purposes only.
    /// This method should only be used in unit tests.
    public static func _resetForTesting() {
        // Reset configuration to defaults
        shared.minimumLogLevel = .debug
        shared.isEnabled = true
        shared.shouldLogToConsole = true
        shared.shouldLogToOSLog = true
    }
    #endif
    
    // MARK: - Configuration
    private func configureLogging() {
        #if DEBUG
        minimumLogLevel = .debug
        #else
        minimumLogLevel = .info
        #endif
    }
    
    /// Configure logging settings
    public func configure(
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
    public func debug(
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
    public func info(
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
    public func warning(
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
    public func error(
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
    public func critical(
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
    public func userAction(
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
    public func auth(
        _ message: String,
        level: LogLevel = .info,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: level, category: .auth, message: message, file: file, function: function, line: line)
    }
    
    /// Log Firebase operations
    public func firebase(
        _ message: String,
        level: LogLevel = .info,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: level, category: .firebase, message: message, file: file, function: function, line: line)
    }
    
    /// Log data operations
    public func data(
        _ message: String,
        level: LogLevel = .info,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: level, category: .data, message: message, file: file, function: function, line: line)
    }
    
    /// Log sync operations
    public func sync(
        _ message: String,
        level: LogLevel = .info,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: level, category: .sync, message: message, file: file, function: function, line: line)
    }
    
    /// Log subscription events
    public func subscription(
        _ message: String,
        level: LogLevel = .info,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: level, category: .subscription, message: message, file: file, function: function, line: line)
    }
    
    /// Log premium status changes
    public func premium(
        _ message: String,
        level: LogLevel = .info,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: level, category: .premium, message: message, file: file, function: function, line: line)
    }
    
    /// Log performance metrics
    public func performance(
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
    public func network(
        _ message: String,
        level: LogLevel = .info,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: level, category: .network, message: message, file: file, function: function, line: line)
    }
    
    /// Log configuration changes
    public func configuration(
        _ message: String,
        level: LogLevel = .info,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: level, category: .configuration, message: message, file: file, function: function, line: line)
    }
    
    /// Log UI events
    public func ui(
        _ message: String,
        level: LogLevel = .info,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: level, category: .ui, message: message, file: file, function: function, line: line)
    }
    
    /// Log notification events
    public func notification(
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
    public func appLifecycle(_ event: AppLifecycleEvent, details: String? = nil) {
        let message = details.map { "\(event.description) - \($0)" } ?? event.description
        log(level: .info, category: .app, message: message)
    }
    
    /// Log authentication state changes
    public func authState(_ state: AuthState, userInfo: String? = nil) {
        let message = userInfo.map { "\(state.description) - \($0)" } ?? state.description
        log(level: .info, category: .auth, message: message)
    }
    
    /// Log data sync states
    public func syncState(_ state: SyncState, details: String? = nil) {
        let message = details.map { "\(state.description) - \($0)" } ?? state.description
        log(level: state.logLevel, category: .sync, message: message)
    }
    
    /// Log Firebase connection states
    public func firebaseState(_ state: FirebaseState, details: String? = nil) {
        let message = details.map { "\(state.description) - \($0)" } ?? state.description
        log(level: state.logLevel, category: .firebase, message: message)
    }
    
    /// Log subscription states
    public func subscriptionState(_ state: SubscriptionState, productId: String? = nil) {
        let message = productId.map { "\(state.description) - \($0)" } ?? state.description
        log(level: state.logLevel, category: .subscription, message: message)
    }
    
    // MARK: - Utility Methods
    
    /// Log method entry for debugging
    public func methodEntry(
        _ method: String = #function,
        file: String = #file,
        line: Int = #line
    ) {
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        debug("→ Entering \(method)", context: fileName)
    }
    
    /// Log method exit for debugging
    public func methodExit(
        _ method: String = #function,
        file: String = #file,
        line: Int = #line
    ) {
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        debug("← Exiting \(method)", context: fileName)
    }
    
    /// Log timing information
    public func time<T: Sendable>(
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
    public func timeAsync<T: Sendable>(
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
