import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:portfolio_website/components/project_viewer.dart';
import 'package:portfolio_website/components/projects_registry.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/theme_provider.dart';

class GameBoyMobileUI extends StatefulWidget {
  const GameBoyMobileUI({Key? key}) : super(key: key);

  @override
  State<GameBoyMobileUI> createState() => _GameBoyMobileUIState();
}

class _GameBoyMobileUIState extends State<GameBoyMobileUI> {
  String? selectedCategory;
  String? highlightedCategory;
  int highlightedIndex = 0;

  // Menu items
  final List<String> menuItems = [
    'About',
    'Projects',
    'Resume',
    'Contact',
    'Main Theme'
  ];

  // Transparent borders for debugging overlays (can be adjusted)
  final bool showOverlayBorders = true; // Set to false for production
  final Color overlayBorderColor = Colors.white.withAlpha(000);

  @override
  void initState() {
    super.initState();
    // Set the initial menu selection
    highlightedCategory = menuItems[0];
  }

  void _handleCategorySelection(String category) {
    setState(() {
      selectedCategory = category;
      highlightedCategory = category;
    });

    // Handle special actions for specific categories
    if (category == 'Resume') {
      _launchURL(
          'https://storage.googleapis.com/uxfolio/643d6d8beaacf70002256d70/Resume_avP.pdf');
    } else if (category == 'Main Theme') {
      // Switch back to main theme
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      themeProvider.toggleNesTheme(false);
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
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

  void _navigateMenu(Direction direction) {
    setState(() {
      int currentIndex = menuItems.indexOf(highlightedCategory ?? menuItems[0]);

      if (direction == Direction.up) {
        currentIndex = (currentIndex - 1) % menuItems.length;
        if (currentIndex < 0) currentIndex = menuItems.length - 1;
      } else if (direction == Direction.down) {
        currentIndex = (currentIndex + 1) % menuItems.length;
      }

      highlightedCategory = menuItems[currentIndex];
      highlightedIndex = currentIndex;
    });
  }

  void _goBack() {
    if (selectedCategory != null) {
      setState(() {
        selectedCategory = null;
      });
    } else {
      // If we're at the main menu, navigate back to previous screen
      Navigator.of(context).pop();
    }
  }

  void _showProjectsModal(BuildContext context, {String projectId = 'tap-in'}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                // Full Game Boy background image
                Positioned.fill(
                  child: Image.asset(
                    'assets/mobile/landscape_mobile.png',
                    fit: BoxFit.fill,
                  ),
                ),

                // Project Content inside screen area
                
                Positioned(
                  left: MediaQuery.of(context).size.width *
                      0.187, // Adjusted based on your values
                  top: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.width * 0.769,
                  height: MediaQuery.of(context).size.height * 0.86,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: PortfolioViewer(projectId: projectId),
                  ),
                ),

                // D-pad left button overlay (back)

                Positioned(
                  left: MediaQuery.of(context).size.width * 0.02,
                  top: MediaQuery.of(context).size.height * 0.34,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(); // Go back to projects list
                    },
                    child: Container(
                      width: 45,
                      height: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: showOverlayBorders
                            ? Border.all(color: overlayBorderColor)
                            : null,
                      ),
                      child: const Center(
                        child: Text('←',
                            style: TextStyle(color: Colors.transparent)),
                      ),
                    ),
                  ),
                ),

                // B button overlay (back/cancel)

                Positioned(
                  right: MediaQuery.of(context).size.width * 0.851,
                  bottom: MediaQuery.of(context).size.height * 0.27,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(); // Go back to projects list
                    },
                    child: Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: showOverlayBorders
                            ? Border.all(color: overlayBorderColor)
                            : null,
                      ),
                      child: const Center(
                        child: Text('B',
                            style: TextStyle(color: Colors.transparent)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Screen dimensions for responsive positioning
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Full Game Boy background image
          Positioned.fill(
            child: Image.asset(
              'assets/mobile/landscape_mobile.png',
              fit: BoxFit.fill,
            ),
          ),

          // Screen Content (where menu/content will go)
          // Adjust these values based on your landscape_mobile.png layout
          Positioned(
            left: screenWidth * 0.187, // 19% from left
            top: screenHeight * 0.07, // 7% from top
            width: screenWidth * 0.769, // 76% of screen width
            height: screenHeight * 0.86, // 86% of screen height
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF8bac0f), // Game Boy green color
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: _buildScreenContent(),
            ),
          ),

          // D-pad Overlays - ensure these match your image layout

          // Up button overlay

          Positioned(
            left: screenWidth * 0.07, // Adjust as needed
            top: screenHeight * 0.24, // Adjust as needed
            child: GestureDetector(
              onTap: () => _navigateMenu(Direction.up),
              child: Container(
                width: 40,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: showOverlayBorders
                      ? Border.all(color: overlayBorderColor)
                      : null,
                ),
                child: const Center(
                  child: Text('↑', style: TextStyle(color: Colors.transparent)),
                ),
              ),
            ),
          ),

          // Down button overlay

          Positioned(
            left: screenWidth * 0.07, // Adjust as needed
            top: screenHeight * 0.42, // Adjust as needed
            child: GestureDetector(
              onTap: () => _navigateMenu(Direction.down),
              child: Container(
                width: 40,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: showOverlayBorders
                      ? Border.all(color: overlayBorderColor)
                      : null,
                ),
                child: const Center(
                  child: Text('↓', style: TextStyle(color: Colors.transparent)),
                ),
              ),
            ),
          ),

          // Left button overlay (back)

          Positioned(
            left: screenWidth * 0.02, // Adjust as needed
            top: screenHeight * 0.34, // Adjust as needed
            child: GestureDetector(
              onTap: _goBack, // This now properly handles going back
              child: Container(
                width: 45,
                height: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: showOverlayBorders
                      ? Border.all(color: overlayBorderColor)
                      : null,
                ),
                child: const Center(
                  child: Text('←', style: TextStyle(color: Colors.transparent)),
                ),
              ),
            ),
          ),

          // Right button overlay (select)

          Positioned(
            left: screenWidth * 0.11, // Adjust as needed
            top: screenHeight * 0.34, // Adjust as needed
            child: GestureDetector(
              onTap: () {
                if (highlightedCategory != null) {
                  _handleCategorySelection(highlightedCategory!);
                }
              },
              child: Container(
                width: 45,
                height: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: showOverlayBorders
                      ? Border.all(color: overlayBorderColor)
                      : null,
                ),
                child: const Center(
                  child: Text('→', style: TextStyle(color: Colors.transparent)),
                ),
              ),
            ),
          ),

          // A button overlay (select/confirm)
          Positioned(
            right: screenWidth * 0.927, // Adjust as needed
            bottom: screenHeight * 0.27, // Adjust as needed
            child: GestureDetector(
              onTap: () {
                if (highlightedCategory != null) {
                  _handleCategorySelection(highlightedCategory!);
                }
              },
              child: Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: showOverlayBorders
                      ? Border.all(color: overlayBorderColor)
                      : null,
                ),
                child: const Center(
                  child: Text('A', style: TextStyle(color: Colors.transparent)),
                ),
              ),
            ),
          ),

          // B button overlay (back/cancel)

          Positioned(
            right: screenWidth * 0.851, // Adjust as needed
            bottom: screenHeight * 0.27, // Adjust as needed
            child: GestureDetector(
              onTap: _goBack, // This now properly handles going back
              child: Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: showOverlayBorders
                      ? Border.all(color: overlayBorderColor)
                      : null,
                ),
                child: const Center(
                  child: Text('B', style: TextStyle(color: Colors.transparent)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScreenContent() {
    if (selectedCategory == null) {
      // Main menu screen
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MENU',
            style: TextStyle(
              fontFamily: 'NES',
              fontSize: 24,
              color: Color.fromARGB(255, 39, 39, 39),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Menu items with selection indicator
          ...menuItems.asMap().entries.map((entry) {
            final int index = entry.key;
            final String item = entry.value;
            final bool isSelected = highlightedCategory == item;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  // Selection indicator
                  SizedBox(
                    width: 20,
                    child: isSelected
                        ? const Text(
                            '▶',
                            style: TextStyle(
                              fontFamily: 'NES',
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 10),

                  // Menu text
                  GestureDetector(
                    onTap: () => _handleCategorySelection(item),
                    child: Text(
                      item.toUpperCase(),
                      style: TextStyle(
                        fontFamily: 'NES',
                        fontSize: 20,
                        color:
                            isSelected ? const Color(0xFF2A1A03) : const Color.fromARGB(255, 15, 56, 15),
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      );
    } else if (selectedCategory == 'About') {
      // About screen
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'ABOUT ME',
              style: TextStyle(
                fontFamily: 'NES',
                fontSize: 24,
                color: Color.fromARGB(255, 39, 39, 39),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'I AM A UX/UI DESIGNER WITH 18+ YEARS AS A TITLE EXAMINER, TRANSLATING COMPLEX DATA INTO USER-FRIENDLY MODELS.',
              style: TextStyle(
                fontFamily: 'NES',
                fontSize: 16,
                color: Color.fromARGB(255, 39, 39, 39),
                height: 1.5,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'MY SKILLS INCLUDE RESEARCH, ATTENTION TO DETAIL, AND EFFECTIVE COMMUNICATION.',
              style: TextStyle(
                fontFamily: 'NES',
                fontSize: 16,
                color: Color.fromARGB(255, 39, 39, 39),
                height: 1.5,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'PRESS B OR LEFT TO GO BACK',
              style: TextStyle(
                fontFamily: 'NES',
                fontSize: 12,
                color: Color.fromARGB(255, 39, 39, 39),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    } else if (selectedCategory == 'Projects') {
      // Projects screen
      final projectsList = ProjectsRegistry().getProjectsForMenu();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PROJECTS',
            style: TextStyle(
              fontFamily: 'NES',
              fontSize: 24,
              color: Color.fromARGB(255, 39, 39, 39),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: projectsList.map((project) {
                  return GestureDetector(
                    onTap: () {
                      if (project['id'] == 'this-website') {
                        // Show a simple alert for the website project
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(
                                "THIS WEBSITE",
                                style: TextStyle(
                                  fontFamily: 'NES',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: const Text(
                                "I DESIGNED AND CODED THE ENTIRETY OF THIS PORTFOLIO SITE!",
                                style: TextStyle(
                                  fontFamily: 'NES',
                                  fontSize: 14,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text(
                                    "CLOSE",
                                    style: TextStyle(
                                      fontFamily: 'NES',
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // Show the project in the Game Boy modal
                        _showProjectsModal(context, projectId: project['id']!);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(0, 48, 98, 48),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color.fromARGB(255, 39, 39, 39).withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Text(
                        project['title']!.toUpperCase(),
                        style: const TextStyle(
                          fontFamily: 'NES',
                          fontSize: 16,
                          color: Color.fromARGB(255, 39, 39, 39),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'PRESS B OR LEFT TO GO BACK',
            style: TextStyle(
              fontFamily: 'NES',
              fontSize: 12,
              color: Color.fromARGB(255, 39, 39, 39),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    } else if (selectedCategory == 'Contact') {
      // Contact screen
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CONTACT',
            style: TextStyle(
              fontFamily: 'NES',
              fontSize: 24,
              color: Color.fromARGB(255, 39, 39, 39),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),

          // Email
          GestureDetector(
            onTap: () => _launchEmail("JeffreyAndersonPDX@gmail.com"),
            child: Row(
              children: const [
                Icon(Icons.email, color: Color.fromARGB(255, 39, 39, 39), size: 20),
                SizedBox(width: 10),
                Text(
                  'JeffreyAndersonPDX@Gmail.COM',
                  style: TextStyle(
                    fontFamily: 'NES',
                    fontSize: 12,
                    color: Color.fromARGB(255, 10, 67, 173),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Phone
          Row(
            children: const [
              Icon(Icons.phone, color: Color.fromARGB(255, 39, 39, 39), size: 20),
              SizedBox(width: 10),
              Text(
                '(503) 282-4647',
                style: TextStyle(
                  fontFamily: 'NES',
                  fontSize: 14,
                  color: Color.fromARGB(255, 39, 39, 39),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Location
          Row(
            children: const [
              Icon(Icons.location_on, color: Color.fromARGB(255, 39, 39, 39), size: 20),
              SizedBox(width: 10),
              Text(
                'Portland, OR',
                style: TextStyle(
                  fontFamily: 'NES',
                  fontSize: 14,
                  color: Color.fromARGB(255, 39, 39, 39),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // LinkedIn
          GestureDetector(
            onTap: () =>
                _launchURL("https://www.linkedin.com/in/jeffrey-anderson-pdx/"),
            child: Row(
              children: [
                Image.asset(
                  'assets/linked_in_nes.png',
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 10),
                const Text(
                  'LinkedIn',
                  style: TextStyle(
                    fontFamily: 'NES',
                    fontSize: 14,
                    color: Color.fromARGB(255, 39, 39, 39),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),
          const Text(
            'Press B or Left to go back',
            style: TextStyle(
              fontFamily: 'NES',
              fontSize: 12,
              color: Color.fromARGB(255, 39, 39, 39),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    } else {
      // Default empty screen
      return const Center(
        child: Text(
          'Press B or Left to go return to the main menu',
          style: TextStyle(
            fontFamily: 'NES',
            fontSize: 20,
            color: Color.fromARGB(255, 39, 39, 39),
          ),
        ),
      );
    }
  }
}

enum Direction {
  up,
  down,
  left,
  right,
}
