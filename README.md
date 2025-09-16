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
- [What's New in 1.0.1](#whats-new-in-101)
- [Quick Start](#quick-start)
- [Usage](#usage)
  - [Basic Setup](#basic-setup)
  - [Singleton Pattern](#singleton-pattern)
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
- **Automatic Setup**: Subsystem automatically derived from bundle identifier for zero-configuration usage
- **Singleton Pattern**: Global access via `Logger.shared` eliminates initialization complexity

## Features

- 🎯 **Structured Logging**: Organized logging with categories and levels
- 🔒 **Thread-Safe**: Safe to use across multiple threads with proper internal synchronization
- 📱 **Apple Ecosystem**: Built specifically for iOS, macOS, watchOS, and tvOS
- 🎨 **Visual Categories**: Emoji-based categorization for easy log identification
- ⚡ **Performance Monitoring**: Built-in timing and performance logging
- 🔧 **Configurable**: Adjustable log levels and output destinations
- 🚀 **Singleton Pattern**: Global access with `Logger.shared` - no initialization needed
- 🛠️ **Automatic Subsystem**: Derives subsystem automatically from bundle identifier

## Installation

### Adding to Xcode Project (Recommended)

1. **In Xcode**: Go to `File` → `Add Package Dependencies...`
2. **Enter URL**: `https://github.com/nothing-to-add/apple-custom-logger.git`
3. **Version Rule**: Select "Up to Next Major Version" and enter `1.0.1`
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
        .package(url: "https://github.com/nothing-to-add/apple-custom-logger.git", from: "1.0.1")
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
pod 'CustomLogger', :git => 'https://github.com/nothing-to-add/apple-custom-logger.git', :tag => '1.0.1'
```

*Note: This package is primarily designed for Swift Package Manager. CocoaPods support may require additional configuration.*

## What's New in 1.0.1

🎉 **Major Simplification**: Version 1.0.1 introduces a revolutionary singleton pattern that makes logging incredibly simple and intuitive!

### Key Improvements

- **🚀 Singleton Pattern**: Access the logger globally with `Logger.shared` - no more complex initialization
- **🛠️ Automatic Subsystem**: Subsystem automatically derived from your app's bundle identifier 
- **❌ No Error Handling**: Eliminated the need for `try/catch` blocks when creating logger instances
- **🔄 Thread Safety**: Enhanced thread safety with internal synchronization instead of `@MainActor`
- **🎯 Zero Configuration**: Works out of the box with sensible defaults
- **📦 Backward Compatible**: Existing logging methods work exactly the same

### Migration from 1.0.0

```swift
// OLD (1.0.0) - Complex initialization
do {
    let logger = try Logger(subsystem: "com.myapp.main")
    logger.info("Hello world")
} catch {
    // Handle error
}

// NEW (1.0.1) - Simple singleton pattern
Logger.shared.info("Hello world")  // That's it! 🎉
```

## Quick Start

```swift
import CustomLogger

// 1. Use the shared logger instance (subsystem automatically derived from bundle ID)
Logger.shared.info("App initialized successfully")

// 2. Configure logging preferences globally (optional)
Logger.shared.configure(
    minimumLevel: .info,
    osLogging: true
)

// 3. Use anywhere in your app - no initialization needed!
Logger.shared.userAction("User tapped login button")
Logger.shared.error("Network request failed")
```

## Usage

### Basic Setup

```swift
import CustomLogger

// Use the shared logger instance - no initialization required
Logger.shared.info("App started successfully")
Logger.shared.warning("Low memory warning")
Logger.shared.error("Failed to load data")

// Check the automatically derived subsystem
print("Current subsystem: \(Logger.shared.currentSubsystem)")
```

### Singleton Pattern

The Logger uses a singleton pattern with automatic subsystem derivation:

```swift
// Access the shared logger from anywhere
Logger.shared.info("This works from any module")

// The subsystem is automatically derived from bundle ID:
// Bundle ID: "com.mycompany.myapp" → Subsystem: "mycompany.myapp"
// Bundle ID: "org.example.greatapp" → Subsystem: "example.greatapp"

// Get the current subsystem
let subsystem = Logger.shared.currentSubsystem
print("Using subsystem: \(subsystem)")

// Configuration affects the global logger instance
Logger.shared.configure(minimumLevel: .info, enabled: true)
```

### Configuration

```swift
Logger.shared.configure(
    minimumLevel: .info,        // Only log .info and above
    osLogging: true            // Log to OS unified logging
)
```

### Specialized Logging

```swift
// User actions
Logger.shared.userAction("Button tapped", details: "Login button")

// Performance monitoring
let result = Logger.shared.time("Database query") {
    // Your expensive operation here
    return performDatabaseQuery()
}

// State logging
Logger.shared.appLifecycle(.didFinishLaunching, details: "App launched")
Logger.shared.authState(.signedIn, userInfo: "user@example.com")
Logger.shared.syncState(.syncing, details: "Syncing user data")

// Method tracing
Logger.shared.methodEntry()
// ... method implementation
Logger.shared.methodExit()
```

### Category-Based Logging

```swift
Logger.shared.auth("User authentication successful")
Logger.shared.firebase("Connected to Firebase")
Logger.shared.data("Saved user preferences")
Logger.shared.network("API request completed")
Logger.shared.ui("View controller appeared")
Logger.shared.performance("Startup completed", duration: 0.5)
```

### Error Handling

```swift
// No error handling needed with singleton pattern!
Logger.shared.info("Logger is always ready to use")
print("Using subsystem: \(Logger.shared.currentSubsystem)")
```

### SwiftUI Integration

```swift
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

The Logger singleton is implemented with `@unchecked Sendable` and uses proper synchronization internally, making it safe to use across multiple threads and contexts without additional synchronization requirements.

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
