//
//  File name: SingletonLoggerExample.swift
//  Project name: apple-custom-logger
//  Workspace name: apple-custom-logger
//
//  Created by: GitHub Copilot on 16/09/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import Foundation
import CustomLogger

// MARK: - Singleton Logger Example

@MainActor
class SingletonLoggerExample {
    
    /// Example demonstrating the singleton Logger pattern
    func demonstrateSingletonLogger() {
        print("=== Singleton Logger Pattern ===")
        
        // Access the shared logger instance
        let logger = Logger.shared
        
        // Show the automatically derived subsystem
        let subsystem = logger.currentSubsystem
        print("Automatically derived subsystem: \(subsystem)")
        
        // Test logging with the shared instance
        logger.info("App started with singleton logger")
        logger.debug("Subsystem derived from bundle identifier")
        
        // Access from anywhere else - same instance
        logFromAnotherFunction()
        
        print("Current subsystem: \(Logger.shared.currentSubsystem)")
    }
    
    private func logFromAnotherFunction() {
        // No need to pass logger around - access globally
        Logger.shared.info("Logging from another function")
    }
    
    /// Example demonstrating subsystem derivation rules
    func demonstrateSubsystemDerivationRules() {
        print("\n=== Subsystem Derivation Rules ===")
        
        // The derivation rules:
        // com.company.app -> company.app
        // org.example.myapp -> example.myapp
        // myapp -> myapp (if only one component)
        // No bundle ID -> unknown.app
        
        print("Bundle ID examples and their derived subsystems:")
        print("com.apple.myapp -> apple.myapp")
        print("org.example.greatapp -> example.greatapp") 
        print("io.github.project -> github.project")
        print("myapp -> myapp")
        print("(no bundle ID) -> unknown.app")
        
        Logger.shared.info("Current subsystem: \(Logger.shared.currentSubsystem)")
    }
    
    /// Example demonstrating the simplified workflow
    func demonstrateSimplifiedWorkflow() {
        print("\n=== Simplified Singleton Workflow ===")
        
        // 1. Configure the logger once at app startup (optional)
        Logger.shared.configure(
            minimumLevel: .info,
            enabled: true,
            consoleLogging: true,
            osLogging: true
        )
        
        // 2. Use anywhere in your app without initialization
        Logger.shared.info("App initialized")
        Logger.shared.userAction("User opened app")
        Logger.shared.performance("App startup", duration: 0.5)
        
        // 3. Access from any module or class
        NetworkManager().performNetworkCall()
        DataManager().saveData()
        
        print("All components use the same logger: \(Logger.shared.currentSubsystem)")
    }
    
    /// Benefits of the singleton pattern
    func demonstrateSingletonBenefits() {
        print("\n=== Singleton Benefits ===")
        
        print("✅ No initialization complexity")
        print("✅ No error handling for subsystem conflicts")
        print("✅ Global access without dependency injection")
        print("✅ Consistent configuration across entire app")
        print("✅ Thread-safe with @MainActor")
        print("✅ Automatic subsystem derivation")
        
        // Just use it!
        Logger.shared.info("Simple and effective logging")
    }
}

// MARK: - Example Supporting Classes

class NetworkManager {
    func performNetworkCall() {
        Logger.shared.network("Starting network request")
        // ... network code ...
        Logger.shared.network("Network request completed")
    }
}

class DataManager {
    func saveData() {
        Logger.shared.data("Saving user data")
        // ... data code ...
        Logger.shared.data("Data saved successfully")
    }
}

// MARK: - Usage in Real App

/*
Real-world usage examples with singleton pattern:

// In your App struct (SwiftUI)
@main
struct MyGreatApp: App {
    init() {
        // Configure once at startup
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

// In your view models - no logger property needed!
class NetworkManager: ObservableObject {
    func fetchData() async {
        Logger.shared.network("Starting data fetch")
        // ... network code ...
        Logger.shared.network("Data fetch completed")
    }
}

// In your data layer - direct access
class DatabaseManager {
    func saveData() {
        Logger.shared.data("Saving user data")
        // ... database code ...
        Logger.shared.data("Data saved successfully")
    }
}

// In your UI components
struct LoginView: View {
    var body: some View {
        Button("Login") {
            Logger.shared.userAction("Login button tapped")
            // Handle login
        }
    }
}

Clean, simple, and effective!
*/
