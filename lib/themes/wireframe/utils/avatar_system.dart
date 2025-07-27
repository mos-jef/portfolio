// File: lib/themes/wireframe/utils/avatar_system.dart
import 'package:flutter/material.dart';
import 'package:avatar_brick/avatar_brick.dart';
import 'package:portfolio_website/widgets/border_beam.dart';
import '../wireframe_layout_constants.dart';
import 'wireframe_color_manager.dart';

class AvatarSystem {
  // Available custom avatars - using GitHub raw URLs
  static const List<String> customAvatars = [
    'https://raw.githubusercontent.com/mos-jef/portfolio-avatars/main/avatar1.png',
    'https://raw.githubusercontent.com/mos-jef/portfolio-avatars/main/avatar2.png',
    'https://raw.githubusercontent.com/mos-jef/portfolio-avatars/main/avatar3.png',
    'https://raw.githubusercontent.com/mos-jef/portfolio-avatars/main/avatar4.png',
    'https://raw.githubusercontent.com/mos-jef/portfolio-avatars/main/avatar5.png',
    'https://raw.githubusercontent.com/mos-jef/portfolio-avatars/main/avatar6.png',
    'https://raw.githubusercontent.com/mos-jef/portfolio-avatars/main/avatar7.png',
    'https://raw.githubusercontent.com/mos-jef/portfolio-avatars/main/avatar8.png',
    'https://raw.githubusercontent.com/mos-jef/portfolio-avatars/main/avatar9.png',
    'https://raw.githubusercontent.com/mos-jef/portfolio-avatars/main/avatar10.png',
    'https://raw.githubusercontent.com/mos-jef/portfolio-avatars/main/avatar11.png',
    'https://raw.githubusercontent.com/mos-jef/portfolio-avatars/main/avatar12.png',
  ];

  // Legacy icon avatars (for backward compatibility)
  static const List<String> iconAvatars = [
    'person',
    'face',
    'account_circle',
    'sentiment_satisfied',
    'emoji_people',
  ];

  /// Build avatar widget based on avatar type
  static Widget buildAvatar({
    required String avatarId,
    required String userName,
    required double size,
    bool showBorder = false,
    Color? borderColor,
  }) {
    // Check if this is the portfolio owner (Jeff)
    if (_isPortfolioOwner(userName)) {
      return _buildPortfolioOwnerAvatar(
        size: size,
        showBorder: showBorder,
        borderColor: borderColor,
      );
    }

    // Check if it's a custom avatar
    if (customAvatars.contains(avatarId)) {
      return _buildCustomAvatar(
        avatarPath: avatarId,
        size: size,
        showBorder: showBorder,
        borderColor: borderColor,
      );
    }

    // Check if it's a legacy icon avatar
    if (iconAvatars.contains(avatarId)) {
      return _buildIconAvatar(
        iconId: avatarId,
        size: size,
        showBorder: showBorder,
        borderColor: borderColor,
      );
    }

    // Fallback to generated avatar from name
    return _buildGeneratedAvatar(
      userName: userName,
      size: size,
      showBorder: showBorder,
      borderColor: borderColor,
    );
  }

  /// Check if the user is the portfolio owner
  static bool _isPortfolioOwner(String userName) {
    const ownerNames = [
      'Jeff',
      'Jeffjitsu',
      'jeffjitsu',
      'jeff'
    ]; // Add your variations
    return ownerNames.contains(userName);
  }

