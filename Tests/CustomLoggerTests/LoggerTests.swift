//
//  File name: LoggerTests.swift  
//  Project name: apple-custom-logger
//  Workspace name: apple-custom-logger
//
//  Created by: nothing-to-add on 13/09/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import XCTest
@testable import CustomLogger

@MainActor
final class LoggerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Reset the subsystem between tests
        Logger._resetSubsystemForTesting()
    }
    
    func testLoggerInitializationWithSubsystem() throws {
        // Test that logger can be initialized with a subsystem
        _ = try Logger(subsystem: "com.test.myapp")
        
        // Verify the subsystem is set correctly
        XCTAssertEqual(Logger.subsystem, "com.test.myapp")
    }
    
    func testMultipleLoggersWithSameSubsystem() throws {
        // Test that multiple loggers can be created with the same subsystem
        let logger1 = try Logger(subsystem: "com.test.same")
        let logger2 = try Logger(subsystem: "com.test.same")
        
        // Both should succeed and share the same subsystem
        XCTAssertEqual(Logger.subsystem, "com.test.same")
        
        // Test that they can both log without issues
        logger1.info("Test message from logger 1")
        logger2.info("Test message from logger 2")
    }
    
    func testSubsystemCannotBeChanged() throws {
        // First logger sets the subsystem
        _ = try Logger(subsystem: "com.test.original")
        XCTAssertEqual(Logger.subsystem, "com.test.original")
        
        // Attempting to create a logger with different subsystem should throw
        XCTAssertThrowsError(try Logger(subsystem: "com.test.different")) { error in
            guard case LoggerError.subsystemAlreadySet(let existing, let attempted) = error else {
                XCTFail("Expected LoggerError.subsystemAlreadySet, got \(error)")
                return
            }
            
            XCTAssertEqual(existing, "com.test.original")
            XCTAssertEqual(attempted, "com.test.different")
        }
        
        // Original subsystem should remain unchanged
        XCTAssertEqual(Logger.subsystem, "com.test.original")
    }
    
    func testLoggerConfiguration() throws {
        let logger = try Logger(subsystem: "com.test.config")
        
        // Test configuration doesn't throw
        XCTAssertNoThrow(
            logger.configure(
                minimumLevel: .warning,
                enabled: true,
                consoleLogging: false,
                osLogging: true
            )
        )
    }
    
    func testBasicLoggingMethods() throws {
        let logger = try Logger(subsystem: "com.test.logging")
        
        // Test that basic logging methods don't throw
        XCTAssertNoThrow(logger.debug("Debug message"))
        XCTAssertNoThrow(logger.info("Info message"))
        XCTAssertNoThrow(logger.warning("Warning message"))
        XCTAssertNoThrow(logger.error("Error message"))
        XCTAssertNoThrow(logger.critical("Critical message"))
    }
    
    func testSpecializedLoggingMethods() throws {
        let logger = try Logger(subsystem: "com.test.specialized")
        
        // Test specialized logging methods
        XCTAssertNoThrow(logger.userAction("Button tap"))
        XCTAssertNoThrow(logger.auth("Login attempt"))
        XCTAssertNoThrow(logger.firebase("Connection established"))
        XCTAssertNoThrow(logger.data("Data saved"))
        XCTAssertNoThrow(logger.network("API request"))
        XCTAssertNoThrow(logger.performance("Operation completed", duration: 0.1))
    }
    
    func testTimingMethods() throws {
        let logger = try Logger(subsystem: "com.test.timing")
        
        // Test synchronous timing
        let result = logger.time("Test operation") {
            return "test result"
        }
        XCTAssertEqual(result, "test result")
        
        // Test method tracing
        XCTAssertNoThrow(logger.methodEntry())
        XCTAssertNoThrow(logger.methodExit())
    }
}
