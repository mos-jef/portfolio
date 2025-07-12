import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'wireframe_color_manager.dart';

/// Helper methods and utilities for the wireframe theme
/// Now uses WireframeColorManager for all colors
class WireframeHelpers {
  WireframeHelpers._(); // Private constructor

  // ===== PROJECT UTILITIES =====

  /// Returns the appropriate color for a given project ID
  static Color getProjectColor(String projectId) {
    return WireframeColorManager.getProjectColor(projectId);
  }

  /// Returns the appropriate icon for a given project ID
  static IconData getProjectIcon(String projectId) {
    switch (projectId) {
      case 'tap-in':
        return Icons.sports_martial_arts;
      case 'moments':
        return Icons.camera_alt;
      case 'core-ai':
        return Icons.psychology;
      case 'plannie':
        return Icons.event_note;
      default:
        return Icons.work;
    }
  }

  /// Returns the project status for a given project ID
  static WireframeProjectStatus getProjectStatus(String projectId) {
    switch (projectId) {
      case 'tap-in':
        return WireframeProjectStatus.completed;
      case 'moments':
        return WireframeProjectStatus.inProgress;
      case 'core-ai':
        return WireframeProjectStatus.completed;
      case 'plannie':
        return WireframeProjectStatus.completed;
      default:
        return WireframeProjectStatus.draft;
    }
  }

  /// Returns a formatted project description
  static String getProjectDescription(String projectId,
      {bool isShort = false}) {
    final descriptions = {
      'tap-in': {
        'short': 'BJJ social platform',
        'full':
            'An inclusive mobile app that caters to the increasing demand for a unified integration of diverse Jiu-Jitsu training and cultural aspects.',
      },
      'moments': {
        'short': 'Social media redefined',
        'full':
            'A burgeoning B2C social media application aiming to redefine the landscape with authentic moments.',
      },
      'core-ai': {
        'short': 'AI analytics platform',
        'full':
            'An innovative B2B SaaS AI platform that analyzes associate metrics and offers actionable insights for continuous improvement.',
      },
      'plannie': {
        'short': 'Event planning made easy',
        'full':
            'Event planning platform that seamlessly connects planners and clients through an intuitive interface.',
      },
    };

    final projectDescriptions = descriptions[projectId] ??
        {
          'short': 'Portfolio project',
          'full': 'A portfolio project demonstrating UX/UI design skills.'
        };

    return isShort
        ? projectDescriptions['short']!
        : projectDescriptions['full']!;
  }

  // ===== URL UTILITIES =====

  /// Launches a URL using the url_launcher package
  static Future<bool> launchUrlSafely(String url) async {
    try {
      final uri = Uri.parse(url);
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Error launching URL: $e');
      return false;
    }
  }

  /// Launches an email client with pre-filled data
  static Future<bool> launchEmailClient({
    required String email,
    String? subject,
    String? body,
  }) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      query: [
        if (subject != null) 'subject=${Uri.encodeComponent(subject)}',
        if (body != null) 'body=${Uri.encodeComponent(body)}',
      ].join('&'),
    );

    return launchUrlSafely(uri.toString());
  }

  /// Launches a phone dialer
  static Future<bool> launchPhoneDialer(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    return launchUrlSafely(uri.toString());
  }

  // ===== FORMATTING UTILITIES =====

  /// Formats a date for display
  static String formatDate(DateTime date, {bool includeTime = false}) {
    if (includeTime) {
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  /// Formats a duration for display
  static String formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays} day${duration.inDays != 1 ? 's' : ''}';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} hour${duration.inHours != 1 ? 's' : ''}';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} minute${duration.inMinutes != 1 ? 's' : ''}';
    } else {
      return 'Just now';
    }
  }

  /// Truncates text with ellipsis
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - 3)}...';
  }

  // ===== VALIDATION UTILITIES =====

  /// Validates an email address
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  /// Validates a URL
  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && uri.hasAuthority;
    } catch (e) {
      return false;
    }
  }

  /// Validates that a string is not empty or just whitespace
  static bool isNotEmpty(String? text) {
    return text != null && text.trim().isNotEmpty;
  }

  /// Validates a name (allows letters, spaces, hyphens, apostrophes)
  static bool isValidName(String name) {
    final nameRegex = RegExp(r"^[a-zA-Z\s\-']+$");
    return nameRegex.hasMatch(name) && name.trim().isNotEmpty;
  }

  // ===== COLOR UTILITIES =====

  /// Generates a color based on a string (useful for consistent avatar colors)
  static Color generateColorFromString(String text) {
    int hash = 0;
    for (int i = 0; i < text.length; i++) {
      hash = text.codeUnitAt(i) + ((hash << 5) - hash);
    }

    final hue = (hash % 360).abs().toDouble();
    return HSLColor.fromAHSL(1.0, hue, 0.7, 0.5).toColor();
  }

  /// Returns a contrasting text color for a given background
  static Color getContrastingTextColor(Color backgroundColor) {
    return WireframeColorManager.getContrastingTextColor(backgroundColor);
  }

  // ===== WIDGET UTILITIES =====

  /// Creates a custom divider with wireframe styling
  static Widget createDivider({
    double height = 1.0,
    Color? color,
    double indent = 0.0,
    double endIndent = 0.0,
  }) {
    return Divider(
      height: height,
      color: color ?? WireframeColorManager.colors.border,
      indent: indent,
      endIndent: endIndent,
    );
  }

  /// Creates a wireframe-styled loading indicator
  static Widget createLoadingIndicator({
    Color? color,
    double? strokeWidth,
  }) {
    return CircularProgressIndicator(
      color: color ?? WireframeColorManager.colors.primary,
      strokeWidth: strokeWidth ?? 2.0,
    );
  }

  /// Creates a wireframe-styled error widget
  static Widget createErrorWidget(String message, {VoidCallback? onRetry}) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: WireframeColorManager.colors.error,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: WireframeColorManager.colors.text,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: WireframeColorManager.colors.primary,
              ),
              child: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }

  /// Creates a wireframe-styled empty state widget
  static Widget createEmptyState({
    required String title,
    String? subtitle,
    IconData? icon,
    Widget? action,
  }) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 64,
              color: WireframeColorManager.colors.secondary,
            ),
            const SizedBox(height: 16),
          ],
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: WireframeColorManager.colors.text,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: WireframeColorManager.colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (action != null) ...[
            const SizedBox(height: 24),
            action,
          ],
        ],
      ),
    );
  }

  // ===== DEBUG UTILITIES =====

  /// Logs debug information (only in debug mode)
  static void debugLog(String message, [String? tag]) {
    assert(() {
      final tagPrefix = tag != null ? '[$tag] ' : '';
      debugPrint('$tagPrefix$message');
      return true;
    }());
  }

  /// Creates a debug border widget (only visible in debug mode)
  static Widget debugBorder(Widget child, {Color? color}) {
    Widget result = child;
    assert(() {
      result = Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: color ?? WireframeColorManager.colors.error,
            width: 1,
          ),
        ),
        child: child,
      );
      return true;
    }());
    return result;
  }
}

