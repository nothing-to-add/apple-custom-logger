# apple-custom-logger

[![Swift](https://img.shields.io/badge/Swift-6.1-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS_13+_|_macOS_11+_|_watchOS_7+_|_visionOS_1+-blue.svg)](https://developer.apple.com)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![License](https://img.shields.io/badge/License-MIT-lightgrey.svg)](LICENSE)
[![GitHub Release](https://img.shields.io/github/v/release/nothing-to-add/apple-custom-logger)](https://github.com/nothing-to-add/apple-custom-logger/releases)
[![GitHub Issues](https://img.shields.io/github/issues/nothing-to-add/apple-custom-logger)](https://github.com/nothing-to-add/apple-custom-logger/issues)

A comprehensive logging framework for Apple platform applications that provides structured logging with emoji-based visual categorization and different log levels for various app states and events.

## Table of Contents

- [About This Package](#about-this-package)
- [Features](#features)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Usage](#usage)
  - [Basic Setup](#basic-setup)
  - [Subsystem Management](#subsystem-management)
  - [Configuration](#configuration)
  - [Specialized Logging](#specialized-logging)
  - [Category-Based Logging](#category-based-logging)
  - [Error Handling](#error-handling)
  - [SwiftUI Integration](#swiftui-integration)
- [Log Categories](#log-categories)
- [Log Levels](#log-levels)
- [Thread Safety](#thread-safety)
- [Requirements](#requirements)
- [Compatibility](#compatibility)
- [Contributing](#contributing)
- [License](#license)

## About This Package

**apple-custom-logger** is a powerful, thread-safe logging framework designed specifically for Apple's ecosystem. It combines the robustness of Apple's unified logging system with an intuitive, emoji-based categorization system that makes log analysis both efficient and visually appealing.

### Key Benefits

- **Unified Logging Integration**: Built on top of Apple's `os.Logger` for optimal performance and system integration
- **Visual Log Organization**: Emoji-based categories make it easy to scan and filter logs during development and debugging
- **Type-Safe Architecture**: Swift-native design with comprehensive error handling and type safety
- **Zero Dependencies**: Pure Swift implementation with no external dependencies
- **Performance Focused**: Minimal overhead with efficient logging mechanisms

## Features

- 🎯 **Structured Logging**: Organized logging with categories and levels
- 🔒 **Thread-Safe**: Safe to use across multiple threads with `@MainActor`
- 📱 **Apple Ecosystem**: Built specifically for iOS, macOS, watchOS, and tvOS
- 🎨 **Visual Categories**: Emoji-based categorization for easy log identification
- ⚡ **Performance Monitoring**: Built-in timing and performance logging
- 🔧 **Configurable**: Adjustable log levels and output destinations
- 🚀 **Subsystem Management**: Consistent subsystem across all logger instances

## Installation

### Adding to Xcode Project (Recommended)

1. **In Xcode**: Go to `File` → `Add Package Dependencies...`
2. **Enter URL**: `https://github.com/nothing-to-add/apple-custom-logger.git`
3. **Version Rule**: Select "Up to Next Major Version" and enter `1.0.0`
4. **Add to Target**: Select your app target and click "Add Package"

### Swift Package Manager (Package.swift)

For **standalone Swift packages** or **server-side projects**, add the dependency to your `Package.swift` file:

```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "YourPackageName",
    platforms: [
        .iOS(.v13),
        .macOS(.v11),
        .watchOS(.v7),
        .visionOS(.v1)
    ],
    dependencies: [
        .package(url: "https://github.com/nothing-to-add/apple-custom-logger.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "YourTarget",
            dependencies: [
                .product(name: "CustomLogger", package: "apple-custom-logger")
            ]
        ),
        .testTarget(
            name: "YourTargetTests",
            dependencies: ["YourTarget"]
        )
    ]
)
```

### Manual Integration

For projects that cannot use Swift Package Manager:

1. **Download**: Download or clone this repository
2. **Drag & Drop**: Add the `Sources/CustomLogger` folder to your Xcode project
3. **Target Membership**: Ensure all files are added to your target
4. **Import**: Use `import CustomLogger` in your Swift files

### CocoaPods (Alternative)

If you prefer CocoaPods, you can reference the GitHub repository:

```ruby
# Podfile
pod 'CustomLogger', :git => 'https://github.com/nothing-to-add/apple-custom-logger.git', :tag => '1.0.0'
```

*Note: This package is primarily designed for Swift Package Manager. CocoaPods support may require additional configuration.*

## Quick Start

```swift
import CustomLogger

// 1. Initialize the logger with your app's bundle identifier
let logger = try Logger(subsystem: "com.yourcompany.yourapp")

// 2. Configure logging preferences (optional)
logger.configure(
    minimumLevel: .info,
    enabled: true,
    consoleLogging: true,
    osLogging: true
)

// 3. Start logging!
logger.info("App initialized successfully")
logger.userAction("User tapped login button")
logger.error("Network request failed")
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

- **iOS 13.0+** / **macOS 11.0+** / **watchOS 7.0+** / **visionOS 1.0+**
- **Swift 6.1+**
- **Xcode 15.0+**

## Compatibility

This package is built with Swift 6.1 and supports:
- ✅ **iOS**: iPhone, iPad, and iPod touch
- ✅ **macOS**: Mac computers with Apple Silicon and Intel processors
- ✅ **watchOS**: Apple Watch
- ✅ **visionOS**: Apple Vision Pro
- ✅ **Swift Concurrency**: Full async/await support
- ✅ **SwiftUI**: Native integration with SwiftUI apps
- ✅ **UIKit/AppKit**: Compatible with traditional UI frameworks

## Contributing

We welcome contributions to apple-custom-logger! Here's how you can help:

### Reporting Issues

- **Bug Reports**: Use the [GitHub Issues](https://github.com/nothing-to-add/apple-custom-logger/issues) page
- **Feature Requests**: Describe your use case and proposed functionality
- **Documentation**: Help improve examples and documentation

### Development Setup

1. **Fork** the repository on GitHub
2. **Clone** your fork locally:
   ```bash
   git clone https://github.com/your-username/apple-custom-logger.git
   cd apple-custom-logger
   ```
3. **Open** the project in Xcode:
   ```bash
   open Package.swift
   ```
4. **Run Tests**: Use `Cmd+U` in Xcode or:
   ```bash
   swift test
   ```

### Pull Requests

- Create a feature branch: `git checkout -b feature/amazing-feature`
- Make your changes and add tests
- Ensure all tests pass
- Submit a pull request with a clear description

### Code Style

- Follow Swift naming conventions
- Add documentation comments for public APIs
- Include unit tests for new functionality
- Maintain backward compatibility when possible

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
