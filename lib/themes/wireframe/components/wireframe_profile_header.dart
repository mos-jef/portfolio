import 'package:flutter/material.dart';
import 'package:portfolio_website/themes/wireframe/utils/wireframe_color_manager.dart';
import 'package:portfolio_website/themes/wireframe/widgets/clickable_widget.dart';
import 'package:portfolio_website/themes/wireframe/widgets/svg_icon.dart';
import 'package:portfolio_website/widgets/border_beam.dart';

import '../wireframe_layout_constants.dart';

class WireframeProfileHeader extends StatelessWidget {
  final bool isMobile;
  final VoidCallback onContactTap;
  final VoidCallback onLinkedInTap;
  final VoidCallback onResumeTap;
  final VoidCallback? onMenuTap;
  final VoidCallback? onAvatarTap;
  final String? currentView;

  const WireframeProfileHeader(
      {Key? key,
      required this.isMobile,
      required this.onContactTap,
      required this.onLinkedInTap,
      required this.onResumeTap,
      this.onMenuTap,
      this.onAvatarTap,
      this.currentView})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return _buildMobileHeader();
    } else {
      return _buildDesktopHeader();
    }
  }

  Widget _buildMobileHeader() {
    return Column(
      children: [
        // Header image section - HIDE FOR SETTINGS
        if (currentView != 'settings')
          Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/uxui_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

        // Profile section with avatar overlapping header
        Stack(
          children: [

            // Background container - CALCULATED HEIGHT based on avatar space
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 140 +
                    80, // 140 base + your desired avatar space (change 80 to whatever you want)
                decoration: BoxDecoration(
                  color: WireframeColorManager.colors.surface,
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
            ),

       
           // Content area without avatar - RESPONSIVE
            Transform.translate(
              offset: Offset(0, -40),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: WireframeLayoutConstants.spacingStandard,
                  vertical: WireframeLayoutConstants.spacingStandard,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final screenWidth = MediaQuery.of(context).size.width;
                    final responsiveScale =
                        WireframeLayoutConstants.getResponsiveScale(
                            screenWidth);

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Left side - Profile info with responsive layout

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  height: 80), // Space for overlapping avatar

                              // Name - RESPONSIVE
                              Text(
                                'Jeff Anderson',
                                style: TextStyle(
                                  fontSize: (WireframeLayoutConstants
                                              .mobileFontSizeTitle *
                                          responsiveScale)
                                      .clamp(16.0, 24.0),
                                  fontWeight: FontWeight.bold,
                                  color: WireframeColorManager.colors.text,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),

                              SizedBox(
                                height: (WireframeLayoutConstants.spacingTiny *
                                        responsiveScale)
                                    .clamp(4.0, 8.0),
                              ),

                              // Role - RESPONSIVE
                              Text(
                                'UX/UI Designer',
                                style: TextStyle(
                                  fontSize: (WireframeLayoutConstants
                                              .mobileFontSizeBody *
                                          responsiveScale)
                                      .clamp(12.0, 18.0),
                                  color: WireframeColorManager.colors.primary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),

                              SizedBox(
                                height: (WireframeLayoutConstants.spacingTiny *
                                        responsiveScale)
                                    .clamp(4.0, 8.0),
                              ),

                              // Quote - RESPONSIVE with wrap
                              Container(
                                width: constraints.maxWidth *
                                    0.8, // Limit width to prevent overflow
                                child: Text(
                                  '"OPEN TO NEW OPPORTUNITIES!"',
                                  style: TextStyle(
                                    fontSize: (WireframeLayoutConstants
                                                .mobileFontSizeCaption *
                                            responsiveScale)
                                        .clamp(10.0, 10.0),
                                    fontStyle: FontStyle.italic,
                                    color: WireframeColorManager
                                        .colors.onSecondary,
                                  ),
                                  overflow: TextOverflow.fade,
                                  softWrap: true,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Right side - Responsive spacing
                        SizedBox(
                          width: (50.0 * responsiveScale).clamp(20.0, 100.0),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

          ],
        ),
      ],
    );
  }

  Widget _buildDesktopHeader() {
    // HIDE ENTIRE PROFILE HEADER FOR SETTINGS on desktop too
    if (currentView == 'settings') {
      return SizedBox.shrink(); // Return empty widget
    }

    return Column(
      children: [
        // Header image section
        Container(
          width: double.infinity,
          height: 160,
          decoration: BoxDecoration(
            image: DecorationImage(
              image:
                  AssetImage('assets/uxui_bg.png'), // Replace with your image
              fit: BoxFit.cover, // or BoxFit.fill, BoxFit.fitWidth, etc.
            ),
          ),
        ),

        // Profile section with avatar overlapping header
        Transform.translate(
          offset: Offset(0, -40),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              left: WireframeLayoutConstants.spacingXLarge,
              right: WireframeLayoutConstants.spacingXLarge,
              top: WireframeLayoutConstants.spacingStandard,
              bottom: WireframeLayoutConstants.spacingStandard,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side - Avatar and info stacked vertically
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Avatar positioned to overlap header image with tap functionality
                      
                      ClickableWidget(
                        onTap: isMobile ? onAvatarTap : onAvatarTap,
                        child: BorderBeam(
                          duration: 10, // Slower animation for desktop
                          borderWidth: 4,
                          colorFrom: WireframeColorManager.colors.primary,
                          colorTo: WireframeColorManager.colors.secondary ??
                              WireframeColorManager.colors.primary,
                          staticBorderColor:
                              WireframeColorManager.colors.surface,
                          borderRadius: BorderRadius.circular(
                              WireframeLayoutConstants.desktopAvatarSize /
                                  2), // Make it circular
                          child: Container(
                            width: WireframeLayoutConstants.desktopAvatarSize,
                            height: WireframeLayoutConstants.desktopAvatarSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage('assets/me_avatar.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: WireframeLayoutConstants.spacingMedium),

                      // Name
                      Text(
                        'Jeff Anderson',
                        style: TextStyle(
                          fontSize: WireframeLayoutConstants
                              .desktopFontSizeLargeTitle,
                          fontWeight: FontWeight.bold,
                          color: WireframeColorManager.colors.focused,
                        ),
                      ),

                      // Title
                      Text(
                        'UX/UI Designer',
                        style: TextStyle(
                          fontSize:
                              WireframeLayoutConstants.desktopFontSizeBodyLarge,
                          color: WireframeColorManager.colors.primary,
                        ),
                      ),

                      SizedBox(height: WireframeLayoutConstants.spacingSmall),

                      // Quote
                      Text(
                        '"OPEN TO NEW OPPORTUNITIES!"',
                        style: TextStyle(
                          fontSize:
                              WireframeLayoutConstants.desktopFontSizeBody,
                          fontStyle: FontStyle.italic,
                          color: WireframeColorManager.colors.onSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Right side - Icons removed (now using floating icons)
                SizedBox(width: 100), // Placeholder spacing
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Helper method for mobile action buttons
  Widget _buildMobileActionButton(
      IconData icon, Color color, VoidCallback onTap) {
    return ClickableWidget(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: Icon(
          icon,
          size: 18,
          color: WireframeLayoutConstants.wireframeWhite,
        ),
      ),
    );
  }

  // Helper method for mobile LinkedIn button
  Widget _buildMobileLinkedInButton() {
    return ClickableWidget(
      onTap: onLinkedInTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: WireframeColorManager.colors.primary, 
        ),
        child: SvgIcon(
          assetPath: SvgIconPaths.linkedbasicon,
          size: 18,
          color: WireframeColorManager.colors.primary,
        ),
      ),
    );
  }

  // Helper method for desktop action buttons
  Widget _buildDesktopActionButton(
      IconData icon, String label, Color color, VoidCallback onTap) {
    return ClickableWidget(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: WireframeLayoutConstants.spacingMedium,
          vertical: WireframeLayoutConstants.spacingSmall,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius:
              BorderRadius.circular(WireframeLayoutConstants.radiusSmall),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: WireframeLayoutConstants.wireframeWhite,
            ),
            SizedBox(width: WireframeLayoutConstants.spacingSmall),
            Text(
              label,
              style: TextStyle(
                color: WireframeLayoutConstants.wireframeWhite,
                fontSize: WireframeLayoutConstants.desktopFontSizeBody,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method for desktop LinkedIn button
  Widget _buildDesktopLinkedInButton() {
    return ClickableWidget(
      onTap: onLinkedInTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: WireframeLayoutConstants.spacingMedium,
          vertical: WireframeLayoutConstants.spacingSmall,
        ),
        decoration: BoxDecoration(
          color: Color(0xFF0077B5), // LinkedIn blue
          borderRadius:
              BorderRadius.circular(WireframeLayoutConstants.radiusSmall),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons
                  .business_center, // Using business icon as LinkedIn alternative
              size: 18,
              color: WireframeLayoutConstants.wireframeWhite,
            ),
            SizedBox(width: WireframeLayoutConstants.spacingSmall),
            Text(
              'LinkedIn',
              style: TextStyle(
                color: WireframeLayoutConstants.wireframeWhite,
                fontSize: WireframeLayoutConstants.desktopFontSizeBody,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
