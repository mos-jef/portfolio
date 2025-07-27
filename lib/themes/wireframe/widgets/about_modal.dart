import 'package:flutter/material.dart';
import 'package:portfolio_website/themes/wireframe/utils/wireframe_color_manager.dart';
import 'package:portfolio_website/themes/wireframe/widgets/clickable_widget.dart';
import 'package:portfolio_website/widgets/border_beam.dart';
import '../wireframe_layout_constants.dart';

class WireframeAboutModal extends StatelessWidget {
  final VoidCallback onClose;

  const WireframeAboutModal({
    Key? key,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: onClose,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.7),
            child: Center(
              child: GestureDetector(
                onTap: () {}, // Prevent tapping modal content from closing
                child: Container(
                  width: 600,
                  height: 500,
                  decoration: BoxDecoration(
                    color: Color(0xFF413F3B),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Header with close button
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Hi I\m Jeff!',
                              style: TextStyle(
                                fontFamily: 'KOMIKAX_',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF5E9D8),
                              ),
                            ),
                            ClickableWidget(
                              onTap: onClose,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  Icons.close,
                                  size: 18,
                                  color: Color(0xFFF5E9D8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Content
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Left side - Image with BorderBeam
                              Column(
                                children: [
                                  SizedBox(height: 20),
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Color(0xFFF5E9D8),
                                        width: 3,
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/about/beard.png',
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            color: Color(0xFFF5E9D8)
                                                .withOpacity(0.3),
                                            child: Icon(
                                              Icons.person,
                                              size: 60,
                                              color: Color(0xFFF5E9D8),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(width: 30),

                              // Right side - Text content
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 20),
                                      Text(
                                        'Hi! You probably figured out I am a UX/UI Designer.  I also do a bit of backend/development, although it is not my focus',
                                        style: TextStyle(
                                          fontFamily: 'KOMIKAX_',
                                          fontSize: 12,
                                          color: Color(0xFFF5E9D8),
                                          height: 1.4,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        'In my free time I love doing BJJ (I am a brown belt), spending time with my wife of 19 years and 2 boys. I love getting out in to nature as much as possible...',
                                        style: TextStyle(
                                          fontFamily: 'KOMIKAX_',
                                          fontSize: 24,
                                          color: Color(0xFFF5E9D8),
                                          height: 1.4,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        '',
                                        style: TextStyle(
                                          fontFamily: 'KOMIKAX_',
                                          fontSize: 16,
                                          color: Color(0xFFF5E9D8),
                                          height: 1.4,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
