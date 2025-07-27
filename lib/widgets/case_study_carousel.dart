// File: lib/widgets/case_study_carousel.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:portfolio_website/themes/wireframe/utils/wireframe_color_manager.dart';

/// Reusable horizontal image carousel widget for case studies using carousel_slider_plus
/// Fully responsive and displays images in a horizontal scrolling layout
class CaseStudyCarousel extends StatefulWidget {
  final List<CarouselImageData> images;
  final double height;
  final bool showTitles;
  final bool showDescriptions;
  final String? carouselTitle;
  final String? carouselSubtitle;
  final Color? backgroundColor;
  final Function(int)? onImageTapped;
  final bool compactMode;

  const CaseStudyCarousel({
    Key? key,
    required this.images,
    this.height = 400.0,
    this.showTitles = true,
    this.showDescriptions = true,
    this.carouselTitle,
    this.carouselSubtitle,
    this.backgroundColor,
    this.onImageTapped,
    this.compactMode = false,
  }) : super(key: key);

  @override
  State<CaseStudyCarousel> createState() => _CaseStudyCarouselState();
}

class _CaseStudyCarouselState extends State<CaseStudyCarousel> {
  int _currentIndex = 0;
  late CarouselSliderController _carouselController;

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselSliderController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Carousel header
          if (widget.carouselTitle != null || widget.carouselSubtitle != null)
            _buildCarouselHeader(),

