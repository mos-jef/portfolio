import 'package:flutter/material.dart';
import 'package:portfolio_website/themes/wireframe/utils/wireframe_color_manager.dart';
import 'package:portfolio_website/themes/wireframe/widgets/clickable_widget.dart';
import 'package:portfolio_website/themes/wireframe/widgets/svg_icon.dart';

import '../wireframe_layout_constants.dart';

/// Enhanced Floating comment button for desktop with animation support
class FloatingCommentButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isOnRight;
  final bool hasAnimation;
  final bool hasEnhancedShadow;
  final Duration animationDuration;
  final double size;
  final bool hasPulseAnimation; // ✅ Add continuous pulse animation
  final bool hasHoverAnimation; // ✅ Add hover animation

  const FloatingCommentButton({
    Key? key,
    required this.onTap,
    this.isOnRight = false,
    this.hasAnimation = true,
    this.hasEnhancedShadow = false,
    this.animationDuration = const Duration(milliseconds: 300),
    this.size = 40.0,
    this.hasPulseAnimation = false, // Default off
    this.hasHoverAnimation = true, // Default on
  }) : super(key: key);

  @override
  State<FloatingCommentButton> createState() => _FloatingCommentButtonState();
}

class _FloatingCommentButtonState extends State<FloatingCommentButton>
    with TickerProviderStateMixin {
  late AnimationController _tapAnimationController;
  late AnimationController _pulseAnimationController;
  late AnimationController _hoverAnimationController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _hoverAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    // Tap animation controller
    _tapAnimationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    // Pulse animation controller (continuous)
    _pulseAnimationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    // Hover animation controller
    _hoverAnimationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    // Scale animation (tap feedback)
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2, // ✅ More dramatic scale for visibility
    ).animate(CurvedAnimation(
      parent: _tapAnimationController,
      curve: Curves.elasticOut,
    ));

    // Rotation animation (tap feedback)
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.2, // ✅ More rotation for visibility
    ).animate(CurvedAnimation(
      parent: _tapAnimationController,
      curve: Curves.easeInOut,
    ));

    // Pulse animation (continuous)
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseAnimationController,
      curve: Curves.easeInOut,
    ));

    // Hover animation
    _hoverAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _hoverAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start pulse animation if enabled
    if (widget.hasPulseAnimation) {
      _pulseAnimationController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _tapAnimationController.dispose();
    _pulseAnimationController.dispose();
    _hoverAnimationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    print('🎯 Button tapped - Animation should start!'); // ✅ Debug print

    if (widget.hasAnimation) {
      _tapAnimationController.forward().then((_) {
        _tapAnimationController.reverse();
      });
    }
    widget.onTap();
  }

  void _handleHover(bool isHovered) {
    if (!widget.hasHoverAnimation) return;

    setState(() {
      _isHovered = isHovered;
    });

    if (isHovered) {
      _hoverAnimationController.forward();
    } else {
      _hoverAnimationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: WireframeLayoutConstants.spacingLarge,
      left: widget.isOnRight ? null : WireframeLayoutConstants.spacingLarge,
      right: widget.isOnRight ? WireframeLayoutConstants.spacingLarge : null,
      child: MouseRegion(
        onEnter: (_) => _handleHover(true),
        onExit: (_) => _handleHover(false),
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _tapAnimationController,
            _pulseAnimationController,
            _hoverAnimationController,
          ]),
          builder: (context, child) {
            double combinedScale = _hoverAnimation.value;

            if (widget.hasPulseAnimation) {
              combinedScale *= _pulseAnimation.value;
            }

            if (widget.hasAnimation) {
              combinedScale *= _scaleAnimation.value;
            }

            return Transform.scale(
              scale: combinedScale,
              child: Transform.rotate(
                angle: widget.hasAnimation ? _rotationAnimation.value : 0.0,
                child: _buildButton(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildButton() {
    return ClickableWidget(
      onTap: _handleTap,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          boxShadow: widget.hasEnhancedShadow
              ? _getEnhancedShadow()
              : _getStandardShadow(),
        ),
        child: SvgIcon(
          assetPath: SvgIconPaths.addCircleFill,
          size: widget.size,
          color: WireframeColorManager.colors.primary,
        ),
      ),
    );
  }

  List<BoxShadow> _getStandardShadow() {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 8,
        offset: Offset(0, 4),
      ),
    ];
  }

  List<BoxShadow> _getEnhancedShadow() {
    return [
      BoxShadow(
        color: WireframeColorManager.colors.primary.withOpacity(0.3),
        blurRadius: 20,
        offset: Offset(0, 8),
      ),
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 4,
        offset: Offset(0, 2),
      ),
      BoxShadow(
        color: WireframeColorManager.colors.primary.withOpacity(0.2),
        blurRadius: 30,
        offset: Offset(0, 0),
      ),
    ];
  }
}

