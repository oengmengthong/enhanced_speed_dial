# Enhanced Speed Dial

A highly customizable Flutter package that provides an elegant speed dial floating action button with advanced blur background effects, flexible positioning, multiple direction layouts, and comprehensive styling options.

## ✨ Features

- 🎨 **Fully Customizable**: Complete control over colors, icons, animations, and styling
- 🌟 **Full-Screen Blur**: Backdrop blur effect that covers the entire screen using overlay
- ✨ **Smooth Animations**: Fluid icon rotation and option animations with custom curves
- 📍 **Flexible Positioning**: Position speed dial anywhere on screen
- 🧭 **Multiple Directions**: Options can expand up, down, left, or right
- 🎯 **Individual Option Styling**: Each option can have unique styling
- 📱 **Safe Area Support**: Proper positioning respecting device safe areas
- ♿ **Accessibility**: Built-in tooltip and semantic support
- 🔧 **Easy Integration**: Simple API with sensible defaults

## 🌟 Full-Screen Blur Background

When `showBlurBackground` is enabled, the Enhanced Speed Dial creates a full-screen overlay that:

- ✅ **Covers the entire screen** regardless of where the speed dial is positioned
- ✅ **Preserves option interactivity** by rendering them above the blur
- ✅ **Supports tap-to-close** functionality on the blurred background
- ✅ **Works seamlessly** as a `floatingActionButton` in Scaffold

## 📦 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  enhanced_speed_dial: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## 🚀 Quick Start

### Basic Example

```dart
import 'package:flutter/material.dart';
import 'package:enhanced_speed_dial/enhanced_speed_dial.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enhanced Speed Dial Example')),
      body: Center(child: Text('Hello World!')),
      floatingActionButton: EnhancedSpeedDial(
        mainIcon: Icons.add,
        options: [
          SpeedDialOption(
            label: 'Create Note',
            icon: Icons.note_add,
            color: Colors.green,
            heroTag: "create_note",
            onTap: () => print('Create Note tapped'),
          ),
          SpeedDialOption(
            label: 'Add Photo',
            icon: Icons.photo_camera,
            color: Colors.orange,
            heroTag: "add_photo",
            onTap: () => print('Add Photo tapped'),
          ),
        ],
      ),
    );
  }
}
```

## 🎛️ Advanced Customization

### Direction and Positioning

```dart
EnhancedSpeedDial(
  mainIcon: Icons.menu,
  direction: SpeedDialDirection.left, // up, down, left, right
  position: Offset(20, 20), // Custom positioning (right, bottom)
  options: [...],
)
```

### Animation Customization

```dart
EnhancedSpeedDial(
  mainIcon: Icons.add,
  animationDuration: Duration(milliseconds: 400),
  animationCurve: Curves.elasticOut,
  rotateMainFab: true,
  rotationAngle: 3.14159, // π radians (180 degrees)
  options: [...],
)
```

### Blur Background Effects

```dart
EnhancedSpeedDial(
  mainIcon: Icons.add,
  showBlurBackground: true,
  blurIntensity: 20.0,
  blurOverlayColor: Color.fromRGBO(0, 0, 0, 0.5),
  closeOnBlurTap: true,
  options: [...],
)
```

### Comprehensive Styling

```dart
EnhancedSpeedDial(
  mainIcon: Icons.menu,
  openIcon: Icons.close,
  backgroundColor: Colors.blue,
  foregroundColor: Colors.white,
  elevation: 8.0,
  fabSize: 60.0,
  optionFabSize: 48.0,
  optionSpacing: 20.0,
  labelSpacing: 16.0,
  showLabels: true,
  labelStyle: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
  ),
  options: [
    SpeedDialOption(
      label: 'Enhanced Action',
      icon: Icons.star,
      color: Colors.purple,
      foregroundColor: Colors.yellow,
      size: 52.0,
      elevation: 6.0,
      heroTag: "enhanced_action",
      tooltip: "Perform enhanced action",
      customLabel: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.purple.withOpacity(0.1),
          border: Border.all(color: Colors.purple),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text('Custom'),
      ),
      onTap: () => print('Enhanced action'),
    ),
  ],
)
```

## 📚 API Reference

