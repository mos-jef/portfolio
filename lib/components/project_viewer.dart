import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:portfolio_website/components/projects_registry.dart';
import 'package:portfolio_website/components/project_data.dart';
import 'dart:math' as math;
import 'package:responsive_framework/responsive_framework.dart';

class ThemeConfig {
  // Text colors
  final Color titleColor;
  final Color subtitleColor;
  final Color bodyTextColor;

  // Font sizes
  final double titleSize;
  final double subtitleSize;
  final double bodyTextSize;

  // Font families
  final String titleFont;
  final String bodyFont;

  // Background colors
  final Color backgroundColor;
  final List<Color> headerBackgroundColor;
  final Color sectionBackgroundColor;

  // Spacing
  final double sectionSpacing;
  final EdgeInsetsGeometry contentPadding;

  ThemeConfig({
    required this.titleColor,
    required this.subtitleColor,
    required this.bodyTextColor,
    required this.titleSize,
    required this.subtitleSize,
    required this.bodyTextSize,
    required this.titleFont,
    required this.bodyFont,
    required this.backgroundColor,
    required this.headerBackgroundColor,
    required this.sectionBackgroundColor,
    required this.sectionSpacing,
    required this.contentPadding,
  });
}

// Then declare your ThemeConfig instance as a variable
final ThemeConfig _themeConfig = ThemeConfig(
  // Text colors
  titleColor: const Color.fromARGB(255, 224, 111, 5),
  subtitleColor: const Color.fromARGB(221, 10, 121, 165),
  bodyTextColor: const Color.fromARGB(135, 10, 10, 10),

  // Font sizes
  titleSize: 28.0,
  subtitleSize: 22.0,
  bodyTextSize: 18.0,

  // Font families
  titleFont: 'Montserrat',
  bodyFont: 'Montserrat',

  // Background colors
  backgroundColor: Colors.white,
  headerBackgroundColor: [Colors.brown.shade300, Colors.brown.shade700],
  sectionBackgroundColor: Colors.white,

  // Spacing
  sectionSpacing: 24.0,
  contentPadding: const EdgeInsets.all(20.0),
);

// Then your PortfolioViewer class follows
class PortfolioViewer extends StatefulWidget {
  final String projectId;

  const PortfolioViewer({
    Key? key,
    required this.projectId,
  }) : super(key: key);

  @override
  State<PortfolioViewer> createState() => _PortfolioViewerState();
}

class _PortfolioViewerState extends State<PortfolioViewer> {
  int _activeStep = 0;
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = [];
  final GlobalKey _headerKey = GlobalKey();
  final GlobalKey _stepperKey = GlobalKey();
  final Map<String, CarouselSliderController> _carouselControllers = {};
  final double _tvContentWidth = 1280.0;

  // Method to get project data using the ProjectsRegistry
  ProjectData getProjectData(String projectId) {
    // Now we're using the ProjectsRegistry to get projects
    return ProjectsRegistry().getProject(projectId);
  }

  // Track if the stepper should be fixed
  bool _isStepperFixed = false;
  double _stepperHeight = 0;

  // For image fullscreen viewing
  bool _isViewingFullscreen = false;
  String _fullscreenImagePath = '';

