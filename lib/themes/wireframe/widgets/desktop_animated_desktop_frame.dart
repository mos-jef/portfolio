// File: lib/themes/wireframe/widgets/desktop_frame.dart
import 'package:flutter/material.dart';
import 'responsive_device_frame.dart';

class DesktopFrame extends StatelessWidget {
  final Widget content;
  final List<BoxShadow>? shadows;
  final GlobalKey? contentKey;

  const DesktopFrame({
    Key? key,
    required this.content,
    this.shadows,
    this.contentKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveDeviceFrame(
      content: content,
      deviceImagePath: DeviceFrameConfigs.chromeBrowser.imagePath,
      deviceWidth: DeviceFrameConfigs.chromeBrowser.frameSize.width,
      deviceHeight: DeviceFrameConfigs.chromeBrowser.frameSize.height,
      contentInsets: DeviceFrameConfigs.chromeBrowser.contentInsets,
      contentRadius: DeviceFrameConfigs.chromeBrowser.contentRadius,
      fallbackBorderColor: DeviceFrameConfigs.chromeBrowser.fallbackBorderColor,
      contentKey: contentKey, // ✅ Pass through the target key
      shadows: shadows ??
          [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 25,
              offset: const Offset(0, 10),
              spreadRadius: 3,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 50,
              offset: const Offset(0, 20),
              spreadRadius: 5,
            ),
          ],
    );
  }
}