### EnhancedSpeedDial Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `options` | `List<SpeedDialOption>` | **required** | List of speed dial options |
| `mainIcon` | `IconData` | **required** | Main FAB icon when closed |
| `openIcon` | `IconData?` | `Icons.close` | Main FAB icon when open |
| `backgroundColor` | `Color?` | `null` | Main FAB background color |
| `foregroundColor` | `Color?` | `null` | Main FAB foreground color |
| `showBlurBackground` | `bool` | `true` | Enable full-screen blur overlay |
| `blurIntensity` | `double` | `10.0` | Blur intensity (sigma value) |
| `blurOverlayColor` | `Color` | `Color.fromRGBO(0, 0, 0, 0.3)` | Blur overlay color |
| `animationDuration` | `Duration` | `Duration(milliseconds: 250)` | Animation duration |
| `animationCurve` | `Curve` | `Curves.easeInOut` | Animation curve |
| `direction` | `SpeedDialDirection` | `SpeedDialDirection.up` | Expansion direction |
| `position` | `Offset` | `Offset(16, 16)` | Position (right, bottom) |
| `fabSize` | `double?` | `null` | Main FAB size |
| `optionFabSize` | `double?` | `null` | Option FAB size |
| `optionSpacing` | `double` | `16.0` | Spacing between options |
| `labelSpacing` | `double` | `16.0` | Spacing between label and button |
| `rotateMainFab` | `bool` | `true` | Enable main FAB rotation |
| `rotationAngle` | `double` | `2π` | Rotation angle in radians |
| `closeOnOptionTap` | `bool` | `true` | Close on option tap |
| `closeOnBlurTap` | `bool` | `true` | Close on blur background tap |
| `showLabels` | `bool` | `true` | Show option labels |
| `labelStyle` | `TextStyle?` | `null` | Global label text style |

### SpeedDialOption Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `label` | `String` | **required** | Option label text |
| `icon` | `IconData` | **required** | Option icon |
| `color` | `Color` | **required** | Option background color |
| `onTap` | `VoidCallback` | **required** | Tap callback |
| `heroTag` | `String` | **required** | Unique hero tag |
| `tooltip` | `String?` | `null` | Tooltip text |
| `foregroundColor` | `Color?` | `Colors.white` | Foreground color |
| `size` | `double?` | `null` | Custom size |
| `elevation` | `double?` | `null` | Custom elevation |
| `enabled` | `bool` | `true` | Enable/disable option |
| `customLabel` | `Widget?` | `null` | Custom label widget |
| `showLabel` | `bool?` | `null` | Override global label visibility |
| `closeOnTap` | `bool?` | `null` | Override close behavior |

### SpeedDialDirection Enum

```dart
enum SpeedDialDirection {
  up,    // Options expand upward
  down,  // Options expand downward
  left,  // Options expand to the left
  right, // Options expand to the right
}
```

## API Reference

### EnhancedSpeedDial

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `options` | `List<SpeedDialOption>` | required | List of speed dial options to display |
| `mainIcon` | `IconData` | required | Main FAB icon when closed |
| `openIcon` | `IconData?` | `Icons.close` | Main FAB icon when open |
| `backgroundColor` | `Color?` | `null` | Background color of main FAB |
| `foregroundColor` | `Color?` | `null` | Foreground color of main FAB |
| `showBlurBackground` | `bool` | `true` | Whether to show blur background when open |
| `blurIntensity` | `double` | `10.0` | Blur intensity (sigma value) |
| `blurOverlayColor` | `Color` | `Color.fromRGBO(0, 0, 0, 0.3)` | Color of the blur overlay |
| `animationDuration` | `Duration` | `Duration(milliseconds: 250)` | Animation duration for opening/closing |
| `heroTag` | `String?` | `null` | Hero tag for the main FAB |
| `tooltip` | `String?` | `null` | Tooltip for the main FAB |
| `initiallyOpen` | `bool` | `false` | Whether the speed dial starts open |

### SpeedDialOption

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `label` | `String` | required | Label text displayed next to the button |
| `icon` | `IconData` | required | Icon displayed on the button |
| `color` | `Color` | required | Background color of the button |
| `onTap` | `VoidCallback` | required | Callback when button is pressed |
| `heroTag` | `String` | required | Unique hero tag for the button |
| `tooltip` | `String?` | `null` | Tooltip text for accessibility |
| `foregroundColor` | `Color?` | `Colors.white` | Foreground color of the button |

## Example App

See the [example](example/) directory for a complete sample application demonstrating various features of the Enhanced Speed Dial package.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
