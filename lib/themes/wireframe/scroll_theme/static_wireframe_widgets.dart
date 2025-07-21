// File: lib/themes/wireframe/scroll_theme/static_wireframe_widgets.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../utils/wireframe_color_manager.dart';

/// Static mobile wireframe that looks like a low-fidelity sketch
class StaticMobileWireframe extends StatelessWidget {
  final double width;
  final double height;
  final double rotation;
  final double strokeWidth;
  final Color? wireColor;

  const StaticMobileWireframe({
    Key? key,
    required this.width,
    required this.height,
    this.rotation = 0.0,
    this.strokeWidth = 2.0,
    this.wireColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = wireColor ??
        WireframeColorManager.colors.textSecondary.withOpacity(0.6);

    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: width,
        height: height,
        child: CustomPaint(
          painter: MobileWireframePainter(
            strokeWidth: strokeWidth,
            wireColor: color,
          ),
        ),
      ),
    );
  }
}

/// Static desktop wireframe that looks like a browser sketch
class StaticDesktopWireframe extends StatelessWidget {
  final double width;
  final double height;
  final double rotation;
  final double strokeWidth;
  final Color? wireColor;

  const StaticDesktopWireframe({
    Key? key,
    required this.width,
    required this.height,
    this.rotation = 0.0,
    this.strokeWidth = 2.0,
    this.wireColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = wireColor ??
        WireframeColorManager.colors.textSecondary.withOpacity(0.6);

    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: width,
        height: height,
        child: CustomPaint(
          painter: DesktopWireframePainter(
            strokeWidth: strokeWidth,
            wireColor: color,
          ),
        ),
      ),
    );
  }
}

/// Custom painter for mobile wireframe
class MobileWireframePainter extends CustomPainter {
  final double strokeWidth;
  final Color wireColor;

  MobileWireframePainter({
    required this.strokeWidth,
    required this.wireColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = wireColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = wireColor.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Phone outline with rounded corners
    final phoneRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(size.width * 0.08),
    );
    canvas.drawRRect(phoneRect, paint);

    // Screen area
    final screenMargin = size.width * 0.06;
    final screenTop = size.height * 0.08;
    final screenBottom = size.height * 0.85;
    final screenRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        screenMargin,
        screenTop,
        size.width - (screenMargin * 2),
        screenBottom - screenTop,
      ),
      Radius.circular(size.width * 0.04),
    );
    canvas.drawRRect(screenRect, fillPaint);
    canvas.drawRRect(screenRect, paint);

    // Status bar
    _drawStatusBar(canvas, size, paint);

    // Header section
    _drawMobileHeader(canvas, size, paint);

    // Content sections
    _drawMobileContent(canvas, size, paint);

    // Navigation bar
    _drawMobileNavigation(canvas, size, paint);

    // Home indicator
    _drawHomeIndicator(canvas, size, paint);
  }

  void _drawStatusBar(Canvas canvas, Size size, Paint paint) {
    final y = size.height * 0.12;
    final margin = size.width * 0.1;

    // Time
    _drawTextPlaceholder(
        canvas, size, paint, margin, y, size.width * 0.2, size.height * 0.02);

    // Battery and signal
    _drawTextPlaceholder(
        canvas,
        size,
        paint,
        size.width - margin - size.width * 0.15,
        y,
        size.width * 0.15,
        size.height * 0.02);
  }

  void _drawMobileHeader(Canvas canvas, Size size, Paint paint) {
    final headerY = size.height * 0.16;
    final margin = size.width * 0.1;

    // Profile avatar circle
    final avatarRadius = size.width * 0.08;
    canvas.drawCircle(
      Offset(margin + avatarRadius, headerY + avatarRadius),
      avatarRadius,
      paint,
    );

    // Name and title
    _drawTextPlaceholder(canvas, size, paint, margin + avatarRadius * 2.5,
        headerY, size.width * 0.4, size.height * 0.025);
    _drawTextPlaceholder(canvas, size, paint, margin + avatarRadius * 2.5,
        headerY + size.height * 0.04, size.width * 0.3, size.height * 0.02);
  }

  void _drawMobileContent(Canvas canvas, Size size, Paint paint) {
    final contentStartY = size.height * 0.3;
    final margin = size.width * 0.1;
    final contentWidth = size.width - (margin * 2);

    // Content cards
    for (int i = 0; i < 3; i++) {
      final cardY = contentStartY + (i * size.height * 0.15);
      final cardRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(margin, cardY, contentWidth, size.height * 0.12),
        Radius.circular(size.width * 0.02),
      );
      canvas.drawRRect(cardRect, paint);

      // Card content lines
      _drawTextPlaceholder(canvas, size, paint, margin + size.width * 0.05,
          cardY + size.height * 0.02, contentWidth * 0.7, size.height * 0.02);
      _drawTextPlaceholder(canvas, size, paint, margin + size.width * 0.05,
          cardY + size.height * 0.05, contentWidth * 0.5, size.height * 0.015);
      _drawTextPlaceholder(canvas, size, paint, margin + size.width * 0.05,
          cardY + size.height * 0.08, contentWidth * 0.6, size.height * 0.015);
    }
  }

  void _drawMobileNavigation(Canvas canvas, Size size, Paint paint) {
    final navY = size.height * 0.78;
    final margin = size.width * 0.1;
    final navWidth = size.width - (margin * 2);

    // Navigation background
    final navRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(margin, navY, navWidth, size.height * 0.08),
      Radius.circular(size.width * 0.04),
    );
    canvas.drawRRect(navRect, paint);

    // Navigation items (circles for icons)
    final itemSpacing = navWidth / 5;
    for (int i = 0; i < 4; i++) {
      final itemX = margin + itemSpacing * (i + 0.5);
      final itemY = navY + size.height * 0.04;
      canvas.drawCircle(
        Offset(itemX, itemY),
        size.width * 0.03,
        paint,
      );
    }
  }

  void _drawHomeIndicator(Canvas canvas, Size size, Paint paint) {
    final indicatorY = size.height * 0.9;
    final indicatorWidth = size.width * 0.3;
    final indicatorX = (size.width - indicatorWidth) / 2;

    final indicatorRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(indicatorX, indicatorY, indicatorWidth, size.height * 0.01),
      Radius.circular(size.height * 0.005),
    );
    canvas.drawRRect(indicatorRect, paint);
  }

  void _drawTextPlaceholder(Canvas canvas, Size size, Paint paint, double x,
      double y, double width, double height) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(x, y, width, height),
      Radius.circular(height * 0.2),
    );
    canvas.drawRRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Custom painter for desktop wireframe