  @override
  void initState() {
    super.initState();

    // Initialize section keys

    final ProjectData project = getProjectData(widget.projectId);
    _sectionKeys.clear();
    for (int i = 0; i < project.pages.length; i++) {
      _sectionKeys.add(GlobalKey());
    }

    // Add scroll listener to track when to fix the stepper
    _scrollController.addListener(_onScroll);

    // Schedule a callback to get dimensions after the layout is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateStepperHeight();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // Update the stepper's height
  void _updateStepperHeight() {
    // Get the stepper's context and RenderBox if available
    final stepperContext = _stepperKey.currentContext;
    if (stepperContext != null) {
      final RenderBox stepperBox =
          stepperContext.findRenderObject() as RenderBox;
      setState(() {
        _stepperHeight = stepperBox.size.height;
      });
    }

    // Call _onScroll to initialize the stepper state
    _onScroll();
  }

  // Handle scroll events to determine when to fix the stepper

  void _onScroll() {
    final ProjectData project = getProjectData(widget.projectId);

    // We want the stepper to become fixed once we reach the "Research" section
    // Find the index of the Research section
    final int researchIndex =
        project.pages.indexWhere((page) => page.title == 'Research');

    if (researchIndex >= 0 && researchIndex < _sectionKeys.length) {
      // Get the Research section's position
      final researchContext = _sectionKeys[researchIndex].currentContext;

      if (researchContext != null) {
        final RenderBox researchBox =
            researchContext.findRenderObject() as RenderBox;
        final researchPosition = researchBox.localToGlobal(Offset.zero).dy;

        // Calculate the scroll offset at which the stepper should become fixed
        // This is the position where the Research section reaches the top of the viewport
        final shouldBeFixed = researchPosition <= 80;

        if (shouldBeFixed != _isStepperFixed) {
          setState(() {
            _isStepperFixed = shouldBeFixed;
          });
        }
      }
    }

    // Update active step based on scroll position
    _updateActiveStep();
  }

  // Update which step is active based on scroll position
  void _updateActiveStep() {
    final ProjectData project = getProjectData(widget.projectId);

    // Skip the Project Overview section for the stepper
    // Start counting from Research section (index 1)
    for (int i = 1; i < project.pages.length; i++) {
      final sectionContext = _sectionKeys[i].currentContext;
      if (sectionContext != null) {
        final RenderBox box = sectionContext.findRenderObject() as RenderBox;
        final position = box.localToGlobal(Offset.zero).dy;

        // If the section is at the top of the viewport (with some margin)
        // or above but closest to the top, make it the active step
        if (position <= 100 + (_isStepperFixed ? _stepperHeight : 0)) {
          // Find the last section that's above or near the top
          int activeIndex =
              i - 1; // Convert to stepper index (0-based for Research)
          for (int j = i + 1; j < project.pages.length; j++) {
            final nextSectionContext = _sectionKeys[j].currentContext;
            if (nextSectionContext != null) {
              final nextBox =
                  nextSectionContext.findRenderObject() as RenderBox;
              final nextPosition = nextBox.localToGlobal(Offset.zero).dy;

              if (nextPosition <=
                  100 + (_isStepperFixed ? _stepperHeight : 0)) {
                activeIndex = j - 1; // Convert to stepper index
              } else {
                break;
              }
            }
          }

          if (_activeStep != activeIndex) {
            setState(() {
              _activeStep = activeIndex;
            });
          }
          break;
        }
      }
    }
  }

  void _scrollToSection(int index) {
    // The index is for the stepper (which starts with Research)
    // So we need to add 1 to get the actual section index
    final sectionIndex = index + 1;

    if (sectionIndex >= 0 && sectionIndex < _sectionKeys.length) {
      // Get the current context of the GlobalKey
      final context = _sectionKeys[sectionIndex].currentContext;
      if (context != null) {
        // Calculate the position to scroll to
        final RenderBox box = context.findRenderObject() as RenderBox;
        final position = box.localToGlobal(Offset.zero).dy;

        // Account for the fixed stepper if it's active
        final offset = _isStepperFixed ? _stepperHeight : 0;

        // Scroll to the position
        _scrollController.animateTo(
          _scrollController.position.pixels + position - 100 - offset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );

        // Update active step
        setState(() {
          _activeStep = index;
        });
      }
    }
  }

  // Method to show image in fullscreen
  void _showFullscreenImage(String imagePath) {
    setState(() {
      _isViewingFullscreen = true;
      _fullscreenImagePath = imagePath;
    });
  }

  // Method to hide fullscreen image
  void _hideFullscreenImage() {
    setState(() {
      _isViewingFullscreen = false;
      _fullscreenImagePath = '';
    });
  }

  // Widget for interactive image (tap to enlarge)
  Widget _buildInteractiveImage(String imagePath, {double? width}) {
    return GestureDetector(
      onTap: () => _showFullscreenImage(imagePath),
      child: Container(
        width: width,
        constraints: BoxConstraints(
          maxWidth: width ?? MediaQuery.of(context).size.width * 0.8,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  // Widget for side-by-side images

  Widget _buildSideBySideImages(String image1, String image2) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    if (isMobile) {

      // Stack vertically on mobile
      return Column(
        children: [
          _buildInteractiveImage(image1, width: screenWidth * 0.8),
          const SizedBox(height: 16),
          _buildInteractiveImage(image2, width: screenWidth * 0.8),
        ],
      );
    } else {

      // Side by side on larger screens
      
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            flex: 1,
            child: _buildInteractiveImage(image1, width: null),
          ),
          const SizedBox(width: 16),
          Flexible(
            flex: 1,
            child: _buildInteractiveImage(image2, width: null),
          ),
        ],
      );
    }
  }

  // Widget for image carousel
  Widget _buildImageCarousel(List<String> imagePaths, {String? id}) {
    // Create a unique ID for this carousel if not provided
    final carouselId = id ?? 'carousel_${imagePaths.hashCode}';

    // Get or create controller for this carousel
    final controller = _carouselControllers.putIfAbsent(
        carouselId, () => CarouselSliderController());

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // Main carousel
            CarouselSlider(
              carouselController: controller, // Add controller
              options: CarouselOptions(
                height: 320,
                viewportFraction: 0.8,
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
              ),
              items: imagePaths.map((imagePath) {
                return Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () => _showFullscreenImage(imagePath),
                      child: Container(
                        width: constraints.maxWidth * 0.8,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),

            // Left navigation arrow
            Positioned(
              left: 10,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () => controller.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),

            // Right navigation arrow
            Positioned(
              right: 10,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () => controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Widget for embedding Figma prototype
  Widget _buildFigmaPrototype({String? projectId, String? prototypeUrl}) {
    // Set default URL if not provided
    final url = prototypeUrl ??
        'https://www.figma.com/proto/go06t5rtb71MIvxBt5BC5g/Untitled?page-id=0%3A1&node-id=5-1854&p=f&viewport=568%2C-73%2C0.11&scaling=scale-down&content-scaling=fixed&starting-point-node-id=5%3A1854';

    // Set appropriate preview image based on project
    String previewImage = 'assets/Feed.png';
    String buttonText = 'Open Interactive Prototype';

    if (projectId == 'moments') {
      previewImage = 'assets/moments/devices/hero.png';
      buttonText = 'Open Moments Prototype';
    } else if (projectId == 'plannie') {
      previewImage = 'assets/plannie/planner.png';
      buttonText = 'Open Plannie Prototype';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Prototype mockup image
          Container(
            height: 400,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, width: 1),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              image: DecorationImage(
                image: AssetImage(previewImage),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Interactive Prototype',
            style: TextStyle(
              fontSize: 20,
              color: const Color.fromARGB(255, 115, 11, 156).withAlpha(255),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Tap the button below to open the prototype',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color.fromARGB(255, 115, 11, 156).withAlpha(255),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.open_in_new),
            label: Text(buttonText),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              final Uri uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Get the selected project based on projectId
        final ProjectData project = getProjectData(widget.projectId);

        // Extract the stepper pages (skip Overview)
        final stepperPages = project.pages.sublist(1);

        // Scale factor for responsive text and spacing
        final double baseWidth = _tvContentWidth;
        final scaleFactor = constraints.maxWidth / baseWidth;

        // Adjust text sizes based on available width
        final adjustedTitleSize =
            _themeConfig.titleSize * math.min(1.0, math.max(0.7, scaleFactor));
        final adjustedSubtitleSize = _themeConfig.subtitleSize *
            math.min(1.0, math.max(0.7, scaleFactor));
        final adjustedBodyTextSize = _themeConfig.bodyTextSize *
            math.min(1.0, math.max(0.8, scaleFactor));

        // Check if we're on a small screen (likely mobile)
        final isSmallScreen = constraints.maxWidth < 600;

        return Stack(
          children: [
            Container(
              color: _themeConfig.backgroundColor,
              child: Stack(
                children: [
                  // Scrollable content
                  SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hero Header - scrolls normally

                        // Hero Header with app screenshot and text on the right
                        Container(
                          key: _headerKey,
                          height: isSmallScreen ? 160 : 220,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: _themeConfig.headerBackgroundColor,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            image: project.heroImage.isNotEmpty
                                ? DecorationImage(
                                    image: AssetImage(project.heroImage),
                                    fit: BoxFit.fill,
                                    opacity: 0.9, // Adjust opacity as needed
                                  )
                                : null,
                          ),
                          child: Stack(
                            children: [
                              // Project info with app screenshot and text
                              Padding(
                                padding:
                                    EdgeInsets.all(isSmallScreen ? 12.0 : 20.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // App screenshot in device frame
                                    Container(
                                      width: isSmallScreen ? 100 : 200,
                                      height: isSmallScreen ? 200 : 400,
                                      decoration: BoxDecoration(
                                        color:
                                            const Color.fromARGB(0, 61, 59, 59),
                                        borderRadius: BorderRadius.circular(4),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.transparent
                                                .withOpacity(0.0),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                        border: Border.all(
                                          color: Colors.transparent,
                                          width: 3,
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(3),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(13),
                                        child: project.logoImage.isNotEmpty
                                            ? Image.asset(
                                                project
                                                    .logoImage, // Use the project's logo image
                                                fit: BoxFit.contain,
                                              )
                                            : Image.asset(
                                                'assets/backgroundheader.png', // Fallback image
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),

                                    // Spacing between image and text
                                    SizedBox(width: isSmallScreen ? 12 : 24),

                                    // Text content
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Project Title
                                          Text(
                                            project.title,
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              color: Color.fromARGB(
                                                  255, 4, 46, 46),
                                              fontSize:
                                                  isSmallScreen ? 20.0 : 32.0,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.2,
                                              shadows: [
                                                Shadow(
                                                  offset: Offset(1, 1),
                                                  blurRadius: 3,
                                                  color: Color.fromARGB(
                                                      0, 0, 0, 0),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                              height: isSmallScreen ? 4 : 8),

                                          // Project Subtitle
                                          Text(
                                            project.subtitle,
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              color: Color.fromARGB(
                                                  255, 88, 51, 2),
                                              fontSize:
                                                  isSmallScreen ? 14.0 : 18.0,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.italic,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // "View Original" button
                              Positioned(
                                top: isSmallScreen ? 10 : 20,
                                right: isSmallScreen ? 10 : 20,
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final Uri uri =
                                        Uri.parse(project.originalLink);
                                    if (await canLaunchUrl(uri)) {
                                      await launchUrl(uri);
                                    }
                                  },
                                  icon: Icon(Icons.open_in_new,
                                      color: Colors.white,
                                      size: isSmallScreen ? 16 : 24),
                                  label: Text("View Original",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: isSmallScreen ? 12 : 14,
                                      )),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black45,
                                    elevation: 0,
                                    padding: isSmallScreen
                                        ? EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4)
                                        : EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Project Overview section
                        Container(
                          key: _sectionKeys[0],
                          margin: EdgeInsets.only(
                            bottom: _themeConfig.sectionSpacing * scaleFactor,
                            left: isSmallScreen ? 8 : 16,
                            right: isSmallScreen ? 8 : 16,
                            top: isSmallScreen ? 8 : 16,
                          ),
                          padding: EdgeInsets.all(isSmallScreen ? 12 : 20),
                          decoration: BoxDecoration(
                            color: _themeConfig.sectionBackgroundColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Section Title
                              Text(
                                project.pages[0].title,
                                style: TextStyle(
                                  fontFamily: _themeConfig.titleFont,
                                  color: _themeConfig.titleColor,
                                  fontSize: adjustedTitleSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: isSmallScreen ? 8 : 16),

                              // Content sections for Project Overview
                              ...project.pages[0].sections.map((section) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (section.subtitle.isNotEmpty) ...[
                                      Text(
                                        section.subtitle,
                                        style: TextStyle(
                                          fontFamily: _themeConfig.titleFont,
                                          color: _themeConfig.subtitleColor,
                                          fontSize: adjustedSubtitleSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: isSmallScreen ? 4 : 8),
                                    ],

                                    // Section text
                                    Text(
                                      section.text,
                                      style: TextStyle(
                                        fontFamily: _themeConfig.bodyFont,
                                        color: _themeConfig.bodyTextColor,
                                        fontSize: adjustedBodyTextSize,
                                        height: 1.5,
                                      ),
                                    ),

                                    // Section image (if any)
                                    if (section.image.isNotEmpty) ...[
                                      SizedBox(height: isSmallScreen ? 8 : 16),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          section.image,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ],
                                    SizedBox(height: isSmallScreen ? 16 : 24),
                                  ],
                                );
                              }).toList(),

                              // App Feature Carousel - placed after the Project Overview
                              // Only add this carousel for Tap In
                              if (project.id == 'tap-in') ...[
                                SizedBox(height: isSmallScreen ? 8 : 16),
                                _buildImageCarousel([
                                  'assets/Calendar.png',
                                  'assets/Photos.png',
                                  'assets/Schedule.png',
                                  'assets/Timer.png',
                                  'assets/Mat.png',
                                  'assets/Feed.png',
                                ], id: 'overview_carousel'),
                                SizedBox(height: isSmallScreen ? 8 : 16),
                              ],
                            ],
                          ),
                        ),

                        // Non-fixed Stepper (only visible when not fixed)
                        // Placed just before the Research section
                        if (!_isStepperFixed && !isSmallScreen)
                          Container(
                            key: _stepperKey,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            color: Colors.white,
                            child: EasyStepper(
                              activeStep: _activeStep,
                              stepShape: StepShape.circle,
                              stepBorderRadius: 15,
                              borderThickness: 2,
                              padding: const EdgeInsets.all(12),
                              stepRadius: 28,
                              activeStepBorderColor: _themeConfig.titleColor,
                              activeStepIconColor: Colors.white,
                              activeStepBackgroundColor:
                                  _themeConfig.titleColor,
                              finishedStepBackgroundColor: _themeConfig
                                  .titleColor
                                  .withAlpha(179), // 0.7 opacity
                              finishedStepIconColor: Colors.white,
                              finishedStepBorderColor: _themeConfig.titleColor
                                  .withAlpha(179), // 0.7 opacity
                              unreachedStepBackgroundColor: Colors.white,
                              unreachedStepBorderColor: Colors.grey.shade300,
                              unreachedStepIconColor: Colors.grey,
                              steps: stepperPages.map((page) {
                                final pageIndex = project.pages.indexOf(page);
                                final stepIndex = pageIndex -
                                    1; // Adjust for stepper indexing

                                return EasyStep(
                                  customStep: Container(
                                    height: 32,
                                    width: 32,
                                    decoration: BoxDecoration(
                                      color: _activeStep >= stepIndex
                                          ? _themeConfig.titleColor
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: _activeStep >= stepIndex
                                            ? _themeConfig.titleColor
                                            : Colors.grey.shade300,
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${stepIndex + 1}',
                                        style: TextStyle(
                                          color: _activeStep >= stepIndex
                                              ? Colors.white
                                              : Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  customTitle: Text(
                                    page.title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _activeStep >= stepIndex
                                          ? _themeConfig.titleColor
                                          : Colors.grey,
                                      fontSize: 12,
                                      fontWeight: _activeStep >= stepIndex
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onStepReached: (index) => _scrollToSection(index),
                            ),
                          ),

                        // Placeholder for stepper when it becomes fixed
                        // This ensures content doesn't jump when stepper becomes fixed
                        if (_isStepperFixed && !isSmallScreen)
                          SizedBox(height: _stepperHeight),

                        // The rest of the sections (starting with Research)
                        ...project.pages
                            .sublist(1)
                            .asMap()
                            .entries
                            .map((entry) {
                          final int index = entry.key +
                              1; // +1 because we're starting from Research
                          final ProjectPage page = entry.value;

                          // Return your existing section patterns with responsive adjustments
                          // Example for a regular section:
                          return Container(
                            key: _sectionKeys[index],
                            margin: EdgeInsets.only(
                              bottom: _themeConfig.sectionSpacing * scaleFactor,
                              left: isSmallScreen ? 8 : 16,
                              right: isSmallScreen ? 8 : 16,
                            ),
                            padding: EdgeInsets.all(isSmallScreen ? 12 : 20),
                            decoration: BoxDecoration(
                              color: _themeConfig.sectionBackgroundColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Section Title
                                Text(
                                  page.title,
                                  style: TextStyle(
                                    fontFamily: _themeConfig.titleFont,
                                    color: _themeConfig.titleColor,
                                    fontSize: adjustedTitleSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: isSmallScreen ? 8 : 16),

                                // Process content sections
                                ...page.sections.map((section) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (section.subtitle.isNotEmpty) ...[
                                        Text(
                                          section.subtitle,
                                          style: TextStyle(
                                            fontFamily: _themeConfig.titleFont,
                                            color: _themeConfig.subtitleColor,
                                            fontSize: adjustedSubtitleSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: isSmallScreen ? 4 : 8),
                                      ],

                                      // Section text
                                      Text(
                                        section.text,
                                        style: TextStyle(
                                          fontFamily: _themeConfig.bodyFont,
                                          color: _themeConfig.bodyTextColor,
                                          fontSize: adjustedBodyTextSize,
                                          height: 1.5,
                                        ),
                                      ),

                                      // Section image (if any)
                                      if (section.image.isNotEmpty) ...[
                                        SizedBox(
                                            height: isSmallScreen ? 8 : 16),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.asset(
                                            section.image,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ],
                                      SizedBox(height: isSmallScreen ? 16 : 24),
                                    ],
                                  );
                                }).toList(),

                                // Add carousel or other special content based on project and section
                                // Example for Tap In project with image carousel
                                if (project.id == 'tap-in' &&
                                    page.title == 'Design Process') ...[
                                  SizedBox(height: isSmallScreen ? 8 : 16),
                                  _buildImageCarousel([
                                    'assets/wire_frame4.png',
                                    'assets/wire_frame3.png',
                                    'assets/wire_frame2.png',
                                    'assets/wire_frame1.png',
                                  ], id: 'wireframes_carousel'),
                                  SizedBox(height: isSmallScreen ? 8 : 16),
                                ],
                              ],
                            ),
                          );
                        }).toList(),

                        // Bottom padding
                        SizedBox(height: isSmallScreen ? 20 : 40),
                      ],
                    ),
                  ),

                  // Fixed Stepper (only visible when fixed and not on small screens)
                  if (_isStepperFixed && !isSmallScreen)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        color: Colors.white,
                        child: EasyStepper(
                          activeStep: _activeStep,
                          stepShape: StepShape.circle,
                          stepBorderRadius: 15,
                          borderThickness: 2,
                          padding: const EdgeInsets.all(12),
                          stepRadius: 28,
                          activeStepBorderColor: _themeConfig.titleColor,
                          activeStepIconColor: Colors.white,
                          activeStepBackgroundColor: _themeConfig.titleColor,
                          finishedStepBackgroundColor: _themeConfig.titleColor
                              .withAlpha(179), // 0.7 opacity
                          finishedStepIconColor: Colors.white,
                          finishedStepBorderColor: _themeConfig.titleColor
                              .withAlpha(179), // 0.7 opacity
                          unreachedStepBackgroundColor: Colors.white,
                          unreachedStepBorderColor: Colors.grey.shade300,
                          unreachedStepIconColor: Colors.grey,
                          steps: stepperPages.map((page) {
                            final pageIndex = project.pages.indexOf(page);
                            final stepIndex =
                                pageIndex - 1; // Adjust for stepper indexing

                            return EasyStep(
                              customStep: Container(
                                height: 32,
                                width: 32,
                                decoration: BoxDecoration(
                                  color: _activeStep >= stepIndex
                                      ? _themeConfig.titleColor
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: _activeStep >= stepIndex
                                        ? _themeConfig.titleColor
                                        : Colors.grey.shade300,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '${stepIndex + 1}',
                                    style: TextStyle(
                                      color: _activeStep >= stepIndex
                                          ? Colors.white
                                          : Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              customTitle: Text(
                                page.title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _activeStep >= stepIndex
                                      ? _themeConfig.titleColor
                                      : Colors.grey,
                                  fontSize: 12,
                                  fontWeight: _activeStep >= stepIndex
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            );
                          }).toList(),
                          onStepReached: (index) => _scrollToSection(index),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Fullscreen image overlay
            if (_isViewingFullscreen)
              GestureDetector(
                onTap: _hideFullscreenImage,
                child: Container(
                  color: Colors.black.withOpacity(0.9),
                  width: double.infinity,
                  height: double.infinity,
                  child: Stack(
                    children: [
                      // Centered fullscreen image
                      Center(
                        child: InteractiveViewer(
                          minScale: 0.5,
                          maxScale: 3.0,
                          child: Image.asset(
                            _fullscreenImagePath,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      // Close button
                      Positioned(
                        top: 20,
                        right: 20,
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: _hideFullscreenImage,
                        ),
                      ),

                      // Instruction text
                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Text(
                            'Tap anywhere to close • Pinch to zoom',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
