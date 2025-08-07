# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-08-07

### Added

#### Core Widget Features

- **EnhancedSpeedDial** widget with full-screen blur background overlay
- **SpeedDialOption** class for individual option configuration
- Two positioning systems: corner-based positioning with `SpeedDialCorner` enum
- Four expansion directions via `SpeedDialDirection` enum (up, down, left, right)
- Smooth animations with customizable duration, curves, and rotation effects

#### Simple Constructor API

- **EnhancedSpeedDial.simple()** constructor for quick setup with minimal configuration
- **SpeedDialOption.simple()** constructor with auto-generated colors and hero tags
- Automatic color generation and hero tag assignment for streamlined development

#### Positioning & Layout

- Corner positioning system (`topLeft`, `topRight`, `bottomLeft`, `bottomRight`)
- Configurable offset from screen edges (`offsetFromEdge` property)
- Multiple spacing controls: `optionSpacing`, `mainToOptionSpacing`, `labelSpacing`
- Safe area handling with `applySafeArea` toggle for Scaffold integration

#### Animation & Effects

- Full-screen blur background with configurable intensity and overlay color
- Main FAB rotation animation with customizable angle and enable/disable toggle
- Smooth open/close animations with configurable curves and duration
- Tap-to-close functionality on blur background

#### Styling & Customization

- Individual option styling: size, elevation, colors, shapes
- Global and per-option label styling with custom decorations and padding
- Custom label widgets support via `customLabel` property
- Material Design integration with splash, focus, and hover colors
- Comprehensive theming support for both light and dark modes

#### Accessibility & User Experience

- Built-in tooltip support for all interactive elements
- Semantic labels and accessibility annotations
- Keyboard navigation and screen reader support
- Enable/disable states for individual options

#### Developer Experience

- Comprehensive API with 25+ configurable properties for main widget
- 20+ configurable properties for individual options
- Extensive documentation with multiple examples
- Type-safe enum-based configuration
- Auto-generated hero tags and colors to prevent conflicts

### Technical Implementation

#### Architecture

- Stateful widget with proper animation controller management
- Overlay-based full-screen blur implementation
- Positioned widgets for precise layout control
- Material Design FloatingActionButton integration

#### Performance

- Optimized animation performance with proper dispose handling
- Efficient overlay management for blur effects
- Memory-conscious widget tree construction

#### Compatibility

- Flutter SDK compatibility
- Cross-platform support (iOS, Android, Web, Desktop)
- Material Design 3 integration
- RTL language support

### Documentation

- Complete API reference with property descriptions and defaults
- Multiple usage examples from basic to advanced
- Screenshot gallery showing various configurations
- Migration guide for different use cases
- Comprehensive README with feature overview
