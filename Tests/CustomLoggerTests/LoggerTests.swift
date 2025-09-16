import XCTest
@testable import CustomLogger

final class LoggerTests: XCTestCase {
    
    func testLoggerExists() {
        // Simple test to verify the logger can be accessed
        XCTAssertNotNil(Logger.shared)
    }
    
    func testSubsystemIsNotEmpty() {
        // Test that subsystem is not empty
        let subsystem = Logger.shared.currentSubsystem
        XCTAssertFalse(subsystem.isEmpty)
        print("Subsystem: \(subsystem)")
    }
    
    func testBasicLogging() {
        // Test that logging methods don't crash
        XCTAssertNoThrow(Logger.shared.info("Test message"))
        XCTAssertNoThrow(Logger.shared.debug("Debug message"))
        XCTAssertNoThrow(Logger.shared.warning("Warning message"))
    }
}
