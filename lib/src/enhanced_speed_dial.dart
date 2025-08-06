import 'package:flutter/material.dart';
import 'dart:ui';
import 'speed_dial_option.dart';

/// A customizable speed dial floating action button with blur background
class EnhancedSpeedDial extends StatefulWidget {
  /// List of speed dial options to display
  final List<SpeedDialOption> options;

  /// The main floating action button icon when closed
  final IconData mainIcon;

  /// The main floating action button icon when open (defaults to close icon)
  final IconData? openIcon;

  /// The background color of the main floating action button
  final Color? backgroundColor;

  /// The foreground color of the main floating action button
  final Color? foregroundColor;

  /// Whether to show a blur background when open
  final bool showBlurBackground;

  /// The blur intensity (sigma value for the blur effect)
  final double blurIntensity;

  /// The color of the blur overlay
  final Color blurOverlayColor;

  /// Animation duration for opening/closing
  final Duration animationDuration;

  /// Hero tag for the main floating action button
  final String? heroTag;

  /// Tooltip for the main floating action button
  final String? tooltip;

  /// Whether the speed dial is initially open
  final bool initiallyOpen;

  /// Position of the speed dial (bottom-right by default)
  final Offset position;

  /// Size of the main floating action button
  final double? fabSize;

  /// Size of the option floating action buttons
  final double? optionFabSize;

  /// Spacing between options
  final double optionSpacing;

  /// Spacing between the main FAB and the first option
  final double mainToOptionSpacing;

  /// Spacing between the label and the option button
  final double labelSpacing;

  /// Custom animation curve for opening/closing
  final Curve animationCurve;

  /// Whether to close the speed dial when an option is tapped
  final bool closeOnOptionTap;

  /// Custom elevation for the main floating action button
  final double? elevation;

  /// Custom shape for the main floating action button
  final ShapeBorder? shape;

  /// Whether to show labels for options
  final bool showLabels;

  /// Custom text style for option labels
  final TextStyle? labelStyle;

  /// Custom decoration for option label cards
  final BoxDecoration? labelDecoration;

  /// Custom padding for option label cards
  final EdgeInsetsGeometry? labelPadding;

  /// Direction to open the speed dial options (up by default)
  final SpeedDialDirection direction;

  /// Custom margin for each option
  final EdgeInsetsGeometry? optionMargin;

  /// Whether the main FAB should rotate when opening/closing
  final bool rotateMainFab;

  /// Rotation angle in radians for the main FAB (2π by default)
  final double rotationAngle;

  /// Custom splash color for the main FAB
  final Color? splashColor;

  /// Custom focus color for the main FAB
  final Color? focusColor;

  /// Custom hover color for the main FAB
  final Color? hoverColor;

  /// Whether the blur background is clickable to close the speed dial
  final bool closeOnBlurTap;

  /// Whether to apply SafeArea automatically (disable when used as Scaffold floatingActionButton)
  final bool applySafeArea;

  const EnhancedSpeedDial({
    super.key,
    required this.options,
    required this.mainIcon,
    this.openIcon,
    this.backgroundColor,
    this.foregroundColor,
    this.showBlurBackground = true,
    this.blurIntensity = 10.0,
    this.blurOverlayColor = const Color.fromRGBO(0, 0, 0, 0.3),
    this.animationDuration = const Duration(milliseconds: 250),
    this.heroTag,
    this.tooltip,
    this.initiallyOpen = false,
    this.position = const Offset(16, 16), // bottom: 16, right: 16
    this.fabSize,
    this.optionFabSize,
    this.optionSpacing = 8.0,
    this.mainToOptionSpacing = 8.0,
    this.labelSpacing = 16.0,
    this.animationCurve = Curves.easeInOut,
    this.closeOnOptionTap = true,
    this.elevation,
    this.shape,
    this.showLabels = true,
    this.labelStyle,
    this.labelDecoration,
    this.labelPadding,
    this.direction = SpeedDialDirection.up,
    this.optionMargin,
    this.rotateMainFab = true,
    this.rotationAngle = 6.283185307179586, // 2 * π
    this.splashColor,
    this.focusColor,
    this.hoverColor,
    this.closeOnBlurTap = true,
    this.applySafeArea = true,
  });

