// File: lib/themes/wireframe/widgets/widget_tilt.dart
import 'package:flutter/material.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'package:portfolio_website/revised_case_studies/moments.dart';
import 'package:portfolio_website/revised_case_studies/tap_in.dart';

class TiltCaseStudyCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String coverAsset;
  final Color backgroundColor;
  final String actionId;
  final double width;
  final double height;
  final double borderRadius;
  final VoidCallback? onTap;

  const TiltCaseStudyCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.coverAsset,
    required this.backgroundColor,
    required this.actionId,
    this.width = 180.0,
    this.height = 240.0,
    this.borderRadius = 12.0,
    this.onTap,
  }) : super(key: key);

  // Handle navigation based on action ID
  void _handleNavigation(BuildContext context) {
    print('🔥 Tilt card clicked: $title');

    if (onTap != null) {
      onTap!();
      return;
    }

    switch (actionId) {
      case 'tap_in':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TapInCaseStudy(),
          ),
        );
        break;
      case 'project_2':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MomentsCaseStudy(),
          ),
        );
        break;
      case 'project_3':
        _showComingSoonDialog(context, 'Project 3');
        break;
      case 'project_4':
        _showComingSoonDialog(context, 'Project 4');
        break;
    }
  }

  // Show coming soon dialog
  void _showComingSoonDialog(BuildContext context, String projectName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF2B2A2F),
          title: Text(
            projectName,
            style: TextStyle(
              color: Color(0xFFFF9A62),
              fontFamily: 'KOMIKAX_',
            ),
          ),
          content: Text(
            'This case study is coming soon!',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              child: Text('OK', style: TextStyle(color: Color(0xFFFF9A62))),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  // Helper method to get the correct back page asset
  String _getBackPageAsset(String actionId) {
    switch (actionId) {
      case 'tap_in':
        return 'assets/tapin/tapin_back.png';
      case 'project_2':
        return 'assets/moments_back.png'; // Update with actual path
      case 'project_3':
        return 'assets/pacha_back.png'; // Update with actual path
      case 'project_4':
        return 'assets/ronin_back.png'; // Update with actual path
      default:
        return 'assets/default_back.png'; // Fallback image
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Tilt(
        // Tilt configuration - enhanced for page reveal effect
        tiltConfig: TiltConfig(
          angle: actionId == 'project_2'
              ? 20.0
              : 12.0, // More dramatic tilt for book with pages
          enableReverse: false,
          filterQuality: FilterQuality.high,
          enableGestureSensors: true,
          enableGestureHover: true,
          enableGestureTouch: true,
          enableRevert: true,
          moveDuration:
              Duration(milliseconds: 200), // Slightly slower for page effect
          leaveDuration:
              Duration(milliseconds: 500), // Longer return for smooth settle
        ),

        // Light effect configuration
        lightConfig: LightConfig(
          disable: false,
          color: const Color(0xFFFFFFFF),
          minIntensity: 0.0,
          maxIntensity: actionId == 'project_2'
              ? 0.4
              : 0.3, // Stronger light for page reveal
          spreadFactor: 3.0,
        ),

        // Shadow configuration
        shadowConfig: ShadowConfig(
          disable: false,
          color: Color(0xFF000000),
          minIntensity: 0.1,
          maxIntensity:
              actionId == 'project_2' ? 0.5 : 0.4, // Stronger shadow for depth
          offsetFactor:
              actionId == 'project_2' ? 0.12 : 0.08, // More offset for pages
          minBlurRadius: 8,
          maxBlurRadius:
              actionId == 'project_2' ? 20 : 16, // More blur for page effect
        ),

        // Border and styling
        borderRadius: BorderRadius.circular(borderRadius),

        // Enhanced ChildLayout with page reveal effect
        childLayout: ChildLayout(

          // BEHIND elements - these appear behind the main book cover

          behind: (actionId == 'project_2' ||
                  actionId == 'project_3' ||
                  actionId == 'project_4' ||
                  actionId == 'tap_in')
              ? [
                  // Page 3 - furthest back (BACK PAGE)
                  Positioned(
                    top: 12,   // higher number more pushed DOWN
                    left: 12,
                    child: TiltParallax(
                      size: const Offset(-35, -30), // Strong parallax for depth
                      child: Container(
                        width: width - 8,   // lower number for larger back image
                        height: height - 8, // lower number for larger back image
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(borderRadius - 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(40),
                              blurRadius: 10,
                              offset: Offset(3, 5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(borderRadius - 2),
                          child: Image.asset(
                            _getBackPageAsset(actionId),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Fallback to colored container if image not found
                              return Container(
                                color: Color(0xFFD5D5CE),
                                child: Center(
                                  child: Text(
                                    'BACK',
                                    style: TextStyle(
                                      color: Color(0xFF888888),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Page 2 - middle page (PAPER TEXTURE)
                  Positioned(
                    top: 7,
                    left: 7,
                    child: TiltParallax(
                      size: const Offset(-24, -19), // Medium parallax
                      child: Container(
                        width: width - 10,
                        height: height - 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(borderRadius - 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 6,
                              offset: Offset(1, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(borderRadius - 1),
                          child: Stack(
                            children: [
                              // Paper texture image
                              Image.asset(
                                'assets/paper.png',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  // Fallback with fake page lines
                                  return Container(
                                    color: Color(0xFFF5F5F0),
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 2,
                                          width: width * 0.7,
                                          color: Color(0xFFE5E5E0),
                                        ),
                                        SizedBox(height: 8),
                                        Container(
                                          height: 2,
                                          width: width * 0.5,
                                          color: Color(0xFFEDEDE0),
                                        ),
                                        SizedBox(height: 8),
                                        Container(
                                          height: 2,
                                          width: width * 0.6,
                                          color: Color(0xFFD5D5CE),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              // Gradient overlay for page edge effect
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Colors.black.withOpacity(0.05),
                                      Colors.transparent,
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.03),
                                    ],
                                    stops: [0.0, 0.02, 0.98, 1.0],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ]
              : [], // No pages for other items

          // OUTER elements - these appear on top of everything
          outer: [
            // Hover indicator that appears on tilt
            Positioned(
              top: 8,
              left: 8,
              child: TiltParallax(
                size: const Offset(-15, -15),
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 200),
                  opacity: 0.0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      actionId == 'project_2'
                          ? 'TILT TO PEEK'
                          : 'CLICK TO VIEW',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Status badge with parallax - ONLY FOR TAP-IN
            if (actionId == 'tap_in')
              Positioned(
                top: 8,
                right: 8,
                child: TiltParallax(
                  size: const Offset(10, 10), // This creates the live 3D effect
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFFFF9A62),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'LIVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),

        // Gesture callbacks
        onGestureMove: (tiltDataModel, gesturesType) {
          // Optional: Add custom behavior on tilt
          // print('Tilt progress: ${tiltDataModel.areaProgress}');
        },

        // Main content - the actual case study card (front layer)
        child: GestureDetector(
          onTap: () => _handleNavigation(context),
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: Stack(
                fit: StackFit.loose, //
                children: [
                  // Cover image - ensure it fills the container
                  Positioned.fill(
                    // Use Positioned.fill instead of just Image.asset
                    child: Image.asset(
                      coverAsset,
                      fit: BoxFit.cover,
                      alignment: Alignment.center, // Center the image
                      errorBuilder: (context, error, stackTrace) {
                        print('🚨 Image failed to load: $coverAsset');
                        print('Error: $error');
                        print('Stack trace: $stackTrace');
                        return Container(
                          color: backgroundColor,
                          child: Center(
                            child: Text(
                              title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Title overlay at bottom
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Preset configurations for easy use
class TiltCaseStudyPresets {
  static TiltCaseStudyCard tapIn({
    Key? key,
    double width = 180.0,
    double height = 240.0,
  }) {
    return TiltCaseStudyCard(
      key: key,
      title: 'Tap In',
      subtitle: 'Mobile App Design',
      coverAsset: 'assets/tapin/tapin_front.png',
      backgroundColor: Color(0xFF2FBF71),
      actionId: 'tap_in',
      width: width,
      height: height,
    );
  }

  static TiltCaseStudyCard project2({
    Key? key,
    double width = 180.0,
    double height = 240.0,
  }) {
    return TiltCaseStudyCard(
      key: key,
      title: 'Moments',
      subtitle: 'Social Platform',
      coverAsset: 'assets/moments_front.png',
      backgroundColor: Color(0xFF4ECDC4),
      actionId: 'project_2',
      width: width,
      height: height,
    );
  }

  static TiltCaseStudyCard project3({
    Key? key,
    double width = 180.0,
    double height = 240.0,
  }) {
    return TiltCaseStudyCard(
      key: key,
      title: 'Moon Pacha',
      subtitle: 'Korean BBQ',
      coverAsset: 'assets/pacha_front.png',
      backgroundColor: Color(0xFFFF6B6B),
      actionId: 'project_3',
      width: width,
      height: height,
    );
  }

  static TiltCaseStudyCard project4({
    Key? key,
    double width = 180.0,
    double height = 240.0,
  }) {
    return TiltCaseStudyCard(
      key: key,
      title: 'Ronin Jiu Jitsu',
      subtitle: 'Elite Training',
      coverAsset: 'assets/ronin_front.png',
      backgroundColor: Color(0xFF9B59B6),
      actionId: 'project_4',
      width: width,
      height: height,
    );
  }
}
