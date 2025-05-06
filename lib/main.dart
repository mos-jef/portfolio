import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'screens/home_screen.dart';
import 'models/theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Force landscape orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MyApp(),
      ),
    );
  });
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
              const Breakpoint(start: 0, end: 599, name: MOBILE),
              const Breakpoint(start: 600, end: 1199, name: TABLET),
              const Breakpoint(
                  start: 1200, end: double.infinity, name: DESKTOP),
            ],
          ),
          theme: ThemeData(
            // Use a dark theme for all UI elements
            brightness: Brightness.dark,
            // No background color (transparent) to allow our custom backgrounds to show
            scaffoldBackgroundColor: Colors.transparent,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}
