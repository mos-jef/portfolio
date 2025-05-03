import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:portfolio_website/components/project_viewer.dart';
import 'package:portfolio_website/components/projects_registry.dart';
import 'package:portfolio_website/widgets/circle_text_widget.dart';
import 'package:portfolio_website/widgets/circle_theme_toggle.dart';
import 'package:portfolio_website/widgets/light_mode_toggle.dart';
import 'package:portfolio_website/widgets/pixel_widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/theme_provider.dart';

// For conditional imports based on platform

// Using newer js_interop instead of deprecated js_util
// ignore: avoid_web_libraries_in_flutter

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String? selectedCategory;
  String? hoveredCategory;
  String? hoveredThemeButton;
  String? pressedThemeButton;
  late AnimationController _menuAnimationController;
  late Animation<double> _menuSlideAnimation;
  bool _isMenuVisible = false;
  bool hoveredNes = false;

  // Menu configuration - all in absolute pixel values
  final double _menuWidth = 1180; // Width in pixels
  final double _menuHeight = 800; // Height in pixels
  final double _menuRestPosition = -380; // How far the menu comes in from the right (0 = full, negative = further in)
  final Duration _menuAnimationDuration = const Duration(milliseconds: 300);
  final Curve _menuAnimationCurve =
      Curves.easeOutQuart; // More dramatic ease-in

  // Menu text configuration
  final double _menuTextSize = 23.0;
  final double _menuTextSpacing = 25.0;
  final double _menuTextTopOffset = 170.0; // Vertical position of first menu item
  final double _menuTextLeftOffset = 500.0; // Horizontal position of menu items
  final Color _menuTextColor = const Color(0xFF567185);
  final Color _menuTextHoverColor = const Color(0xFFCC510F);
  final double _menuTextStrokeWidth = 0.3;
  final Color _menuTextStrokeColor = const Color(0xFF193857);

  // TV text configuration
  final double _tvContentWidth = 1280.0; // Default width of content area
  final double _tvContentHeight = 1120.0; // Default height of content area
  final double _textIndent = 24.0; // Adjust this value to control indentation
  final double _tvContentPadding = 1.0;
  final double _tvTextTitleSize = 28.0;
  final double _tvTextSubtitleSize = 22.0;
  final double _tvTextBodySize = 16.0;
  final double _tvTextSpacing = 20.0;
  final Map<String, double> _sectionHeights = {
    'About': 50.0,          // Affects top margin/padding/height of about section
    'Contact': 300.0,
    // Add other sections as needed
  };
  final Color _tvTextColor = const Color(0xFFFF9A62);
  final Color _tvTextLinkColor = const Color(0xFF34B9F2);
  final double _tvTextStrokeWidth = 2.0;
  final Color _tvTextStrokeColor = const Color.fromARGB(255, 29, 29, 28);

  // Book text configuration
  final double _bookTextSize = 28.0;
  final double _bookTextSpacing = 14.1; // Spacing between book labels
  final double _bookTextTopOffset = 74.0; // Vertical position adjustment
  final double _bookTextLeftOffset = 318.0; // Horizontal position of first book
  final Color _bookTextColor = const Color(0xFFF1E6C5);
  final Color _bookTextHoverColor = const Color(0xFFFF9500);   
  final double _bookTextStrokeWidth = 3.5;
  final Color _bookTextStrokeColor = const Color(0xFF193857);

  @override
  void initState() {
    super.initState();
    _menuAnimationController = AnimationController(
      vsync: this,
      duration: _menuAnimationDuration,
    );

    // We'll animate the right position from offscreen to the rest position
    _menuSlideAnimation = Tween<double>(
      begin: -_menuWidth, // Start completely off-screen to the right
      end: _menuRestPosition, // End at the specified rest position
    ).animate(CurvedAnimation(
      parent: _menuAnimationController,
      curve: _menuAnimationCurve,
    ));

    // Listen to animation for rebuilds
    _menuAnimationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _menuAnimationController.dispose();
    super.dispose();
  }

  // ignore: unused_element
  void _toggleMenu() {
    setState(() {
      _isMenuVisible = !_isMenuVisible;
      if (_isMenuVisible) {
        _menuAnimationController.forward();
      } else {
        _menuAnimationController.reverse();
      }
    });
  }

  // Regular hide menu method (with animation)
  void _hideMenu() {
    if (_isMenuVisible) {
      setState(() {
        _isMenuVisible = false;
      });
      // Use normal animation for background taps
      _menuAnimationController.reverse();
    }
  }

  // Force-close menu method (bypasses animation)

  void _forceCloseMenu() {
    setState(() {
      _isMenuVisible = false;
    });
    // Immediately hide menu
    _menuAnimationController.reset();
  }

  void _handleCategorySelection(String category) {
    setState(() {
      selectedCategory = category;
    });

    // Only hide menu for categories that don't open external URLs
    bool isExternalLink = category == 'Resume';

    if (!isExternalLink) {
      _hideMenu();
    }

    // Handle special actions for specific categories
    if (category == 'Resume') {
      _launchURL(
          'https://storage.googleapis.com/uxfolio/643d6d8beaacf70002256d70/Jeff_Resume_PhJ.webp');
    }
    // No special handling for 'Projects' - it will just update selectedCategory
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      // Don't hide menu when opening external URL
    } else {
      // Handle error
      debugPrint('Could not launch $url');
    }
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      debugPrint('Could not launch email');
    }
  }

  // Helper method to build project buttons

  Widget _buildProjectButton(
      BuildContext context, String title, String projectId, bool isNesTheme) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop(); // Close the selection modal

        if (projectId == 'this-website') {
          // Show a simple alert for the website project
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("This Website",
                    style:
                        TextStyle(fontFamily: isNesTheme ? 'NES' : 'Ghibli')),
                content: Text(
                  "I designed and coded the entirety of this portfolio site!",
                  style: TextStyle(fontFamily: isNesTheme ? 'NES' : 'Ghibli'),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("Close",
                        style: TextStyle(
                            fontFamily: isNesTheme ? 'NES' : 'Ghibli')),
                  ),
                ],
              );
            },
          );
        } else {

          // Show the project TV modal for other projects

          _showProjectsModal(context, projectId: projectId);
        }
      },
      child: Container(
        width: 200,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF195F8B).withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF195F8B), width: 1),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontFamily: isNesTheme ? 'NES' : 'Ghibli',
              color: Colors.white,
              fontSize: isNesTheme ? 14 : 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  

  // Implementation of the TV modal for projects
  void _showProjectsModal(BuildContext context, {String projectId = 'tap-in'}) {
    // Get screen dimensions for proper sizing
    final screenSize = MediaQuery.of(context).size;

    // Calculate modal size based on the TV image dimensions
    final modalWidth = math.min(screenSize.width * 1.132, 3900.0);
    final modalHeight = math.min(screenSize.height * 1.2, 1020.0);

    // Calculate the scaling ratio to maintain aspect ratio
    final scaleFactor = modalWidth / 2500.0;

    // Calculate content area dimensions with scaling
    final contentWidth = 1350.0 * scaleFactor;
    final contentHeight = 910.0 * scaleFactor;

    // Position content within TV frame
    final contentTop = modalHeight * 0.100;
    final contentLeft = modalWidth * 0.154;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // TV Image Background
              Image.asset(
                'assets/switch_modal.png',
                width: modalWidth,
                height: modalHeight,
                fit: BoxFit.cover,
              ),

              // Portfolio Content Area
              Positioned(
                top: contentTop,
                left: contentLeft,
                width: contentWidth,
                height: contentHeight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: PortfolioViewer(projectId: projectId),
                ),
              ),

              // Close button for switch modal 
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.close, color: const Color(0xFF51FF00), size: 40),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get theme provider
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final isNesTheme = themeProvider.isNesTheme;

    // Design dimensions (based on your background image dimensions)
    const designWidth = 1366.0; // Common desktop width
    const designHeight = 768.0; // Common desktop height
    const aspectRatio = designWidth / designHeight;

    // Get current screen dimensions
    final screenSize = MediaQuery.of(context).size;

    // Calculate the scaling factor - used by FittedBox
    if (screenSize.width / screenSize.height > aspectRatio) {
      // Screen is wider than our design - constrain by height
      // scaleFactor would be screenSize.height / designHeight
    } else {
      // Screen is taller than our design - constrain by width
      // scaleFactor would be screenSize.width / designWidth
    }

    // Use fixed positions based on the design size
    const tvLeft = 0.252 * designWidth;
    const tvTop = 0.135 * designHeight;
    const tvWidth = 0.461 * designWidth; // affects size of tv area
    const tvHeight = 0.422 * designHeight; // affects size of tv area
    const booksTop = 0.60 * designHeight;
    const menuTop = tvTop - 10;

    // NES theme specific dimensions
    const orangeRectLeft = 0.43 * designWidth;
    const orangeRectTop = 0.05 * designHeight;
    const orangeRectWidth = 0.51 * designWidth;
    const orangeRectHeight = 0.70 * designHeight;

    const whiteRectLeft = 0.21 * designWidth;
    const whiteRectTop = 0.44 * designHeight;
    const whiteRectWidth = 0.18 * designWidth;
    const whiteRectHeight = 0.35 * designHeight;

    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: SizedBox(
            width: designWidth,
            height: designHeight,
            child: FittedBox(
              fit: BoxFit.contain,
              alignment: Alignment.center,
              child: SizedBox(
                width: designWidth,
                height: designHeight,
                child: Stack(
                  children: [
                    // Full-screen background image (based on theme)
                    SizedBox(
                      width: designWidth,
                      height: designHeight,
                      child: Image.asset(
                        isNesTheme
                            ? isDarkMode
                                ? 'assets/nes_land_night.png'
                                : 'assets/nes_land_day.png'
                            : isDarkMode
                                ? 'assets/background_dark2.png'
                                : 'assets/background_light2.png',
                        fit: BoxFit.fill,
                      ),
                    ),

                    // Invisible overlay that closes the menu when tapped
                    if (_isMenuVisible && !isNesTheme)
                      Positioned.fill(
                        child: GestureDetector(
                          onTap: _hideMenu,
                          child: Container(color: Colors.transparent),
                        ),
                      ),

                    // Different layouts based on theme
                    if (!isNesTheme) ...[
                      // Standard Theme UI Components

                      // TV Screen (Content Display Area)

                      Positioned(
                        left: tvLeft,
                        top: tvTop,
                        width: tvWidth,
                        height: tvHeight,
                        child: Center(
                          child: Container(
                            width: _tvContentWidth,
                            height: _tvContentHeight,
                            padding: EdgeInsets.symmetric(
                              horizontal: _tvContentPadding,
                              vertical: _tvContentPadding,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.white.withAlpha(51),
                                  width: 1), // thin border
                            ),
                            child: _buildTVContent(),
                          ),
                        ),
                      ),

                      // Transparent circular overlay for dark/light mode toggle
                      Positioned(
                        top: 10, // 20 pixels from the top
                        right: 646, // 20 pixels from the right
                        child: CircleThemeToggle(
                          size: 73.0,
                          borderColor: isDarkMode
                              ? Colors.white.withAlpha(0)
                              : const Color.fromARGB(255, 58, 44, 2).withAlpha(0),
                          borderWidth: 1.5,
                        ),
                      ),

                      // Book text labels on shelf
                      Positioned(
                        left: _bookTextLeftOffset,
                        top: booksTop + _bookTextTopOffset,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildBookTextItem('About', 0),
                            SizedBox(width: _bookTextSpacing),
                            _buildBookTextItem('Projects', 1),
                            SizedBox(width: _bookTextSpacing),
                            _buildBookTextItem('Resume', 2),
                            SizedBox(width: _bookTextSpacing),
                            _buildBookTextItem('Contact', 3),
                            SizedBox(width: _bookTextSpacing),
                            _buildBookTextItem('Menu', 4),
                          ],
                        ),
                      ),

                        // NES system clickable area with very visible settings for testing
                      Positioned(
                      // Adjust these values based on where the NES system appears in your background
                      left: 650, // Estimate - you'll need to adjust
                      top: 570,  // Estimate - you'll need to adjust
                      child: MouseRegion(
                        onEnter: (_) => setState(() => hoveredNes = true),
                        onExit: (_) => setState(() => hoveredNes = false),
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory = 'Menu';
                            });
                          },
                          child: Container(
                            width: 300,
                            height: 100,
                            decoration: BoxDecoration(
                              color: hoveredNes ? Colors.white.withAlpha(20) : Colors.transparent,
                              border: Border.all(
                                color: hoveredNes 
                                  ? Colors.white.withAlpha(0) 
                                  : Colors.white.withAlpha(0),
                                width: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),


                    ] else ...[

                    

                      // NES Theme UI Components

                      // White rectangle menu area

                      Positioned(
                        left: whiteRectLeft,
                        top: whiteRectTop,
                        width: whiteRectWidth,
                        height: whiteRectHeight,
                        child: PixelContainer(
                          backgroundColor: Colors.transparent,
                          padding: const EdgeInsets.all(8),
                          borderColor: Colors.transparent,
                          borderWidth: 0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _buildNesMenuItem('About', isSmall: true),
                              _buildNesMenuItem('Projects', isSmall: true),
                              _buildNesMenuItem('Resume', isSmall: true),
                              _buildNesMenuItem('Contact', isSmall: true),
                              _buildNesMenuItem('Menu', isSmall: true),

                              // Theme toggle in NES style
                              PixelButton(
                                isPrimary: true,
                                onPressed: () {
                                  themeProvider.toggleDarkMode(!isDarkMode);
                                },
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2),
                                height: 22,
                                width: 50, // Narrow width for the button
                                backgroundColor:
                                    const Color(0xFF9370DB), // Purple color
                                textColor: Colors.white,
                                borderWidth: 1.0,
                                borderRadius: 3.0,
                                showShadow: false,
                                child: Text(
                                  isDarkMode ? 'LIGHT' : 'DARK',
                                  style: const TextStyle(
                                    fontFamily: 'NES',
                                    fontSize: 8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Orange rectangle content area
                      Positioned(
                        left: orangeRectLeft,
                        top: orangeRectTop,
                        width: orangeRectWidth,
                        height: orangeRectHeight,
                        child: PixelContainer(
                          backgroundColor: Colors.transparent,
                          padding: const EdgeInsets.all(16),
                          borderColor: Colors.transparent,
                          borderWidth: 0,
                          child: _buildNesContent(),
                        ),
                      ),
                    ],

                    // Animated menu with text (only shown when visible in standard theme)
                    if (_isMenuVisible && !isNesTheme)
                      Positioned(
                        top: menuTop,
                        right: _menuSlideAnimation.value,
                        child: GestureDetector(
                          onTap: () {},
                          behavior: HitTestBehavior.opaque,
                          child: SizedBox(
                            width: _menuWidth,
                            height: _menuHeight,
                            child: Stack(
                              children: [
                                // Menu background image
                                Image.asset(
                                  'assets/menublank.png',
                                  width: _menuWidth,
                                  height: _menuHeight,
                                  fit: BoxFit.contain,
                                ),

                                // Menu text items
                                Positioned(
                                  left: _menuTextLeftOffset,
                                  top: _menuTextTopOffset,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildMenuTextItem('About'),
                                      SizedBox(height: _menuTextSpacing),
                                      _buildMenuTextItem('Projects'),
                                      SizedBox(height: _menuTextSpacing),
                                      _buildMenuTextItem('Resume'),
                                      SizedBox(height: _menuTextSpacing),
                                      _buildMenuTextItem('Contact'),
                                      SizedBox(height: _menuTextSpacing),
                                      _buildMenuTextItem('Menu'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    // Close (X) button with improved responsiveness (for standard theme)
                    if (_isMenuVisible && !isNesTheme)
                      Positioned(
                        top: 10,
                        right: 20,
                        child: Material(
                          color: Colors.transparent,
                          elevation: 0,
                          child: InkWell(
                            onTap: _forceCloseMenu,
                            splashColor: const Color(0x33FFFFFF),
                            highlightColor: const Color(0x22FFFFFF),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.close,
                                  color: Color.fromARGB(255, 19, 19, 19),
                                  size: 32,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    // Hamburger menu button with circular text (only when menu is hidden in standard theme)
                    if (!_isMenuVisible && !isNesTheme)
                      Positioned(
                        top: 10,
                        right: 20,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [

                            // Circular rotating text
                            CircularText(
                              text: "unem rof ereh paT ... ",
                              radius:
                                  35.0, // Adjust radius to fit around your icon
                              textColor: const Color(0xFF1DF0E6),
                              fontSize: 12.0,
                            ),

                            // The existing menu button
                            IconButton(
                              icon: const Icon(
                                Icons.menu_rounded,
                                color: const Color(0xFFF9D200),
                                size: 40,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isMenuVisible = true;
                                  _menuAnimationController.forward();
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                    // Back to Main Theme button (only in NES theme)
                    if (isNesTheme)
                      Positioned(
                        top: 20,
                        right: 20,
                        child: PixelButton(
                          isPrimary: false,
                          onPressed: () {
                            themeProvider.toggleNesTheme(false);
                          },
                          child: const Text(
                            'MAIN THEME',
                            style: TextStyle(
                              fontFamily: 'NES',
                              fontSize: 12,
                            ),
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
    );
  }

  // Build a single menu text item with hover effect
  Widget _buildMenuTextItem(String category) {
    final isHovered = hoveredCategory == category;

    return MouseRegion(
      onEnter: (_) => setState(() => hoveredCategory = category),
      onExit: (_) => setState(() => hoveredCategory = null),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _handleCategorySelection(category),
        child: Stack(
          children: [
            // Stroke text (shadow)
            Text(
              category,
              style: TextStyle(
                fontFamily: 'Ghibli',
                fontSize: _menuTextSize,
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = _menuTextStrokeWidth
                  ..color = _menuTextStrokeColor,
              ),
            ),
            // Main text
            Text(
              category,
              style: TextStyle(
                fontFamily: 'Ghibli',
                fontSize: _menuTextSize,
                fontWeight: FontWeight.bold,
                color: isHovered ? _menuTextHoverColor : _menuTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build a single book text item with hover effect and rotation
  Widget _buildBookTextItem(String category, int index) {
    final isHovered = hoveredCategory == category;

    return MouseRegion(
      onEnter: (_) => setState(() => hoveredCategory = category),
      onExit: (_) => setState(() => hoveredCategory = null),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _handleCategorySelection(category),
        child: RotatedBox(
          quarterTurns: 5, // Rotate text 90 degrees counterclockwise
          child: Stack(
            children: [
              // Stroke text (shadow)
              Text(
                category,
                style: TextStyle(
                  fontFamily: 'Ghibli',
                  fontSize: _bookTextSize,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = _bookTextStrokeWidth
                    ..color = _bookTextStrokeColor,
                ),
              ),
              // Main text
              Text(
                category,
                style: TextStyle(
                  fontFamily: 'Ghibli',
                  fontSize: _bookTextSize,
                  fontWeight: FontWeight.bold,
                  color: isHovered ? _bookTextHoverColor : _bookTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TV content based on selected category - continued

  Widget _buildTVContent() {
    if (selectedCategory == null) {
      // Default welcome message
      return Container(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(left: _textIndent), // Apply indent
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start, // Left align children
          children: [
            _buildStrokedText(
              "Hi! I'm Jeff!",
              color: Color.fromARGB(255, 228, 133, 69),
              size: _tvTextTitleSize,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.left,
            ),
            SizedBox(height: _tvTextSpacing),
            _buildStrokedText(
              "I love to create...",
              color: const Color(0xFFFFB74D),  // FFB74D
              size: _tvTextTitleSize,
              fontStyle: FontStyle.italic,
              textAlign: TextAlign.left,
            ),
            SizedBox(height: _tvTextSpacing + 10),
            _buildStrokedText(
              "Click the hamburger icon in the right corner for a menu,\nor select a book below for an interactive experience",
              color: const Color(0xFFF5E7C8),
              size: _tvTextBodySize,
              textAlign: TextAlign.left,
            ),
            SizedBox(height: _tvTextSpacing + 10),
              _buildStrokedText(
              "...tap the clock to change the time of day",
                color: const Color(0xFFB2D348),
                size: _tvTextBodySize,
                textAlign: TextAlign.left,
              ),
          ],
        ),
        ),
      );

      // About Content

    } else if (selectedCategory == 'About') {
      return Container(
        alignment: Alignment.topLeft, // Align to top-left corner
        margin: EdgeInsets.only(
            left: _textIndent,
            top: _sectionHeights['About'] ?? 200.0 // Use the height as top margin instead
            ),
        child: SingleChildScrollView(
          child: _buildStrokedText(
            "As a seasoned UX/UI Designer, I bring a wealth of experience in analytic\nresearch and examination to my work.\n\nLeveraging over 18 years as a title examiner/officer, I excel in translating\ncomplex data into user-friendly models.\n\nMy knack for research, meticulous attention to detail, and effective communication skills...are instrumental in my success within industries\nthat demand precision.",
            color: const Color(0xFFF2D89E),
            size: _tvTextBodySize,
          ),
        ),
      );
    } else if (selectedCategory == 'Contact') {

      // Contact information

      return Padding(
        padding: EdgeInsets.only(left: _textIndent), // Apply indent
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildStrokedText(
                  "Email: ",
                  size: _tvTextBodySize,
                  fontWeight: FontWeight.bold,
                ),
                GestureDetector(
                  onTap: () => _launchEmail("JeffreyAndersonPDX@gmail.com"),
                  child: Text(
                    "JeffreyAndersonPDX@gmail.com",
                    style: TextStyle(
                      fontFamily: 'Ghibli',
                      fontSize: _tvTextBodySize,
                      color: _tvTextLinkColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: _tvTextSpacing * 0.5),

            // Phone section with custom color
            Row(
              children: [
                _buildStrokedText(
                  "Phone: ",
                  size: _tvTextBodySize,
                  fontWeight: FontWeight.bold,
                ),
                Text(
                  "(503) 282-4647",
                  style: TextStyle(
                    fontFamily: 'Ghibli',
                    fontSize: _tvTextBodySize,
                    color: const Color(0xFFFFB74D), 
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            SizedBox(height: _tvTextSpacing * 0.5),

            // Portfolio section on same row
            Row(
              children: [
                _buildStrokedText(
                  "Portfolio: ",
                  size: _tvTextBodySize,
                  fontWeight: FontWeight.bold,
                ),
                GestureDetector(
                  onTap: () => _launchURL("https://jeffpdx.net"),
                  child: Text(
                    "JeffPDX.net",
                    style: TextStyle(
                      fontFamily: 'Ghibli',
                      fontSize: _tvTextBodySize,
                      color: _tvTextLinkColor,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: _tvTextSpacing * 0.5),

            // Location with custom color
            Row(
              children: [
                _buildStrokedText(
                  "Location: ",
                  size: _tvTextBodySize,
                  fontWeight: FontWeight.bold,
                ),
                Text(
                  "Portland, OR",
                  style: TextStyle(
                    fontFamily: 'Ghibli',
                    fontSize: _tvTextBodySize,
                    color: const Color( 0xFFFFB74D), // Custom orange color for location
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else if (selectedCategory == 'Menu') {
      // Updated Menu content with theme selection
      return Stack(
        children: [
          // Background image
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/portfolio_selection.png'),
                  fit: BoxFit.fill, // Using fill instead of contain to stretch
                  // For fine-tuning dimensions
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),

          // Theme selection buttons
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 70.0), // Move CTA Theme buttons 
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Theme One button
                  GestureDetector(
                    onTap: () {
                      // Switch to theme one (main/primary theme)
                      final themeProvider =
                          Provider.of<ThemeProvider>(context, listen: false);
                      themeProvider.toggleNesTheme(false); // Set to main theme
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) =>
                          setState(() => hoveredThemeButton = 'one'),
                      onExit: (_) => setState(() => hoveredThemeButton = null),
                      child: _buildThemeButton(
                        '1 THEME ONE',
                        isHovered: hoveredThemeButton == 'one',
                        isPressed: pressedThemeButton == 'one',
                      ),
                    ),
                  ),

                  SizedBox(height: 12), // Spacing between buttons

                  // Theme Two button
                  GestureDetector(
                    onTap: () {
                      // Switch to theme two (NES theme)
                      final themeProvider =
                          Provider.of<ThemeProvider>(context, listen: false);
                      themeProvider.toggleNesTheme(true); // Set to NES theme
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) =>
                          setState(() => hoveredThemeButton = 'two'),
                      onExit: (_) => setState(() => hoveredThemeButton = null),
                      child: _buildThemeButton(
                        '2 THEME TWO',
                        isHovered: hoveredThemeButton == 'two',
                        isPressed: pressedThemeButton == 'two',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else if (selectedCategory == 'Projects') {
      // Projects listing in TV screen for Theme 1
      final projectsList = ProjectsRegistry().getProjectsForMenu();

      return Container(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: _textIndent),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildStrokedText(
                  "My Projects",
                  size: _tvTextTitleSize,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: _tvTextSpacing),

                // List each project with enhanced styling
                ...projectsList.map((project) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (project['id'] == 'this-website') {
                            // Show a simple alert for the website project
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("This site right here!",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: const Color(0xFFFF9A62),
                                        fontFamily: 'Ghibli'
                                        )),
                                  content: const Text(
                                    "I designed and coded the entirety of this portfolio site!",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: const Color(0xFFFFB74D),
                                      fontFamily: 'Ghibli'
                                      ),
                                      
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text("Close",
                                          style:
                                              TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xFFB2D348),
                                                fontFamily: 'Ghibli')),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {

                            // Show the project in TV modal

                            _showProjectsModal(context,
                                projectId: project['id']!);
                          }
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 8),
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Colors.transparent,
                                width: 0.1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.arrow_right,
                                  color: const Color(0xFFB2D348),
                                  size: _tvTextBodySize * 1.5,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  project['title']!,
                                  style: TextStyle(
                                    fontFamily: 'Ghibli',
                                    fontSize: _tvTextBodySize * 1.2,
                                    color: _tvTextLinkColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          )
        );
    } else {

      // For other categories, display a blank screen
      return Container(
        alignment: Alignment.center,
        // No child widget means nothing will be displayed
      );
    }
  }

  // Helper method to build the theme buttons
  Widget _buildThemeButton(String text,
      {bool isHovered = false, bool isPressed = false}) {
    Color textColor = Colors.white;

    if (isHovered) {
      textColor = const Color(0xFFFF9A62);
    } else if (isPressed) {
      textColor = const Color(0xFF0D99FF);    
    }

    return Container(
      // Add a container to apply the shadow effect
      decoration: BoxDecoration(
        // Drop shadow effect
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.0),
            spreadRadius: 0.5,
            blurRadius: 0.5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Stroke (shadow)
          Text(
            text,
            style: TextStyle(
              fontFamily: 'SuperMario256',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 3
                ..color = Colors.black,
            ),
          ),
          // Main text
          Text(
            text,
            style: TextStyle(
              fontFamily: 'SuperMario256',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to create text with optional stroke/outline
  Widget _buildStrokedText(
    String text, {
    required double size,
    FontWeight fontWeight = FontWeight.normal,
    FontStyle fontStyle = FontStyle.normal,
    TextAlign textAlign = TextAlign.left,
    Color? color,
  }) {
    return Stack(
      children: [
        // Only show stroke if stroke width > 0
        if (_tvTextStrokeWidth > 0)
          Text(
            text,
            textAlign: textAlign,
            style: TextStyle(
              fontFamily: 'Ghibli',
              fontSize: size,
              fontWeight: fontWeight,
              fontStyle: fontStyle,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = _tvTextStrokeWidth
                ..color = _tvTextStrokeColor,
            ),
          ),
        // Main text
        Text(
          text,
          textAlign: textAlign,
          style: TextStyle(
            fontFamily: 'Ghibli',
            fontSize: size,
            fontWeight: fontWeight,
            fontStyle: fontStyle,
            color: color ?? _tvTextColor,
          ),
        ),
      ],
    );
  }

  // Helper method to build NES theme menu items
  Widget _buildNesMenuItem(String category, {bool isSmall = false}) {
    final isSelected = selectedCategory == category;

    return PixelButton(
      isPrimary: isSelected,
      onPressed: () => _handleCategorySelection(category),
      padding: isSmall
          ? const EdgeInsets.symmetric(
              horizontal: 4, vertical: 2) // Even smaller padding
          : const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: isSmall ? 22 : null, // button height
      width: isSmall ? 80 : null, // Control button width
      backgroundColor: isSelected
          ? const Color(0xFF9370DB) // Custom color for selected
          : Color(0xFFED725C), // Custom color for normal
      textColor: isSelected ? Colors.white : Colors.black, // Text color
      borderWidth: 1.0, // Thinner border
      borderRadius: 4.0, // Slightly rounded corners
      showShadow: true, // No shadow for small buttons
      child: Text(
        category.toUpperCase(),
        style: TextStyle(
          fontFamily: 'NES',
          fontSize: isSmall ? 8 : 12, // Even smaller font
        ),
      ),
    );
  }

  // Helper method to build content for NES theme
  Widget _buildNesContent() {
    if (selectedCategory == null) {
      // Default welcome message in NES style
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Icon(Icons.star,
              size: 32, color: Color.fromARGB(255, 6, 63, 90)),
          SizedBox(height: 24),
          Text(
            "WELCOME TO MY NES PORTFOLIO!",
            style: TextStyle(
              fontFamily: 'NES',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF09523B),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            "I'M JEFF, A UX/UI DESIGNER & DEVELOPER",
            style: TextStyle(
              fontFamily: 'NES',
              fontSize: 16,
              color: Color(0xFF32138C),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          Text(
            "SELECT A MENU OPTION TO BEGIN",
            style: TextStyle(
              fontFamily: 'NES',
              fontSize: 14,
              color: Color(0xFF701010),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          Icon(
            Icons.arrow_left_rounded,
            size: 60,
            color: Color(0xFF470446),
          ),
        ],
      );
    } else if (selectedCategory == 'About') {
      // About content in NES style
      return const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ABOUT ME",
              style: TextStyle(
                fontFamily: 'NES',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 11, 49, 61),
              ),
            ),
            SizedBox(height: 16),
            Text(
              "I'M A SEASONED UX/UI DESIGNER WITH OVER 18 YEARS EXPERIENCE AS A TITLE EXAMINER. I EXCEL AT TRANSLATING COMPLEX DATA INTO USER-FRIENDLY MODELS.",
              style: TextStyle(
                fontFamily: 'NES',
                fontSize: 14,
                color: Color.fromARGB(255, 21, 56, 73),
                height: 1.5,
              ),
            ),

            /*
            const SizedBox(height: 24),

            const Text(
              "MY SKILLS:",
              style: TextStyle(
                fontFamily: 'NES',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 15, 48, 65),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildNesSkillChip("RESEARCH"),
                _buildNesSkillChip("UI DESIGN"),
                _buildNesSkillChip("PROTOTYPING"),
                _buildNesSkillChip("FLUTTER"),
                _buildNesSkillChip("FIGMA"),
              ],
            ),
              */

          ],
        ),
      );
    } else if (selectedCategory == 'Contact') {

      // Contact information in NES style
      
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "CONTACT ME",
            style: TextStyle(
              fontFamily: 'NES',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2B2A2F),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.email, size: 24, color: Color(0xFF3C3836)),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => _launchEmail("JeffreyAndersonPDX@gmail.com"),
                child: const Text(
                  "JeffreyAndersonPDX@gmail.com",
                  style: TextStyle(
                    fontFamily: 'NES',
                    fontSize: 16,
                    color: Color(0xFF0B4A9D),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.phone, size: 24, color: Color(0xFF3C3836)),
              const SizedBox(width: 16),
              const Text(
                "(503) 282-4647",
                style: TextStyle(
                  fontFamily: 'NES',
                  fontSize: 16,
                  color: Color(0xFF0B4A9D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.public, size: 24, color: Color(0xFF3C3836)),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => _launchURL("https://jeffpdx.net"),
                child: const Text(
                  "JeffPDX.net",
                  style: TextStyle(
                    fontFamily: 'NES',
                    fontSize: 16,
                    color: Color(0xFF0B4A9D),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, size: 24, color: Color(0xFF3C3836)),
              const SizedBox(width: 16),
              const Text(
                "Portland, OR",
                style: TextStyle(
                  fontFamily: 'NES',
                  fontSize: 16,
                  color: Color(0xFF0B4A9D),
                ),
              ),
            ],
          ),
        ],
      );
    } else if (selectedCategory == 'Projects') {
      // Projects content in NES style - updated to use ProjectsRegistry
      // Get available projects from registry
      final projectsList = ProjectsRegistry().getProjectsForMenu();

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "MY PROJECTS",
            style: TextStyle(
              fontFamily: 'NES',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3C3836),
            ),
          ),
          const SizedBox(height: 32),

          // Project buttons in NES style from registry
          
          ...projectsList.map((project) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: PixelButton(
                  isPrimary: true,
                  backgroundColor:
                  const Color(0xFF4EBD5F),                                 // project button color
                  textColor: Color(0xFF302e2c),                            // project button text color
                  onPressed: () {
                    if (project['id'] == 'this-website') {
                      // Show simple alert for website project
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            backgroundColor: Color(0xFF3C3836),
                            child: Padding(
                              padding: const EdgeInsets.all(200.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    "THIS WEBSITE! (the one you're on right now)",
                                    style: TextStyle(
                                      fontFamily: 'NES',
                                      fontSize: 16,
                                      color: Color(0xFFFF9A62),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    "I designed and coded the entirety of this portfolio site!",
                                    style: TextStyle(
                                      fontFamily: 'NES',
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  PixelButton(
                                    isPrimary: true,                                      
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("CLOSE"),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      // Show project in TV modal
                      _showProjectsModal(context, projectId: project['id']!);
                    }
                  },
                  child: Text(
                    project['title']!.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'NES',
                      fontSize: 14,
                    ),
                  ),
                ),
              )),

          const SizedBox(height: 32),
          const Text(
            "SELECT A PROJECT TO VIEW",
            style: TextStyle(
              fontFamily: 'NES',
              fontSize: 12,
              color: Color(0xFF302E2C),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else if (selectedCategory == 'Resume') {
      // Resume in NES style - simple view with a button to open the full resume
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "MY RESUME",
            style: TextStyle(
              fontFamily: 'NES',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF302E2C),
            ),
          ),
          const SizedBox(height: 32),
          PixelButton(
            isPrimary: true,
            onPressed: () {
              _launchURL(
                  'https://storage.googleapis.com/uxfolio/643d6d8beaacf70002256d70/Jeff_Resume_PhJ.webp');
            },
            child: const Text(
              "VIEW FULL RESUME",
              style: TextStyle(
                fontFamily: 'NES',
                fontSize: 14,
                color: Color(0xFF3C3836),
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            "CLICK THE BUTTON ABOVE TO VIEW MY COMPLETE RESUME",
            style: TextStyle(
              fontFamily: 'NES',
              fontSize: 12,
              color: Color(0xFF3C3836),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else if (selectedCategory == 'Menu') {
      // Menu content in NES style - theme selection
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "THEME SELECTION",
            style: TextStyle(
              fontFamily: 'NES',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3C3836),
            ),
          ),
          const SizedBox(height: 32),
          PixelButton(
            isPrimary: true,
            onPressed: () {
              // Switch to theme one (main/primary theme)
              final themeProvider =
                  Provider.of<ThemeProvider>(context, listen: false);
              themeProvider.toggleNesTheme(false); // Set to main theme
            },
            child: const Text(
              "MAIN THEME",
              style: TextStyle(
                fontFamily: 'NES',
                fontSize: 16,
                color: Color(0xFF3C3836),
              ),
            ),
          ),
          const SizedBox(height: 24),
          PixelButton(
            backgroundColor: const Color(0xFF302E2C),
            isPrimary: false,
            onPressed: () {

              // Already in NES theme, no need to change
            },
            child: const Text(
              "NES THEME (CURRENT)",
              style: TextStyle(
                fontFamily: 'NES',
                fontSize: 16,
                color: Color(0xFFF8E9D2),
              ),
            ),
          ),
        ],
      );
    } else {

      // Fallback for other categories

      return Center(
        child: Text(
          "Content for: $selectedCategory",
          style: const TextStyle(
            fontFamily: 'NES',
            fontSize: 18,
            color: Color(0xFF302E2C),
          ),
        ),
      );
    }
  }

  // Helper method to build NES skill chips
  Widget _buildNesSkillChip(String label) {
    return PixelContainer(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderWidth: 2,
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'NES',
          fontSize: 12,
          color: Color(0xFF3C3836),
        ),
      ),
    );
  }
}

// Platform-aware WebView widget
class WebViewWidget extends StatelessWidget {
  final String url;

  const WebViewWidget({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract projectId from URL if needed
    final Uri uri = Uri.parse(url);
    String projectId = 'tap-in';

    // If the URL has a specific path segment, use it as project ID
    if (uri.pathSegments.isNotEmpty) {
      projectId = uri.pathSegments.last;
    }

    // Use the enhanced PortfolioViewer component
    return PortfolioViewer(projectId: projectId);
  }
}

// Web-specific implementation using IFrameElement
// Web-specific implementation for the portfolio viewer
class _WebPlatformView extends StatelessWidget {
  final String url;

  const _WebPlatformView({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // For web platforms, we'll show a stylized "preview" with a button to launch the site
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.web_asset,
            size: 64,
            color: Colors.white70,
          ),
          const SizedBox(height: 20),
          Text(
            'My Portfolio Website',
            style: const TextStyle(
                color: Color(0xFF3C3836),
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () async {
              final Uri uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: const Text(
              "Open Portfolio",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
