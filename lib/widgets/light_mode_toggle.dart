import 'package:flutter/material.dart';

class ThemeToggle extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onToggle;

  const ThemeToggle({
    Key? key,
    required this.isDarkMode,
    required this.onToggle,
  }) : super(key: key);

  @override
  State<ThemeToggle> createState() => _ThemeToggleState();
}

class _ThemeToggleState extends State<ThemeToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _moveAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
          milliseconds: 800), // Longer animation for better effect
    );

    // Initialize animations
    _moveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutBack, // More dramatic curve
    ));

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Set initial animation state
    if (widget.isDarkMode) {
      _animationController.value = 1.0;
    } else {
      _animationController.value = 0.0;
    }
  }

  @override
  void didUpdateWidget(ThemeToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isDarkMode != oldWidget.isDarkMode) {
      if (widget.isDarkMode) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use a container with fixed dimensions to ensure consistent rendering
    return Container(
      width: 200, // Fixed width for the toggle
      height: 70, // Fixed height for the toggle
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (widget.isDarkMode) {
              _animationController.reverse();
            } else {
              _animationController.forward();
            }
            widget.onToggle(!widget.isDarkMode);
          });
        },
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            final switchWidth = 200.0;
            final switchHeight = 70.0;
            final sunMoonSize = 56.0;

            // Calculate sun/moon position
            final leftPosition =
                _moveAnimation.value * (switchWidth - sunMoonSize - 30.0) +
                    13.0;

            // Get colors based on mode
            final bgColor = Color.lerp(
              const Color(0xFF2E8BDE), // Light mode color
              const Color(0xFF021220), // Dark mode color
              _moveAnimation.value,
            )!;

            return Container(
              width: switchWidth,
              height: switchHeight,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: bgColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60.0),
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none, // Allow elements to overflow
                children: [
                  // Background cloud circles for light mode (fade out on dark mode)
                  ...List.generate(8, (index) {
                    final baseTop = 5.0 + (index * 5.0);
                    final baseLeft = 180.0 - (index * 25.0);

                    return Opacity(
                      opacity: _fadeAnimation.value * 0.8,
                      child: Positioned(
                        left: baseLeft,
                        top: baseTop,
                        child: Container(
                          width: 56.0,
                          height: 56.0,
                          decoration: const ShapeDecoration(
                            color: Color(0xFFF0F0F0),
                            shape: OvalBorder(),
                          ),
                        ),
                      ),
                    );
                  }),

                  // Background grey cloud circles (light mode)
                  ...List.generate(8, (index) {
                    final baseTop = 0.0 + (index * 5.0);
                    final baseLeft = 175.0 - (index * 25.0);

                    return Opacity(
                      opacity: _fadeAnimation.value * 0.5,
                      child: Positioned(
                        left: baseLeft,
                        top: baseTop,
                        child: Container(
                          width: 56.0,
                          height: 56.0,
                          decoration: const ShapeDecoration(
                            color: Color(0xFFD9D9D9),
                            shape: OvalBorder(),
                          ),
                        ),
                      ),
                    );
                  }),

                  // Background circles for dark mode (stars/nebula)
                  Opacity(
                    opacity: 1.0 - _fadeAnimation.value,
                    child: Stack(
                      children: [
                        // Large nebula circles
                        Positioned(
                          left: 80,
                          top: -60,
                          child: Opacity(
                            opacity: 0.20,
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: const ShapeDecoration(
                                color: Color(0xFFD9D9D9),
                                shape: OvalBorder(),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 120,
                          top: -30,
                          child: Opacity(
                            opacity: 0.20,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: const ShapeDecoration(
                                color: Color(0xFFD9D9D9),
                                shape: OvalBorder(),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 100,
                          top: -20,
                          child: Opacity(
                            opacity: 0.20,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: const ShapeDecoration(
                                color: Color(0xFFD9D9D9),
                                shape: OvalBorder(),
                              ),
                            ),
                          ),
                        ),

                        // Add small stars
                        ...List.generate(10, (index) {
                          final top = (index * 5.0) % switchHeight;
                          final left = 20.0 + (index * 15.0);
                          final size = 2.0 + (index % 3);

                          return Positioned(
                            left: left,
                            top: top,
                            child: Container(
                              width: size,
                              height: size,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),

                  // Sun/Moon
                  Positioned(
                    left: leftPosition,
                    top: (switchHeight - sunMoonSize) / 2,
                    child: Transform.scale(
                      scale: 1.0 +
                          (_scaleAnimation.value - 1.0) * _moveAnimation.value,
                      child: Container(
                        width: sunMoonSize,
                        height: sunMoonSize,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28.0),
                          ),
                          shadows: const [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 4.0,
                              offset: Offset(-2.0, 2.0),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Base circle (sun/moon)
                            Positioned.fill(
                              child: Container(
                                decoration: ShapeDecoration(
                                  color: Color.lerp(
                                    const Color(0xFFFFD700), // Sun color
                                    const Color(0xFF9D9D9D), // Moon color
                                    _moveAnimation.value,
                                  )!,
                                  shape: const OvalBorder(),
                                ),
                              ),
                            ),

                            // Moon craters (only visible in dark mode)
                            ...List.generate(4, (index) {
                              // Positions for moon craters
                              final craterPositions = [
                                [25.0, 10.0, 11.0], // x, y, size
                                [40.0, 24.0, 8.0],
                                [12.0, 23.0, 5.0],
                                [24.0, 38.0, 6.0],
                              ];

                              final pos = craterPositions[index];

                              return Opacity(
                                opacity: (1.0 - _fadeAnimation.value) * 0.8,
                                child: Positioned(
                                  left: pos[0],
                                  top: pos[1],
                                  child: Container(
                                    width: pos[2],
                                    height: pos[2],
                                    decoration: const ShapeDecoration(
                                      color: Color(0xFF525252),
                                      shape: OvalBorder(),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