class DesktopWireframePainter extends CustomPainter {
  final double strokeWidth;
  final Color wireColor;

  DesktopWireframePainter({
    required this.strokeWidth,
    required this.wireColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = wireColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = wireColor.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Browser window outline
    final browserRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(size.width * 0.02),
    );
    canvas.drawRRect(browserRect, paint);
    canvas.drawRRect(browserRect, fillPaint);

    // Browser chrome/header
    _drawBrowserChrome(canvas, size, paint);

    // Sidebar
    _drawSidebar(canvas, size, paint);

    // Main content area
    _drawMainContent(canvas, size, paint);

    // Footer
    _drawFooter(canvas, size, paint);
  }

  void _drawBrowserChrome(Canvas canvas, Size size, Paint paint) {
    final chromeHeight = size.height * 0.15;

    // Chrome background
    final chromeRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, chromeHeight),
      Radius.circular(size.width * 0.02),
    );
    canvas.drawRRect(chromeRect, paint);

    // Traffic lights
    final lightRadius = size.width * 0.015;
    final lightY = chromeHeight * 0.4;
    final lightSpacing = size.width * 0.04;
    final lightStartX = size.width * 0.03;

    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(
        Offset(lightStartX + (i * lightSpacing), lightY),
        lightRadius,
        paint,
      );
    }

    // URL bar
    final urlBarWidth = size.width * 0.5;
    final urlBarHeight = chromeHeight * 0.4;
    final urlBarX = (size.width - urlBarWidth) / 2;
    final urlBarY = (chromeHeight - urlBarHeight) / 2;

    final urlBarRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(urlBarX, urlBarY, urlBarWidth, urlBarHeight),
      Radius.circular(urlBarHeight * 0.3),
    );
    canvas.drawRRect(urlBarRect, paint);
  }

  void _drawSidebar(Canvas canvas, Size size, Paint paint) {
    final sidebarWidth = size.width * 0.2;
    final sidebarTop = size.height * 0.15;
    final sidebarHeight = size.height * 0.7;

    // Sidebar background
    final sidebarRect =
        Rect.fromLTWH(0, sidebarTop, sidebarWidth, sidebarHeight);
    canvas.drawRect(sidebarRect, paint);

    // Sidebar items
    final itemHeight = size.height * 0.08;
    final itemMargin = size.width * 0.02;

    for (int i = 0; i < 6; i++) {
      final itemY = sidebarTop + (i * itemHeight) + size.height * 0.05;

      // Icon placeholder
      canvas.drawCircle(
        Offset(itemMargin + size.width * 0.03, itemY + itemHeight * 0.3),
        size.width * 0.015,
        paint,
      );

      // Text placeholder
      _drawTextPlaceholder(canvas, size, paint, itemMargin + size.width * 0.07,
          itemY + itemHeight * 0.2, sidebarWidth * 0.6, itemHeight * 0.2);
    }
  }

  void _drawMainContent(Canvas canvas, Size size, Paint paint) {
    final contentLeft = size.width * 0.2;
    final contentTop = size.height * 0.15;
    final contentWidth = size.width * 0.8;
    final contentHeight = size.height * 0.7;

    // Header section
    _drawTextPlaceholder(
        canvas,
        size,
        paint,
        contentLeft + size.width * 0.05,
        contentTop + size.height * 0.05,
        contentWidth * 0.4,
        size.height * 0.06);

    // Content grid
    final cardWidth = contentWidth * 0.25;
    final cardHeight = size.height * 0.15;
    final cardSpacing = size.width * 0.03;

    for (int row = 0; row < 2; row++) {
      for (int col = 0; col < 3; col++) {
        final cardX =
            contentLeft + size.width * 0.05 + (col * (cardWidth + cardSpacing));
        final cardY = contentTop +
            size.height * 0.15 +
            (row * (cardHeight + size.height * 0.05));

        final cardRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(cardX, cardY, cardWidth, cardHeight),
          Radius.circular(size.width * 0.01),
        );
        canvas.drawRRect(cardRect, paint);

        // Card content
        _drawTextPlaceholder(canvas, size, paint, cardX + size.width * 0.02,
            cardY + size.height * 0.02, cardWidth * 0.7, size.height * 0.025);
        _drawTextPlaceholder(canvas, size, paint, cardX + size.width * 0.02,
            cardY + size.height * 0.06, cardWidth * 0.5, size.height * 0.02);
      }
    }
  }

  void _drawFooter(Canvas canvas, Size size, Paint paint) {
    final footerY = size.height * 0.85;
    final footerHeight = size.height * 0.15;

    // Footer background
    final footerRect = Rect.fromLTWH(0, footerY, size.width, footerHeight);
    canvas.drawRect(footerRect, paint);

    // Footer content
    _drawTextPlaceholder(canvas, size, paint, size.width * 0.05,
        footerY + size.height * 0.05, size.width * 0.3, size.height * 0.03);
  }

  void _drawTextPlaceholder(Canvas canvas, Size size, Paint paint, double x,
      double y, double width, double height) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(x, y, width, height),
      Radius.circular(height * 0.2),
    );
    canvas.drawRRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Animated wireframe that can transition between states