  /// Simple constructor for quick setup with minimal configuration
  /// Only requires options and main icon - everything else uses smart defaults
  const EnhancedSpeedDial.simple({
    super.key,
    required this.options,
    required this.mainIcon,
    this.applySafeArea = true,
  })  : openIcon = null,
        backgroundColor = null,
        foregroundColor = null,
        showBlurBackground = true,
        blurIntensity = 10.0,
        blurOverlayColor = const Color.fromRGBO(0, 0, 0, 0.3),
        animationDuration = const Duration(milliseconds: 250),
        heroTag = null,
        tooltip = null,
        initiallyOpen = false,
        position = const Offset(16, 16),
        fabSize = null,
        optionFabSize = null,
        optionSpacing = 8.0,
        mainToOptionSpacing = 8.0,
        labelSpacing = 16.0,
        animationCurve = Curves.easeInOut,
        closeOnOptionTap = true,
        elevation = null,
        shape = null,
        showLabels = true,
        labelStyle = null,
        labelDecoration = null,
        labelPadding = null,
        direction = SpeedDialDirection.up,
        optionMargin = null,
        rotateMainFab = true,
        rotationAngle = 6.283185307179586,
        splashColor = null,
        focusColor = null,
        hoverColor = null,
        closeOnBlurTap = true;

  @override
  State<EnhancedSpeedDial> createState() => _EnhancedSpeedDialState();
}

