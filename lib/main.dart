import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'screens/home_screen.dart';
import 'screens/mobile.dart'; // Your mobile UI file
import 'models/theme_provider.dart';
import 'utils/device_utils.dart'; // Import enhanced device utils

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // No forced orientation here - we'll handle that in specific screens
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'Jeff\'s Portfolio',
          debugShowCheckedModeBanner: false,
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              // Increased mobile breakpoint to match our DeviceUtils
              const Breakpoint(start: 0, end: 1099, name: MOBILE),
              const Breakpoint(start: 1100, end: 1199, name: TABLET),
              const Breakpoint(
                  start: 1200, end: double.infinity, name: DESKTOP),
            ],
          ),
          theme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Colors.transparent,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ),
          home: const AppSelector(),
        );
      },
    );
  }
}

// Enhanced AppSelector with comprehensive device detection
class AppSelector extends StatefulWidget {
  const AppSelector({Key? key}) : super(key: key);

  @override
  State<AppSelector> createState() => _AppSelectorState();
}

class _AppSelectorState extends State<AppSelector> {
  // Flag to enable extensive debug info
  final bool _showDebugInfo = kDebugMode && false; // Set to true for debugging

  // Optional: Force mobile mode for testing (set to true to force mobile UI)
  final bool _forceMobileUI = kDebugMode && false;

  @override
  void initState() {
    super.initState();

    // Print debug info to console in debug mode
    if (kDebugMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print('📱 DEVICE DEBUG INFO:');
        // This will be printed once the context is available
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Print debug info once context is available
    if (kDebugMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print(DeviceUtils.getDeviceInfo(context));
      });
    }

    // Super comprehensive device detection
    final bool isMobile = DeviceUtils.isMobileDevice(context);
    final bool isIphoneProMax = DeviceUtils.isIphoneProMax(context);
    final bool isLargeAndroid = DeviceUtils.isLargeAndroid(context);

    // Use mobile UI for any of these conditions
    final bool useMobileUI =
        isMobile || isIphoneProMax || isLargeAndroid || _forceMobileUI;

    if (useMobileUI) {
      // Force landscape for the mobile UI
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);

      // If we're currently in portrait mode on mobile, show rotation instructions
      if (DeviceUtils.isPortrait(context)) {
        return _buildRotationInstructions();
      }

      // Show the mobile UI with optional debug overlay
      return Stack(
        children: [
          // Your mobile UI
          const GameBoyMobileUI(),

          // Debug overlay (only shown if enabled)
          if (_showDebugInfo) _buildDebugOverlay(context),
        ],
      );
    } else {
      // On desktop/tablet, use the normal home screen
      // Force landscape for consistency
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);

      // Show the regular home screen with optional debug overlay
      return Stack(
        children: [
          // Your regular home screen
          const HomeScreen(),

          // Debug overlay (only shown if enabled)
          if (_showDebugInfo) _buildDebugOverlay(context),
        ],
      );
    }
  }

  // Overlay for device debugging
  Widget _buildDebugOverlay(BuildContext context) {
    return Positioned(
      top: 10,
      right: 10,
      child: Container(
        padding: const EdgeInsets.all(8),
        width: 300,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'DEVICE DEBUG INFO',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DeviceUtils.getDeviceInfo(context),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to show instructions when the device needs to be rotated
  Widget _buildRotationInstructions() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Rotation icon
            const Icon(
              Icons.screen_rotation,
              size: 80,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            // Text instruction
            const Text(
              'PLEASE ROTATE\nYOUR DEVICE',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'NES',
                fontSize: 24,
                color: Colors.white,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            // Animation to indicate rotation
            RotationAnimation(),
          ],
        ),
      ),
    );
  }
}

// Simple animation to show rotation instruction
class RotationAnimation extends StatefulWidget {
  const RotationAnimation({Key? key}) : super(key: key);

  @override
  State<RotationAnimation> createState() => _RotationAnimationState();
}

class _RotationAnimationState extends State<RotationAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1.5708, // 90 degrees in radians
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Repeat the animation
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _animation.value,
          child: Container(
            width: 100,
            height: 160,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(
                Icons.phone_android,
                size: 60,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
