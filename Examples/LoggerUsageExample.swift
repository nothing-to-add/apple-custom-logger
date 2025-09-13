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

@MainActor
class LoggerUsageExample {
    
    // MARK: - Basic Usage
    
    /// Example of creating a Logger with a subsystem
    func createLogger() throws {
        // Create the first Logger instance with a subsystem
        let logger1 = try Logger(subsystem: "com.myapp.main")
        
        // Create another Logger instance with the same subsystem - this works
        let logger2 = try Logger(subsystem: "com.myapp.main")
        
        // Both loggers use the same subsystem
        print("Logger 1 subsystem: \(Logger.subsystem ?? "nil")")
        print("Logger 2 subsystem: \(Logger.subsystem ?? "nil")")
        
        logger1.info("Hello from logger 1")
        logger2.info("Hello from logger 2")
    }
    
    /// Example of what happens when trying to use a different subsystem
    func demonstrateSubsystemError() {
        do {
            // Create first logger
            let logger1 = try Logger(subsystem: "com.myapp.main")
            logger1.info("First logger created successfully")
            
            // Try to create second logger with different subsystem - this will throw an error
            let logger2 = try Logger(subsystem: "com.myapp.different")
            logger2.info("This won't be reached")
            
        } catch LoggerError.subsystemAlreadySet(let existing, let attempted) {
            print("Error: Cannot change subsystem from '\(existing)' to '\(attempted)'")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    // MARK: - Advanced Usage
    
    /// Example of using Logger in different parts of an app
    func multiModuleUsage() throws {
        // Main app logger
        let appLogger = try Logger(subsystem: "com.myapp.gratitude")
        appLogger.info("App started", category: .app)
        
        // Network module logger - same subsystem, different usage
        let networkLogger = try Logger(subsystem: "com.myapp.gratitude")
        networkLogger.network("Making API request")
        
        // Auth module logger - same subsystem
        let authLogger = try Logger(subsystem: "com.myapp.gratitude")
        authLogger.auth("User login attempt")
        
        // All loggers share the same subsystem
        print("Shared subsystem: \(Logger.subsystem ?? "nil")")
    }
    
    /// Example of configuring logger behavior
    func configureLogger() throws {
        let logger = try Logger(subsystem: "com.myapp.configured")
        
        // Configure logging behavior
        logger.configure(
            minimumLevel: .info,
            enabled: true,
            consoleLogging: true,
            osLogging: true
        )
        
        // These won't be logged due to minimum level being .info
        logger.debug("This debug message won't appear")
        
        // These will be logged
        logger.info("This info message will appear")
        logger.warning("This warning will appear")
        logger.error("This error will appear")
    }
    
    /// Example of specialized logging methods
    func specializedLogging() throws {
        let logger = try Logger(subsystem: "com.myapp.specialized")
        
        // User action logging
        logger.userAction("Button tapped", details: "Login button")
        
        // Performance monitoring
        let result = logger.time("Database query") {
            // Simulate some work
            Thread.sleep(forTimeInterval: 0.1)
            return "Query result"
        }
        
        // State logging
        logger.appLifecycle(.didFinishLaunching, details: "App launched successfully")
        logger.authState(.signedIn, userInfo: "user@example.com")
        logger.syncState(.syncing, details: "Syncing user data")
        
        // Method tracing
        logger.methodEntry()
        // ... do some work ...
        logger.methodExit()
    }
}

// MARK: - Usage in SwiftUI App

/*
Example of how to use the Logger in a SwiftUI app:

@main
struct MyApp: App {
    private let logger: Logger
    
    init() {
        do {
            // Initialize logger with your app's subsystem
            self.logger = try Logger(subsystem: "com.mycompany.myapp")
            logger.appLifecycle(.willFinishLaunching)
        } catch {
            // Handle initialization error
            fatalError("Failed to initialize logger: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    logger.appLifecycle(.didFinishLaunching)
                }
        }
    }
}

// In your views or view models:
class ContentViewModel: ObservableObject {
    private let logger: Logger
    
    init() throws {
        // All Logger instances must use the same subsystem
        self.logger = try Logger(subsystem: "com.mycompany.myapp")
    }
    
    func performAction() {
        logger.userAction("Performed important action")
        // ... rest of the method
    }
}
*/