// ===== ENUMS AND DATA CLASSES =====

/// Project status enumeration
enum WireframeProjectStatus {
  draft,
  inProgress,
  completed,
  archived,
}

/// Device type enumeration
enum WireframeDeviceType {
  mobile,
  tablet,
  desktop,
}

/// Animation direction enumeration
enum WireframeAnimationDirection {
  up,
  down,
  left,
  right,
}

/// Wireframe component configuration
class WireframeConfig {
  final bool enableAnimations;
  final bool enableDebugMode;
  final bool enableAccessibilityFeatures;
  final WireframeDeviceType targetDevice;
  final Duration defaultAnimationDuration;
  final String locale;

  const WireframeConfig({
    this.enableAnimations = true,
    this.enableDebugMode = false,
    this.enableAccessibilityFeatures = true,
    this.targetDevice = WireframeDeviceType.mobile,
    this.defaultAnimationDuration = const Duration(milliseconds: 300),
    this.locale = 'en',
  });

  /// Default configuration for development
  static const development = WireframeConfig(
    enableAnimations: true,
    enableDebugMode: true,
    enableAccessibilityFeatures: true,
  );

  /// Production configuration
  static const production = WireframeConfig(
    enableAnimations: true,
    enableDebugMode: false,
    enableAccessibilityFeatures: true,
  );

  /// Accessibility-focused configuration
  static const accessibility = WireframeConfig(
    enableAnimations: false,
    enableDebugMode: false,
    enableAccessibilityFeatures: true,
    defaultAnimationDuration: Duration(milliseconds: 100),
  );

  /// Performance-focused configuration
  static const performance = WireframeConfig(
    enableAnimations: false,
    enableDebugMode: false,
    enableAccessibilityFeatures: false,
    defaultAnimationDuration: Duration.zero,
  );

  /// Creates a copy of this config with overridden values
  WireframeConfig copyWith({
    bool? enableAnimations,
    bool? enableDebugMode,
    bool? enableAccessibilityFeatures,
    WireframeDeviceType? targetDevice,
    Duration? defaultAnimationDuration,
    String? locale,
  }) {
    return WireframeConfig(
      enableAnimations: enableAnimations ?? this.enableAnimations,
      enableDebugMode: enableDebugMode ?? this.enableDebugMode,
      enableAccessibilityFeatures:
          enableAccessibilityFeatures ?? this.enableAccessibilityFeatures,
      targetDevice: targetDevice ?? this.targetDevice,
      defaultAnimationDuration:
          defaultAnimationDuration ?? this.defaultAnimationDuration,
      locale: locale ?? this.locale,
    );
  }
}

/// Contact information data class
class WireframeContactInfo {
  final String name;
  final String email;
  final String? phone;
  final String? website;
  final String? linkedIn;
  final String? location;
  final String? resume;

  const WireframeContactInfo({
    required this.name,
    required this.email,
    this.phone,
    this.website,
    this.linkedIn,
    this.location,
    this.resume,
  });

