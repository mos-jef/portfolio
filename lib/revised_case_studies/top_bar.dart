import 'package:flutter/material.dart';
import 'package:portfolio_website/themes/wireframe/utils/wireframe_color_manager.dart';

enum PortfolioTheme {
  wireframe,
  nes,
  studioGhibli,
}

class CaseStudyTopBar extends StatefulWidget {
  final String caseStudyTitle;
  final VoidCallback onBackPressed;
  final PortfolioTheme currentTheme;
  final VoidCallback? onMainAreaPressed; // Callback for returning to main area

  const CaseStudyTopBar({
    Key? key,
    required this.caseStudyTitle,
    required this.onBackPressed,
    this.currentTheme = PortfolioTheme.wireframe,
    this.onMainAreaPressed,
  }) : super(key: key);

  @override
  State<CaseStudyTopBar> createState() => _CaseStudyTopBarState();
}

class _CaseStudyTopBarState extends State<CaseStudyTopBar> {
  bool _isHoveringName = false;
  OverlayEntry? _overlayEntry;

  // 🎛️ TOP BAR CONTROLS - Easy customization
  static const double topBarHeight = 70.0; // Try 60, 80, 90
  static const double horizontalPadding = 40.0; // Try 20, 30, 50
  static const double nameHoverOpacity = 0.7; // Try 0.5, 0.8, 0.9
  static const double linkIconSize = 16.0; // Link icon size (try 14, 18, 20)
  static const double linkIconSpacing = 8.0; // Space between name and icon
  static const Color backgroundColor = Colors.white; // Background color
  static const Color textColor = Color(0xFF000000); // Figma black
  static const Color linkIconColor = Color(0xFF000000); // Link icon color
  static const Color shadowColor = Colors.black26; // Shadow color
  static const double shadowBlurRadius = 8.0; // Shadow blur
  static const double shadowSpreadRadius = 0.0; // Shadow spread
  static const Offset shadowOffset = Offset(0, 2); // Shadow position

  @override
  void dispose() {
    _removeTooltip();
    super.dispose();
  }

  void _showTooltip() {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: topBarHeight + 10, // Position below the top bar
        left: horizontalPadding + 60, // Position near the name
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              'Return to Main Area',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'SFPro',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _handleNamePressed() {
    switch (widget.currentTheme) {
      case PortfolioTheme.wireframe:
        // Return to wireframe main area
        if (widget.onMainAreaPressed != null) {
          widget.onMainAreaPressed!();
        } else {
          // Fallback navigation - navigate to wireframe main
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
        break;
      case PortfolioTheme.nes:
        // Return to NES theme main screen
        Navigator.of(context).popUntil((route) => route.isFirst);
        // TODO: Add specific NES theme navigation when implemented
        break;
      case PortfolioTheme.studioGhibli:
        // Return to Studio Ghibli theme main screen
        Navigator.of(context).popUntil((route) => route.isFirst);
        // TODO: Add specific Studio Ghibli theme navigation when implemented
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: topBarHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: shadowBlurRadius,
            spreadRadius: shadowSpreadRadius,
            offset: shadowOffset,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 10,
          ),
          child: Row(
            children: [
              // Back Arrow
              _buildBackButton(),

              SizedBox(width: 20),

              // Jeff Anderson Name (Clickable)
              _buildNameButton(),

              // Case Study Title (Centered)
              Expanded(
                child: _buildCaseStudyTitle(),
              ),

              // Expand Button (NEW)
              _buildExpandButton(),

              SizedBox(
                  width: 20), // Reduced spacing to accommodate expand button
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onBackPressed,
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Color(0xFFF8F8F8),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: Color(0xFF363333),
              width: 1,
            ),
          ),
          child: Icon(
            Icons.arrow_back,
            color: textColor,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildNameButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          _isHoveringName = true;
        });
        _showTooltip();
      },
      onExit: (_) {
        setState(() {
          _isHoveringName = false;
        });
        _removeTooltip();
      },
      child: GestureDetector(
        onTap: _handleNamePressed,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 200),
          opacity: _isHoveringName ? nameHoverOpacity : 1.0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Jeff Anderson',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'SFPro',
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              SizedBox(width: linkIconSpacing),
              Icon(
                Icons.link,
                size: linkIconSize,
                color: linkIconColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCaseStudyTitle() {
    return Center(
      child: Text(
        widget.caseStudyTitle,
        style: TextStyle(
          fontSize: 16,
          fontFamily: 'SFPro',
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildExpandButton() {
    // Only show expand button for Tap In and Moments case studies
    if (!['tap in', 'moments'].contains(widget.caseStudyTitle.toLowerCase())) {
      return SizedBox.shrink();
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // Launch the revised case study in browser
          if (widget.caseStudyTitle.toLowerCase() == 'tap in') {
            // TODO: Add URL launch for Tap In revised case study
            print('Launch Tap In revised case study');
          } else if (widget.caseStudyTitle.toLowerCase() == 'moments') {
            // TODO: Add URL launch for Moments revised case study
            print('Launch Moments revised case study');
          }
        },
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.black,
              width: 1.0,
            ),
            color: Colors.white.withOpacity(0.8), // Semi-transparent white
          ),
          child: Icon(
            Icons.open_in_new,
            color: Colors.black,
            size: 16,
          ),
        ),
      ),
    );
  }


}

// Helper class for theme-aware navigation
class TopBarNavigationHelper {
  static void navigateToMainArea(BuildContext context, PortfolioTheme theme) {
    switch (theme) {
      case PortfolioTheme.wireframe:
        // Navigate to wireframe theme main area
        Navigator.of(context).popUntil((route) => route.isFirst);
        break;
      case PortfolioTheme.nes:
        // Navigate to NES theme main area
        Navigator.of(context).popUntil((route) => route.isFirst);
        // Add specific NES theme navigation logic here
        break;
      case PortfolioTheme.studioGhibli:
        // Navigate to Studio Ghibli theme main area
        Navigator.of(context).popUntil((route) => route.isFirst);
        // Add specific Studio Ghibli theme navigation logic here
        break;
    }
  }

  static String getMainAreaTooltipText(PortfolioTheme theme) {
    switch (theme) {
      case PortfolioTheme.wireframe:
        return 'Return to Wireframe Area';
      case PortfolioTheme.nes:
        return 'Return to NES Theme';
      case PortfolioTheme.studioGhibli:
        return 'Return to Studio Ghibli Theme';
    }
  }
}

// Extension for easy integration with existing case studies
extension CaseStudyTopBarExtension on Widget {
  Widget withTopBar({
    required String title,
    required VoidCallback onBack,
    PortfolioTheme theme = PortfolioTheme.wireframe,
    VoidCallback? onMainAreaPressed,
  }) {
    return Column(
      children: [
        CaseStudyTopBar(
          caseStudyTitle: title,
          onBackPressed: onBack,
          currentTheme: theme,
          onMainAreaPressed: onMainAreaPressed,
        ),
        Expanded(child: this),
      ],
    );
  }
}
