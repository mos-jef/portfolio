// File: lib/themes/wireframe/widgets/responsive_device_frame.dart
import 'package:flutter/material.dart';
import '../wireframe_layout_constants.dart';

class ResponsiveDeviceFrame extends StatelessWidget {
  final Widget content;
  final String deviceImagePath;
  final double deviceWidth;
  final double deviceHeight;
  final EdgeInsets contentInsets;
  final double contentRadius;
  final List<BoxShadow>? shadows;
  final Color? fallbackBorderColor;
  final double? maxScale;
  final GlobalKey? contentKey; 

  const ResponsiveDeviceFrame({
    Key? key,
    required this.content,
    required this.deviceImagePath,
    required this.deviceWidth,
    required this.deviceHeight,
    required this.contentInsets,
    this.contentRadius = 20.0,
    this.shadows,
    this.fallbackBorderColor,
    this.maxScale = 1.0,
    this.contentKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate optimal scale while maintaining aspect ratio
        double deviceAspectRatio = deviceWidth / deviceHeight;
        double containerAspectRatio =
            constraints.maxWidth / constraints.maxHeight;

        double scale;
        if (containerAspectRatio > deviceAspectRatio) {
          // Container is wider - scale based on height
          scale = constraints.maxHeight / deviceHeight;
        } else {
          // Container is taller - scale based on width
          scale = constraints.maxWidth / deviceWidth;
        }

        // Apply maximum scale limit and padding factor
        scale = (scale * 0.9).clamp(0.1, maxScale ?? 1.0);

        double scaledWidth = deviceWidth * scale;
        double scaledHeight = deviceHeight * scale;

        return Center(
          child: SizedBox(
            width: scaledWidth,
            height: scaledHeight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35 * scale),
                boxShadow: shadows
                    ?.map((shadow) => BoxShadow(
                          color: shadow.color,
                          blurRadius: shadow.blurRadius * scale,
                          offset: shadow.offset * scale,
                          spreadRadius: shadow.spreadRadius * scale,
                        ))
                    .toList(),
              ),
              child: Stack(
                children: [
                  // Content positioned precisely within device frame
                  Positioned(
                    top: contentInsets.top * scale,
                    left: contentInsets.left * scale,
                    right: contentInsets.right * scale,
                    bottom: contentInsets.bottom * scale,
                    child: Container(
                      key: contentKey,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(contentRadius * scale),
                      ),
                      child: content,
                    ),
                  ),

                  // Device frame overlay (always perfectly aligned)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Image.asset(
                        deviceImagePath,
                        fit: BoxFit.fill, // Fill ensures perfect alignment
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: fallbackBorderColor ??
                                    const Color(0xFFE8D5C4),
                                width: 20 * scale,
                              ),
                              borderRadius: BorderRadius.circular(35 * scale),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Predefined device configurations
class DeviceFrameConfigs {
  static const iphone14 = DeviceFrameConfig(
    imagePath: 'assets/iphone14_black.png',
    frameSize: Size(320.0, 635.0),
    contentInsets:EdgeInsets.only(top: 8.0, left: 10.0, right: 15.0, bottom: 8.0),
    contentRadius: 20.0,
    fallbackBorderColor: Color(0xFFE8D5C4),
  );

  static const chromeBrowser = DeviceFrameConfig(
    imagePath: 'assets/chrome_dark.png',
    frameSize: Size(1440.0, 974.0), // CORRECT SIZE to match your PNG
    contentInsets: EdgeInsets.only(
        top: 10.0,
        left: 10.0,
        right: 10.0,
        bottom: 10.0), // Proportionally scaled
    contentRadius: 10.8,
    fallbackBorderColor: Color(0xFFE8E8E8),
  );
}

class DeviceFrameConfig {
  final String imagePath;
  final Size frameSize;
  final EdgeInsets contentInsets;
  final double contentRadius;
  final Color fallbackBorderColor;

  const DeviceFrameConfig({
    required this.imagePath,
    required this.frameSize,
    required this.contentInsets,
    required this.contentRadius,
    required this.fallbackBorderColor,
  });
}

// Helper widget for common device frames
class IPhoneFrame extends StatelessWidget {
  final Widget content;
  final List<BoxShadow>? shadows;
  final GlobalKey? contentKey;

  const IPhoneFrame({
    Key? key,
    required this.content,
    this.shadows,
    this.contentKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveDeviceFrame(
      content: content,
      deviceImagePath: DeviceFrameConfigs.iphone14.imagePath,
      deviceWidth: DeviceFrameConfigs.iphone14.frameSize.width,
      deviceHeight: DeviceFrameConfigs.iphone14.frameSize.height,
      contentInsets: DeviceFrameConfigs.iphone14.contentInsets,
      contentRadius: DeviceFrameConfigs.iphone14.contentRadius,
      fallbackBorderColor: DeviceFrameConfigs.iphone14.fallbackBorderColor,
      contentKey: contentKey,
      shadows: shadows ??
          [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 40,
              offset: const Offset(0, 16),
              spreadRadius: 4,
            ),
          ],
    );
  }
}

class ChromeFrame extends StatelessWidget {
  final Widget content;
  final List<BoxShadow>? shadows;

  const ChromeFrame({
    Key? key,
    required this.content,
    this.shadows,
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
