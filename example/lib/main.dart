/// Example app demonstrating the Enhanced Speed Dial package
library;

import 'package:flutter/material.dart';
import 'package:enhanced_speed_dial/enhanced_speed_dial.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enhanced Speed Dial Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ExampleScreen(),
    );
  }
}

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  String _lastAction = 'No action yet';
  bool _useSimpleVersion = true;
  SpeedDialCorner _selectedCorner = SpeedDialCorner.bottomRight;
  SpeedDialDirection _selectedDirection = SpeedDialDirection.up;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    setState(() {
      _lastAction = message;
    });
  }

  String _getCornerName(SpeedDialCorner corner) {
    switch (corner) {
      case SpeedDialCorner.topLeft:
        return 'Top Left';
      case SpeedDialCorner.topRight:
        return 'Top Right';
      case SpeedDialCorner.bottomLeft:
        return 'Bottom Left';
      case SpeedDialCorner.bottomRight:
        return 'Bottom Right';
    }
  }

  String _getDirectionName(SpeedDialDirection direction) {
    switch (direction) {
      case SpeedDialDirection.up:
        return 'Up';
      case SpeedDialDirection.down:
        return 'Down';
      case SpeedDialDirection.left:
        return 'Left';
      case SpeedDialDirection.right:
        return 'Right';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enhanced Speed Dial Example'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _useSimpleVersion = !_useSimpleVersion;
              });
            },
            child: Text(
              _useSimpleVersion ? 'Advanced' : 'Simple',
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _useSimpleVersion
                      ? 'Simple Configuration'
                      : 'Advanced Configuration',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  _useSimpleVersion
                      ? 'Minimal setup with auto-generated colors and hero tags'
                      : 'Full customization with explicit styling',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Corner selector
                if (!_useSimpleVersion) ...[
                  const Text('Position Corner:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: SpeedDialCorner.values.map((corner) {
                      return ChoiceChip(
                        label: Text(_getCornerName(corner)),
                        selected: _selectedCorner == corner,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedCorner = corner;
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text('Expand Direction:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: SpeedDialDirection.values.map((direction) {
                      return ChoiceChip(
                        label: Text(_getDirectionName(direction)),
                        selected: _selectedDirection == direction,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedDirection = direction;
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                ],

                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Features Demonstrated:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      if (_useSimpleVersion) ...[
                        const Text('• SpeedDialOption.simple() constructor'),
                        const Text('• Auto-generated colors'),
                        const Text('• Auto-generated hero tags'),
                        const Text('• Minimal configuration'),
                      ] else ...[
                        const Text('• Full customization options'),
                        const Text('• Custom colors and styling'),
                        const Text('• Individual option settings'),
                        const Text('• Advanced animations'),
                        const Text('• All corner positioning'),
                        const Text('• All direction expansions'),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Last action: $_lastAction',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
          // Place the speed dial as a positioned widget instead of floatingActionButton
          if (!_useSimpleVersion) _buildAdvancedSpeedDial(),
        ],
      ),
      floatingActionButton: _useSimpleVersion ? _buildSimpleSpeedDial() : null,
    );
  }

  // Simple version with minimal configuration
  Widget _buildSimpleSpeedDial() {
    return EnhancedSpeedDial.simple(
      mainIcon: Icons.menu,
      applySafeArea: false, // Required when used as floatingActionButton
      options: [
        SpeedDialOption.simple(
          label: 'Create',
          icon: Icons.add,
          onTap: () => _showSnackBar('Create tapped (simple)'),
        ),
        SpeedDialOption.simple(
          label: 'Edit',
          icon: Icons.edit,
          onTap: () => _showSnackBar('Edit tapped (simple)'),
        ),
        SpeedDialOption.simple(
          label: 'Share',
          icon: Icons.share,
          onTap: () => _showSnackBar('Share tapped (simple)'),
        ),
        SpeedDialOption.simple(
          label: 'Settings',
          icon: Icons.settings,
          onTap: () => _showSnackBar('Settings tapped (simple)'),
        ),
      ],
    );
  }

  // Advanced version with full customization
  Widget _buildAdvancedSpeedDial() {
    return EnhancedSpeedDial(
      mainIcon: Icons.add,
      openIcon: Icons.close,
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      showBlurBackground: true,
      blurIntensity: 10.0,
      blurOverlayColor: const Color.fromRGBO(0, 0, 0, 0.3),
      heroTag: "example_speed_dial",
      tooltip: "Open speed dial",
      animationDuration: const Duration(milliseconds: 300),
      animationCurve: Curves.easeInOutBack,
      corner: _selectedCorner, // Use selected corner
      direction: _selectedDirection, // Use selected direction
      optionSpacing: 12.0,
      mainToOptionSpacing: 24.0, // Better spacing from main FAB to first option
      labelSpacing: 16.0,
      fabSize: 56.0,
      optionFabSize: 48.0,
      elevation: 8.0,
      rotateMainFab: true,
      rotationAngle: 3.14159, // π radians (180 degrees)
      closeOnOptionTap: true,
      closeOnBlurTap: true,
      showLabels: true,
      applySafeArea: true, // Enable free positioning for all corners
      labelStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      options: [
        SpeedDialOption(
          label: 'Create Note',
          icon: Icons.note_add,
          color: Colors.green,
          heroTag: "create_note",
          tooltip: "Create a new note",
          onTap: () => _showSnackBar('Create Note tapped (advanced)'),
          elevation: 4.0,
          size: 52.0,
        ),
        SpeedDialOption(
          label: 'Add Photo',
          icon: Icons.photo_camera,
          color: Colors.orange,
          heroTag: "add_photo",
          tooltip: "Add a photo",
          onTap: () => _showSnackBar('Add Photo tapped (advanced)'),
          elevation: 4.0,
        ),
        SpeedDialOption(
          label: 'Record Audio',
          icon: Icons.mic,
          color: Colors.red,
          heroTag: "record_audio",
          tooltip: "Record audio",
          onTap: () => _showSnackBar('Record Audio tapped (advanced)'),
          elevation: 6.0,
          splashColor: Colors.red.withValues(alpha: 0.3),
        ),
        SpeedDialOption(
          label: 'Share',
          icon: Icons.share,
          color: Colors.purple,
          heroTag: "share",
          tooltip: "Share content",
          onTap: () => _showSnackBar('Share tapped (advanced)'),
          elevation: 4.0,
          closeOnTap: false, // This option won't close the speed dial
        ),
      ],
    );
  }
}
