// File: lib/themes/wireframe/widgets/custom_settings_item.dart
import 'package:flutter/material.dart';
import 'package:portfolio_website/themes/wireframe/utils/wireframe_color_manager.dart';
import 'package:portfolio_website/themes/wireframe/widgets/svg_icon.dart';

class CustomSettingsItem extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final String? subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final Widget? trailing;
  final String? svgIconPath;
  final Color? svgIconColor;
  final double svgIconSize;
  final bool showIcon;

  const CustomSettingsItem({
    Key? key,
    this.onTap,
    required this.title,
    this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
    this.trailing,
    this.svgIconPath,
    this.svgIconColor,
    this.svgIconSize = 20.0,
    this.showIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // SVG Icon (if provided and showIcon is true)
              if (showIcon && svgIconPath != null) ...[
                SvgIcon(
                  assetPath: svgIconPath!,
                  size: svgIconSize,
                  color: svgIconColor ?? WireframeColorManager.colors.text,
                ),
                SizedBox(width: 12),
              ],

              // Title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: titleStyle ??
                          TextStyle(
                            color: WireframeColorManager.colors.text,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: subtitleStyle ??
                            TextStyle(
                              color: WireframeColorManager.colors.textSecondary,
                              fontSize: 14,
                            ),
                      ),
                    ],
                  ],
                ),
              ),

              // Trailing widget
              if (trailing != null) ...[
                SizedBox(width: 8),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Custom settings group to match babstrap style
class CustomSettingsGroup extends StatelessWidget {
  final String settingsGroupTitle;
  final TextStyle? settingsGroupTitleStyle;
  final Color? backgroundColor;
  final List<Widget> items;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  const CustomSettingsGroup({
    Key? key,
    required this.settingsGroupTitle,
    this.settingsGroupTitleStyle,
    this.backgroundColor,
    required this.items,
    this.margin,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Group title
          Padding(
            padding: EdgeInsets.only(left: 16, bottom: 8),
            child: Text(
              settingsGroupTitle,
              style: settingsGroupTitleStyle ??
                  TextStyle(
                    color: WireframeColorManager.colors.text,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),

          // Items container
          Container(
            decoration: BoxDecoration(
              color: backgroundColor ?? WireframeColorManager.colors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: WireframeColorManager.colors.border,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                for (int i = 0; i < items.length; i++) ...[
                  items[i],
                  if (i < items.length - 1)
                    Divider(
                      height: 1,
                      color: WireframeColorManager.colors.border,
                      indent: 16,
                      endIndent: 16,
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
