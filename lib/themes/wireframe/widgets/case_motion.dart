// File: lib/themes/wireframe/widgets/case_motion.dart
import 'package:flutter/material.dart';
import 'package:card_animation_hover/card_animation_hover.dart';
import 'package:portfolio_website/revised_case_studies/moments.dart';
import 'package:portfolio_website/revised_case_studies/tap_in.dart';
import 'package:portfolio_website/themes/wireframe/widgets/widget_tilt.dart';

class CaseStudyMotionGrid extends StatefulWidget {
  final double? width;
  final double? height;
  final double cardWidth;
  final double cardHeight;
  final double spacing;
  final double borderRadius;
  final bool showAnimation;

  const CaseStudyMotionGrid({
    Key? key,
    this.width,
    this.height,
    this.cardWidth = 180.0,
    this.cardHeight = 240.0,
    this.spacing = 20.0,
    this.borderRadius = 12.0,
    this.showAnimation = true, // Enable/disable hover animations
  }) : super(key: key);

  @override
  State<CaseStudyMotionGrid> createState() => _CaseStudyMotionGridState();
}

class _CaseStudyMotionGridState extends State<CaseStudyMotionGrid> {
  // Case study data - ALL 4 PROJECTS
  final List<CaseStudyItem> caseStudies = [
    CaseStudyItem(
      id: 'tap_in',
      title: 'Tap In',
      subtitle: 'Mobile App Design',
      coverAsset: 'assets/tapin/tapin_front.png',
      backgroundColor: Color(0xFF2FBF71),
      actionId: 'tap_in',
    ),
    CaseStudyItem(
      id: 'project_2',
      title: 'Moments',
      subtitle: 'Social Platform',
      coverAsset: 'assets/moments_front.png',
      backgroundColor: Color(0xFF4ECDC4),
      actionId: 'project_2',
    ),
    CaseStudyItem(
      id: 'project_3',
      title: 'Moon Pacha',
      subtitle: 'Korean BBQ',
      coverAsset: 'assets/pacha_front.png',
      backgroundColor: Color(0xFFFF6B6B),
      actionId: 'project_3',
    ),
    CaseStudyItem(
      id: 'project_4',
      title: 'Ronin Jiu Jitsu',
      subtitle: 'Elite BJJ Training',
      coverAsset: 'assets/ronin_front.png',
      backgroundColor: Color(0xFF9B59B6),
      actionId: 'project_4',
    ),
  ];

  @override
  void initState() {
    super.initState();
    print(
        '📚 Card Animation Grid initialized with ${caseStudies.length} case studies');
  }

  // Handle case study clicks
  void _handleCaseStudyTap(CaseStudyItem caseStudy) {
    print('🔥 Clicked on: ${caseStudy.title}');

    switch (caseStudy.actionId) {
      case 'tap_in':
        print('🔥 Navigating to Tap In case study...');
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TapInCaseStudy(),
          ),
        );
        break;

