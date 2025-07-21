// File: lib/themes/wireframe/widgets/svg_icon.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portfolio_website/themes/wireframe/widgets/clickable_widget.dart';

/// SVG Icon widget for wireframe theme
class SvgIcon extends StatelessWidget {
  final String assetPath;
  final double size;
  final Color? color;
  final VoidCallback? onTap;

  const SvgIcon({
    Key? key,
    required this.assetPath,
    this.size = 24.0,
    this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget svgWidget = SvgPicture.asset(
      assetPath,
      width: size,
      height: size,
      colorFilter:
          color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      semanticsLabel: 'Icon',
    );

    if (onTap != null) {
      return ClickableWidget(
        onTap: onTap,
        child: svgWidget,
      );
    }

    return svgWidget;
  }
}

/// Predefined SVG icon paths
class SvgIconPaths {
  // LinkedIn
  static const String linkedinLine = 'assets/icons/svg/linkedin_line.svg';
  static const String linkedinFill = 'assets/icons/svg/linkedin_fill.svg';
  static const String linkedbasicon = 'assets/icons/svg/linkedbasicon.svg';

  // Resume/Document
  static const String documentLine = 'assets/icons/svg/document_line.svg';
  static const String documentsFile = 'assets/icons/svg/documents_fill.svg';
  static const String resumebasicon = 'assets/icons/svg/resumebasicon.svg';

  // Analytics
  static const String chartBar2Line = 'assets/icons/svg/chart_bar_2_line.svg';
  static const String chartBarLine = 'assets/icons/svg/chart_bar_line.svg';

  // Add/Comment
  static const String addCircleLine = 'assets/icons/svg/add_circle_line.svg';
  static const String comment2Line = 'assets/icons/svg/comment_2_line.svg';
  static const String editbasicon = 'assets/icons/svg/editbasicon.svg';
  static const String basiconedit = 'assets/icons/svg/basiconedit.svg';
  static const String pencil = 'assets/icons/svg/pencil.svg';
  static const String pencil3 = 'assets/icons/svg/pencil3.svg';

  // Contact
  static const String contacts3Line = 'assets/icons/svg/contacts_3_line.svg';
  static const String contactbasicon = 'assets/icons/svg/contactbasicon.svg';

  // Menu
  static const String menuFill = 'assets/icons/svg/menu_fill.svg';
  static const String menuLine = 'assets/icons/svg/menu_line.svg';

  // Arrows
  static const String arrowLeftCircleLine ='assets/icons/svg/arrow_left_circle_line.svg';
  static const String arrowLeftCircleFill ='assets/icons/svg/arrow_left_circle_fill.svg';
  static const String leftFill = 'assets/icons/svg/left_fill.svg';
  static const String leftSmallLine = 'assets/icons/svg/left_small_line.svg';
  static const String arrowup = 'assets/icons/svg/arrowup.svg';
  static const String updown = 'assets/icons/svg/updown.svg';

  // Settings
  static const String settings3Line = 'assets/icons/svg/settings_3_line.svg';

  // Theme icons
  static const String fullMoonLine ='assets/icons/svg/full_moon_line.svg'; // Studio Ghibli
  static const String nintendoSwitchLine ='assets/icons/svg/nintendo_switch_line.svg'; // NES

  // Home
  static const String home3Line = 'assets/icons/svg/home_3_line.svg';

  // Other useful icons
  static const String userLine = 'assets/icons/svg/user_4_line.svg';
  static const String presentationLine ='assets/icons/svg/presentation_1_line.svg';
  static const String paletteLine = 'assets/icons/svg/palette_line.svg';
  static const String componentLine = 'assets/icons/svg/components_line.svg';
  static const String displayLine = 'assets/icons/svg/display_line.svg';
  static const String addCircleFill = 'assets/icons/svg/add_circle_fill.svg';
  static const String reactsmile = 'assets/icons/svg/reactsmile.svg';
  static const String unlikedshaka = 'assets/icons/svg/unlikedshaka.svg';
  static const String shakayellow = 'assets/icons/svg/shakayellow.svg';
  static const String emailbasicon = 'assets/icons/svg/emailbasicon.svg';
  static const String phonebasicon = 'assets/icons/svg/phonebasicon.svg';
  static const String computerbasicon = 'assets/icons/svg/computerbasicon.svg';
  static const String settingsbasicon = 'assets/icons/svg/settingsbasicon.svg';
  static const String personbasicon = 'assets/icons/svg/personbasicon.svg';
  static const String chartbasicon = 'assets/icons/svg/chartbasicon.svg';
  static const String housebasicon = 'assets/icons/svg/housebasicon.svg';
  static const String addbasicon = 'assets/icons/svg/addbasicon.svg';
  static const String commentbasicon = 'assets/icons/svg/commentbasicon.svg';
  static const String flash = 'assets/icons/svg/flash.svg';
  static const String dashboard = 'assets/icons/svg/dashboard.svg';
  static const String vibrate = 'assets/icons/svg/vibrate.svg';
  static const String sound = 'assets/icons/svg/sound.svg';
  static const String crescent_moon = 'assets/icons/svg/crescent_moon.svg';
  static const String heart = 'assets/icons/svg/heart.svg';
  static const String magnet = 'assets/icons/svg/magnet.svg';

  // New theme and settings icons
  static const String shadowLine = 'assets/icons/svg/shadow_line.svg';
  static const String fontSizeLine = 'assets/icons/svg/font_size_line.svg';
  static const String palette2Line = 'assets/icons/svg/palette_2_line.svg';
  static const String info = 'assets/icons/svg/info.svg';
}
