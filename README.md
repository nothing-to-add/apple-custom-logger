# apple-custom-logger

A comprehensive logging framework for Apple platform applications that provides structured logging with emoji-based visual categorization and different log levels for various app states and events.

## Features

- 🎯 **Structured Logging**: Organized logging with categories and levels
- 🔒 **Thread-Safe**: Safe to use across multiple threads with `@MainActor`
- 📱 **Apple Ecosystem**: Built specifically for iOS, macOS, watchOS, and tvOS
- 🎨 **Visual Categories**: Emoji-based categorization for easy log identification
- ⚡ **Performance Monitoring**: Built-in timing and performance logging
- 🔧 **Configurable**: Adjustable log levels and output destinations
- 🚀 **Subsystem Management**: Consistent subsystem across all logger instances

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/nothing-to-add/apple-custom-logger.git", from: "1.0.0")
]
```

## Usage

### Basic Setup

```swift
import CustomLogger

// Initialize logger with your app's subsystem
// All Logger instances MUST use the same subsystem
let logger = try Logger(subsystem: "com.mycompany.myapp")

// Basic logging
logger.info("App started successfully")
logger.warning("Low memory warning")
logger.error("Failed to load data")
```

### Subsystem Management

The Logger enforces that all instances use the same subsystem. Once set, the subsystem cannot be changed:

```swift
// First logger sets the subsystem
let logger1 = try Logger(subsystem: "com.myapp.main")

// This works - same subsystem
let logger2 = try Logger(subsystem: "com.myapp.main")

// This throws an error - different subsystem
let logger3 = try Logger(subsystem: "com.myapp.different") // ❌ Throws LoggerError.subsystemAlreadySet
```

### Configuration

```swift
let logger = try Logger(subsystem: "com.myapp.main")

logger.configure(
    minimumLevel: .info,        // Only log .info and above
    enabled: true,              // Enable logging
    consoleLogging: true,       // Log to console
    osLogging: true            // Log to OS unified logging
)
```

### Specialized Logging

```swift
// User actions
logger.userAction("Button tapped", details: "Login button")

// Performance monitoring
let result = logger.time("Database query") {
    // Your expensive operation here
    return performDatabaseQuery()
}

// State logging
logger.appLifecycle(.didFinishLaunching, details: "App launched")
logger.authState(.signedIn, userInfo: "user@example.com")
logger.syncState(.syncing, details: "Syncing user data")

// Method tracing
logger.methodEntry()
// ... method implementation
logger.methodExit()
```

### Category-Based Logging

```swift
logger.auth("User authentication successful")
logger.firebase("Connected to Firebase")
logger.data("Saved user preferences")
logger.network("API request completed")
logger.ui("View controller appeared")
logger.performance("Startup completed", duration: 0.5)
```

### Error Handling

```swift
do {
    let logger = try Logger(subsystem: "com.myapp.main")
    logger.info("Logger initialized successfully")
} catch LoggerError.subsystemAlreadySet(let existing, let attempted) {
    print("Error: Cannot change subsystem from '\(existing)' to '\(attempted)'")
} catch {
    print("Unexpected error: \(error)")
}
```

### SwiftUI Integration

```swift
@main
struct MyApp: App {
    private let logger: Logger
    
    init() {
        do {
            self.logger = try Logger(subsystem: "com.mycompany.myapp")
            logger.appLifecycle(.willFinishLaunching)
        } catch {
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
```

## Log Categories

- 📱 **App**: General application events
- 👤 **User Action**: User interaction tracking
- 🔐 **Auth**: Authentication and authorization
- 🔥 **Firebase**: Firebase-related operations
- 💾 **Data**: Data operations and persistence
- 🔄 **Sync**: Data synchronization
- 💎 **Subscription**: In-app purchases and subscriptions
- ⭐ **Premium**: Premium feature usage
- 🏺 **Jar**: App-specific jar operations
- ⚡ **Performance**: Performance metrics and timing
- 🌐 **Network**: Network requests and responses
- ⚙️ **Configuration**: App configuration changes
- 🎨 **UI**: User interface events
- 📢 **Notification**: Push notifications and alerts
- ❌ **Error**: Error conditions and exceptions

## Log Levels

- 🐛 **Debug**: Detailed information for debugging
- ℹ️ **Info**: General informational messages
- ⚠️ **Warning**: Warning conditions
- ❌ **Error**: Error conditions
- 🚨 **Critical**: Critical error conditions

## Thread Safety

The Logger is marked with `@MainActor` and implements `Sendable`, making it safe to use in concurrent environments while ensuring all logging operations happen on the main actor.

## Requirements

- iOS 14.0+ / macOS 11.0+ / watchOS 7.0+ / tvOS 14.0+
- Swift 5.9+
- Xcode 15.0+

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
