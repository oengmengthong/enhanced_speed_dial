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

  /// Corner position of the speed dial
  final SpeedDialCorner corner;

  /// Custom offset from the corner (defaults to 16px from edges)
  final double offsetFromEdge;

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
    this.corner = SpeedDialCorner.bottomRight,
    this.offsetFromEdge = 16.0,
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
        corner = SpeedDialCorner.bottomRight,
        offsetFromEdge = 16.0,
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
        // Fallback: calculate position based on corner and safe area
        if (widget.applySafeArea) {
          actualFabPosition = _getPositionFromCorner(context);
        } else {
          // For floatingActionButton mode, get position from Scaffold
          final scaffoldRenderBox = context.findRenderObject() as RenderBox?;
          if (scaffoldRenderBox != null) {
            actualFabPosition = scaffoldRenderBox.localToGlobal(Offset.zero);
          }
        }
      }

      // Calculate the position relative to the screen for overlay positioning
      final screenSize = MediaQuery.of(context).size;
      final mediaQuery = MediaQuery.of(context);

      // Adjust for safe area if needed - the overlay is always full screen
      final overlayTopPadding =
          widget.applySafeArea ? 0.0 : mediaQuery.padding.top;
      final overlayBottomPadding =
          widget.applySafeArea ? 0.0 : mediaQuery.padding.bottom;

      // Calculate positions based on corner, accounting for overlay coordinate system
      // Add bounds checking to prevent negative or off-screen positioning
      final topPosition = (actualFabPosition.dy - overlayTopPadding)
          .clamp(0.0, screenSize.height);
      final leftPosition = actualFabPosition.dx.clamp(0.0, screenSize.width);
      final bottomPosition = (screenSize.height -
              overlayBottomPadding -
              actualFabPosition.dy -
              actualFabSize.height)
          .clamp(0.0, screenSize.height);
      final rightPosition =
          (screenSize.width - actualFabPosition.dx - actualFabSize.width)
              .clamp(0.0, screenSize.width);

      _overlayEntry = OverlayEntry(
        builder: (context) {
          final overlayStack = Stack(
            children: [
              // Full screen blur background
              Positioned.fill(
                child: GestureDetector(
                  onTap: widget.closeOnBlurTap ? _toggleSpeedDial : null,
                  behavior: HitTestBehavior
                      .translucent, // Allow hits to pass through to underlying widgets
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
              // Speed dial options positioned relative to the main FAB
              ..._buildOverlayOptions(topPosition, leftPosition, bottomPosition,
                  rightPosition, actualFabSize),
              // Main FAB rendered in overlay to stay above blur
              _buildMainFabInOverlay(
                  topPosition, leftPosition, bottomPosition, rightPosition),
            ],
          );

          // Return the overlay stack directly - positioning is already calculated
          return overlayStack;
        },
      );
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  // Helper method to build overlay options positioned based on direction and corner
  List<Widget> _buildOverlayOptions(double topPosition, double leftPosition,
      double bottomPosition, double rightPosition, Size fabSize) {
    final fabSizeValue = widget.fabSize ?? 56.0;
    final spacing = widget.mainToOptionSpacing;

    // Auto-adjust direction based on corner position for better UX
    SpeedDialDirection effectiveDirection = widget.direction;

    // Smart direction adjustment to prevent going off-screen
    // Get screen dimensions for better decision making
    final screenSize = MediaQuery.of(context).size;
    final mediaQuery = MediaQuery.of(context);
    final fabPosition = _getPositionFromCorner(context);
    final optionCount = widget.options.length;

    // Calculate total space needed more accurately
    final optionFabSize = widget.optionFabSize ?? 40.0;
    final optionSpacing = widget.optionSpacing;
    final labelHeight = widget.showLabels ? 40.0 : 0.0; // Estimate label height
    final totalOptionSpace = (optionCount * optionFabSize) +
        ((optionCount - 1) * optionSpacing) +
        spacing +
        labelHeight;

    // Calculate actual available space considering safe areas and screen bounds
    final safePadding =
        widget.applySafeArea ? mediaQuery.padding : EdgeInsets.zero;
    final spaceUp =
        fabPosition.dy - safePadding.top - 50.0; // Extra margin for safety
    final spaceDown = screenSize.height -
        fabPosition.dy -
        fabSizeValue -
        safePadding.bottom -
        50.0;
    final spaceLeft = fabPosition.dx - safePadding.left - 50.0;
    final spaceRight = screenSize.width -
        fabPosition.dx -
        fabSizeValue -
        safePadding.right -
        50.0;

    // Smart auto-adjustment logic with better boundary checking
    if (_shouldUseTop()) {
      // For top corners, prefer downward expansion if there's space
      if (widget.direction == SpeedDialDirection.up &&
          spaceDown > totalOptionSpace &&
          spaceDown > spaceUp) {
        effectiveDirection = SpeedDialDirection.down;
      }
      // For top-left, avoid going left if insufficient space
      else if (widget.corner == SpeedDialCorner.topLeft &&
          widget.direction == SpeedDialDirection.left &&
          spaceLeft < totalOptionSpace) {
        effectiveDirection =
            spaceRight > spaceLeft && spaceRight > totalOptionSpace
                ? SpeedDialDirection.right
                : (spaceDown > totalOptionSpace
                    ? SpeedDialDirection.down
                    : SpeedDialDirection.right);
      }
      // For top-right, avoid going right if insufficient space
      else if (widget.corner == SpeedDialCorner.topRight &&
          widget.direction == SpeedDialDirection.right &&
          spaceRight < totalOptionSpace) {
        effectiveDirection =
            spaceLeft > spaceRight && spaceLeft > totalOptionSpace
                ? SpeedDialDirection.left
                : (spaceDown > totalOptionSpace
                    ? SpeedDialDirection.down
                    : SpeedDialDirection.left);
      }
    } else if (_shouldUseBottom()) {
      // For bottom corners, prefer upward expansion if there's space
      if (widget.direction == SpeedDialDirection.down &&
          spaceUp > totalOptionSpace &&
          spaceUp > spaceDown) {
        effectiveDirection = SpeedDialDirection.up;
      }
      // For bottom-left, avoid going left if insufficient space
      else if (widget.corner == SpeedDialCorner.bottomLeft &&
          widget.direction == SpeedDialDirection.left &&
          spaceLeft < totalOptionSpace) {
        effectiveDirection =
            spaceRight > spaceLeft && spaceRight > totalOptionSpace
                ? SpeedDialDirection.right
                : (spaceUp > totalOptionSpace
                    ? SpeedDialDirection.up
                    : SpeedDialDirection.right);
      }
      // For bottom-right, avoid going right if insufficient space
      else if (widget.corner == SpeedDialCorner.bottomRight &&
          widget.direction == SpeedDialDirection.right &&
          spaceRight < totalOptionSpace) {
        effectiveDirection =
            spaceLeft > spaceRight && spaceLeft > totalOptionSpace
                ? SpeedDialDirection.left
                : (spaceUp > totalOptionSpace
                    ? SpeedDialDirection.up
                    : SpeedDialDirection.left);
      }
    }

    Widget optionsWidget;

    switch (effectiveDirection) {
      case SpeedDialDirection.up:
        optionsWidget = SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: _getCrossAxisAlignment(),
            spacing: widget.optionSpacing,
            children:
                widget.options.reversed.toList().asMap().entries.map((entry) {
              final index = widget.options.length - 1 - entry.key;
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
            }).toList(),
          ),
        );
        break;

      case SpeedDialDirection.down:
        optionsWidget = SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: _getCrossAxisAlignment(),
            spacing: widget.optionSpacing,
            children: widget.options.asMap().entries.map((entry) {
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
            }).toList(),
          ),
        );
        break;

      case SpeedDialDirection.left:
        // Use scrollable SingleChildScrollView for horizontal layouts to prevent overflow
        optionsWidget = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: widget.optionSpacing,
            children:
                widget.options.reversed.toList().asMap().entries.map((entry) {
              final index = widget.options.length - 1 - entry.key;
              final option = entry.value;
              return AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment:
                          _getHorizontalLabelAlignment(effectiveDirection),
                      spacing: option.labelSpacing ?? widget.labelSpacing,
                      children: _shouldUseBottom()
                          ? [
                              // For bottom corners, put label above FAB to prevent cutoff
                              if (option.showLabel ?? widget.showLabels) ...[
                                option.customLabel ?? _buildOptionLabel(option),
                              ],
                              _buildOptionFab(option, index),
                            ]
                          : [
                              // For top corners, keep label below FAB
                              _buildOptionFab(option, index),
                              if (option.showLabel ?? widget.showLabels) ...[
                                option.customLabel ?? _buildOptionLabel(option),
                              ],
                            ],
                    ),
                  );
                },
              );
            }).toList(),
          ),
        );
        break;

      case SpeedDialDirection.right:
        // Use scrollable SingleChildScrollView for horizontal layouts to prevent overflow
        optionsWidget = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: widget.optionSpacing,
            children: widget.options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              return AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment:
                          _getHorizontalLabelAlignment(effectiveDirection),
                      spacing: option.labelSpacing ?? widget.labelSpacing,
                      children: _shouldUseBottom()
                          ? [
                              // For bottom corners, put label above FAB to prevent cutoff
                              if (option.showLabel ?? widget.showLabels) ...[
                                option.customLabel ?? _buildOptionLabel(option),
                              ],
                              _buildOptionFab(option, index),
                            ]
                          : [
                              // For top corners, keep label below FAB
                              _buildOptionFab(option, index),
                              if (option.showLabel ?? widget.showLabels) ...[
                                option.customLabel ?? _buildOptionLabel(option),
                              ],
                            ],
                    ),
                  );
                },
              );
            }).toList(),
          ),
        );
        break;
    }

    // Position the options widget based on effective direction with bounds checking
    Widget positionedOptions;

    // Calculate safe positioning bounds to ensure visibility
    final safeMargin = 16.0; // Minimum margin from screen edges

    switch (effectiveDirection) {
      case SpeedDialDirection.up:
        final calculatedBottom = bottomPosition + fabSizeValue + spacing;
        final safeBottom =
            calculatedBottom.clamp(safeMargin, screenSize.height - safeMargin);

        positionedOptions = Positioned(
          bottom: safeBottom,
          left: _shouldUseLeft()
              ? leftPosition.clamp(safeMargin, screenSize.width - 100)
              : null,
          right: _shouldUseRight()
              ? rightPosition.clamp(safeMargin, screenSize.width - 100)
              : null,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenSize.width - (2 * safeMargin),
              maxHeight: screenSize.height - safeBottom - safeMargin,
            ),
            child: optionsWidget,
          ),
        );
        break;

      case SpeedDialDirection.down:
        final calculatedTop = topPosition + fabSizeValue + spacing;
        final safeTop =
            calculatedTop.clamp(safeMargin, screenSize.height - safeMargin);

        positionedOptions = Positioned(
          top: safeTop,
          left: _shouldUseLeft()
              ? leftPosition.clamp(safeMargin, screenSize.width - 100)
              : null,
          right: _shouldUseRight()
              ? rightPosition.clamp(safeMargin, screenSize.width - 100)
              : null,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenSize.width - (2 * safeMargin),
              maxHeight: screenSize.height - safeTop - safeMargin,
            ),
            child: optionsWidget,
          ),
        );
        break;

      case SpeedDialDirection.left:
        final calculatedRight = rightPosition + fabSizeValue + spacing;
        final safeRight =
            calculatedRight.clamp(safeMargin, screenSize.width - safeMargin);

        positionedOptions = Positioned(
          right: safeRight,
          top: topPosition.clamp(
              safeMargin, screenSize.height - 200), // Reserve space for options
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenSize.width - safeRight - safeMargin,
              maxHeight: screenSize.height - (2 * safeMargin),
            ),
            child: optionsWidget,
          ),
        );
        break;

      case SpeedDialDirection.right:
        final calculatedLeft = leftPosition + fabSizeValue + spacing;
        final safeLeft =
            calculatedLeft.clamp(safeMargin, screenSize.width - safeMargin);

        positionedOptions = Positioned(
          left: safeLeft,
          top: topPosition.clamp(
              safeMargin, screenSize.height - 200), // Reserve space for options
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenSize.width - safeLeft - safeMargin,
              maxHeight: screenSize.height - (2 * safeMargin),
            ),
            child: optionsWidget,
          ),
        );
        break;
    }

    return [positionedOptions];
  }

  // Helper method to build main fab positioned in overlay
  Widget _buildMainFabInOverlay(double topPosition, double leftPosition,
      double bottomPosition, double rightPosition) {
    final screenSize = MediaQuery.of(context).size;
    final fabSize = widget.fabSize ?? 56.0;
    final safeMargin = 16.0;

    // Ensure FAB stays within safe bounds
    final safeTopPosition = _shouldUseTop()
        ? topPosition.clamp(
            safeMargin, screenSize.height - fabSize - safeMargin)
        : null;
    final safeLeftPosition = _shouldUseLeft()
        ? leftPosition.clamp(
            safeMargin, screenSize.width - fabSize - safeMargin)
        : null;
    final safeBottomPosition = _shouldUseBottom()
        ? bottomPosition.clamp(
            safeMargin, screenSize.height - fabSize - safeMargin)
        : null;
    final safeRightPosition = _shouldUseRight()
        ? rightPosition.clamp(
            safeMargin, screenSize.width - fabSize - safeMargin)
        : null;

    return Positioned(
      top: safeTopPosition,
      left: safeLeftPosition,
      bottom: safeBottomPosition,
      right: safeRightPosition,
      child: _buildMainFabForOverlay(),
    );
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

    // Auto-generate based on widget instance, corner, direction, label and index to ensure uniqueness
    final baseTag = widget.heroTag ?? "enhanced_speed_dial";
    final cleanLabel =
        option.label.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toLowerCase();
    final cornerKey = widget.corner.toString().split('.').last;
    final directionKey = widget.direction.toString().split('.').last;
    final instanceId =
        hashCode.toString().substring(0, 6); // Use object hash for uniqueness
    return "${baseTag}_${cornerKey}_${directionKey}_${cleanLabel}_${index}_$instanceId";
  }

  // Helper method to get position from corner and offset
  Offset _getPositionFromCorner(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;
    final padding = mediaQuery.padding;
    final fabSize = widget.fabSize ?? 56.0;

    // Ensure minimum edge distance and screen boundary validation
    final minOffset =
        16.0; // Increased minimum edge distance for better visibility
    final maxOffset =
        screenSize.width / 6; // Maximum offset to prevent too far from edge
    final effectiveOffset = widget.offsetFromEdge.clamp(minOffset, maxOffset);

    // Calculate safe screen bounds with more conservative margins
    final safeLeft = effectiveOffset;
    final safeTop =
        widget.applySafeArea ? effectiveOffset + padding.top : effectiveOffset;
    final safeRight = (screenSize.width - effectiveOffset - fabSize)
        .clamp(safeLeft + fabSize, screenSize.width - minOffset);
    final safeBottom = widget.applySafeArea
        ? (screenSize.height - effectiveOffset - fabSize - padding.bottom)
            .clamp(safeTop + fabSize, screenSize.height - minOffset)
        : (screenSize.height - effectiveOffset - fabSize)
            .clamp(safeTop + fabSize, screenSize.height - minOffset);

    // Validate screen is large enough for proper positioning
    if (safeRight < safeLeft + fabSize || safeBottom < safeTop + fabSize) {
      // Screen too small - fallback to center with better bounds checking
      final centerX = (screenSize.width - fabSize) / 2;
      final centerY = (screenSize.height - fabSize) / 2;
      return Offset(
        centerX.clamp(minOffset, screenSize.width - fabSize - minOffset),
        centerY.clamp(minOffset + padding.top,
            screenSize.height - fabSize - minOffset - padding.bottom),
      );
    }

    switch (widget.corner) {
      case SpeedDialCorner.topLeft:
        return Offset(safeLeft, safeTop);

      case SpeedDialCorner.topRight:
        return Offset(safeRight, safeTop);

      case SpeedDialCorner.bottomLeft:
        return Offset(safeLeft, safeBottom);

      case SpeedDialCorner.bottomRight:
        return Offset(safeRight, safeBottom);
    }
  }

  // Helper method to get consistent positioning that accounts for safe areas
  Offset _getAdjustedPosition(BuildContext context) {
    // When applySafeArea is false (used as floatingActionButton),
    // the positioning is handled by Scaffold, so we return zero offset
    if (!widget.applySafeArea) {
      // For floatingActionButton, Scaffold handles positioning
      // We return zero because the FAB will be positioned by Scaffold
      return Offset.zero;
    }

    // When applySafeArea is true, use position from corner
    return _getPositionFromCorner(context);
  }

  @override
  Widget build(BuildContext context) {
    // When applySafeArea is false (used as floatingActionButton),
    // return just the main FAB without positioning
    if (!widget.applySafeArea) {
      return _buildMainFab();
    }

    // When applySafeArea is true, use full positioning logic
    final adjustedPosition = _getAdjustedPosition(context);

    final stackWidget = Stack(
      children: [
        // Speed dial options (only when not using overlay)
        if (_isOpen && !widget.showBlurBackground)
          _buildPositionedOptions(adjustedPosition),
        // Speed dial main button (hidden when overlay is active to prevent double rendering)
        if (!(_isOpen && widget.showBlurBackground))
          _buildPositionedMainFab(adjustedPosition),
      ],
    );

    // Wrap with SafeArea since applySafeArea is true
    return SafeArea(child: stackWidget);
  }

  // Helper method to build positioned options based on corner and direction
  Widget _buildPositionedOptions(Offset position) {
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;
    final padding = mediaQuery.padding;

    // Calculate correct positioning values for options
    final topValue = _shouldUseTop() ? position.dy : null;
    final leftValue = _shouldUseLeft() ? position.dx : null;
    final bottomValue = _shouldUseBottom()
        ? (screenSize.height -
            position.dy -
            (widget.fabSize ?? 56.0) -
            (widget.applySafeArea ? padding.bottom : 0.0))
        : null;
    final rightValue = _shouldUseRight()
        ? (screenSize.width - position.dx - (widget.fabSize ?? 56.0))
        : null;

    return Positioned(
      top: topValue,
      left: leftValue,
      bottom: bottomValue,
      right: rightValue,
      child: _buildOptionsOnly(),
    );
  }

  // Helper method to build positioned main fab
  Widget _buildPositionedMainFab(Offset position) {
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;
    final padding = mediaQuery.padding;

    // Calculate correct positioning values for main FAB
    final topValue = _shouldUseTop() ? position.dy : null;
    final leftValue = _shouldUseLeft() ? position.dx : null;
    final bottomValue = _shouldUseBottom()
        ? (screenSize.height -
            position.dy -
            (widget.fabSize ?? 56.0) -
            (widget.applySafeArea ? padding.bottom : 0.0))
        : null;
    final rightValue = _shouldUseRight()
        ? (screenSize.width - position.dx - (widget.fabSize ?? 56.0))
        : null;

    return Positioned(
      top: topValue,
      left: leftValue,
      bottom: bottomValue,
      right: rightValue,
      child: _buildMainFab(),
    );
  }

  // Helper methods to determine positioning based on corner
  bool _shouldUseTop() {
    return widget.corner == SpeedDialCorner.topLeft ||
        widget.corner == SpeedDialCorner.topRight;
  }

  bool _shouldUseBottom() {
    return widget.corner == SpeedDialCorner.bottomLeft ||
        widget.corner == SpeedDialCorner.bottomRight;
  }

  bool _shouldUseLeft() {
    return widget.corner == SpeedDialCorner.topLeft ||
        widget.corner == SpeedDialCorner.bottomLeft;
  }

  bool _shouldUseRight() {
    return widget.corner == SpeedDialCorner.topRight ||
        widget.corner == SpeedDialCorner.bottomRight;
  }

  // Helper method to get cross axis alignment based on corner
  CrossAxisAlignment _getCrossAxisAlignment() {
    if (_shouldUseLeft()) {
      return CrossAxisAlignment.start;
    } else {
      return CrossAxisAlignment.end;
    }
  }

  // Helper method to get label alignment for horizontal directions
  CrossAxisAlignment _getHorizontalLabelAlignment(
      SpeedDialDirection effectiveDirection) {
    // For horizontal directions, we need to consider label overflow
    if (effectiveDirection == SpeedDialDirection.left) {
      // When expanding left, align labels to prevent right overflow
      return _shouldUseRight()
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.center;
    } else if (effectiveDirection == SpeedDialDirection.right) {
      // When expanding right, align labels to prevent left overflow
      return _shouldUseLeft()
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center;
    }
    return CrossAxisAlignment.center;
  }

  Widget _buildOptionsOnly() {
    // Auto-adjust direction based on corner position for better UX
    SpeedDialDirection effectiveDirection = widget.direction;

    // Smart direction adjustment to prevent going off-screen
    if (_shouldUseTop()) {
      // For top corners, prefer downward expansion to avoid going off-screen
      if (widget.direction == SpeedDialDirection.up) {
        effectiveDirection = SpeedDialDirection.down;
      }
      // For top-left, avoid going left off-screen
      else if (widget.corner == SpeedDialCorner.topLeft &&
          widget.direction == SpeedDialDirection.left) {
        effectiveDirection = SpeedDialDirection.right;
      }
      // For top-right, avoid going right off-screen
      else if (widget.corner == SpeedDialCorner.topRight &&
          widget.direction == SpeedDialDirection.right) {
        effectiveDirection = SpeedDialDirection.left;
      }
    } else if (_shouldUseBottom()) {
      // For bottom corners, prefer upward expansion
      if (widget.direction == SpeedDialDirection.down) {
        effectiveDirection = SpeedDialDirection.up;
      }
      // For bottom-left, avoid going left off-screen
      else if (widget.corner == SpeedDialCorner.bottomLeft &&
          widget.direction == SpeedDialDirection.left) {
        effectiveDirection = SpeedDialDirection.right;
      }
      // For bottom-right, avoid going right off-screen
      else if (widget.corner == SpeedDialCorner.bottomRight &&
          widget.direction == SpeedDialDirection.right) {
        effectiveDirection = SpeedDialDirection.left;
      }
    }

    switch (effectiveDirection) {
      case SpeedDialDirection.up:
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: _getCrossAxisAlignment(),
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
          ),
        );
      case SpeedDialDirection.down:
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: _getCrossAxisAlignment(),
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
          ),
        );
      case SpeedDialDirection.left:
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment:
                            _getHorizontalLabelAlignment(effectiveDirection),
                        children: _shouldUseBottom()
                            ? [
                                // For bottom corners, put label above FAB to prevent cutoff
                                if (option.showLabel ?? widget.showLabels) ...[
                                  option.customLabel ??
                                      _buildOptionLabel(option),
                                  SizedBox(
                                      height: option.labelSpacing ??
                                          widget.labelSpacing),
                                ],
                                _buildOptionFab(option, index),
                              ]
                            : [
                                // For top corners, keep label below FAB
                                _buildOptionFab(option, index),
                                if (option.showLabel ?? widget.showLabels) ...[
                                  SizedBox(
                                      height: option.labelSpacing ??
                                          widget.labelSpacing),
                                  option.customLabel ??
                                      _buildOptionLabel(option),
                                ],
                              ],
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        );
      case SpeedDialDirection.right:
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment:
                            _getHorizontalLabelAlignment(effectiveDirection),
                        children: _shouldUseBottom()
                            ? [
                                // For bottom corners, put label above FAB to prevent cutoff
                                if (option.showLabel ?? widget.showLabels) ...[
                                  option.customLabel ??
                                      _buildOptionLabel(option),
                                  SizedBox(
                                      height: option.labelSpacing ??
                                          widget.labelSpacing),
                                ],
                                _buildOptionFab(option, index),
                              ]
                            : [
                                // For top corners, keep label below FAB
                                _buildOptionFab(option, index),
                                if (option.showLabel ?? widget.showLabels) ...[
                                  SizedBox(
                                      height: option.labelSpacing ??
                                          widget.labelSpacing),
                                  option.customLabel ??
                                      _buildOptionLabel(option),
                                ],
                              ],
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        );
    }
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
                key: ValueKey(
                    "enhanced_speed_dial_main_fab_${widget.corner.toString().split('.').last}"),
                heroTag: widget.heroTag ??
                    "enhanced_speed_dial_main_${widget.corner.toString().split('.').last}_${hashCode.toString().substring(0, 6)}",
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
                key: ValueKey(
                    "enhanced_speed_dial_main_fab_overlay_${widget.corner.toString().split('.').last}"),
                heroTag:
                    "${widget.heroTag ?? "enhanced_speed_dial_main_${widget.corner.toString().split('.').last}"}_overlay_${hashCode.toString().substring(0, 6)}",
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
        children: _shouldUseLeft()
            ? [
                // Button first for left corners
                _buildOptionFab(option, index),
                // Label after button for left corners
                if (showLabel) ...[
                  option.customLabel ?? _buildOptionLabel(option),
                ],
              ]
            : [
                // Label first for right corners
                if (showLabel) ...[
                  option.customLabel ?? _buildOptionLabel(option),
                ],
                // Button after label for right corners
                _buildOptionFab(option, index),
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
          key: ValueKey(
              "speed_dial_option_${option.label.replaceAll(' ', '_').toLowerCase()}"),
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