  /// Default contact information for Jeff Anderson
  static const jeffAnderson = WireframeContactInfo(
    name: 'Jeff Anderson',
    email: 'JeffreyAndersonPDX@gmail.com',
    phone: '(503) 282-4647',
    website: 'https://jeffpdx.net',
    linkedIn: 'https://www.linkedin.com/in/jeffrey-anderson-pdx/',
    location: 'Portland, OR',
    resume:
        'https://storage.googleapis.com/uxfolio/643d6d8beaacf70002256d70/Resume_avP.pdf',
  );

  /// Creates a map representation of the contact info
  Map<String, String?> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'website': website,
      'linkedIn': linkedIn,
      'location': location,
      'resume': resume,
    };
  }

  /// Creates contact info from a map
  factory WireframeContactInfo.fromMap(Map<String, dynamic> map) {
    return WireframeContactInfo(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'],
      website: map['website'],
      linkedIn: map['linkedIn'],
      location: map['location'],
      resume: map['resume'],
    );
  }
}

/// Social media post data class
class WireframeSocialPost {
  final String id;
  final String author;
  final String content;
  final DateTime timestamp;
  final String avatarId;
  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final List<String> tags;
  final String? imageUrl;

  const WireframeSocialPost({
    required this.id,
    required this.author,
    required this.content,
    required this.timestamp,
    this.avatarId = 'person',
    this.likeCount = 0,
    this.commentCount = 0,
    this.isLiked = false,
    this.tags = const [],
    this.imageUrl,
  });

  /// Creates a copy of this post with updated values
  WireframeSocialPost copyWith({
    String? id,
    String? author,
    String? content,
    DateTime? timestamp,
    String? avatarId,
    int? likeCount,
    int? commentCount,
    bool? isLiked,
    List<String>? tags,
    String? imageUrl,
  }) {
    return WireframeSocialPost(
      id: id ?? this.id,
      author: author ?? this.author,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      avatarId: avatarId ?? this.avatarId,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      isLiked: isLiked ?? this.isLiked,
      tags: tags ?? this.tags,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  /// Toggles the like status
  WireframeSocialPost toggleLike() {
    return copyWith(
      isLiked: !isLiked,
      likeCount: isLiked ? likeCount - 1 : likeCount + 1,
    );
  }

  /// Adds a comment
  WireframeSocialPost addComment() {
    return copyWith(commentCount: commentCount + 1);
  }

  /// Creates a map representation
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'author': author,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'avatarId': avatarId,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'isLiked': isLiked,
      'tags': tags,
      'imageUrl': imageUrl,
    };
  }

  /// Creates post from a map
  factory WireframeSocialPost.fromMap(Map<String, dynamic> map) {
    return WireframeSocialPost(
      id: map['id'] ?? '',
      author: map['author'] ?? '',
      content: map['content'] ?? '',
      timestamp:
          DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
      avatarId: map['avatarId'] ?? 'person',
      likeCount: map['likeCount'] ?? 0,
      commentCount: map['commentCount'] ?? 0,
      isLiked: map['isLiked'] ?? false,
      tags: List<String>.from(map['tags'] ?? []),
      imageUrl: map['imageUrl'],
    );
  }
}

/// Project metadata data class
class WireframeProjectMeta {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String role;
  final String heroImagePath;
  final String? thumbnailPath;
  final WireframeProjectStatus status;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String> technologies;
  final List<String> teamMembers;
  final String? githubUrl;
  final String? liveUrl;

  const WireframeProjectMeta({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.role,
    required this.heroImagePath,
    this.thumbnailPath,
    this.status = WireframeProjectStatus.completed,
    this.startDate,
    this.endDate,
    this.technologies = const [],
    this.teamMembers = const [],
    this.githubUrl,
    this.liveUrl,
  });

  /// Gets the project duration as a formatted string
  String get duration {
    if (startDate == null) return 'Unknown duration';
    final end = endDate ?? DateTime.now();
    final difference = end.difference(startDate!);

    if (difference.inDays < 30) {
      return '${difference.inDays} days';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).round();
      return '$months month${months != 1 ? 's' : ''}';
    } else {
      final years = (difference.inDays / 365).round();
      return '$years year${years != 1 ? 's' : ''}';
    }
  }

  /// Gets the status as a display string
  String get statusDisplay {
    switch (status) {
      case WireframeProjectStatus.draft:
        return 'Draft';
      case WireframeProjectStatus.inProgress:
        return 'In Progress';
      case WireframeProjectStatus.completed:
        return 'Completed';
      case WireframeProjectStatus.archived:
        return 'Archived';
    }
  }

  /// Creates a copy with updated values
  WireframeProjectMeta copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? description,
    String? role,
    String? heroImagePath,
    String? thumbnailPath,
    WireframeProjectStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? technologies,
    List<String>? teamMembers,
    String? githubUrl,
    String? liveUrl,
  }) {
    return WireframeProjectMeta(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      role: role ?? this.role,
      heroImagePath: heroImagePath ?? this.heroImagePath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      technologies: technologies ?? this.technologies,
      teamMembers: teamMembers ?? this.teamMembers,
      githubUrl: githubUrl ?? this.githubUrl,
      liveUrl: liveUrl ?? this.liveUrl,
    );
  }
}