class _EnhancedSpeedDialState extends State<EnhancedSpeedDial>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  bool _isOpen = false;
  OverlayEntry? _overlayEntry;
  final GlobalKey _mainFabKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _isOpen = widget.initiallyOpen;
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    // Rotation animation for main FAB
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: widget.rotationAngle / (2 * 3.14159), // Convert to rotation fraction
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.animationCurve,
    ));

    // Scale animation for options
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.animationCurve,
    ));

    if (_isOpen) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleSpeedDial() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _animationController.forward();
        if (widget.showBlurBackground) {
          _showOverlay();
        }
      } else {
        _animationController.reverse();
        _removeOverlay();
      }
    });
  }

  void _showOverlay() {
    if (_overlayEntry == null && widget.showBlurBackground) {
      // Get the actual position of the main FAB using its GlobalKey
      final RenderBox? mainFabRenderBox =
          _mainFabKey.currentContext?.findRenderObject() as RenderBox?;

      Offset actualFabPosition = Offset.zero;
      Size actualFabSize = Size(widget.fabSize ?? 56.0, widget.fabSize ?? 56.0);

      if (mainFabRenderBox != null) {
        // Get the FAB's actual position on screen
        actualFabPosition = mainFabRenderBox.localToGlobal(Offset.zero);
        actualFabSize = mainFabRenderBox.size;
      } else {
        // Fallback calculation if key is not available
        final adjustedPosition = _getAdjustedPosition(context);
        final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
        final Offset widgetPosition =
            renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;

        actualFabPosition = Offset(
          widgetPosition.dx + adjustedPosition.dx,
          widgetPosition.dy + adjustedPosition.dy,
        );
      }

      // Calculate the position relative to the screen for overlay positioning
      final screenSize = MediaQuery.of(context).size;
      final bottomPosition =
          screenSize.height - actualFabPosition.dy - actualFabSize.height;
      final rightPosition =
          screenSize.width - actualFabPosition.dx - actualFabSize.width;

      _overlayEntry = OverlayEntry(
        builder: (context) {
          final overlayStack = Stack(
            children: [
              // Full screen blur background
              Positioned.fill(
                child: GestureDetector(
                  onTap: widget.closeOnBlurTap ? _toggleSpeedDial : null,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: widget.blurIntensity,
                      sigmaY: widget.blurIntensity,
                    ),
                    child: Container(
                      color: widget.blurOverlayColor,
                    ),
                  ),
                ),
              ),
              // Speed dial options positioned above the main FAB
              Positioned(
                bottom: bottomPosition +
                    (widget.fabSize ?? 56.0) +
                    widget.mainToOptionSpacing,
                right: rightPosition,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  spacing: widget.optionSpacing,
                  children: _buildOptionsForOverlay(),
                ),
              ),
              // Main FAB rendered in overlay to stay above blur
              Positioned(
                bottom: bottomPosition,
                right: rightPosition,
                child: _buildMainFabForOverlay(),
              ),
            ],
          );

          // Conditionally wrap with SafeArea based on applySafeArea setting
          return widget.applySafeArea
              ? SafeArea(child: overlayStack)
              : overlayStack;
        },
      );
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  // Helper method to generate a color for an option if not provided
  Color _getOptionColor(SpeedDialOption option, int index) {
    if (option.color != null) return option.color!;

    // Pre-defined color palette for auto-generation
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
      Colors.amber,
      Colors.cyan,
    ];

    return colors[index % colors.length];
  }

  // Helper method to generate a heroTag for an option if not provided
  String _getOptionHeroTag(SpeedDialOption option, int index) {
    if (option.heroTag != null) return option.heroTag!;

    // Auto-generate based on label and index
    final baseTag = widget.heroTag ?? "enhanced_speed_dial";
    final cleanLabel =
        option.label.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toLowerCase();
    return "${baseTag}_option_${cleanLabel}_$index";
  }

  // Helper method to get consistent positioning that accounts for safe areas
  Offset _getAdjustedPosition(BuildContext context) {
    // When applySafeArea is false (used as floatingActionButton),
    // we need to account for the Scaffold's positioning
    if (!widget.applySafeArea) {
      final mediaQuery = MediaQuery.of(context);
      final padding = mediaQuery.padding;

      // Calculate position similar to how Scaffold positions the FAB
      // Default FAB position is bottom-right with 16px margins
      return Offset(
        widget.position.dx + padding.right,
        widget.position.dy + padding.bottom,
      );
    }

    // When applySafeArea is true, use original position
    return widget.position;
  }

  @override
  Widget build(BuildContext context) {
    final adjustedPosition = _getAdjustedPosition(context);

    final stackWidget = Stack(
      children: [
        // Speed dial options (only when not using overlay)
        if (_isOpen && !widget.showBlurBackground)
          Positioned(
            bottom: adjustedPosition.dy,
            right: adjustedPosition.dx,
            child: _buildOptionsOnly(),
          ),
        // Speed dial main button (hidden when overlay is active to prevent double rendering)
        if (!(_isOpen && widget.showBlurBackground))
          Positioned(
            bottom: adjustedPosition.dy,
            right: adjustedPosition.dx,
            child: _buildMainFab(),
          ),
      ],
    );

    // Conditionally wrap with SafeArea based on applySafeArea setting
    return widget.applySafeArea ? SafeArea(child: stackWidget) : stackWidget;
  }

  Widget _buildOptionsOnly() {
    switch (widget.direction) {
      case SpeedDialDirection.up:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Speed dial options
            ...widget.options.reversed.toList().asMap().entries.map((entry) {
              final index =
                  widget.options.length - 1 - entry.key; // Reverse index
              final option = entry.value;
              return AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: _buildSpeedDialOption(option, index),
                  );
                },
              );
            }),
            // Spacing between options and main button
            if (widget.options.isNotEmpty)
              SizedBox(height: widget.mainToOptionSpacing),
          ],
        );
      case SpeedDialDirection.down:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: widget.mainToOptionSpacing,
          children: [
            // Speed dial options
            ...widget.options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              return AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: _buildSpeedDialOption(option, index),
                  );
                },
              );
            }),
          ],
        );
      case SpeedDialDirection.left:
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: widget.mainToOptionSpacing,
          children: [
            // Speed dial options
            ...widget.options.reversed.toList().asMap().entries.map((entry) {
              final index =
                  widget.options.length - 1 - entry.key; // Reverse index
              final option = entry.value;
              return AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: _buildSpeedDialOptionHorizontal(option, index),
                  );
                },
              );
            }),
          ],
        );
      case SpeedDialDirection.right:
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: widget.mainToOptionSpacing,
          children: [
            // Speed dial options
            ...widget.options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              return AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: _buildSpeedDialOptionHorizontal(option, index),
                  );
                },
              );
            }),
          ],
        );
    }
  }

  List<Widget> _buildOptionsForOverlay() {
    return widget.options.reversed.toList().asMap().entries.map((entry) {
      final index = widget.options.length - 1 - entry.key; // Reverse index
      final option = entry.value;
      return AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: _buildSpeedDialOption(option, index),
          );
        },
      );
    }).toList();
  }

  Widget _buildMainFab() {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle:
              widget.rotateMainFab ? _rotationAnimation.value * 2 * 3.14159 : 0,
          child: Material(
            elevation: widget.elevation ?? 8.0,
            shape: widget.shape ?? const CircleBorder(),
            shadowColor: (widget.backgroundColor ??
                    Theme.of(context).colorScheme.primary)
                .withValues(alpha: 0.4),
            child: SizedBox(
              key: _mainFabKey,
              width: widget.fabSize ?? 56.0,
              height: widget.fabSize ?? 56.0,
              child: FloatingActionButton(
                heroTag: widget.heroTag ?? "enhanced_speed_dial_main",
                onPressed: _toggleSpeedDial,
                backgroundColor: widget.backgroundColor ??
                    Theme.of(context).colorScheme.primary,
                foregroundColor: widget.foregroundColor ??
                    Theme.of(context).colorScheme.onPrimary,
                elevation: 0.0, // Material widget handles elevation
                shape: widget.shape ?? const CircleBorder(),
                splashColor: widget.splashColor,
                focusColor: widget.focusColor,
                hoverColor: widget.hoverColor,
                tooltip: widget.tooltip,
                child: Icon(
                  _isOpen ? (widget.openIcon ?? Icons.close) : widget.mainIcon,
                  size:
                      (widget.fabSize ?? 56.0) * 0.43, // Proportional icon size
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainFabForOverlay() {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle:
              widget.rotateMainFab ? _rotationAnimation.value * 2 * 3.14159 : 0,
          child: Material(
            elevation:
                (widget.elevation ?? 8.0) + 2.0, // Higher elevation in overlay
            shape: widget.shape ?? const CircleBorder(),
            shadowColor: (widget.backgroundColor ??
                    Theme.of(context).colorScheme.primary)
                .withValues(alpha: 0.5),
            child: SizedBox(
              width: widget.fabSize ?? 56.0,
              height: widget.fabSize ?? 56.0,
              child: FloatingActionButton(
                heroTag:
                    "${widget.heroTag ?? "enhanced_speed_dial_main"}_overlay",
                onPressed: _toggleSpeedDial,
                backgroundColor: widget.backgroundColor ??
                    Theme.of(context).colorScheme.primary,
                foregroundColor: widget.foregroundColor ??
                    Theme.of(context).colorScheme.onPrimary,
                elevation: 0.0, // Material widget handles elevation
                shape: widget.shape ?? const CircleBorder(),
                splashColor: widget.splashColor,
                focusColor: widget.focusColor,
                hoverColor: widget.hoverColor,
                tooltip: widget.tooltip,
                child: Icon(
                  _isOpen ? (widget.openIcon ?? Icons.close) : widget.mainIcon,
                  size:
                      (widget.fabSize ?? 56.0) * 0.43, // Proportional icon size
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSpeedDialOption(SpeedDialOption option, int index) {
    final showLabel = option.showLabel ?? widget.showLabels;
    final labelSpacing = option.labelSpacing ?? widget.labelSpacing;
    final optionMargin = option.margin ??
        widget.optionMargin ??
        EdgeInsets.only(bottom: widget.optionSpacing);

    return Container(
      margin: optionMargin,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: labelSpacing,
        children: [
          // Label
          if (showLabel) ...[
            option.customLabel ?? _buildOptionLabel(option),
          ],
          // Button
          _buildOptionFab(option, index),
        ],
      ),
    );
  }

  Widget _buildSpeedDialOptionHorizontal(SpeedDialOption option, int index) {
    final showLabel = option.showLabel ?? widget.showLabels;
    final labelSpacing = option.labelSpacing ?? widget.labelSpacing;
    final optionMargin = option.margin ??
        widget.optionMargin ??
        EdgeInsets.only(right: widget.optionSpacing);

    return Container(
      margin: optionMargin,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: labelSpacing,
        children: [
          // Button
          _buildOptionFab(option, index),
          // Label
          if (showLabel) ...[
            option.customLabel ?? _buildOptionLabel(option),
          ],
        ],
      ),
    );
  }

  Widget _buildOptionLabel(SpeedDialOption option) {
    final labelStyle = option.labelStyle ??
        widget.labelStyle ??
        Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            );
    final labelPadding = option.labelPadding ??
        widget.labelPadding ??
        const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
    final labelDecoration = option.labelDecoration ?? widget.labelDecoration;

    return Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(8),
      shadowColor: Colors.black.withValues(alpha: 0.3),
      child: Container(
        decoration: labelDecoration ??
            BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
        padding: labelPadding,
        child: Text(
          option.label,
          style: labelStyle?.copyWith(
                color:
                    labelStyle.color ?? Theme.of(context).colorScheme.onSurface,
              ) ??
              TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
        ),
      ),
    );
  }

  Widget _buildOptionFab(SpeedDialOption option, int index) {
    final fabSize = option.size ?? widget.optionFabSize ?? 48.0;
    final closeOnTap = option.closeOnTap ?? widget.closeOnOptionTap;
    final optionColor = _getOptionColor(option, index);
    final optionHeroTag = _getOptionHeroTag(option, index);

    return Material(
      elevation: option.elevation ?? 8.0,
      shape: option.shape ?? const CircleBorder(),
      shadowColor: optionColor.withValues(alpha: 0.4),
      child: SizedBox(
        width: fabSize,
        height: fabSize,
        child: FloatingActionButton(
          mini: fabSize < 56.0,
          heroTag: optionHeroTag,
          onPressed: option.enabled
              ? () {
                  option.onTap();
                  if (closeOnTap) {
                    _toggleSpeedDial(); // Close speed dial after selection
                  }
                }
              : null,
          backgroundColor:
              option.enabled ? optionColor : optionColor.withValues(alpha: 0.5),
          foregroundColor: option.foregroundColor ?? Colors.white,
          elevation: 0.0, // Material widget handles elevation
          shape: option.shape ?? const CircleBorder(),
          splashColor: option.splashColor,
          focusColor: option.focusColor,
          hoverColor: option.hoverColor,
          tooltip: option.tooltip,
          child: Icon(
            option.icon,
            size: fabSize * 0.4, // Proportional icon size
          ),
        ),
      ),
    );
  }
}
