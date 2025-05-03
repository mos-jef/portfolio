import 'package:flutter/material.dart';

class LightDarkSwitch extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onToggle;

  const LightDarkSwitch({
    Key? key,
    required this.isDarkMode,
    required this.onToggle,
  }) : super(key: key);

  @override
  State<LightDarkSwitch> createState() => _LightDarkSwitchState();
}

class _LightDarkSwitchState extends State<LightDarkSwitch>
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
      duration: const Duration(milliseconds: 400),
    );

    // Initialize animations
    _moveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
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
  void didUpdateWidget(LightDarkSwitch oldWidget) {
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
    return GestureDetector(
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
          final switchWidth = 470.0;
          final switchHeight = 150.0;
          final sunMoonSize = 112.0;

          // Calculate sun/moon position
          final leftPosition =
              _moveAnimation.value * (switchWidth - sunMoonSize - 100.0) + 13.0;

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
                borderRadius: BorderRadius.circular(132.20),
              ),
            ),
            child: Stack(
              children: [
                // Background cloud circles for light mode (fade out on dark mode)
                ...List.generate(8, (index) {
                  final baseTop = 38.0 + (index * 10.0);
                  final baseLeft = 392.0 - (index * 55.0);

                  return Opacity(
                    opacity: _fadeAnimation.value * 0.8,
                    child: Positioned(
                      left: baseLeft,
                      top: baseTop,
                      child: Container(
                        width: 112.0,
                        height: 112.0,
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
                  final baseTop = 17.93 + (index * 10.0);
                  final baseLeft = 385.39 - (index * 55.0);

                  return Opacity(
                    opacity: _fadeAnimation.value * 0.5,
                    child: Positioned(
                      left: baseLeft,
                      top: baseTop,
                      child: Container(
                        width: 112.0,
                        height: 112.0,
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
                        left: 182.45,
                        top: -129.96,
                        child: Opacity(
                          opacity: 0.20,
                          child: Container(
                            width: 436.92,
                            height: 436.92,
                            decoration: const ShapeDecoration(
                              color: Color(0xFFD9D9D9),
                              shape: OvalBorder(),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 226.14,
                        top: -86.26,
                        child: Opacity(
                          opacity: 0.20,
                          child: Container(
                            width: 349.54,
                            height: 349.54,
                            decoration: const ShapeDecoration(
                              color: Color(0xFFD9D9D9),
                              shape: OvalBorder(),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 269.83,
                        top: -42.57,
                        child: Opacity(
                          opacity: 0.20,
                          child: Container(
                            width: 262.15,
                            height: 262.15,
                            decoration: const ShapeDecoration(
                              color: Color(0xFFD9D9D9),
                              shape: OvalBorder(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Sun/Moon
                Positioned(
                  left: leftPosition,
                  top: 18.70,
                  child: Transform.scale(
                    scale: 1.0 +
                        (_scaleAnimation.value - 1.0) * _moveAnimation.value,
                    child: Container(
                      width: sunMoonSize,
                      height: sunMoonSize,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(56.02),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 8.96,
                            offset: Offset(-8.96, 8.96),
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
                              [50.17, 20.53, 22.81], // x, y, size
                              [79.82, 47.89, 15.96],
                              [25.09, 45.61, 11.40],
                              [47.89, 77.54, 11.40],
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
    );
  }
}

// A demo widget to test the light/dark switch
class LightDarkSwitchDemo extends StatefulWidget {
  const LightDarkSwitchDemo({Key? key}) : super(key: key);

  @override
  State<LightDarkSwitchDemo> createState() => _LightDarkSwitchDemoState();
}

class _LightDarkSwitchDemoState extends State<LightDarkSwitchDemo> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        title: const Text('Light/Dark Switch Demo'),
        backgroundColor: _isDarkMode ? const Color(0xFF212121) : Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current Mode: ${_isDarkMode ? "Dark" : "Light"}',
              style: TextStyle(
                fontSize: 24,
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: FittedBox(
                child: LightDarkSwitch(
                  isDarkMode: _isDarkMode,
                  onToggle: (value) {
                    setState(() {
                      _isDarkMode = value;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Main function to run the demo
void main() {
  runApp(const MaterialApp(
    home: LightDarkSwitchDemo(),
  ));
}
