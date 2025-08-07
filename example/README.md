# enhanced_speed_dial_example

# Enhanced Speed Dial Example - Testing Guide

This directory contains a comprehensive Flutter example application for testing the `enhanced_speed_dial` package with automated UI testing and macOS automation support.

## 📋 Table of Contents

- [Overview](#overview)
- [Features Tested](#features-tested)
- [Setup](#setup)
- [Running Tests](#running-tests)
- [Test Types](#test-types)
- [macOS Automation](#macos-automation)
- [Screenshots and Reports](#screenshots-and-reports)
- [Troubleshooting](#troubleshooting)

## 🔍 Overview

This example app demonstrates all features of the Enhanced Speed Dial package and includes comprehensive testing:

- **Unit Tests**: Test individual widget behaviors
- **Widget Tests**: Test UI interactions and state changes  
- **Integration Tests**: Test full app workflows across different platforms
- **macOS UI Automation**: Automated testing using macOS accessibility features
- **Performance Monitoring**: Track performance metrics during testing

## 🎯 Features Tested

### Simple Configuration
- Basic speed dial setup with minimal configuration
- Auto-generated colors and hero tags
- Default animations and positioning

### Advanced Configuration  
- All 4 corner positions (Top Left, Top Right, Bottom Left, Bottom Right)
- All 4 expansion directions (Up, Down, Left, Right)
- Blur background effects with adjustable intensity
- Custom styling and animations
- Individual option configurations

### Interactions Tested
- Opening and closing speed dial
- Tapping speed dial options
- Configuration changes
- State management
- Position consistency
- Performance under load

## ⚙️ Setup

### Prerequisites

1. **Flutter SDK** (latest stable version)
   ```bash
   flutter --version
   ```

2. **Xcode** (for iOS Simulator and macOS testing)
   ```bash
   xcode-select --version
   ```

3. **macOS Development** (optional, for desktop testing)
   ```bash
   flutter config --enable-macos-desktop
   ```

### Installation

1. Navigate to the example directory:
   ```bash
   cd example/
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Verify setup:
   ```bash
   flutter doctor
   ```

## 🚀 Running Tests

### Quick Start

Run all tests with the automated script:

```bash
./run_tests_macos.sh
```

This script will:
- Clean and install dependencies
- Run unit tests
- Run widget tests with coverage
- Run integration tests on available devices
- Generate coverage reports
- Optionally start the app for manual testing

### Individual Test Commands

#### Unit Tests
```bash
flutter test
```

#### Widget Tests with Coverage
```bash
flutter test --coverage
```

#### Integration Tests
```bash
# iOS Simulator
flutter test integration_test/ -d ios

# macOS Desktop
flutter test integration_test/ -d macos
```

#### Run App for Manual Testing
```bash
# iOS Simulator
flutter run -d ios

# macOS Desktop  
flutter run -d macos
```

## 🧪 Test Types

### 1. Unit Tests (`test/widget_test.dart`)

Comprehensive widget testing covering:
- **Initial State Testing**: Verify app starts correctly
- **Simple Mode Testing**: Test basic speed dial functionality
- **Advanced Mode Testing**: Test all configuration options
- **State Management**: Verify counter increments and resets
- **Configuration Changes**: Test corner and direction switching
- **Blur Controls**: Test blur toggle and intensity slider
- **All Corners**: Test speed dial in all 4 corners
- **All Directions**: Test expansion in all 4 directions

**Key Test Scenarios:**
```dart
// Test groups include:
- Enhanced Speed Dial Widget Tests (basic functionality)
- Enhanced Speed Dial Corner Positioning Tests (all corners)
- Enhanced Speed Dial Direction Tests (all directions)
```

### 2. Integration Tests (`integration_test/speed_dial_positioning_test.dart`)

Full workflow testing across real devices:
- **Complete App Flow**: End-to-end testing of simple configuration
- **Advanced Configuration**: Test all corners with screenshots
- **Blur Effects**: Test blur toggle and customization
- **Performance Testing**: Rapid open/close cycles with timing
- **Position Consistency**: Verify FAB position remains stable
- **Edge Cases**: Test rapid taps and configuration changes

**Features:**
- Automatic screenshot capture
- Performance timing measurements  
- Position consistency validation
- Cross-platform device testing

### 3. macOS UI Automation (`ui_automation_macos.sh`)

Advanced automation using macOS accessibility:
- **Accessibility Integration**: Uses macOS System Events for automation
- **Screenshot Capture**: Automated screenshots during testing
- **Performance Monitoring**: CPU and memory usage tracking
- **Keyboard Navigation**: Test keyboard accessibility
- **Visual Verification**: Compare screenshots for UI consistency

## 🖥️ macOS Automation

### Setup Accessibility Permissions

1. Go to **System Preferences** > **Security & Privacy** > **Privacy**
2. Select **Accessibility** from the sidebar
3. Click the lock to make changes
4. Add **Terminal** (or your IDE) to the allowed apps
5. Restart the automation script

### Running UI Automation

```bash
# macOS Desktop
./ui_automation_macos.sh

# iOS Simulator  
./ui_automation_macos.sh ios

# Show help
./ui_automation_macos.sh help
```

### What It Does

1. **App Startup**: Automatically starts the Flutter app
2. **Window Detection**: Finds the app window using accessibility APIs
3. **UI Interaction**: Simulates keyboard and mouse interactions
4. **Screenshot Capture**: Takes screenshots at key moments
5. **Performance Monitoring**: Tracks CPU/memory usage
6. **Report Generation**: Creates test reports with results

## 📊 Screenshots and Reports

### Test Artifacts

After running tests, you'll find:

```
example/
├── coverage/
│   ├── lcov.info          # Coverage data
│   └── html/              # HTML coverage report
├── screenshots_*/         # UI automation screenshots
├── performance_trace.trace # Performance profiling data
└── build/
    └── screenshots/       # Integration test screenshots
```

### Coverage Report

Open the HTML coverage report:
```bash
open coverage/html/index.html
```

### Screenshots

Integration test screenshots are automatically saved during test runs and can be viewed to verify UI behavior across different configurations.

## 🛠️ Troubleshooting

### Common Issues

#### 1. "No devices found"
```bash
# Check available devices
flutter devices

# Start iOS Simulator
open -a Simulator

# Enable macOS desktop
flutter config --enable-macos-desktop
```

#### 2. "Accessibility permissions denied"
- Follow the macOS Automation setup steps above
- Restart Terminal after granting permissions
- Try running the script again

#### 3. "Tests fail to find widgets"
- Ensure you're using the correct widget finders
- Check that the app has fully loaded before interactions
- Verify ValueKey widgets are properly set

#### 4. "Integration tests timeout"
- Increase timeout values in test files
- Ensure devices have sufficient resources
- Check for device-specific issues

### Debugging Tips

1. **Verbose Output**: Add `--verbose` flag to Flutter commands
2. **Device Logs**: Use `flutter logs` to see runtime output  
3. **Test Debugging**: Add `debugDumpApp()` calls in tests
4. **Screenshot Analysis**: Review generated screenshots for visual verification

## 📚 Additional Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/cookbook/testing)
- [Integration Testing Guide](https://docs.flutter.dev/cookbook/testing/integration)
- [Flutter macOS Desktop](https://docs.flutter.dev/platform-integration/macos)
- [Enhanced Speed Dial Package](../README.md)

## 🤝 Contributing

When adding new tests:

1. Follow the existing test structure and naming conventions
2. Add appropriate comments explaining test scenarios
3. Include both positive and negative test cases
4. Update this README with new test descriptions
5. Ensure tests are platform-agnostic where possible

## 📄 License

This example follows the same license as the Enhanced Speed Dial package.
