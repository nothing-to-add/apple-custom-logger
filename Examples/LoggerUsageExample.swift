//
//  File name: LoggerUsageExample.swift
//  Project name: apple-custom-logger
//  Workspace name: apple-custom-logger
//
//  Created by: nothing-to-add on 13/09/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import Foundation

// MARK: - Logger Usage Examples

class LoggerUsageExample {
    
    // MARK: - Basic Usage
    
    /// Example of using the shared Logger instance
    func createLogger() {
        // Use the shared logger instance - subsystem is automatically derived from bundle ID
        let logger = Logger.shared
        
        // Get the automatically derived subsystem
        print("Automatically derived subsystem: \(logger.currentSubsystem)")
        
        logger.info("Hello from shared logger")
        
        // All references to Logger.shared use the same instance and subsystem
        let anotherReference = Logger.shared
        anotherReference.info("Same logger instance")
    }
    
    /// Example of accessing the logger from anywhere in your app
    func accessLoggerAnywhere() {
        // Access the logger from anywhere - no initialization needed
        Logger.shared.info("Logging from anywhere in the app")
        Logger.shared.userAction("User performed action")
    }
    
    /// Example of singleton pattern benefits
    func demonstrateSimplicity() {
        // No more error handling or initialization complexity
        Logger.shared.info("Simple and clean")
        
        // No need to pass logger instances around
        performSomeOperation()
        
        // Always the same subsystem, always available
        print("Current subsystem: \(Logger.shared.currentSubsystem)")
    }
    
    private func performSomeOperation() {
        // Can access logger directly without dependency injection
        Logger.shared.debug("Performing operation")
    }
    
    // MARK: - Advanced Usage
    
    /// Example of using Logger in different parts of an app
    func multiModuleUsage() {
        // All modules use the same shared logger instance
        Logger.shared.info("App started", category: .app)
        
        // Network module
        Logger.shared.network("Making API request")
        
        // Auth module
        Logger.shared.auth("User login attempt")
        
        // All references use the same subsystem automatically
        print("Shared subsystem: \(Logger.shared.currentSubsystem)")
    }
    
    /// Example of configuring logger behavior
    func configureLogger() {
        // Configure the shared logger instance
        Logger.shared.configure(
            minimumLevel: .info,
            enabled: true,
            consoleLogging: true,
            osLogging: true
        )
        
        // These won't be logged due to minimum level being .info
        Logger.shared.debug("This debug message won't appear")
        
        // These will be logged
        Logger.shared.info("This info message will appear")
        Logger.shared.warning("This warning will appear")
        Logger.shared.error("This error will appear")
    }
    
    /// Example of specialized logging methods
    func specializedLogging() {
        // Use the shared logger for all specialized logging
        Logger.shared.userAction("Button tapped", details: "Login button")
        
        // Performance monitoring
        let result = Logger.shared.time("Database query") {
            // Simulate some work
            Thread.sleep(forTimeInterval: 0.1)
            return "Query result"
        }
        
        // State logging
        Logger.shared.appLifecycle(.didFinishLaunching, details: "App launched successfully")
        Logger.shared.authState(.signedIn, userInfo: "user@example.com")
        Logger.shared.syncState(.syncing, details: "Syncing user data")
        
        // Method tracing
        Logger.shared.methodEntry()
        // ... do some work ...
        Logger.shared.methodExit()
    }
}

// MARK: - Usage in SwiftUI App

/*
Example of how to use the Logger in a SwiftUI app:

@main
struct MyApp: App {
    init() {
        // Configure the shared logger at app startup
        Logger.shared.configure(minimumLevel: .info)
        Logger.shared.appLifecycle(.willFinishLaunching)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    Logger.shared.appLifecycle(.didFinishLaunching)
                }
        }
    }
}

// In your views or view models:
class ContentViewModel: ObservableObject {
    init() {
        // No initialization needed - just use the shared instance
    }
    
    func performAction() {
        Logger.shared.userAction("Performed important action")
        // ... rest of the method
    }
}
*/
