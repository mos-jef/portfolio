import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:portfolio_website/revised_case_studies/tap_in.dart';

class VinylWidget extends StatefulWidget {
  final String sectionType;

  const VinylWidget({
    Key? key,
    required this.sectionType,
  }) : super(key: key);

  @override
  State<VinylWidget> createState() => _VinylWidgetState();
}

class _VinylWidgetState extends State<VinylWidget>
    with TickerProviderStateMixin {
  late AnimationController animController;
  late Animation<double> _flipAnimation;
  late Animation<double> _pushBackAnimation;
  late Animation<double> _combinedVerticalAnimation;
  late Animation<double> _topJumpAnimation;
  late Animation<double> _topMoveForwardAnimation;

  late AnimationController animParentController;
  late Animation<double> _headBowForwardAnimation;

  late AnimationController vinylController;
  late Animation<double> _vinylJumpAnimation;

  late List<VinylItem> _vinylItems;
  late List<String> vinylOrder;

  bool isAnimateButtonVisible = true;

  @override
  void initState() {
    super.initState();
    _initializeVinylItems();
    initAnimations();
  }

  void _initializeVinylItems() {
    // Create section-specific vinyl items
    switch (widget.sectionType) {
      case 'Work':
        _vinylItems = [
          VinylItem(
            id: 'tap_in',
            color: Colors.blue,
            asset: "assets/images/vinyl/cover_1.png",
            title: 'Tap In',
          ),
          VinylItem(
            id: 'work_2',
            color: Colors.green,
            asset: "assets/images/vinyl/cover_2.png",
            title: 'Moments',
          ),
          VinylItem(
            id: 'work_3',
            color: Colors.purple,
            asset: "assets/images/vinyl/cover_3.png",
            title: 'Project 3',
          ),
        ];
        vinylOrder = ['work_3', 'work_2', 'tap_in'];
        break;
      case 'About':
        _vinylItems = [
          VinylItem(
            id: 'about_1',
            color: Colors.orange,
            asset: "assets/images/vinyl/cover_1.png",
          ),
          VinylItem(
            id: 'about_2',
            color: Colors.red,
            asset: "assets/images/vinyl/cover_2.png",
          ),
          VinylItem(
            id: 'about_3',
            color: Colors.teal,
            asset: "assets/images/vinyl/cover_3.png",
          ),
        ];
        vinylOrder = ['about_3', 'about_2', 'about_1'];
        break;
      case 'Contact':
        _vinylItems = [
          VinylItem(
            id: 'contact_1',
            color: Colors.pink,
            asset: "assets/images/vinyl/cover_1.png",
          ),
          VinylItem(
            id: 'contact_2',
            color: Colors.amber,
            asset: "assets/images/vinyl/cover_2.png",
          ),
          VinylItem(
            id: 'contact_3',
            color: Colors.cyan,
            asset: "assets/images/vinyl/cover_3.png",
          ),
        ];
        vinylOrder = ['contact_3', 'contact_2', 'contact_1'];
        break;
      default:
        _vinylItems = [];
        vinylOrder = [];
    }
  }

  @override
  void dispose() {
    animController.dispose();
    vinylController.dispose();
    animParentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double baseRotationX = 355 * pi / 180;

    return Container(
      width: 200,
      height: 200,
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: Listenable.merge([_headBowForwardAnimation]),
            builder: (context, child) {
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0003512553609721081)
                  ..rotateY(323 * pi / 180)
                  ..rotateX(baseRotationX +
                      sin(_headBowForwardAnimation.value * pi) * 10 * pi / 180)
                  ..rotateZ(6 * pi / 180)
                  ..scale(0.6), // Scale down for hero section
                alignment: Alignment.center,
                child: _buildCardStack(),
              );
            },
          ),
          if (isAnimateButtonVisible)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {
                    animController.forward();
                    setState(() {
                      isAnimateButtonVisible = false;
                    });
                  },
                  child: Text(
                    'Explore ${widget.sectionType}',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildCardStack() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _flipAnimation,
        _pushBackAnimation,
        _combinedVerticalAnimation,
        _topJumpAnimation,
        _topMoveForwardAnimation,
        _vinylJumpAnimation,
      ]),
      builder: (context, child) {
        return Stack(
          children: List.generate(_vinylItems.length, (index) {
            var vinylItem = _vinylItems[index];
            bool isSecond = false;

            if (vinylItem.id == vinylOrder[0]) {
              vinylItem.verticalAnimationValue =
                  _combinedVerticalAnimation.value;
              vinylItem.zPositionValue =
                  lerpDouble(-100.0, 0.0, _pushBackAnimation.value)!;
              vinylItem.rotateX = _flipAnimation.value;
            } else if (_vinylItems[index].id == vinylOrder[1]) {
              isSecond = true;
              vinylItem.verticalAnimationValue = _topJumpAnimation.value;
              vinylItem.zPositionValue = -50.0 + _topMoveForwardAnimation.value;
              vinylItem.rotateX = 0.0;
            } else if (_vinylItems[index].id == vinylOrder[2]) {
              vinylItem.verticalAnimationValue = _topJumpAnimation.value;
              vinylItem.zPositionValue =
                  (-0 * 50.0) + _topMoveForwardAnimation.value;
              vinylItem.rotateX = 0.0;
            }

            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..translate(0.0, vinylItem.verticalAnimationValue,
                    vinylItem.zPositionValue - (index * 30.0))
                ..rotateX(vinylItem.rotateX),
              alignment: Alignment.center,
              child: _buildAlbumCover(vinylItem, index, isSecond),
            );
          }),
        );
      },
    );
  }

