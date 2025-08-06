import 'package:flutter/material.dart';

/// Direction for speed dial options to expand
enum SpeedDialDirection {
  up,
  down,
  left,
  right,
}

/// Configuration class for a speed dial option
class SpeedDialOption {
  /// The label text to display next to the button
  final String label;

  /// The icon to display on the button
  final IconData icon;

  /// The background color of the button (auto-generated if not provided)
  final Color? color;

  /// The callback function when the button is pressed
  final VoidCallback onTap;

  /// A unique hero tag for the FloatingActionButton (auto-generated if not provided)
  final String? heroTag;

  /// The tooltip text for accessibility
  final String? tooltip;

  /// The foreground color of the button (defaults to white)
  final Color? foregroundColor;

  /// Custom size for this specific option button
  final double? size;

  /// Custom elevation for this specific option button
  final double? elevation;

  /// Custom shape for this specific option button
  final ShapeBorder? shape;

  /// Custom splash color for this specific option button
  final Color? splashColor;

  /// Custom focus color for this specific option button
  final Color? focusColor;

  /// Custom hover color for this specific option button
  final Color? hoverColor;

  /// Whether this option should be enabled
  final bool enabled;

  /// Custom margin for this specific option
  final EdgeInsetsGeometry? margin;

  /// Custom label style for this specific option
  final TextStyle? labelStyle;

  /// Custom label decoration for this specific option
  final BoxDecoration? labelDecoration;

  /// Custom label padding for this specific option
  final EdgeInsetsGeometry? labelPadding;

  /// Whether to show the label for this specific option
  final bool? showLabel;

  /// Custom widget to use instead of the default label
  final Widget? customLabel;

  /// Custom spacing between label and button for this option
  final double? labelSpacing;

  /// Whether this option should close the speed dial when tapped
  final bool? closeOnTap;

  const SpeedDialOption({
    required this.label,
    required this.icon,
    required this.onTap,
    this.color,
    this.heroTag,
    this.tooltip,
    this.foregroundColor,
    this.size,
    this.elevation,
    this.shape,
    this.splashColor,
    this.focusColor,
    this.hoverColor,
    this.enabled = true,
    this.margin,
    this.labelStyle,
    this.labelDecoration,
    this.labelPadding,
    this.showLabel,
    this.customLabel,
    this.labelSpacing,
    this.closeOnTap,
  });

  /// Quick constructor for simple options with just icon, label, and callback
  /// Colors and heroTag will be auto-generated
  const SpeedDialOption.simple({
    required this.label,
    required this.icon,
    required this.onTap,
    this.tooltip,
    this.enabled = true,
    this.closeOnTap,
  })  : color = null,
        heroTag = null,
        foregroundColor = null,
        size = null,
        elevation = null,
        shape = null,
        splashColor = null,
        focusColor = null,
        hoverColor = null,
        margin = null,
        labelStyle = null,
        labelDecoration = null,
        labelPadding = null,
        showLabel = null,
        customLabel = null,
        labelSpacing = null;
}