/// Floating action button with customizable appearance
class WireframeFloatingActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final bool hasShadow;
  final String? tooltip;
  final bool isExpanded;

  const WireframeFloatingActionButton({
    Key? key,
    required this.onTap,
    required this.icon,
    this.backgroundColor,
    this.iconColor,
    this.size = 56.0,
    this.hasShadow = true,
    this.tooltip,
    this.isExpanded = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor =
        backgroundColor ?? WireframeLayoutConstants.wireframeAccent;
    final effectiveIconColor =
        iconColor ?? WireframeLayoutConstants.wireframeWhite;

    Widget button = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: effectiveBackgroundColor,
        boxShadow: hasShadow ? WireframeLayoutConstants.shadowMedium : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(size / 2),
          child: Icon(
            icon,
            color: effectiveIconColor,
            size: size * 0.4,
          ),
        ),
      ),
    );

    if (tooltip != null) {
      button = Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}

/// Speed dial floating action button with multiple actions
class WireframeSpeedDial extends StatefulWidget {
  final List<WireframeSpeedDialAction> actions;
  final IconData mainIcon;
  final IconData? closeIcon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? tooltip;
  final bool closeOnAction;

  const WireframeSpeedDial({
    Key? key,
    required this.actions,
    this.mainIcon = Icons.add,
    this.closeIcon = Icons.close,
    this.backgroundColor,
    this.foregroundColor,
    this.tooltip,
    this.closeOnAction = true,
  }) : super(key: key);

  @override
  State<WireframeSpeedDial> createState() => _WireframeSpeedDialState();
}

