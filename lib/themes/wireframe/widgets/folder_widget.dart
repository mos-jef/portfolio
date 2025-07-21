import 'package:flutter/material.dart';

class FolderWidget extends StatefulWidget {
  final String title;
  final VoidCallback? onTap;

  const FolderWidget({
    Key? key,
    required this.title,
    this.onTap,
  }) : super(key: key);

  @override
  State<FolderWidget> createState() => _FolderWidgetState();
}

class _FolderWidgetState extends State<FolderWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late AnimationController _shadowAnimationController;
  late Animation<double> _shadowAnimation;

  bool isOpen = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );

    _shadowAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _shadowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _shadowAnimationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _shadowAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      child: AnimatedBuilder(
        animation: Listenable.merge([_animation, _shadowAnimation]),
        builder: (context, child) {
          return GestureDetector(
            onTap: () {
              print("Folder tapped! Title: ${widget.title}");
              if (isOpen) {
                print("Closing folder");
                _animationController.reverse();
                _shadowAnimationController.reverse();
                isOpen = false;
              } else {
                print("Opening folder");
                _animationController.forward();
                Future.delayed(Duration(milliseconds: 300), () {
                  _shadowAnimationController.forward();
                });
                isOpen = true;

                // Navigate to case study after animation completes
                Future.delayed(Duration(milliseconds: 1200), () {
                  print("Navigating to case study");
                  if (widget.onTap != null) {
                    widget.onTap!();
                  }
                });
              }
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Folder back cover (always visible)
                Positioned(
                  bottom: 40,
                  child: Image.asset(
                    'assets/folder_backcover.png',
                    width: 150,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print("Error loading folder_backcover.png: $error");
                      return Container(
                        width: 150,
                        height: 120,
                        color: Colors.brown[700],
                        child: Center(
                          child: Text(
                            'Back\nCover',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Shadow/gradient effect

                Positioned(
                  bottom: 40,
                  child: Container(
                    width: 150,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.0, 0.4 + 0.4 * _shadowAnimation.value],
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.1 * _shadowAnimation.value),
                        ],
                      ),
                    ),
                  ),
                ),

                // Folder front cover (animated)

                Positioned(
                  bottom: 40,
                  child: _buildFolderFront(),
                ),

                // Title below the folder
                Positioned(
                  bottom: 10,
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),

                // Tap instruction
                if (!isOpen)
                  Positioned(
                    top: 20,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'TAP TO OPEN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
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

  Widget _buildFolderFront() {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.003)
        ..rotateX(1.3 * _animation.value),
      alignment: FractionalOffset.bottomCenter,
      child: SizedBox(
        width: 150,
        height: 100,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Front cover image
            Image.asset(
              'assets/folder_frontcover.png',
              width: 150,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print("Error loading folder_frontcover.png: $error");
                return Container(
                  width: 150,
                  height: 100,
                  color: Colors.brown[500],
                  child: Center(
                    child: Text(
                      'Front\nCover',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),

            // Lightning/glow effect inside folder
            if (_shadowAnimation.value > 0)
              Positioned(
                bottom: 10,
                child: Container(
                  width: 80 * _shadowAnimation.value,
                  height: 60 * _shadowAnimation.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    gradient: RadialGradient(
                      colors: [
                        const Color.fromARGB(255, 48, 48, 47).withOpacity(_shadowAnimation.value * 0.1),
                        const Color.fromARGB(255, 68, 68, 68).withOpacity(_shadowAnimation.value * 0.1),
                        const Color.fromARGB(255, 27, 27, 27).withOpacity(_shadowAnimation.value * 0.1),
                        Colors.transparent,
                      ],
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