  /// Build special avatar for portfolio owner
  static Widget _buildPortfolioOwnerAvatar({
    required double size,
    bool showBorder = false,
    Color? borderColor,
  }) {
    return BorderBeam(
      duration: 8, // Slower animation for subtle effect
      borderWidth: showBorder ? 3 : 2,
      colorFrom: WireframeColorManager.colors.primary,
      colorTo: WireframeColorManager.colors.secondary ??
          WireframeColorManager.colors.primary,
      staticBorderColor: WireframeColorManager.colors.primary.withOpacity(0.3),
      borderRadius: BorderRadius.circular(size / 2), // Make it circular
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent, // Remove background to show BorderBeam
        ),
        child: ClipOval(
          child: Image.asset(
            'assets/me_avatar.png', // Your special avatar image
            fit: BoxFit.cover,
            alignment: Alignment(0, -0.3), // Same alignment as in about section
            errorBuilder: (context, error, stackTrace) {
              // Fallback to a special icon if image fails
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      WireframeColorManager.colors.surface,
                      WireframeColorManager.colors.surface.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Icon(
                  Icons.star, // Special icon for owner
                  size: size * 0.5,
                  color: Colors.white,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// Build custom image avatar
  static Widget _buildCustomAvatar({
    required String avatarPath,
    required double size,
    bool showBorder = false,
    Color? borderColor,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(
                color: borderColor ?? WireframeColorManager.colors.border,
                width: 2)
            : null,
      ),
      child: ClipOval(
        child: avatarPath.startsWith('http')
            ? Image.network(
                avatarPath,
                width: size,
                height: size,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: WireframeColorManager.colors.surface,
                    ),
                    child: Center(
                      child: SizedBox(
                        width: size * 0.3,
                        height: size * 0.3,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: WireframeColorManager.colors.primary,
                        ),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to generated avatar if image fails to load
                  return _buildGeneratedAvatar(
                    userName: 'User',
                    size: size,
                    showBorder: false,
                  );
                },
              )
            : Image.asset(
                avatarPath,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to generated avatar if image fails to load
                  return _buildGeneratedAvatar(
                    userName: 'User',
                    size: size,
                    showBorder: false,
                  );
                },
              ),
      ),
    );
  }

  /// Build icon-based avatar (legacy)
  static Widget _buildIconAvatar({
    required String iconId,
    required double size,
    bool showBorder = false,
    Color? borderColor,
  }) {
    final color = _getAvatarColor(iconId);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(color: borderColor ?? color, width: 2)
            : Border.all(color: color, width: 2),
      ),
      child: Icon(
        _getAvatarIcon(iconId),
        size: size * 0.5,
        color: color,
      ),
    );
  }

  
  /// Build generated avatar from name using simple approach
  static Widget _buildGeneratedAvatar({
    required String userName,
    required double size,
    bool showBorder = false,
    Color? borderColor,
  }) {
    final initials = _getInitials(userName);
    final backgroundColor = _generateColorFromName(userName);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        border: showBorder
            ? Border.all(
                color: borderColor ?? WireframeColorManager.colors.border,
                width: 2)
            : null,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.4, // Scale font size with avatar size
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// Get initials from name
  static String _getInitials(String name) {
    if (name.isEmpty) return 'U';

    final words = name.trim().split(' ');
    if (words.length == 1) {
      return words[0].substring(0, 1).toUpperCase();
    } else {
      return (words[0].substring(0, 1) + words[1].substring(0, 1))
          .toUpperCase();
    }
  }

  /// Generate consistent color from name
  static Color _generateColorFromName(String name) {
    final colors = [
      WireframeColorManager.colors.primary,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];

    if (name.isEmpty) return colors[0];

    int hash = 0;
    for (int i = 0; i < name.length; i++) {
      hash = name.codeUnitAt(i) + ((hash << 5) - hash);
    }
    return colors[hash.abs() % colors.length];
  }

  /// Legacy color mapping for icon avatars
  static Color _getAvatarColor(String avatarId) {
    final avatarColors = {
      'person': WireframeColorManager.colors.primary,
      'face': Colors.green,
      'account_circle': Colors.red,
      'sentiment_satisfied': Colors.purple,
      'emoji_people': Colors.orange,
    };
    return avatarColors[avatarId] ?? WireframeColorManager.colors.primary;
  }

  /// Legacy icon mapping
  static IconData _getAvatarIcon(String avatarId) {
    final avatarIcons = {
      'person': Icons.person,
      'face': Icons.face,
      'account_circle': Icons.account_circle,
      'sentiment_satisfied': Icons.sentiment_satisfied,
      'emoji_people': Icons.emoji_people,
    };
    return avatarIcons[avatarId] ?? Icons.person;
  }

  /// Get all available avatars for selection
  static List<Map<String, dynamic>> getAllAvatars() {
    List<Map<String, dynamic>> allAvatars = [];

    // Add only custom avatars from GitHub
    for (String avatar in customAvatars) {
      allAvatars.add({
        'id': avatar,
        'type': '',
        'name': 'Avatar ${customAvatars.indexOf(avatar) + 1}',
      });
    }

    // Keep the name-based generated avatar as an option
    allAvatars.add({
      'id': 'generated',
      'type': '',
      'name': 'Generate from Name',
    });

    // Removed all icon avatars (person, face, account_circle, etc.)

    return allAvatars;
  }

  /// Check if avatar is custom image
  static bool isCustomAvatar(String avatarId) {
    return customAvatars.contains(avatarId);
  }

  /// Check if avatar is icon-based
  static bool isIconAvatar(String avatarId) {
    return iconAvatars.contains(avatarId);
  }

  /// Check if avatar should be generated
  static bool isGeneratedAvatar(String avatarId) {
    return avatarId == 'generated' ||
        (!isCustomAvatar(avatarId) && !isIconAvatar(avatarId));
  }

  /// Get random custom avatar
  static String getRandomCustomAvatar() {
    return customAvatars[
        DateTime.now().millisecondsSinceEpoch % customAvatars.length];
  }

  /// Get default avatar for new users
  static String getDefaultAvatar() {
    return 'generated'; // Default to name-generated avatar
  }
}
