// cursor_fix_script.dart - Run this script to automatically fix cursor issues
// Usage: dart cursor_fix_script.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:portfolio_website/themes/wireframe/widgets/clickable_widget.dart';

void main() async {
  print('🔧 Starting cursor fix script...');

  // Find all Dart files in lib directory
  final libDir = Directory('lib');
  final dartFiles = await libDir
      .list(recursive: true)
      .where((entity) => entity.path.endsWith('.dart'))
      .cast<File>()
      .toList();

  int filesModified = 0;
  int replacementsMade = 0;

  for (final file in dartFiles) {
    final content = await file.readAsString();
    String modifiedContent = content;
    bool fileChanged = false;

    // Pattern 1: Simple GestureDetector replacement
    final gesturePattern = RegExp(
      r'GestureDetector\(\s*onTap:\s*([^,]+),\s*child:\s*([^}]+)\)',
      multiLine: true,
      dotAll: true,
    );

    if (gesturePattern.hasMatch(modifiedContent)) {
      modifiedContent =
          modifiedContent.replaceAllMapped(gesturePattern, (match) {
        replacementsMade++;
        fileChanged = true;
        return 'ClickableWidget(\n  onTap: ${match.group(1)},\n  child: ${match.group(2)}\n)';
      });
    }

    // Pattern 2: InkWell wrapper
    final inkWellPattern = RegExp(r'InkWell\(');
    if (inkWellPattern.hasMatch(modifiedContent)) {
      modifiedContent = modifiedContent.replaceAll(
        'InkWell(',
        'MouseRegion(\n  cursor: SystemMouseCursors.click,\n  child: InkWell(',
      );
      // Count InkWell replacements
      replacementsMade += inkWellPattern.allMatches(content).length;
      fileChanged = true;
    }

    // Add import if ClickableWidget is used and import doesn't exist
    if (modifiedContent.contains('ClickableWidget') &&
        !modifiedContent.contains(
            "import 'package:portfolio_website/widgets/clickable_widget.dart'")) {
      // Find the last import statement
      final importPattern = RegExp(r"import '[^']+';", multiLine: true);
      final matches = importPattern.allMatches(modifiedContent).toList();

      if (matches.isNotEmpty) {
        final lastImport = matches.last;
        final insertIndex = lastImport.end;
        modifiedContent = modifiedContent.substring(0, insertIndex) +
            "\nimport 'package:portfolio_website/widgets/clickable_widget.dart';" +
            modifiedContent.substring(insertIndex);
        fileChanged = true;
      }
    }

    // Write back to file if changes were made
    if (fileChanged) {
      await file.writeAsString(modifiedContent);
      filesModified++;
      print('✅ Modified: ${file.path}');
    }
  }

  print('\n🎉 Cursor fix complete!');
  print('📊 Files modified: $filesModified');
  print('🔄 Replacements made: $replacementsMade');
  print('\n⚠️  Manual fixes still needed for:');
  print('   - Complex GestureDetectors with multiple callbacks');
  print(
      '   - IconButtons (should auto-show pointer, but may need MouseRegion)');
  print('   - Custom tap widgets that don\'t use GestureDetector');
  print('\n🔍 Review your changes and test thoroughly!');
}

// Alternative: Manual replacement helpers
class CursorFixHelpers {
  // Quick wrapper function you can use manually
  static Widget makeClickable(Widget child, VoidCallback? onTap) {
    if (onTap == null) return child;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ClickableWidget(
        onTap: onTap,
        child: child,
      ),
    );
  }

  // For wrapping existing InkWells
  static Widget wrapInkWell(Widget inkWellWidget) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: inkWellWidget,
    );
  }
}
