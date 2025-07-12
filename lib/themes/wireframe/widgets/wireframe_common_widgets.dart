import 'package:flutter/material.dart';
import 'package:portfolio_website/themes/wireframe/utils/wireframe_color_manager.dart';
import 'package:portfolio_website/themes/wireframe/widgets/clickable_widget.dart';

import '../utils/master_colors.dart';

class WireframeCommonWidgets {
  WireframeCommonWidgets._();

  /// Unified contact item builder for both mobile and desktop
  static Widget buildContactItem(
    IconData icon,
    String text,
    bool isMobile, {
    VoidCallback? onTap,
  }) {
    final iconSize = isMobile ? 14.0 : 20.0;
    final fontSize = isMobile ? 12.0 : 16.0;
    final spacing = isMobile ? 8.0 : 12.0;
    final verticalPadding = isMobile ? 4.0 : 8.0;

    Widget content = Row(
      children: [
        Icon(
          icon,
          size: iconSize,
          color: MasterColors.wireframeAccent,
        ),
        SizedBox(width: spacing),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              color: WireframeColorManager.colors.text,
            ),
          ),
        ),
      ],
    );

    return Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        child: onTap != null
            ? MouseRegion(
                cursor: SystemMouseCursors.click,
                child: ClickableWidget(
                  onTap: onTap,
                  child: content,
                ),
              )
            : content);
  }

  /// Standard spacing widgets
  static const Widget standardSpacing = SizedBox(height: 20);
  static const Widget smallSpacing = SizedBox(height: 8);
  static const Widget largeSpacing = SizedBox(height: 40);
  static const Widget tinySpacing = SizedBox(height: 4);

  /// Standard wireframe button
  static Widget buildWireframeButton({
    required String text,
    required VoidCallback onPressed,
    bool isPrimary = true,
    bool isMobile = false,
  }) {
    final fontSize = isMobile ? 12.0 : 16.0;
    final padding = EdgeInsets.symmetric(
      horizontal: isMobile ? 12 : 16,
      vertical: isMobile ? 6 : 8,
    );

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary
            ? MasterColors.wireframeAccent
            : MasterColors.wireframeSecondary,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isMobile ? 4 : 8),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: WireframeColorManager.colors.onPrimary,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Standard avatar widget
  static Widget buildAvatar({
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
    bool isMobile = false,
  }) {
    final size = isMobile ? 32.0 : 44.0;
    final iconSize = isMobile ? 16.0 : 20.0;

    return ClickableWidget(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? MasterColors.wireframeOrange : color,
          border: Border.all(
            color: isSelected
                ? MasterColors.wireframeOrange
                : MasterColors.transparent,
            width: 2,
          ),
        ),
        child: Icon(
          icon,
          size: iconSize,
          color: WireframeColorManager.colors.onPrimary,
        ),
      ),
    );
  }

  /// Standard step indicator dots
  static Widget buildStepDots({
    required int currentStep,
    required int totalSteps,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final isActive = index == currentStep;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive
                  ? MasterColors.wireframeOrange
                  : MasterColors.wireframeBorder,
            ),
          ),
        );
      }),
    );
  }
}
