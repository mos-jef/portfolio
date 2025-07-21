// File: lib/themes/wireframe/widgets/grid_background.dart
import 'package:flutter/material.dart';
import 'package:portfolio_website/themes/wireframe/wireframe_layout_constants.dart';
import 'package:portfolio_website/themes/wireframe/utils/wireframe_color_manager.dart';

class GridBackground extends StatelessWidget {
  final Widget child;
  final Color gridColor;
  final double gridOpacity;
  final double gridSize;
  final double strokeWidth;
  final Color backgroundColor;

  const GridBackground({
    Key? key,
    required this.child,
    this.gridColor = Colors.grey,
    this.gridOpacity = 0.3,
    this.gridSize = 20.0,
    this.strokeWidth = 1.0,
    this.backgroundColor = Colors.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: CustomPaint(
        painter: GridPainter(
          gridColor: gridColor.withOpacity(gridOpacity),
          gridSize: gridSize,
          strokeWidth: strokeWidth,
        ),
        child: child,
      ),
    );
  }
}

/// Enhanced grid background with wireframe theme integration
class WireframeConsistentBackground extends StatelessWidget {
  final Widget child;
  final bool showGrid;
  final double? gridFadeOpacity; // null = use default, 0.0-1.0 = fade amount
  final bool useResponsiveGrid; // Scale grid with screen size

  const WireframeConsistentBackground({
    Key? key,
    required this.child,
    this.showGrid = true,
    this.gridFadeOpacity,
    this.useResponsiveGrid = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!showGrid) {
      return Container(
        color: WireframeColorManager.colors.background,
        child: child,
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final scale = useResponsiveGrid
        ? WireframeLayoutConstants.getResponsiveScale(screenWidth)
        : 1.0;

    final gridOpacity =
        gridFadeOpacity ?? WireframeLayoutConstants.masterGridOpacity;
    final effectiveGridSize = WireframeLayoutConstants.masterGridSize * scale;

    return GridBackground(
      gridColor: WireframeColorManager.colors.textSecondary,
      gridOpacity: gridOpacity,
      gridSize: effectiveGridSize,
      strokeWidth: WireframeLayoutConstants.masterGridStrokeWidth,
      backgroundColor: WireframeColorManager.colors.background,
      child: child,
    );
  }

  /// Factory constructor for bottom section with subtle grid
  factory WireframeConsistentBackground.bottomSection({
    required Widget child,
    bool showGrid = true,
  }) {
    return WireframeConsistentBackground(
      child: child,
      showGrid: showGrid,
      gridFadeOpacity: 0.05, // Very subtle for bottom section
      useResponsiveGrid: true,
    );
  }

  /// Factory constructor for top section with full grid
  factory WireframeConsistentBackground.topSection({
    required Widget child,
    bool showGrid = true,
  }) {
    return WireframeConsistentBackground(
      child: child,
      showGrid: showGrid,
      gridFadeOpacity: null, // Use default opacity
      useResponsiveGrid: true,
    );
  }
}

class GridPainter extends CustomPainter {
  final Color gridColor;
  final double gridSize;
  final double strokeWidth;

  GridPainter({
    required this.gridColor,
    required this.gridSize,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Draw vertical lines
    for (double x = 0; x <= size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (double y = 0; y <= size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GridPainter &&
        other.gridColor == gridColor &&
        other.gridSize == gridSize &&
        other.strokeWidth == strokeWidth;
  }

  @override
  int get hashCode => Object.hash(gridColor, gridSize, strokeWidth);
}