          // Main horizontal carousel using carousel_slider_plus
          Container(
            height: widget.height,
            width: double.infinity,
            child: CarouselSlider.builder(
              controller: _carouselController, // Changed from carouselController to controller
              itemCount: widget.images.length,
              options: CarouselOptions(
                height: widget.height,
                viewportFraction: _getViewportFraction(),
                enlargeCenterPage: false,
                enableInfiniteScroll: false,
                autoPlay: false,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                  widget.onImageTapped?.call(index);
                },
              ),
              itemBuilder: (context, index, realIndex) {
                return _buildCarouselCard(widget.images[index], index);
              },
            ),
          ),

          // Controls and info section
          if (widget.images.length > 1)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  // Current scroll position indicator
                  _buildScrollIndicator(),

                  SizedBox(height: 16),

                  // Navigation buttons for easier desktop control
                  _buildDesktopNavigationButtons(),

                  SizedBox(height: 16),

                  // Quick stats
                  _buildQuickStats(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  double _getViewportFraction() {
    // Calculate viewport fraction based on screen size to show multiple images
    final screenWidth = MediaQuery.of(context).size.width;

    if (widget.compactMode) {
      if (screenWidth > 1400) return 0.16; // Show ~6 cards
      if (screenWidth > 1200) return 0.18; // Show ~5-6 cards
      if (screenWidth > 900) return 0.22; // Show ~4-5 cards
      if (screenWidth > 600) return 0.28; // Show ~3-4 cards
      return 0.35; // Show ~2-3 cards on mobile
    } else {
      if (screenWidth > 1400) return 0.28; // Show ~3-4 cards
      if (screenWidth > 1200) return 0.32; // Show ~3 cards
      if (screenWidth > 900) return 0.38; // Show ~2-3 cards
      if (screenWidth > 600) return 0.45; // Show ~2 cards
      return 0.55; // Show ~1-2 cards on mobile
    }
  }

  Widget _buildCarouselHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.carouselTitle != null)
            Text(
              widget.carouselTitle!,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 2, 82, 136),
              ),
            ),
          if (widget.carouselSubtitle != null)
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                widget.carouselSubtitle!,
                style: TextStyle(
                  fontSize: 16,
                  color: const Color.fromARGB(255, 3, 105, 66),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCarouselCard(CarouselImageData imageData, int index) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final borderRadius = widget.compactMode ? 12.0 : 16.0;

        return GestureDetector(
          onTap: () {
            setState(() {
              _currentIndex = index;
            });
            widget.onImageTapped?.call(index);
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.0),
                  blurRadius: widget.compactMode ? 6 : 8,
                  offset: Offset(0, widget.compactMode ? 2 : 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  
                  // Main image - NO GREY BACKGROUND
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.white, // White background instead of grey
                    child: Image.asset(
                      imageData.imagePath,
                      fit: BoxFit.contain, // Shows full image without cropping
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.white, // White background for error state too
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_not_supported,
                                  size: widget.compactMode ? 24 : 32,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Image not found',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: widget.compactMode ? 10 : 12,
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

                  // Gradient overlay for text readability (only if showing text)
                  if ((widget.showTitles && imageData.title != null) ||
                      (widget.showDescriptions &&
                          imageData.description != null))
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(widget.compactMode ? 8 : 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.0),
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.showTitles && imageData.title != null)
                              Text(
                                imageData.title!,
                                style: TextStyle(
                                  color: Colors.white.withAlpha(0),
                                  fontSize: widget.compactMode ? 11 : 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: widget.compactMode ? 1 : 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            if (widget.showDescriptions &&
                                imageData.description != null &&
                                !widget.compactMode)
                              Padding(
                                padding: EdgeInsets.only(top: 4),
                                child: Text(
                                  imageData.description!,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 11,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                  // Category tag
                  if (imageData.category != null)
                    Positioned(
                      top: widget.compactMode ? 8 : 12,
                      left: widget.compactMode ? 8 : 12,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: widget.compactMode ? 6 : 8,
                          vertical: widget.compactMode ? 2 : 4,
                        ),
                        decoration: BoxDecoration(
                          color: imageData.categoryColor ?? Colors.blue,
                          borderRadius: BorderRadius.circular(
                              widget.compactMode ? 8 : 12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.0),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          imageData.category!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: widget.compactMode ? 8 : 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                  // Image counter badge
                  Positioned(
                    top: widget.compactMode ? 8 : 12,
                    right: widget.compactMode ? 8 : 12,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: widget.compactMode ? 6 : 8,
                        vertical: widget.compactMode ? 2 : 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius:
                            BorderRadius.circular(widget.compactMode ? 8 : 12),
                      ),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: widget.compactMode ? 8 : 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  // Current selection indicator
                  if (_currentIndex == index)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: WireframeColorManager.colors.primary.withAlpha(0),
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(borderRadius),
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

  Widget _buildScrollIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pan_tool,
            size: 16,
            color: const Color.fromARGB(255, 214, 135, 15).withAlpha(255),
          ),
          SizedBox(width: 8),
          Text(
            'Drag or use buttons to scroll through all ${widget.images.length} screens',
            style: TextStyle(
              fontSize: 14,
              color: const Color.fromARGB(255, 2, 46, 59).withAlpha(255),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Scroll Left Button
        ElevatedButton.icon(
          onPressed: _currentIndex > 0
              ? () => _carouselController.previousPage()
              : null,
          icon: Icon(Icons.chevron_left, size: 18),
          label: Text('Previous'),
          style: ElevatedButton.styleFrom(
            backgroundColor: _currentIndex > 0
                ? Colors.black54.withAlpha(255)
                : Colors.grey[300],
            foregroundColor:
                _currentIndex > 0 
                ? Colors.white.withAlpha(255)   // Affects color of "previous"
                : Colors.grey[500],
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            textStyle: TextStyle(fontSize: 14),
          ),
        ),

        SizedBox(width: 16),

        // Scroll to Start Button
        OutlinedButton.icon(
          onPressed: _currentIndex > 0
              ? () => _carouselController.animateToPage(0)
              : null,
          icon: Icon(Icons.first_page, size: 18),
          label: Text('First'),
          style: OutlinedButton.styleFrom(
            foregroundColor: _currentIndex > 0
                ? Colors.black54
                : Colors.grey[400],
            side: BorderSide(
              color: _currentIndex > 0
                  ? Colors.black54
                  : Colors.grey[400]!,
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            textStyle: TextStyle(fontSize: 14),
          ),
        ),

        SizedBox(width: 16),

        // Current position indicator
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: WireframeColorManager.colors.secondary.withAlpha(0),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black54),
          ),
          child: Text(
            '${_currentIndex + 1} / ${widget.images.length}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ),

        SizedBox(width: 16),

        // Scroll to End Button
        OutlinedButton(
          onPressed: _currentIndex < widget.images.length - 1
              ? () =>
                  _carouselController.animateToPage(widget.images.length - 1)
              : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Last'),
              SizedBox(width: 4), // Small gap between text and icon
              Icon(Icons.last_page, size: 18),
            ],
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: _currentIndex < widget.images.length - 1
                ? Colors.black54
                : Colors.grey[400],
            side: BorderSide(
              color: _currentIndex < widget.images.length - 1
                  ? Colors.black54
                  : Colors.grey[400]!,
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            textStyle: TextStyle(fontSize: 14),
          ),
        ),

        SizedBox(width: 16),

        // Scroll Right Button
        ElevatedButton(
          onPressed: _currentIndex < widget.images.length - 1
              ? () => _carouselController.nextPage()
              : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Next'),
              SizedBox(width: 4), // Small gap between text and icon
              Icon(Icons.chevron_right, size: 18),
            ],
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: _currentIndex < widget.images.length - 1
                ? Colors.black54.withAlpha(255)
                : Colors.grey[300],
            foregroundColor: _currentIndex < widget.images.length - 1
                ? Colors.white.withAlpha(255)    /// Affects color of "next"
                : Colors.grey[500],
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            textStyle: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    // Group images by category for stats
    Map<String, int> categoryCount = {};
    for (var image in widget.images) {
      if (image.category != null) {
        categoryCount[image.category!] =
            (categoryCount[image.category!] ?? 0) + 1;
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 16,
        runSpacing: 8,
        children: categoryCount.entries.take(6).map((entry) {
          // Find the color for this category
          Color categoryColor = Colors.blue;
          for (var image in widget.images) {
            if (image.category == entry.key && image.categoryColor != null) {
              categoryColor = image.categoryColor!;
              break;
            }
          }

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: categoryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: categoryColor.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: categoryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6),
                Text(
                  '${entry.key} (${entry.value})',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54.withAlpha(255),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Data model for carousel images
class CarouselImageData {
  final String imagePath;
  final String? title;
  final String? description;
  final String? category;
  final Color? categoryColor;

  const CarouselImageData({
    required this.imagePath,
    this.title,
    this.description,
    this.category,
    this.categoryColor,
  });
}

/// Preset configurations for different case studies

class CaseStudyCarouselPresets {

  /// Tap In app carousel preset with all screens

  static CaseStudyCarousel tapInCarousel({bool compactMode = false}) {
    return CaseStudyCarousel(
      carouselTitle: 'Tap In App Screens',
      carouselSubtitle:'Screens demonstrating core functionality',
      height: compactMode ? 550 : 700, // Smaller height for compact mode
      compactMode: compactMode, // Pass the compact mode flag
      images: [
        // Main Dashboard Screens
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/main_screen1.png',
          title: 'Main Dashboard',
          description: 'Primary home screen with activity feed and navigation',
          category: 'Core UI',
          categoryColor: Color(0xFF2FBF71),
        ),
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/main_screen2.png',
          title: 'Main Dashboard - Variant 2',
          description: 'Alternative view of the main interface',
          category: 'Core UI',
          categoryColor: Color(0xFF2FBF71),
        ),
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/main_screen3.png',
          title: 'Main Dashboard - Variant 3',
          description: 'Extended main screen functionality',
          category: 'Core UI',
          categoryColor: Color(0xFF2FBF71),
        ),

        // User Profile & Settings
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/profile1.png',
          title: 'User Profile',
          description: 'Personal profile with BJJ stats and achievements',
          category: 'Profile',
          categoryColor: Color(0xFF3498DB),
        ),
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/profile2.png',
          title: 'Profile Details',
          description: 'Detailed profile view with training history',
          category: 'Profile',
          categoryColor: Color(0xFF3498DB),
        ),
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/settings1.png',
          title: 'Settings',
          description: 'App preferences and account settings',
          category: 'Settings',
          categoryColor: Color(0xFF95A5A6),
        ),
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/belt_selection.png',
          title: 'Belt Selection',
          description: 'Choose your current BJJ belt level',
          category: 'Profile',
          categoryColor: Color(0xFF3498DB),
        ),

        // Navigation & Menu
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/drawer1.png',
          title: 'Navigation Drawer',
          description: 'Main navigation menu with app sections',
          category: 'Navigation',
          categoryColor: Color(0xFF8E44AD),
        ),
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/drawer2.png',
          title: 'Extended Drawer',
          description: 'Additional navigation options',
          category: 'Navigation',
          categoryColor: Color(0xFF8E44AD),
        ),
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/menu1.png',
          title: 'Context Menu',
          description: 'Action menu for specific features',
          category: 'Navigation',
          categoryColor: Color(0xFF8E44AD),
        ),

        // Gym & Team Features
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/gym_home2.png',
          title: 'Gym Home',
          description: 'Gym-specific dashboard and information',
          category: 'Gym Features',
          categoryColor: Color(0xFFE67E22),
        ),
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/team_page1.png',
          title: 'Team Page',
          description: 'Team overview with member information',
          category: 'Gym Features',
          categoryColor: Color(0xFFE67E22),
        ),
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/team_dropdown.png',
          title: 'Team Selection',
          description: 'Choose between different teams',
          category: 'Gym Features',
          categoryColor: Color(0xFFE67E22),
        ),
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/members_view.png',
          title: 'Members View',
          description: 'Browse gym members and training partners',
          category: 'Gym Features',
          categoryColor: Color(0xFFE67E22),
        ),

        // Communication Features
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/team_channel1.png',
          title: 'Team Channel',
          description: 'Team communication hub',
          category: 'Communication',
          categoryColor: Color(0xFF1ABC9C),
        ),
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/team_channel2.png',
          title: 'Channel Messages',
          description: 'Team messaging and discussions',
          category: 'Communication',
          categoryColor: Color(0xFF1ABC9C),
        ),
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/channel1.png',
          title: 'General Channel',
          description: 'Main communication channel',
          category: 'Communication',
          categoryColor: Color(0xFF1ABC9C),
        ),
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/private_dm1.png',
          title: 'Private Messages',
          description: 'Direct messaging with other users',
          category: 'Communication',
          categoryColor: Color(0xFF1ABC9C),
        ),
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/thread1.png',
          title: 'Message Thread',
          description: 'Threaded conversation view',
          category: 'Communication',
          categoryColor: Color(0xFF1ABC9C),
        ),
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/reply.png',
          title: 'Reply Interface',
          description: 'Compose and send message replies',
          category: 'Communication',
          categoryColor: Color(0xFF1ABC9C),
        ),

        // Event & Schedule Management
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/event_planner.png',
          title: 'Event Planner',
          description: 'Plan and organize BJJ events',
          category: 'Events',
          categoryColor: Color(0xFFE74C3C),
        ),
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/create_event2.png',
          title: 'Create Event',
          description: 'Set up new training events',
          category: 'Events',
          categoryColor: Color(0xFFE74C3C),
        ),
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/create_event3.png',
          title: 'Event Details',
          description: 'Configure event specifics',
          category: 'Events',
          categoryColor: Color(0xFFE74C3C),
        ),
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/event_details1.png',
          title: 'Event Information',
          description: 'View complete event details',
          category: 'Events',
          categoryColor: Color(0xFFE74C3C),
        ),
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/date_picker.png',
          title: 'Date Picker',
          description: 'Select dates for events and scheduling',
          category: 'Events',
          categoryColor: Color(0xFFE74C3C),
        ),
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/upcoming1.png',
          title: 'Upcoming Events',
          description: 'View scheduled upcoming activities',
          category: 'Events',
          categoryColor: Color(0xFFE74C3C),
        ),

        // Schedule Views
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/schedule1.png',
          title: 'Training Schedule',
          description: 'Weekly training schedule overview',
          category: 'Schedule',
          categoryColor: Color(0xFFF39C12),
        ),
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/schedule2.png',
          title: 'Schedule Details',
          description: 'Detailed scheduling information',
          category: 'Schedule',
          categoryColor: Color(0xFFF39C12),
        ),
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/schedule3.png',
          title: 'Schedule Variant 3',
          description: 'Alternative schedule view',
          category: 'Schedule',
          categoryColor: Color(0xFFF39C12),
        ),
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/schedule4.png',
          title: 'Extended Schedule',
          description: 'Comprehensive schedule layout',
          category: 'Schedule',
          categoryColor: Color(0xFFF39C12),
        ),

        // Mat & Training Features
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/mat_create1.png',
          title: 'Create Mat Session',
          description: 'Set up new training mat session',
          category: 'Training',
          categoryColor: Color(0xFF9B59B6),
        ),
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/mat_create2.png',
          title: 'Mat Configuration',
          description: 'Configure mat session details',
          category: 'Training',
          categoryColor: Color(0xFF9B59B6),
        ),
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/timer.png',
          title: 'Training Timer',
          description: 'Track training session duration',
          category: 'Training',
          categoryColor: Color(0xFF9B59B6),
        ),
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/stats1.png',
          title: 'Training Stats',
          description: 'View personal training statistics',
          category: 'Training',
          categoryColor: Color(0xFF9B59B6),
        ),

        // Media & Content
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/add_images.png',
          title: 'Add Images',
          description: 'Upload and share training photos',
          category: 'Media',
          categoryColor: Color(0xFF34495E),
        ),
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/add_socials.png',
          title: 'Social Sharing',
          description: 'Share content to social platforms',
          category: 'Media',
          categoryColor: Color(0xFF34495E),
        ),
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/add_youtube.png',
          title: 'YouTube Integration',
          description: 'Add YouTube videos to content',
          category: 'Media',
          categoryColor: Color(0xFF34495E),
        ),
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/image_view1.png',
          title: 'Image Viewer',
          description: 'Full-screen image viewing',
          category: 'Media',
          categoryColor: Color(0xFF34495E),
        ),
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/library_view.png',
          title: 'Media Library',
          description: 'Browse and manage media content',
          category: 'Media',
          categoryColor: Color(0xFF34495E),
        ),
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/select_photo.png',
          title: 'Photo Selection',
          description: 'Choose photos from gallery',
          category: 'Media',
          categoryColor: Color(0xFF34495E),
        ),

        // Notifications & Alerts
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/notifications1.png',
          title: 'Notifications',
          description: 'View app notifications and updates',
          category: 'Notifications',
          categoryColor: Color(0xFFE67E22),
        ),
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/alert1.png',
          title: 'System Alert',
          description: 'Important system notifications',
          category: 'Notifications',
          categoryColor: Color(0xFFE67E22),
        ),
        CarouselImageData(
          imagePath: 'assets/carousels/tapin/alert2.png',
          title: 'Alert Dialog',
          description: 'User action confirmation dialogs',
          category: 'Notifications',
          categoryColor: Color(0xFFE67E22),
        ),
      ],
    );
  }

  // Add this method to your CaseStudyCarouselPresets class in case_study_carousel.dart

  /// Moments dev handoff carousel preset
  static CaseStudyCarousel momentsDevHandoffCarousel(
      {bool compactMode = false}) {
    return CaseStudyCarousel(
      carouselTitle: 'Dev Handoff Documentation',
      carouselSubtitle: 'Detailed handoff materials for development team',
      height: compactMode ? 400 : 500,
      compactMode: compactMode,
      images: [
        CarouselImageData(
          imagePath: 'assets/moments/dev_handoff/1.png',
          title: 'Handoff Document 1',
          description: 'Initial handoff specifications',
          category: 'Documentation',
          categoryColor: Color(0xFF2FBF71),
        ),
        CarouselImageData(
          imagePath: 'assets/moments/dev_handoff/2.png',
          title: 'Handoff Document 2',
          description: 'Component specifications',
          category: 'Documentation',
          categoryColor: Color(0xFF2FBF71),
        ),
        CarouselImageData(
          imagePath: 'assets/moments/dev_handoff/3.png',
          title: 'Handoff Document 3',
          description: 'Design system guidelines',
          category: 'Documentation',
          categoryColor: Color(0xFF2FBF71),
        ),
        CarouselImageData(
          imagePath: 'assets/moments/dev_handoff/4.png',
          title: 'Handoff Document 4',
          description: 'Interaction specifications',
          category: 'Documentation',
          categoryColor: Color(0xFF2FBF71),
        ),
        CarouselImageData(
          imagePath: 'assets/moments/dev_handoff/5.png',
          title: 'Handoff Document 5',
          description: 'Style guide details',
          category: 'Documentation',
          categoryColor: Color(0xFF2FBF71),
        ),
        CarouselImageData(
          imagePath: 'assets/moments/dev_handoff/6.png',
          title: 'Handoff Document 6',
          description: 'Layout specifications',
          category: 'Documentation',
          categoryColor: Color(0xFF2FBF71),
        ),
        CarouselImageData(
          imagePath: 'assets/moments/dev_handoff/7.png',
          title: 'Handoff Document 7',
          description: 'Component library',
          category: 'Documentation',
          categoryColor: Color(0xFF2FBF71),
        ),
        CarouselImageData(
          imagePath: 'assets/moments/dev_handoff/8.png',
          title: 'Handoff Document 8',
          description: 'Animation guidelines',
          category: 'Documentation',
          categoryColor: Color(0xFF2FBF71),
        ),
        CarouselImageData(
          imagePath: 'assets/moments/dev_handoff/9.png',
          title: 'Handoff Document 9',
          description: 'Responsive breakpoints',
          category: 'Documentation',
          categoryColor: Color(0xFF2FBF71),
        ),
        CarouselImageData(
          imagePath: 'assets/moments/dev_handoff/10.png',
          title: 'Handoff Document 10',
          description: 'Asset specifications',
          category: 'Documentation',
          categoryColor: Color(0xFF2FBF71),
        ),
        CarouselImageData(
          imagePath: 'assets/moments/dev_handoff/11.png',
          title: 'Handoff Document 11',
          description: 'User flow documentation',
          category: 'Documentation',
          categoryColor: Color(0xFF2FBF71),
        ),
        CarouselImageData(
          imagePath: 'assets/moments/dev_handoff/12.png',
          title: 'Handoff Document 12',
          description: 'Final implementation notes',
          category: 'Documentation',
          categoryColor: Color(0xFF2FBF71),
        ),
        CarouselImageData(
          imagePath: 'assets/moments/dev_handoff/13.png',
          title: 'Handoff Document 13',
          description: 'Quality assurance checklist',
          category: 'Documentation',
          categoryColor: Color(0xFF2FBF71),
        ),
      ],
    );
  }

  /// Generic carousel for other projects
  static CaseStudyCarousel projectCarousel({
    required String projectName,
    required List<CarouselImageData> images,
    required Color primaryColor,
  }) {
    return CaseStudyCarousel(
      carouselTitle: '$projectName Showcase',
      carouselSubtitle: 'Interface designs and key features',
      height: 450,
      images: images,
    );
  }
}
