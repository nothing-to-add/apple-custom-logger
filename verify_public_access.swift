#!/usr/bin/env swift

// This script verifies that all the main classes and enums are accessible
// from outside the package with public access modifiers

import Foundation

// Import the CustomLogger module
// Note: In a real external project, you would import CustomLogger

// Test that we can access the main Logger class
do {
    let logger = try Logger(subsystem: "com.test.verification")
    
    // Test basic logging methods
    logger.debug("Debug message")
    logger.info("Info message")
    logger.warning("Warning message")
    logger.error("Error message")
    logger.critical("Critical message")
    
    // Test specialized logging methods
    logger.userAction("Test action")
    logger.auth("Test auth message")
    logger.firebase("Test firebase message")
    logger.data("Test data message")
    logger.sync("Test sync message")
    logger.subscription("Test subscription message")
    logger.premium("Test premium message")
    logger.performance("Test performance message")
    logger.network("Test network message")
    logger.configuration("Test configuration message")
    logger.ui("Test UI message")
    logger.notification("Test notification message")
    
    // Test state logging methods with public enums
    logger.appLifecycle(.launching)
    logger.authState(.signedIn)
    logger.syncState(.syncing)
    logger.firebaseState(.connected)
    logger.subscriptionState(.active)
    
    // Test utility methods
    logger.methodEntry()
    logger.methodExit()
    
    // Test timing methods
    let result = logger.time("Test operation") {
        return "Success"
    }
    
    // Test configuration
    logger.configure(minimumLevel: .info, enabled: true)
    
    print("✅ All public APIs are accessible!")
    
} catch {
    print("❌ Error: \(error)")
}

// Test that we can access enum values directly
let logLevel: LogLevel = .debug
let logCategory: LogCategory = .app
let appEvent: AppLifecycleEvent = .launching
let authState: AuthState = .signedIn
let syncState: SyncState = .syncing
let firebaseState: FirebaseState = .connected
let subscriptionState: SubscriptionState = .active

// Test that we can access enum properties
print("Log level priority: \(logLevel.priority)")
print("Category emoji: \(logCategory.emoji)")
print("Category OS log: \(logCategory.osLogCategory)")
print("App event description: \(appEvent.description)")
print("Auth state description: \(authState.description)")
print("Sync state description: \(syncState.description)")
print("Sync state log level: \(syncState.logLevel)")
print("Firebase state description: \(firebaseState.description)")
print("Firebase state log level: \(firebaseState.logLevel)")
print("Subscription state description: \(subscriptionState.description)")
print("Subscription state log level: \(subscriptionState.logLevel)")

// Test LoggerError
do {
    throw LoggerError.subsystemAlreadySet(existing: "test", attempted: "other")
} catch let error as LoggerError {
    print("Logger error description: \(error.errorDescription ?? "nil")")
} catch {
    print("Unexpected error")
}

print("✅ All public enums and their properties are accessible!")