class AnimatedWireframeTransition extends StatelessWidget {
  final Widget staticWireframe;
  final Widget interactiveWireframe;
  final double transitionProgress;
  final Duration animationDuration;

  const AnimatedWireframeTransition({
    Key? key,
    required this.staticWireframe,
    required this.interactiveWireframe,
    required this.transitionProgress,
    this.animationDuration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Static wireframe (fades out)
        Opacity(
          opacity: (1.0 - transitionProgress).clamp(0.0, 1.0),
          child: staticWireframe,
        ),

        // Interactive wireframe (fades in)
        Opacity(
          opacity: transitionProgress.clamp(0.0, 1.0),
          child: interactiveWireframe,
        ),
      ],
    );
  }
}

/// Collection of wireframe sketches positioned like a design workspace
class WireframeWorkspace extends StatelessWidget {
  final double width;
  final double height;
  final double scrollProgress;
  final bool isMobile;

  const WireframeWorkspace({
    Key? key,
    required this.width,
    required this.height,
    required this.scrollProgress,
    this.isMobile = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: Stack(
        children: [
          // Background paper texture
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              border: Border.all(
                color:
                    WireframeColorManager.colors.textSecondary.withOpacity(0.3),
                width: 1,
              ),
            ),
          ),

          // Multiple wireframe sketches scattered around
          _buildScatteredWireframes(),

          // Design tools (ruler, pencil, etc.)
          if (!isMobile) _buildDesignTools(),
        ],
      ),
    );
  }

  Widget _buildScatteredWireframes() {
    return Stack(
      children: [
        // Mobile wireframe sketch
        Positioned(
          left: width * 0.1,
          top: height * 0.2,
          child: Transform.rotate(
            angle: -0.2,
            child: StaticMobileWireframe(
              width: width * 0.25,
              height: width * 0.5,
              strokeWidth: 1.5,
            ),
          ),
        ),

        // Desktop wireframe sketch
        Positioned(
          right: width * 0.1,
          top: height * 0.1,
          child: Transform.rotate(
            angle: 0.15,
            child: StaticDesktopWireframe(
              width: width * 0.4,
              height: width * 0.25,
              strokeWidth: 1.5,
            ),
          ),
        ),

        // Additional sketches for tablet view
        if (!isMobile) ...[
          Positioned(
            left: width * 0.3,
            bottom: height * 0.2,
            child: Transform.rotate(
              angle: 0.1,
              child: StaticMobileWireframe(
                width: width * 0.2,
                height: width * 0.4,
                strokeWidth: 1.0,
                wireColor:
                    WireframeColorManager.colors.textSecondary.withOpacity(0.4),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDesignTools() {
    return Stack(
      children: [
        // Ruler
        Positioned(
          left: 0,
          top: height * 0.7,
          child: Container(
            width: width * 0.8,
            height: 20,
            decoration: BoxDecoration(
              color:
                  WireframeColorManager.colors.textSecondary.withOpacity(0.2),
              border: Border.all(
                color:
                    WireframeColorManager.colors.textSecondary.withOpacity(0.5),
                width: 1,
              ),
            ),
          ),
        ),

        // Pencil
        Positioned(
          right: width * 0.05,
          bottom: height * 0.1,
          child: Transform.rotate(
            angle: 0.7,
            child: Container(
              width: 8,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.yellow.withOpacity(0.8),
                border: Border.all(
                  color: WireframeColorManager.colors.textSecondary,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