// New method to build individual album cover
  Widget _buildAlbumCover(VinylItem vinylItem, int index, bool isSecond) {
    return Transform.translate(
      offset: Offset(0, isSecond ? _vinylJumpAnimation.value : 0),
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Album cover background - NO GESTURE DETECTOR HERE
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 200,
                height: 200,
                child: Image.asset(
                  vinylItem.asset,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: vinylItem.color,
                      child: Center(
                        child: Text(
                          vinylItem.title ?? widget.sectionType,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // SIMPLIFIED: Single edge tap area (avoids multiple Positioned widgets)
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 60,
                height: 60,
                child: GestureDetector(
                  onTap: () {
                    print("Edge tapped - shuffling");
                    if (!animController.isAnimating &&
                        !animParentController.isAnimating &&
                        !vinylController.isAnimating) {
                      animController.forward();
                    }
                  },
                  child: Container(
                    color: Colors.blue
                        .withOpacity(0.3), // Temporary - so you can see it
                    child: Center(
                      child: Text(
                        'SHUFFLE',
                        style: TextStyle(color: Colors.white, fontSize: 8),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Center circle - ALWAYS on top
            Center(
              child: Container(
                width: 100,
                height: 100,
                child: GestureDetector(
                  onTap: () {
                    print("🔥 CENTER CIRCLE DEFINITELY TAPPED! 🔥");
                    print("isAnimateButtonVisible: $isAnimateButtonVisible");
                    print(
                        "animController.isAnimating: ${animController.isAnimating}");
                    print(
                        "animParentController.isAnimating: ${animParentController.isAnimating}");
                    print(
                        "vinylController.isAnimating: ${vinylController.isAnimating}");

                    if (!animController.isAnimating &&
                        !animParentController.isAnimating &&
                        !vinylController.isAnimating) {
                      final currentTopVinyl = _vinylItems.firstWhere(
                        (item) => item.id == vinylOrder[0],
                        orElse: () => _vinylItems.first,
                      );

                      print("Current vinyl ID: ${currentTopVinyl.id}");
                      print("Current vinyl title: ${currentTopVinyl.title}");

                      if (currentTopVinyl.id == 'tap_in') {
                        print("🚀 NAVIGATING TO TAP IN CASE STUDY! 🚀");
                        _handleVinylTap();
                      } else {
                        print("❌ No case study for ${currentTopVinyl.id}");
                      }
                    } else {
                      print("⏳ Animation is running, ignoring tap");
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.withOpacity(0.8),
                      border: Border.all(color: Colors.yellow, width: 4),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'TAP ME',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'CENTER',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isFrontImage(double angle) {
    const degrees90 = pi / 2;
    const degrees270 = 3 * pi / 2;
    return angle <= degrees90 || angle >= degrees270;
  }

  void resetAnimation() {
    // Don't dispose and recreate - just reset
    animController.removeListener(_animationHooks);
    animController.reset();
    animParentController.reset();
    vinylController.reset();

    // Re-add listener
    animController.addListener(_animationHooks);

    // Reset vinyl item states
    for (var item in _vinylItems) {
      item.verticalAnimationValue = 0.0;
      item.zPositionValue = 0.0;
      item.rotateX = 0.0;
    }

    // Reset flags
    _isStackReordered = false;
  }

  initAnimations() {
    animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..addListener(_animationHooks);

    animParentController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));

    vinylController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animParentController.forward();
      }
    });

    animParentController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        print("animation completed | simple order change");

        // Change order first
        _changeAnimationListOrder();

        // Then reset controllers properly
        Future.delayed(Duration(milliseconds: 50), () {
          if (mounted) {
            setState(() {
              // Reset all animation values
              for (var item in _vinylItems) {
                item.verticalAnimationValue = 0.0;
                item.zPositionValue = 0.0;
                item.rotateX = 0.0;
              }

              // Reset animation states
              _isStackReordered = false;
              isAnimateButtonVisible = false;
            });

            // Reset controllers without recreating them
            animController.reset();
            animParentController.reset();
            vinylController.reset();
          }
        });
      }
    });

    // Combined vertical animations
    _combinedVerticalAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 150.0)
            .chain(CurveTween(curve: Curves.linear)),
        weight: 30.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 150.0, end: 150.0)
            .chain(CurveTween(curve: Curves.linear)),
        weight: 40.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 150.0, end: 0.0)
            .chain(CurveTween(curve: Curves.linear)),
        weight: 30.0,
      ),
    ]).animate(animController);

    _flipAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: pi / 2)
            .chain(CurveTween(curve: Curves.linear)),
        weight: 30.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: pi / 2, end: 3 * pi / 2)
            .chain(CurveTween(curve: Curves.linear)),
        weight: 40.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 3 * pi / 2, end: 2 * pi)
            .chain(CurveTween(curve: Curves.linear)),
        weight: 30.0,
      ),
    ]).animate(animController);

    _pushBackAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animController,
        curve: Interval(0.13, 0.85, curve: Curves.linear),
      ),
    );

    _topJumpAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: -100)
            .chain(CurveTween(curve: SnappySpringCurve())),
        weight: 40.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -100, end: -100)
            .chain(CurveTween(curve: Curves.linear)),
        weight: 30.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -100, end: 0.0)
            .chain(CurveTween(curve: SnappySpringCurve())),
        weight: 40.0,
      ),
    ]).animate(animController);

    _topMoveForwardAnimation = Tween<double>(begin: 0.0, end: -50).animate(
      CurvedAnimation(
        parent: animController,
        curve: Interval(0.0, 0.3, curve: SnappySpringCurve()),
      ),
    );

    _headBowForwardAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: animParentController,
          curve: Interval(0.0, 0.75, curve: SnappySpringCurve())),
    );

    _vinylJumpAnimation = Tween<double>(begin: 0, end: -50).animate(
      CurvedAnimation(
        parent: vinylController,
        curve: Interval(0.0, 1.0, curve: SnappySpringCurve()),
      ),
    );
  }

  bool _isStackReordered = false;

  _animationHooks() {
    if (animController.value >= 0.5 && !_isStackReordered) {
      _changeStackOrder();
      _isStackReordered = true;
    } else if (animController.value < 0.5) {
      _isStackReordered = false;
    } else if (animController.value > 0.74) {
      vinylController.forward().then((_) => vinylController.reverse());
    }
  }

  void _changeStackOrder() {
    setState(() {
      VinylItem item = _vinylItems.removeAt(_vinylItems.length - 1);
      _vinylItems.insert(0, item);
    });
  }

  void _changeAnimationListOrder() {
    setState(() {
      String firstElement = vinylOrder.removeAt(0);
      vinylOrder.add(firstElement);
    });
  }

  void _handleVinylTap() {
    print("🔥 _handleVinylTap method called!");

    // Get the current top vinyl
    final currentTopVinyl = _vinylItems.firstWhere(
      (item) => item.id == vinylOrder[0],
      orElse: () => _vinylItems.first,
    );

    print("Navigating for vinyl: ${currentTopVinyl.id}");

    // Navigate based on vinyl ID
    if (currentTopVinyl.id == 'tap_in') {
      print("🚀 Attempting to navigate to TapInCaseStudy");
      try {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TapInCaseStudy(),
          ),
        );
        print("✅ Navigation successful!");
      } catch (e) {
        print("❌ Navigation failed: $e");
      }
    } else {
      print("❌ No navigation defined for vinyl: ${currentTopVinyl.id}");
    }
  }

  void debugAnimationState() {
    print("=== ANIMATION STATE DEBUG ===");
    print("isAnimateButtonVisible: $isAnimateButtonVisible");
    print("animController.isAnimating: ${animController.isAnimating}");
    print("animController.status: ${animController.status}");
    print(
        "animParentController.isAnimating: ${animParentController.isAnimating}");
    print("vinylController.isAnimating: ${vinylController.isAnimating}");

    for (int i = 0; i < _vinylItems.length; i++) {
      final item = _vinylItems[i];
      print(
          "Vinyl $i (${item.id}): vertical=${item.verticalAnimationValue}, z=${item.zPositionValue}, rotateX=${item.rotateX}");
    }
    print("vinylOrder: $vinylOrder");
    print("=============================");
  }
}

class VinylItem {
  final String id;
  final Color color;
  final String asset;
  final String? title;
  double verticalAnimationValue = 0.0;
  double zPositionValue = 0.0;
  double rotateX = 0.0;

  VinylItem({
    required this.id,
    required this.color,
    required this.asset,
    this.title,
    this.verticalAnimationValue = 0.0,
    this.zPositionValue = 0.0,
    this.rotateX = 0.0,
  });
}

class SnappySpringCurve extends Curve {
  @override
  double transform(double t) {
    return t * t * (3 - 2 * t) + sin(t * pi * 3) * 0.1 * (1 - t);
  }
}