      case 'project_2':
        print('🔥 Navigating to Moments case study...');
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MomentsCaseStudy(),
          ),
        );
        break;

      case 'project_3':
        _showComingSoonDialog('Project 3');
        break;
      case 'project_4':
        _showComingSoonDialog('Project 4');
        break;
    }
  }

  // Show coming soon dialog
  void _showComingSoonDialog(String projectName) {
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

  // Convert case study to card format for CardAnimationHover
  Map<String, String> _caseStudyToCard(CaseStudyItem caseStudy) {
    return {
      'image': caseStudy.coverAsset,
      'header': caseStudy.title,
      'content': caseStudy.subtitle,
      'actionId': caseStudy.actionId,
    };
  }

  // Build individual case study card with flutter_tilt effects
  Widget _buildAnimatedCaseStudyCard(CaseStudyItem caseStudy) {
    // Use flutter_tilt for all cards based on actionId
    switch (caseStudy.actionId) {
      case 'tap_in':
        return TiltCaseStudyPresets.tapIn(
          width: widget.cardWidth,
          height: widget.cardHeight,
        );
      case 'project_2':
        return TiltCaseStudyPresets.project2(
          width: widget.cardWidth,
          height: widget.cardHeight,
        );
      case 'project_3':
        return TiltCaseStudyPresets.project3(
          width: widget.cardWidth,
          height: widget.cardHeight,
        );
      case 'project_4':
        return TiltCaseStudyPresets.project4(
          width: widget.cardWidth,
          height: widget.cardHeight,
        );
      default:
        // Fallback to regular card if actionId doesn't match
        return SizedBox(
          width: widget.cardWidth,
          height: widget.cardHeight,
          child: CardAnimationHover(
            card: _caseStudyToCard(caseStudy),
            showAnimation: widget.showAnimation,
            onTap: () => _handleCaseStudyTap(caseStudy),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate grid dimensions
    final double totalWidth = (widget.cardWidth * 2) + widget.spacing;
    final double totalHeight = (widget.cardHeight * 2) + widget.spacing;

    return Container(
      width: widget.width ?? totalWidth,
      height: widget.height ?? totalHeight,
      child: Column(
        children: [
          // First row: Tap In + Project 2
          Row(
            children: [
              _buildAnimatedCaseStudyCard(caseStudies[0]), // Tap In
              SizedBox(width: widget.spacing),
              _buildAnimatedCaseStudyCard(caseStudies[1]), // Project 2
            ],
          ),

          SizedBox(height: widget.spacing),

          // Second row: Project 3 + Project 4
          Row(
            children: [
              _buildAnimatedCaseStudyCard(caseStudies[2]), // Project 3
              SizedBox(width: widget.spacing),
              _buildAnimatedCaseStudyCard(caseStudies[3]), // Project 4
            ],
          ),
        ],
      ),
    );
  }
}

// Data model
class CaseStudyItem {
  final String id;
  final String title;
  final String subtitle;
  final String coverAsset;
  final Color backgroundColor;
  final String actionId;

  CaseStudyItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.coverAsset,
    required this.backgroundColor,
    required this.actionId,
  });
}

// Custom hover card widget with web-optimized animations
class _CustomHoverCard extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final bool showAnimation;
  final VoidCallback onTap;
  final Widget child;

  const _CustomHoverCard({
    Key? key,
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.showAnimation,
    required this.onTap,
    required this.child,
  }) : super(key: key);

  @override
  State<_CustomHoverCard> createState() => _CustomHoverCardState();
}

class _CustomHoverCardState extends State<_CustomHoverCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05, // Slight scale increase on hover
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _elevationAnimation = Tween<double>(
      begin: 4.0,
      end: 12.0, // Increase shadow on hover
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovering) {
    if (!widget.showAnimation) return;

    setState(() {
      _isHovering = isHovering;
    });

    if (isHovering) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: _elevationAnimation.value,
                      offset: Offset(0, _elevationAnimation.value * 0.5),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    widget.child,
                    // Hover indicator
                    if (_isHovering)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: AnimatedOpacity(
                          duration: Duration(milliseconds: 200),
                          opacity: _isHovering ? 1.0 : 0.0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 3),
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
                              'CLICK TO VIEW',
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
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Preset configurations
class CaseMotionPresets {
  static CaseStudyMotionGrid compact({
    Key? key,
    bool showAnimation = true,
  }) {
    return CaseStudyMotionGrid(
      key: key,
      cardWidth: 140.0,
      cardHeight: 180.0,
      spacing: 15.0,
      borderRadius: 10.0,
      showAnimation: showAnimation,
    );
  }

  static CaseStudyMotionGrid standard({
    Key? key,
    bool showAnimation = true,
  }) {
    return CaseStudyMotionGrid(
      key: key,
      cardWidth: 180.0,
      cardHeight: 240.0,
      spacing: 20.0,
      borderRadius: 12.0,
      showAnimation: showAnimation,
    );
  }

  static CaseStudyMotionGrid large({
    Key? key,
    bool showAnimation = true,
  }) {
    return CaseStudyMotionGrid(
      key: key,
      cardWidth: 220.0,
      cardHeight: 280.0,
      spacing: 25.0,
      borderRadius: 15.0,
      showAnimation: showAnimation,
    );
  }
}