class _WireframeSpeedDialState extends State<WireframeSpeedDial>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Animation<double> _rotationAnimation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: WireframeLayoutConstants.animationDurationMedium,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: WireframeLayoutConstants.animationCurveStandard,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.75,
    ).animate(_animation);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _handleActionTap(WireframeSpeedDialAction action) {
    action.onTap();
    if (widget.closeOnAction) {
      _toggle();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Action buttons
        ...widget.actions.asMap().entries.map((entry) {
          final index = entry.key;
          final action = entry.value;

          return AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final slideOffset = Offset(
                0,
                (1 - _animation.value) * (index + 1) * 70,
              );

              return Transform.translate(
                offset: slideOffset,
                child: Opacity(
                  opacity: _animation.value,
                  child: Container(
                    margin: EdgeInsets.only(
                      bottom: WireframeLayoutConstants.spacingSmall,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Label
                        if (action.label != null)
                          Container(
                            margin: EdgeInsets.only(
                              right: WireframeLayoutConstants.spacingMedium,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  WireframeLayoutConstants.spacingMedium,
                              vertical: WireframeLayoutConstants.spacingSmall,
                            ),
                            decoration: BoxDecoration(
                              color: WireframeLayoutConstants.wireframeWhite,
                              borderRadius: BorderRadius.circular(
                                WireframeLayoutConstants.radiusSmall,
                              ),
                              border: Border.all(
                                color: WireframeColorManager.colors.border,
                              ),
                              boxShadow: WireframeLayoutConstants.shadowLight,
                            ),
                            child: Text(
                              action.label!,
                              style: TextStyle(
                                color: WireframeColorManager.colors.text,
                                fontSize:
                                    WireframeLayoutConstants.mobileFontSizeBody,
                              ),
                            ),
                          ),

                        // Action button
                        WireframeFloatingActionButton(
                          onTap: () => _handleActionTap(action),
                          icon: action.icon ?? Icons.help_outline,
                          backgroundColor: action.backgroundColor,
                          iconColor: action.iconColor,
                          size: 40,
                          tooltip: action.tooltip,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),

        // Main button
        AnimatedBuilder(
          animation: _rotationAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotationAnimation.value * 2 * 3.14159,
              child: WireframeFloatingActionButton(
                onTap: _toggle,
                icon: _isOpen
                    ? (widget.closeIcon ?? Icons.close)
                    : widget.mainIcon,
                backgroundColor: widget.backgroundColor,
                iconColor: widget.foregroundColor,
                tooltip: widget.tooltip,
              ),
            );
          },
        ),
      ],
    );
  }
}

/// Speed dial action item
class WireframeSpeedDialAction {
  final VoidCallback onTap;
  final IconData? icon;
  final String? svgIconPath;
  final String? label;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? iconColor;

  const WireframeSpeedDialAction({
    required this.onTap,
    required this.icon,
    this.svgIconPath,
    this.label,
    this.tooltip,
    this.backgroundColor,
    this.iconColor,
  });
}

/// Floating notification badge
class WireframeFloatingBadge extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final bool isVisible;

  const WireframeFloatingBadge({
    Key? key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.padding,
    this.onTap,
    this.isVisible = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return SizedBox.shrink();

    final effectiveBackgroundColor =
        backgroundColor ?? WireframeLayoutConstants.wireframeDanger;
    final effectiveTextColor =
        textColor ?? WireframeLayoutConstants.wireframeWhite;
    final effectiveFontSize =
        fontSize ?? WireframeLayoutConstants.fontSizeCaption;
    final effectivePadding = padding ??
        EdgeInsets.symmetric(
          horizontal: WireframeLayoutConstants.spacingSmall,
          vertical: WireframeLayoutConstants.spacingTiny,
        );

    Widget badge = Container(
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius:
            BorderRadius.circular(WireframeLayoutConstants.radiusSmall),
        boxShadow: WireframeLayoutConstants.shadowLight,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: effectiveTextColor,
          fontSize: effectiveFontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    if (onTap != null) {
      badge = ClickableWidget(
        onTap: onTap,
        child: badge,
      );
    }

    return badge;
  }
}

/// Floating action button positioned widget
class WireframePositionedFAB extends StatelessWidget {
  final Widget child;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final AlignmentGeometry? alignment;

  const WireframePositionedFAB({
    Key? key,
    required this.child,
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.alignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (alignment != null) {
      return Align(
        alignment: alignment!,
        child: Container(
          margin: EdgeInsets.all(WireframeLayoutConstants.spacingStandard),
          child: child,
        ),
      );
    }

    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: child,
    );
  }

  /// Predefined position: bottom right
  factory WireframePositionedFAB.bottomRight({
    required Widget child,
    double? margin,
  }) {
    final effectiveMargin = margin ?? WireframeLayoutConstants.spacingStandard;
    return WireframePositionedFAB(
      bottom: effectiveMargin,
      right: effectiveMargin,
      child: child,
    );
  }

  /// Predefined position: bottom left
  factory WireframePositionedFAB.bottomLeft({
    required Widget child,
    double? margin,
  }) {
    final effectiveMargin = margin ?? WireframeLayoutConstants.spacingStandard;
    return WireframePositionedFAB(
      bottom: effectiveMargin,
      left: effectiveMargin,
      child: child,
    );
  }

  /// Predefined position: top right
  factory WireframePositionedFAB.topRight({
    required Widget child,
    double? margin,
  }) {
    final effectiveMargin = margin ?? WireframeLayoutConstants.spacingStandard;
    return WireframePositionedFAB(
      top: effectiveMargin,
      right: effectiveMargin,
      child: child,
    );
  }

  /// Predefined position: top left
  factory WireframePositionedFAB.topLeft({
    required Widget child,
    double? margin,
  }) {
    final effectiveMargin = margin ?? WireframeLayoutConstants.spacingStandard;
    return WireframePositionedFAB(
      top: effectiveMargin,
      left: effectiveMargin,
      child: child,
    );
  }
}

/// Floating action utilities and helpers
class WireframeFloatingActionUtils {
  /// Common floating action button configurations
  static const Map<String, Map<String, dynamic>> presetConfigs = {
    'edit': {
      'icon': Icons.edit,
      'backgroundColor': Color(0xFFFF0062),
      'tooltip': 'Edit',
    },
    'add': {
      'icon': Icons.add,
      'backgroundColor': null, // Uses default
      'tooltip': 'Add',
    },
    'comment': {
      'icon': Icons.comment,
      'backgroundColor': Color(0xFF17A2B8),
      'tooltip': 'Add Comment',
    },
    'share': {
      'icon': Icons.share,
      'backgroundColor': Color(0xFF28A745),
      'tooltip': 'Share',
    },
    'favorite': {
      'icon': Icons.favorite,
      'backgroundColor': Color(0xFFDC3545),
      'tooltip': 'Favorite',
    },
    'settings': {
      'svgIcon': SvgIconPaths.settings3Line,
      'backgroundColor': Color(0xFF6C757D),
      'tooltip': 'Settings',
    },
  };

  /// Get preset configuration
  static Map<String, dynamic>? getPresetConfig(String preset) {
    return presetConfigs[preset];
  }

  /// Create a floating action button from preset
  static WireframeFloatingActionButton createFromPreset({
    required String preset,
    required VoidCallback onTap,
    double? size,
    bool? hasShadow,
  }) {
    final config = getPresetConfig(preset);
    if (config == null) {
      throw ArgumentError('Unknown preset: $preset');
    }

    return WireframeFloatingActionButton(
      onTap: onTap,
      icon: config['icon'] as IconData,
      backgroundColor: config['backgroundColor'] as Color?,
      tooltip: config['tooltip'] as String?,
      size: size ?? 56.0,
      hasShadow: hasShadow ?? true,
    );
  }

  /// Create common speed dial actions
  static List<WireframeSpeedDialAction> createCommonSpeedDialActions({
    VoidCallback? onComment,
    VoidCallback? onShare,
    VoidCallback? onFavorite,
    VoidCallback? onSettings,
  }) {
    final actions = <WireframeSpeedDialAction>[];

    if (onComment != null) {
      actions.add(WireframeSpeedDialAction(
        onTap: onComment,
        icon: Icons.comment,
        label: 'Comment',
        backgroundColor: WireframeLayoutConstants.wireframeInfo,
      ));
    }

    if (onShare != null) {
      actions.add(WireframeSpeedDialAction(
        onTap: onShare,
        icon: Icons.share,
        label: 'Share',
        backgroundColor: WireframeLayoutConstants.wireframeSuccess,
      ));
    }

    if (onFavorite != null) {
      actions.add(WireframeSpeedDialAction(
        onTap: onFavorite,
        icon: Icons.favorite,
        label: 'Favorite',
        backgroundColor: WireframeLayoutConstants.wireframeDanger,
      ));
    }

    if (onSettings != null) {
      actions.add(WireframeSpeedDialAction(
        onTap: onSettings,
        icon: null, // Removes IconData
        svgIconPath: SvgIconPaths.settings3Line, // Added SVG path
        label: 'Settings',
        backgroundColor: WireframeLayoutConstants.wireframeSecondary,
      ));
    }

    return actions;
  }

  /// Common positions for floating action buttons
  static const Map<String, AlignmentGeometry> commonPositions = {
    'bottomRight': Alignment.bottomRight,
    'bottomLeft': Alignment.bottomLeft,
    'topRight': Alignment.topRight,
    'topLeft': Alignment.topLeft,
    'centerRight': Alignment.centerRight,
    'centerLeft': Alignment.centerLeft,
  };

  /// Get alignment from position name
  static AlignmentGeometry? getAlignment(String position) {
    return commonPositions[position];
  }
}

class SimpleFloatingCommentButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool hasAnimation;
  final bool hasEnhancedShadow;
  final Duration animationDuration;
  final double size;
  final bool hasPulseAnimation;
  final bool hasHoverAnimation;

  const SimpleFloatingCommentButton({
    Key? key,
    required this.onTap,
    this.hasAnimation = true,
    this.hasEnhancedShadow = false,
    this.animationDuration = const Duration(milliseconds: 300),
    this.size = 56.0,
    this.hasPulseAnimation = false,
    this.hasHoverAnimation = true,
  }) : super(key: key);

  @override
  State<SimpleFloatingCommentButton> createState() =>
      _SimpleFloatingCommentButtonState();
}

class _SimpleFloatingCommentButtonState
    extends State<SimpleFloatingCommentButton> with TickerProviderStateMixin {
  late AnimationController _tapAnimationController;
  late AnimationController _pulseAnimationController;
  late AnimationController _hoverAnimationController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _hoverAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    _tapAnimationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _pulseAnimationController = AnimationController(
      duration: Duration(milliseconds: 30000),
      vsync: this,
    );

    _hoverAnimationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _tapAnimationController,
      curve: Curves.elasticOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseAnimationController,
      curve: Curves.easeIn,
    ));

    _hoverAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _hoverAnimationController,
      curve: Curves.easeInOut,
    ));

    if (widget.hasPulseAnimation) {
      _pulseAnimationController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _tapAnimationController.dispose();
    _pulseAnimationController.dispose();
    _hoverAnimationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.hasAnimation) {
      _tapAnimationController.forward().then((_) {
        _tapAnimationController.reverse();
      });
    }
    widget.onTap();
  }

  void _handleHover(bool isHovered) {
    if (!widget.hasHoverAnimation) return;

    setState(() {
      _isHovered = isHovered;
    });

    if (isHovered) {
      _hoverAnimationController.forward();
    } else {
      _hoverAnimationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _tapAnimationController,
          _pulseAnimationController,
          _hoverAnimationController,
        ]),
        builder: (context, child) {
          double combinedScale = _hoverAnimation.value;

          if (widget.hasPulseAnimation) {
            combinedScale *= _pulseAnimation.value;
          }

          if (widget.hasAnimation) {
            combinedScale *= _scaleAnimation.value;
          }

          return Transform.scale(
            scale: combinedScale,
            child: ClickableWidget(
              onTap: _handleTap,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: WireframeColorManager.colors.primary.withAlpha(0),
                  boxShadow: widget.hasEnhancedShadow
                      ? [
                          BoxShadow(
                            color: WireframeColorManager.colors.textOnSurface.withAlpha(35),
                            blurRadius: 5,
                            offset: Offset(-4, 8),
                          ),
                          BoxShadow(color: WireframeColorManager.colors.textOnSurface.withAlpha(35),
                            blurRadius: 4,
                            offset: Offset(-4, 2),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: WireframeColorManager.colors.textOnSurface.withAlpha(35),
                            blurRadius: 8,
                            offset: Offset(-4, 4),
                          ),
                        ],
                ),
                child: SvgIcon(
                  assetPath: SvgIconPaths.addCircleLine,
                  size: widget.size * 0.02,
                  color: WireframeColorManager.colors.primary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
