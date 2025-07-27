// File: lib/themes/wireframe/widgets/books.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:portfolio_website/themes/wireframe/utils/wireframe_color_manager.dart';

class WireframeAnimatedBook extends StatefulWidget {
  final String title;
  final String author;
  final String coverAsset;
  final String spineAsset;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final Duration animationDuration;

  const WireframeAnimatedBook({
    Key? key,
    required this.title,
    required this.author,
    required this.coverAsset,
    required this.spineAsset,
    this.backgroundColor,
    this.textColor,
    this.onTap,
    this.width = 200,
    this.height = 250,
    this.animationDuration = const Duration(milliseconds: 600),
  }) : super(key: key);

  @override
  State<WireframeAnimatedBook> createState() => _WireframeAnimatedBookState();
}

class _WireframeAnimatedBookState extends State<WireframeAnimatedBook>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _openAnimation;
  late Animation<double> _hoverAnimation;
  bool _isOpen = false;
  bool _showingCover = false; // Track if showing cover or spine
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _openAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));

    _hoverAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleBook() {
    setState(() {
      if (!_showingCover) {
        // First tap: flip to show cover
        _showingCover = true;
      } else {
        // Second tap: trigger navigation and animate
        _isOpen = true;
        _controller.forward();

        // Trigger callback for navigation
        if (widget.onTap != null) {
          Future.delayed(Duration(milliseconds: 300), () {
            widget.onTap!();
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: _toggleBook,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _isHovering ? 1.02 : 1.0,
              child: Container(
                width: widget.width,
                height: widget.height,
                child: Stack(
                  children: [
                    // Book Shadow
                    Positioned(
                      left: 5,
                      top: 8,
                      child: Container(
                        width: widget.width! - 5,
                        height: widget.height! - 8,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    // START STATE: Show only spine (centered)
                    if (!_showingCover)
                      Positioned(
                        left: (widget.width! / 2) + 10,
                        top: 0,
                        child: Container(
                          width: 80,
                          height: widget.height!,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.0),
                                blurRadius: 8,
                                offset: Offset(2, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              widget.spineAsset,
                              fit: BoxFit
                                  .contain, // Changed from cover to contain
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: widget.backgroundColor ??
                                      Colors.grey.withAlpha(0),
                                  child: RotatedBox(
                                    quarterTurns: 3,
                                    child: Center(
                                      child: Text(
                                        widget.title,
                                        style: TextStyle(
                                          color:
                                              widget.textColor ?? Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                    // COVER STATE: Show front cover
                    if (_showingCover)
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: widget.width!,
                          height: widget.height!,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.0),
                                blurRadius: 8,
                                offset: Offset(2, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              widget.coverAsset,
                              fit: BoxFit.contain, // Changed from cover to contain
                              errorBuilder: (context, error, stackTrace) {
                                return _buildFallbackCover();
                              },
                            ),
                          ),
                        ),
                      ),

                    // Interaction Hint
                    if (_isHovering)
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.0),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _showingCover
                                  ? 'Click to open'
                                  : 'Click to view cover',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFallbackCover() {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? WireframeColorManager.colors.primary.withAlpha(0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: Center(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    widget.title.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: widget.textColor ?? Colors.white,
                      fontSize: 18,
                      height: 1.1,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              height: 20,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  widget.author.toUpperCase(),
                  style: TextStyle(
                    color: (widget.textColor ?? Colors.white).withOpacity(0.0),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Book presets for different themes
class WireframeBookPresets {
  static const work = (
    backgroundColor: Color(0xFF2FBF71), // Green
    textColor: Colors.white,
  );
  
  static const about = (
    backgroundColor: Color(0xFF4ECDC4), // Teal
    textColor: Colors.white,
  );
  
  static const contact = (
    backgroundColor: Color(0xFFFF6B6B), // Coral
    textColor: Colors.white,
  );
}

// Simple book widget for when you don't need animation
class WireframeSimpleBook extends StatelessWidget {
  final String title;
  final String author;
  final String coverAsset;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const WireframeSimpleBook({
    Key? key,
    required this.title,
    required this.author,
    required this.coverAsset,
    this.backgroundColor,
    this.textColor,
    this.onTap,
    this.width = 160,
    this.height = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.0),
              blurRadius: 6,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            coverAsset,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: BoxDecoration(
                  color: backgroundColor ?? WireframeColorManager.colors.primary.withAlpha(0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 7,
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              title.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: textColor ?? Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        author.toUpperCase(),
                        style: TextStyle(
                          color: (textColor ?? Colors.white).withOpacity(0.9),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}