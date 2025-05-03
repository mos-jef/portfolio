import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:portfolio_website/components/projects_registry.dart';
import 'package:portfolio_website/components/project_data.dart';

// Enhanced component for displaying portfolio projects with sticky stepper
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

  // Track if the stepper should be fixed
  bool _isStepperFixed = false;
  double _stepperHeight = 0;

  // For image fullscreen viewing
  bool _isViewingFullscreen = false;
  String _fullscreenImagePath = '';

  // Theme configuration
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
    headerBackgroundColors: [Colors.brown.shade300, Colors.brown.shade700],
    sectionBackgroundColor: Colors.white,

    // Spacing
    sectionSpacing: 24.0,
    contentPadding: const EdgeInsets.all(20.0),
  );

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
    // Get the selected project based on projectId
    final ProjectData project = getProjectData(widget.projectId);

    // Extract the stepper pages (skip Overview)
    final stepperPages = project.pages.sublist(1);

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
                      height: 220,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _themeConfig.headerBackgroundColors,
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
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // App screenshot in device frame
                                Container(
                                  width: 200,
                                  height: 400,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(0, 61, 59, 59),
                                    borderRadius: BorderRadius.circular(4),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.transparent.withOpacity(0.0),
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
                                const SizedBox(width: 24),

                                // Text content
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [

                                      // Project Title
                                      Text(
                                        project.title,
                                        style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Color.fromARGB(255, 4, 46, 46),
                                          fontSize: 32.0, // Custom size
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2, // Add some letter spacing
                                          shadows: [
                                            Shadow(
                                              offset: Offset(1, 1),
                                              blurRadius: 3,
                                              color: Color.fromARGB(0, 0, 0, 0),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),

                                      // Project Subtitle
                                      Text(
                                        project.subtitle,
                                        style: const TextStyle(
                                          fontFamily:
                                              'Montserrat', // Use your preferred font here
                                          color: Color.fromARGB(255, 88, 51, 2), // Light blue color
                                          fontSize: 18.0, // Custom size
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle
                                              .italic, // Make it italic
                                          letterSpacing:
                                              0.5, // Add some letter spacing
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
                            top: 20,
                            right: 20,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final Uri uri = Uri.parse(project.originalLink);
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri);
                                }
                              },
                              icon: const Icon(Icons.open_in_new,
                                  color: Colors.white),
                              label: const Text("View Original",
                                  style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black45,
                                elevation: 0,
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
                        bottom: _themeConfig.sectionSpacing,
                        left: 16,
                        right: 16,
                        top: 16,
                      ),
                      padding: _themeConfig.contentPadding,
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
                              fontSize: _themeConfig.titleSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

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
                                      fontSize: _themeConfig.subtitleSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],

                                // Section text
                                Text(
                                  section.text,
                                  style: TextStyle(
                                    fontFamily: _themeConfig.bodyFont,
                                    color: _themeConfig.bodyTextColor,
                                    fontSize: _themeConfig.bodyTextSize,
                                    height: 1.5,
                                  ),
                                ),

                                // Section image (if any)
                                if (section.image.isNotEmpty) ...[
                                  const SizedBox(height: 16),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      section.image,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 24),
                              ],
                            );
                          }).toList(),

                          // App Feature Carousel - placed after the Project Overview
                          // Only add this carousel for Tap In
                          if (project.id == 'tap-in') ...[
                            const SizedBox(height: 16),
                            _buildImageCarousel([
                              'assets/Calendar.png',
                              'assets/Photos.png',
                              'assets/Schedule.png',
                              'assets/Timer.png',
                              'assets/Mat.png',
                              'assets/Feed.png',
                            ], id: 'overview_carousel'),
                            const SizedBox(height: 16),
                          ],
                        ],
                      ),
                    ),

                    // Non-fixed Stepper (only visible when not fixed)
                    // Placed just before the Research section
                    if (!_isStepperFixed)
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

                    // Placeholder for stepper when it becomes fixed
                    // This ensures content doesn't jump when stepper becomes fixed
                    if (_isStepperFixed) SizedBox(height: _stepperHeight),

                    // The rest of the sections (starting with Research)
                    ...project.pages.sublist(1).asMap().entries.map((entry) {
                    final int index = entry.key + 1; // +1 because we're starting from Research
                    final ProjectPage page = entry.value;

                      // Special case for Moments "Prototyping" page to add device mockups carousel

                      if (page.title == 'Prototyping' &&
                          project.id == 'moments') {
                        return Container(
                          key: _sectionKeys[index],
                          margin: EdgeInsets.only(
                            bottom: _themeConfig.sectionSpacing,
                            left: 16,
                            right: 16,
                          ),
                          padding: _themeConfig.contentPadding,
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
                                  fontSize: _themeConfig.titleSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Process content sections first
                              ...page.sections.map((section) {
                                if (section.subtitle == 'Figma Prototype') {
                                  // Add Figma Prototype for Moments
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        section.subtitle,
                                        style: TextStyle(
                                          fontFamily: _themeConfig.titleFont,
                                          color: _themeConfig.subtitleColor,
                                          fontSize: _themeConfig.subtitleSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        section.text,
                                        style: TextStyle(
                                          fontFamily: _themeConfig.bodyFont,
                                          color: _themeConfig.bodyTextColor,
                                          fontSize: _themeConfig.bodyTextSize,
                                          height: 1.5,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      _buildFigmaPrototype(
                                        projectId: 'moments',
                                        prototypeUrl: 'https://embed.figma.com/proto/znj6MYokQyyVJVeIVTWUEn/Moments-Playground?kind=proto&node-id=7-11061&page-id=0%3A1&scaling=scale-down&starting-point-node-id=7%3A11061&type=design&viewport=2661%2C5709%2C0.52&embed-host=share'
                                      ),
                                      const SizedBox(height: 24),
                                    ],
                                  );
                                } else {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (section.subtitle.isNotEmpty) ...[
                                        Text(
                                          section.subtitle,
                                          style: TextStyle(
                                            fontFamily: _themeConfig.titleFont,
                                            color: _themeConfig.subtitleColor,
                                            fontSize: _themeConfig.subtitleSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                      ],

                                      // Section text
                                      Text(
                                        section.text,
                                        style: TextStyle(
                                          fontFamily: _themeConfig.bodyFont,
                                          color: _themeConfig.bodyTextColor,
                                          fontSize: _themeConfig.bodyTextSize,
                                          height: 1.5,
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                    ],
                                  );
                                }
                              }).toList(),

                              // Add Device Mockups carousel after all the content sections
                              const SizedBox(height: 16),
                              Text(
                                "Device Mockups",
                                style: TextStyle(
                                  fontFamily: _themeConfig.titleFont,
                                  color: _themeConfig.subtitleColor,
                                  fontSize: _themeConfig.subtitleSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildImageCarousel([
                                'assets/moments/devices/1.png',
                                'assets/moments/devices/2.png',
                                'assets/moments/devices/3.png',
                                'assets/moments/devices/4.png',
                                'assets/moments/devices/5.png',
                                'assets/moments/devices/6.png',
                                'assets/moments/devices/7.png',
                                'assets/moments/devices/8.png',
                                'assets/moments/devices/9.png',
                                'assets/moments/devices/10.png',
                                'assets/moments/devices/11.png',
                              ], id: 'moments_devices_carousel'),
                              const SizedBox(height: 24),
                            ],
                          ),
                        );
                      }
                      
                      // Special case for Moments "Dev Handoff" page to show handoff documentation carousel

                      else if (page.title == 'Dev Handoff' &&
                          project.id == 'moments') {
                        return Container(
                          key: _sectionKeys[index],
                          margin: EdgeInsets.only(
                            bottom: _themeConfig.sectionSpacing,
                            left: 16,
                            right: 16,
                          ),
                          padding: _themeConfig.contentPadding,
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
                                  fontSize: _themeConfig.titleSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Process content sections first

                              ...page.sections.map((section) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (section.subtitle.isNotEmpty) ...[
                                      Text(
                                        section.subtitle,
                                        style: TextStyle(
                                          fontFamily: _themeConfig.titleFont,
                                          color: _themeConfig.subtitleColor,
                                          fontSize: _themeConfig.subtitleSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                    ],

                                    // Section text

                                    Text(
                                      section.text,
                                      style: TextStyle(
                                        fontFamily: _themeConfig.bodyFont,
                                        color: _themeConfig.bodyTextColor,
                                        fontSize: _themeConfig.bodyTextSize,
                                        height: 1.5,
                                      ),
                                    ),

                                    // Add the carousel after the "Handoff Documentation" section

                                    if (section.subtitle ==
                                        'Handoff Documentation') ...[
                                      const SizedBox(height: 24),
                                      _buildImageCarousel([
                                        'assets/moments/dev_handoff/1.png',
                                        'assets/moments/dev_handoff/2.png',
                                        'assets/moments/dev_handoff/3.png',
                                        'assets/moments/dev_handoff/4.png',
                                        'assets/moments/dev_handoff/5.png',
                                        'assets/moments/dev_handoff/6.png',
                                        'assets/moments/dev_handoff/7.png',
                                        'assets/moments/dev_handoff/8.png',
                                        'assets/moments/dev_handoff/9.png',
                                        'assets/moments/dev_handoff/10.png',
                                        'assets/moments/dev_handoff/11.png',
                                        'assets/moments/dev_handoff/12.png',
                                        'assets/moments/dev_handoff/13.png',
                                      ], id: 'moments_handoff_carousel'),
                                    ],

                                    const SizedBox(height: 24),
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                        );
                      }

                      // Special case for CoreAi "Final Screens" page to add device mockups carousel

                      else if (page.title == 'Final Screens' &&
                          project.id == 'core-ai') {
                        return Container(
                          key: _sectionKeys[index],
                          margin: EdgeInsets.only(
                            bottom: _themeConfig.sectionSpacing,
                            left: 16,
                            right: 16,
                          ),
                          padding: _themeConfig.contentPadding,
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
                                  fontSize: _themeConfig.titleSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Process content sections first
                              ...page.sections.map((section) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (section.subtitle.isNotEmpty) ...[
                                      Text(
                                        section.subtitle,
                                        style: TextStyle(
                                          fontFamily: _themeConfig.titleFont,
                                          color: _themeConfig.subtitleColor,
                                          fontSize: _themeConfig.subtitleSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                    ],

                                    // Section text
                                    Text(
                                      section.text,
                                      style: TextStyle(
                                        fontFamily: _themeConfig.bodyFont,
                                        color: _themeConfig.bodyTextColor,
                                        fontSize: _themeConfig.bodyTextSize,
                                        height: 1.5,
                                      ),
                                    ),

                                    const SizedBox(height: 24),
                                  ],
                                );
                              }).toList(),

                              // Add Device Mockups carousel after the content sections
                              const SizedBox(height: 16),
                              Text(
                                "Final Screens",
                                style: TextStyle(
                                  fontFamily: _themeConfig.titleFont,
                                  color: _themeConfig.subtitleColor,
                                  fontSize: _themeConfig.subtitleSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildImageCarousel([
                                'assets/coreai/device1.png',
                                'assets/coreai/device2.png',
                                'assets/coreai/device3.png',
                                'assets/coreai/device4.png',
                                'assets/coreai/device5.png',
                              ], id: 'coreai_devices_carousel'),
                              const SizedBox(height: 24),
                            ],
                          ),
                        );
                      }
                      // Special case for CoreAi "Dev Handoff" page to show handoff documentation carousel

                      else if (page.title == 'Dev Handoff' &&
                          project.id == 'core-ai') {
                        return Container(
                          key: _sectionKeys[index],
                          margin: EdgeInsets.only(
                            bottom: _themeConfig.sectionSpacing,
                            left: 16,
                            right: 16,
                          ),
                          padding: _themeConfig.contentPadding,
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
                                  fontSize: _themeConfig.titleSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Process content sections first
                              ...page.sections.map((section) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (section.subtitle.isNotEmpty) ...[
                                      Text(
                                        section.subtitle,
                                        style: TextStyle(
                                          fontFamily: _themeConfig.titleFont,
                                          color: _themeConfig.subtitleColor,
                                          fontSize: _themeConfig.subtitleSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                    ],

                                    // Section text
                                    Text(
                                      section.text,
                                      style: TextStyle(
                                        fontFamily: _themeConfig.bodyFont,
                                        color: _themeConfig.bodyTextColor,
                                        fontSize: _themeConfig.bodyTextSize,
                                        height: 1.5,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                  ],
                                );
                              }).toList(),

                              // Add Dev Handoff documentation carousel
                              const SizedBox(height: 16),
                              Text(
                                "Handoff Documentation",
                                style: TextStyle(
                                  fontFamily: _themeConfig.titleFont,
                                  color: _themeConfig.subtitleColor,
                                  fontSize: _themeConfig.subtitleSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildImageCarousel([
                                'assets/coreai/dev_handoff1.png',
                                'assets/coreai/dev_handoff2.png',
                                'assets/coreai/dev_handoff3.png',
                                'assets/coreai/dev_handoff4.png',
                              ], id: 'coreai_handoff_carousel'),
                              const SizedBox(height: 24),
                            ],
                          ),
                        );
                      }
                      // Special case for CoreAi "Design" page to add High Fidelity Wireframes carousel

                      else if (page.title == 'Design' &&
                          project.id == 'core-ai') {
                        return Container(
                          key: _sectionKeys[index],
                          margin: EdgeInsets.only(
                            bottom: _themeConfig.sectionSpacing,
                            left: 16,
                            right: 16,
                          ),
                          padding: _themeConfig.contentPadding,
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
                                  fontSize: _themeConfig.titleSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Process content sections
                              ...page.sections.asMap().entries.map((entry) {
                                final int sectionIndex = entry.key;
                                final ContentSection section = entry.value;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (section.subtitle.isNotEmpty) ...[
                                      Text(
                                        section.subtitle,
                                        style: TextStyle(
                                          fontFamily: _themeConfig.titleFont,
                                          color: _themeConfig.subtitleColor,
                                          fontSize: _themeConfig.subtitleSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                    ],

                                    // Section text
                                    Text(
                                      section.text,
                                      style: TextStyle(
                                        fontFamily: _themeConfig.bodyFont,
                                        color: _themeConfig.bodyTextColor,
                                        fontSize: _themeConfig.bodyTextSize,
                                        height: 1.5,
                                      ),
                                    ),

                                    // Add Mood Board image after mood boards and inspiration section
                                    if (section.subtitle ==
                                        'Mood boards and inspiration') ...[
                                      const SizedBox(height: 24),
                                      _buildInteractiveImage(
                                          'assets/coreai/mood_board.png'),
                                    ],

                                    // Add Color Exploration image
                                    if (section.subtitle ==
                                        'Color Exploration') ...[
                                      const SizedBox(height: 24),
                                      _buildInteractiveImage(
                                          'assets/coreai/color_exploration.png'),
                                    ],

                                    // Add Style Guide - Colors and Logos image
                                    if (section.subtitle == 'Style Guide') ...[
                                      const SizedBox(height: 24),
                                      _buildInteractiveImage(
                                          'assets/coreai/color_and_logos.png'),
                                    ],

                                    // Add High Fidelity Wireframes carousel after that section
                                    if (section.subtitle ==
                                            'High Fidelity Wireframes' &&
                                        sectionIndex ==
                                            page.sections.length - 2) ...[
                                      const SizedBox(height: 24),
                                      _buildImageCarousel([
                                        'assets/coreai/hifi1.png',
                                        'assets/coreai/hifi2.png',
                                        'assets/coreai/hifi3.png',
                                        'assets/coreai/hifi4.png',
                                        'assets/coreai/hifi5.png',
                                      ], id: 'coreai_hifi_carousel'),
                                    ],

                                    const SizedBox(height: 24),
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                        );
                      }
                      // Special case for CoreAi "Low and Mid-Fidelity Wireframes" page

                      else if (page.title ==
                              'Low and Mid-Fidelity Wireframes' &&
                          project.id == 'core-ai') {
                        return Container(
                          key: _sectionKeys[index],
                          margin: EdgeInsets.only(
                            bottom: _themeConfig.sectionSpacing,
                            left: 16,
                            right: 16,
                          ),
                          padding: _themeConfig.contentPadding,
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
                                  fontSize: _themeConfig.titleSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Process content sections
                              ...page.sections.map((section) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (section.subtitle.isNotEmpty) ...[
                                      Text(
                                        section.subtitle,
                                        style: TextStyle(
                                          fontFamily: _themeConfig.titleFont,
                                          color: _themeConfig.subtitleColor,
                                          fontSize: _themeConfig.subtitleSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                    ],

                                    // Section text
                                    Text(
                                      section.text,
                                      style: TextStyle(
                                        fontFamily: _themeConfig.bodyFont,
                                        color: _themeConfig.bodyTextColor,
                                        fontSize: _themeConfig.bodyTextSize,
                                        height: 1.5,
                                      ),
                                    ),

                                    const SizedBox(height: 24),
                                  ],
                                );
                              }).toList(),

                              // Add wireframes at the end of the section
                              const SizedBox(height: 16),
                              _buildImageCarousel([
                                'assets/coreai/1.png',
                                'assets/coreai/2.png',
                                'assets/coreai/3.png',
                                'assets/coreai/4.png',
                                'assets/coreai/5.png',
                                'assets/coreai/6.png',
                                'assets/coreai/7.png',
                                'assets/coreai/8.png',
                              ], id: 'coreai_wireframes_carousel'),
                              const SizedBox(height: 24),
                            ],
                          ),
                        );
                      }
                      // Special case for CoreAi "Ideation" page

                      else if (page.title == 'Ideation' &&
                          project.id == 'core-ai') {
                        return Container(
                          key: _sectionKeys[index],
                          margin: EdgeInsets.only(
                            bottom: _themeConfig.sectionSpacing,
                            left: 16,
                            right: 16,
                          ),
                          padding: _themeConfig.contentPadding,
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
                                  fontSize: _themeConfig.titleSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Process content sections
                              ...page.sections.map((section) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (section.subtitle.isNotEmpty) ...[
                                      Text(
                                        section.subtitle,
                                        style: TextStyle(
                                          fontFamily: _themeConfig.titleFont,
                                          color: _themeConfig.subtitleColor,
                                          fontSize: _themeConfig.subtitleSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                    ],

                                    // Section text
                                    Text(
                                      section.text,
                                      style: TextStyle(
                                        fontFamily: _themeConfig.bodyFont,
                                        color: _themeConfig.bodyTextColor,
                                        fontSize: _themeConfig.bodyTextSize,
                                        height: 1.5,
                                      ),
                                    ),

                                    const SizedBox(height: 24),
                                  ],
                                );
                              }).toList(),

                              // Add User Flows image after all sections
                              const SizedBox(height: 16),
                              Text(
                                "User Flows",
                                style: TextStyle(
                                  fontFamily: _themeConfig.titleFont,
                                  color: _themeConfig.subtitleColor,
                                  fontSize: _themeConfig.subtitleSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildSideBySideImages(
                                'assets/coreai/flow1.png',
                                'assets/coreai/flow2.png',
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        );
                      }
                      // Special case for CoreAi "Discovery" page to show heuristic analysis

                      else if (page.title == 'Discovery' &&
                          project.id == 'core-ai') {
                        return Container(
                          key: _sectionKeys[index],
                          margin: EdgeInsets.only(
                            bottom: _themeConfig.sectionSpacing,
                            left: 16,
                            right: 16,
                          ),
                          padding: _themeConfig.contentPadding,
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
                                  fontSize: _themeConfig.titleSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Process content sections
                              ...page.sections.asMap().entries.map((entry) {
                                final int sectionIndex = entry.key;
                                final ContentSection section = entry.value;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (section.subtitle.isNotEmpty) ...[
                                      Text(
                                        section.subtitle,
                                        style: TextStyle(
                                          fontFamily: _themeConfig.titleFont,
                                          color: _themeConfig.subtitleColor,
                                          fontSize: _themeConfig.subtitleSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                    ],

                                    // Section text
                                    Text(
                                      section.text,
                                      style: TextStyle(
                                        fontFamily: _themeConfig.bodyFont,
                                        color: _themeConfig.bodyTextColor,
                                        fontSize: _themeConfig.bodyTextSize,
                                        height: 1.5,
                                      ),
                                    ),

                                    // Add Heuristic Evaluation image
                                    if (section.subtitle ==
                                            'Heuristic Evaluation' &&
                                        sectionIndex == 1) ...[
                                      const SizedBox(height: 24),
                                      _buildInteractiveImage(
                                          'assets/coreai/hueristic1.png'),
                                    ],

                                    const SizedBox(height: 24),
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                        );
                      }

                      // Special case for Plannie "Prototyping" page to add the Figma prototype
                      else if (page.title == 'Prototyping' &&
                          project.id == 'plannie') {
                        return Container(
                          key: _sectionKeys[index],
                          margin: EdgeInsets.only(
                            bottom: _themeConfig.sectionSpacing,
                            left: 16,
                            right: 16,
                          ),
                          padding: _themeConfig.contentPadding,
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
                                  fontSize: _themeConfig.titleSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Process content sections first
                              ...page.sections.map((section) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (section.subtitle.isNotEmpty) ...[
                                      Text(
                                        section.subtitle,
                                        style: TextStyle(
                                          fontFamily: _themeConfig.titleFont,
                                          color: _themeConfig.subtitleColor,
                                          fontSize: _themeConfig.subtitleSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                    ],

                                    // Section text
                                    Text(
                                      section.text,
                                      style: TextStyle(
                                        fontFamily: _themeConfig.bodyFont,
                                        color: _themeConfig.bodyTextColor,
                                        fontSize: _themeConfig.bodyTextSize,
                                        height: 1.5,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                  ],
                                );
                              }).toList(),

                              // Add Figma prototype button
                              const SizedBox(height: 16),
                              Container(
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
                                        border: Border.all(
                                            color: Colors.grey.shade300,
                                            width: 1),
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withAlpha(10),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                            spreadRadius: 0,
                                          ),
                                        ],
                                        image: const DecorationImage(
                                          image: AssetImage(
                                              'assets/plannie/planner.png'),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Text(
                                      'Interactive Prototype',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: const Color.fromARGB(
                                                255, 115, 11, 156)
                                            .withAlpha(255),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Tap the button below to open the prototype',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                                255, 115, 11, 156)
                                            .withAlpha(255),
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.open_in_new),
                                      label: const Text(
                                          'Open Interactive Prototype'),
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24, vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () async {
                                        final url = Uri.parse(
                                            'https://embed.figma.com/proto/7zhGYNGvHehoXFuaxBQ7Fj/Individual-Project---Plannie--Copy-?kind=proto&node-id=535-2149&page-id=535%3A418&scaling=scale-down&starting-point-node-id=535%3A2149&type=design&viewport=527%2C324%2C0.07&embed-host=share');
                                        if (await canLaunchUrl(url)) {
                                          await launchUrl(url,
                                              mode: LaunchMode
                                                  .externalApplication);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Add image carousel of additional device mockups
                              _buildImageCarousel([
                                'assets/plannie/device1.png',
                                'assets/plannie/device2.png',
                                'assets/plannie/device3.png',
                                'assets/plannie/device4.png',
                              ], id: 'plannie_devices_carousel'),
                              const SizedBox(height: 24),
                            ],
                          ),
                        );
                      }

                      // Default case for other sections

                      else {
                        return Container(
                          key: _sectionKeys[index],
                          margin: EdgeInsets.only(
                            bottom: _themeConfig.sectionSpacing,
                            left: 16,
                            right: 16,
                          ),
                          padding: _themeConfig.contentPadding,
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
                                  fontSize: _themeConfig.titleSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Special case for "Research" section to add Empathy Mapping image

                              if (page.title == 'Research' &&
                                  project.id == 'tap-in') ...[
                                // Content sections with added image displays
                                ...page.sections
                                    .asMap()
                                    .entries
                                    .map((sectionEntry) {
                                  final int sectionIndex = sectionEntry.key;
                                  final ContentSection section =
                                      sectionEntry.value;

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
                                            fontSize: _themeConfig.subtitleSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                      ],

                                      // Section text
                                      Text(
                                        section.text,
                                        style: TextStyle(
                                          fontFamily: _themeConfig.bodyFont,
                                          color: _themeConfig.bodyTextColor,
                                          fontSize: _themeConfig.bodyTextSize,
                                          height: 1.5,
                                        ),
                                      ),

                                      // Add Empathy Mapping image after the Affinity Mapping text
                                      if (section.subtitle ==
                                          'Affinity Mapping') ...[
                                        const SizedBox(height: 24),
                                        _buildInteractiveImage(
                                            'assets/empathy_mapping.png'),
                                      ],

                                      // Add dual content member images after Empathy Mapping
                                      if (section.subtitle ==
                                          'Empathy Mapping') ...[
                                        const SizedBox(height: 24),
                                        _buildSideBySideImages(
                                            'assets/media_content_members.png',
                                            'assets/social_content_gym_members.png'),
                                      ],

                                      const SizedBox(height: 24),
                                    ],
                                  );
                                }).toList(),
                              ]
                              // Special case for "Research Outcomes" section to add Persona images

                              else if (page.title == 'Research Outcomes' &&
                                  project.id == 'tap-in') ...[
                                ...page.sections
                                    .asMap()
                                    .entries
                                    .map((sectionEntry) {
                                  final ContentSection section =
                                      sectionEntry.value;

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
                                            fontSize: _themeConfig.subtitleSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                      ],

                                      // Section text
                                      Text(
                                        section.text,
                                        style: TextStyle(
                                          fontFamily: _themeConfig.bodyFont,
                                          color: _themeConfig.bodyTextColor,
                                          fontSize: _themeConfig.bodyTextSize,
                                          height: 1.5,
                                        ),
                                      ),

                                      // Add Persona images after the Personas subtitle
                                      if (section.subtitle == 'Personas') ...[
                                        const SizedBox(height: 24),
                                        _buildSideBySideImages(
                                            'assets/persona_michelle.png',
                                            'assets/persona_eric.png'),
                                      ],

                                      const SizedBox(height: 24),
                                    ],
                                  );
                                }).toList(),
                              ]
                              // Special case for "Ideation" section to add Site Map and User Flows images

                              else if (page.title == 'Ideation' &&
                                  project.id == 'tap-in') ...[
                                ...page.sections
                                    .asMap()
                                    .entries
                                    .map((sectionEntry) {
                                  final ContentSection section =
                                      sectionEntry.value;

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
                                            fontSize: _themeConfig.subtitleSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                      ],

                                      // Section text
                                      Text(
                                        section.text,
                                        style: TextStyle(
                                          fontFamily: _themeConfig.bodyFont,
                                          color: _themeConfig.bodyTextColor,
                                          fontSize: _themeConfig.bodyTextSize,
                                          height: 1.5,
                                        ),
                                      ),

                                      // Add Site Map image after the Site Map subtitle
                                      if (section.subtitle == 'Site Map') ...[
                                        const SizedBox(height: 24),
                                        _buildInteractiveImage(
                                            'assets/site_map.png'),
                                      ],

                                      // Add User Flows image after the User Flows subtitle
                                      if (section.subtitle == 'User Flows') ...[
                                        const SizedBox(height: 24),
                                        _buildInteractiveImage(
                                            'assets/user_flows.png'),
                                      ],

                                      const SizedBox(height: 24),
                                    ],
                                  );
                                }).toList(),
                              ]
                              // Special case for "Design Process" section for Wireframes, Mood Board, Style Guide

                              else if (page.title == 'Design Process' &&
                                  project.id == 'tap-in') ...[
                                ...page.sections
                                    .asMap()
                                    .entries
                                    .map((sectionEntry) {
                                  final ContentSection section =
                                      sectionEntry.value;

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
                                            fontSize: _themeConfig.subtitleSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                      ],

                                      // Section text
                                      Text(
                                        section.text,
                                        style: TextStyle(
                                          fontFamily: _themeConfig.bodyFont,
                                          color: _themeConfig.bodyTextColor,
                                          fontSize: _themeConfig.bodyTextSize,
                                          height: 1.5,
                                        ),
                                      ),

                                      // Add Wireframes carousel after the Wireframes subtitle
                                      if (section.subtitle == 'Wireframes') ...[
                                        const SizedBox(height: 24),
                                        _buildImageCarousel([
                                          'assets/wire_frame4.png',
                                          'assets/wire_frame3.png',
                                          'assets/wire_frame2.png',
                                          'assets/wire_frame1.png',
                                        ], id: 'wireframes_carousel'),
                                      ],

                                      // Add Mood Board image after the Mood Board subtitle
                                      if (section.subtitle == 'Mood Board') ...[
                                        const SizedBox(height: 24),
                                        _buildInteractiveImage(
                                            'assets/mood_board.png'),
                                      ],

                                      // Add Style Guide carousel after the Style Guide subtitle
                                      if (section.subtitle ==
                                          'Style Guide') ...[
                                        const SizedBox(height: 24),
                                        _buildImageCarousel([
                                          'assets/style_guide_ninja_light.png',
                                          'assets/style_guide_ninja_dark.png',
                                          'assets/style_guide_athelete_dark.png',
                                          'assets/style_guide1.png',
                                        ], id: 'style_carousel'),
                                      ],

                                      const SizedBox(height: 24),
                                    ],
                                  );
                                }).toList(),
                              ]
                              // Special case for "Testing" section to add Prototype and Redesign images

                              else if (page.title == 'Testing' &&
                                  project.id == 'tap-in') ...[
                                ...page.sections
                                    .asMap()
                                    .entries
                                    .map((sectionEntry) {
                                  final ContentSection section =
                                      sectionEntry.value;

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
                                            fontSize: _themeConfig.subtitleSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                      ],

                                      // Section text
                                      Text(
                                        section.text,
                                        style: TextStyle(
                                          fontFamily: _themeConfig.bodyFont,
                                          color: _themeConfig.bodyTextColor,
                                          fontSize: _themeConfig.bodyTextSize,
                                          height: 1.5,
                                        ),
                                      ),

                                      // Add Figma prototype after the Prototype subtitle
                                      if (section.subtitle == 'Prototype') ...[
                                        const SizedBox(height: 24),
                                        _buildFigmaPrototype(),
                                      ],

                                      // Add Redesign image after the Redesign subtitle
                                      if (section.subtitle == 'Redesign') ...[
                                        const SizedBox(height: 24),
                                        _buildInteractiveImage(
                                            'assets/redesign_images.png'),
                                      ],

                                      const SizedBox(height: 24),
                                    ],
                                  );
                                }).toList(),
                              ]

                              
                              // Default case for other sections

                              else ...[
                                // Content sections
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
                                            fontSize: _themeConfig.subtitleSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                      ],

                                      // Section text
                                      Text(
                                        section.text,
                                        style: TextStyle(
                                          fontFamily: _themeConfig.bodyFont,
                                          color: _themeConfig.bodyTextColor,
                                          fontSize: _themeConfig.bodyTextSize,
                                          height: 1.5,
                                        ),
                                      ),

                                      // Section image (if any)
                                      if (section.image.isNotEmpty) ...[
                                        const SizedBox(height: 16),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.asset(
                                            section.image,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ],
                                      const SizedBox(height: 24),
                                    ],
                                  );
                                }).toList(),
                              ],
                            ],
                          ),
                        );
                      }
                    }).toList(),

                    // Bottom padding
                    const SizedBox(height: 40),
                  ],
                ),
              ),

            

              // Fixed Stepper (only visible when fixed)

              if (_isStepperFixed)
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
                      finishedStepBackgroundColor:
                          _themeConfig.titleColor.withAlpha(179), // 0.7 opacity
                      finishedStepIconColor: Colors.white,
                      finishedStepBorderColor:
                          _themeConfig.titleColor.withAlpha(179), // 0.7 opacity
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
  }

  // Method to get project data using the ProjectsRegistry
  ProjectData getProjectData(String projectId) {
    // Now we're using the ProjectsRegistry to get projects
    return ProjectsRegistry().getProject(projectId);
  }
}

// Theme configuration class
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
  final List<Color> headerBackgroundColors;
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
    required this.headerBackgroundColors,
    required this.sectionBackgroundColor,
    required this.sectionSpacing,
    required this.contentPadding,
  });
}
