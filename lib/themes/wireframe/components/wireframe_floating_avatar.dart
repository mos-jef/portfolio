import 'package:flutter/material.dart';
import 'package:portfolio_website/themes/wireframe/utils/wireframe_color_manager.dart';
import 'package:portfolio_website/themes/wireframe/widgets/clickable_widget.dart';
import 'package:portfolio_website/widgets/border_beam.dart';

class WireframeFloatingAvatar extends StatelessWidget {
  final VoidCallback? onTap;
  final double size;
  final String imagePath;
  final double borderWidth;
  final Color? borderColor;

  const WireframeFloatingAvatar({
    Key? key,
    this.onTap,
    this.size = 60.0,
    this.imagePath = 'assets/me_avatar.png',
    this.borderWidth = 3.0,
    this.borderColor,
  }) : super(key: key);

 @override
  Widget build(BuildContext context) {
    return ClickableWidget(
      onTap: onTap,
      child: BorderBeam(
        duration: 10, // Slower for floating avatar
        borderWidth: borderWidth,
        colorFrom: WireframeColorManager.colors.primary,
        colorTo: WireframeColorManager.colors.secondary ??
            WireframeColorManager.colors.primary,
        staticBorderColor: WireframeColorManager.colors.surface,
        borderRadius: BorderRadius.circular(size / 2),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
