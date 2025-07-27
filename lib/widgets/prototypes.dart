import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MomentsPrototype extends StatelessWidget {
  const MomentsPrototype({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Device image only - no container/border
        GestureDetector(
          onTap: () async {
            final url =
                'https://www.figma.com/proto/znj6MYokQyyVJVeIVTWUEn/Moments-Playground?page-id=0%3A1&node-id=7-11061&p=f&viewport=479%2C498%2C0.02&scaling=scale-down&content-scaling=fixed&starting-point-node-id=7%3A11061';
            try {
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url),
                    mode: LaunchMode.externalApplication);
              }
            } catch (e) {
              print('Could not launch $url');
            }
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              // Remove fixed width/height to let image size naturally
              child: Image.asset(
                'assets/moments/devices/1.png',
                width: 400, // Adjust this size as needed
                fit: BoxFit.contain, // Keep device proportions
                filterQuality: FilterQuality.high,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 400,
                    height: 600,
                    color: Colors.grey.shade100,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.phone_android,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Device Image\nNot Found',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                              fontFamily: 'SFPro',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),

        SizedBox(height: 30),

        // Open Prototype Button
        ElevatedButton(
          onPressed: () async {
            final url =
                'https://www.figma.com/proto/znj6MYokQyyVJVeIVTWUEn/Moments-Playground?page-id=0%3A1&node-id=7-11061&p=f&viewport=479%2C498%2C0.02&scaling=scale-down&content-scaling=fixed&starting-point-node-id=7%3A11061';
            try {
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url),
                    mode: LaunchMode.externalApplication);
              }
            } catch (e) {
              print('Could not launch $url');
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade600,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 4,
          ),
          child: Text(
            'Open Prototype',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'SFPro',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
