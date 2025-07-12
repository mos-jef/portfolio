import 'package:flutter/material.dart';
import 'package:portfolio_website/themes/wireframe/utils/wireframe_color_manager.dart';
import 'package:portfolio_website/themes/wireframe/widgets/clickable_widget.dart';

import '../wireframe_layout_constants.dart';

/// Social media style post card for mobile
class WireframeMobileSocialCard extends StatelessWidget {
  final String author;
  final String timeAgo;
  final String content;
  final String avatarId;
  final String? imageUrl;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final bool isLiked;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onMore;

  const WireframeMobileSocialCard({
    Key? key,
    required this.author,
    required this.timeAgo,
    required this.content,
    required this.avatarId,
    this.imageUrl,
    this.likeCount = 0,
    this.commentCount = 0,
    this.shareCount = 0,
    this.isLiked = false,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 1),
      padding: EdgeInsets.all(WireframeLayoutConstants.spacingMedium),
      decoration: BoxDecoration(
        color: WireframeLayoutConstants.wireframeWhite,
        border: Border(
          bottom:
              BorderSide(color: WireframeLayoutConstants.wireframeLightGray),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with avatar and user info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: WireframeLayoutConstants.smallAvatarSize,
                height: WireframeLayoutConstants.smallAvatarSize,
                decoration: BoxDecoration(
                  color: _getAvatarColor(avatarId).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                      WireframeLayoutConstants.smallAvatarSize / 2),
                  border: Border.all(color: _getAvatarColor(avatarId)),
                ),
                child: Icon(
                  _getAvatarIcon(avatarId),
                  size: 16,
                  color: _getAvatarColor(avatarId),
                ),
              ),
              SizedBox(width: WireframeLayoutConstants.spacingSmall),

              // User info and content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User name and more button
                    Row(
                      children: [
                        Text(
                          author,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize:
                                WireframeLayoutConstants.mobileFontSizeBody,
                            color: WireframeColorManager.colors.border,
                          ),
                        ),
                        Spacer(),
                        if (onMore != null)
                          ClickableWidget(
                            onTap: onMore,
                            child: Icon(
                              Icons.more_vert,
                              size: 14,
                              color:
                                  WireframeLayoutConstants.wireframeSecondary,
                            ),
                          ),
                      ],
                    ),

                    // Time
                    Text(
                      timeAgo,
                      style: TextStyle(
                        color: WireframeColorManager
                            .colors.disabled, // affects timestamp color
                        fontSize:
                            WireframeLayoutConstants.mobileFontSizeCaption,
                      ),
                    ),

                    SizedBox(height: WireframeLayoutConstants.spacingTiny),

                    // Content
                    Text(
                      content,
                      style: TextStyle(
                        fontSize: WireframeLayoutConstants.mobileFontSizeBody,
                        color: WireframeColorManager.colors.text,
                        height: 1.3,
                      ),
                    ),

                    // Image if provided
                    if (imageUrl != null) ...[
                      SizedBox(height: WireframeLayoutConstants.spacingSmall),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                            WireframeLayoutConstants.radiusMedium),
                        child: Image.asset(
                          imageUrl!,
                          width: double.infinity,
                          height: 160,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: double.infinity,
                              height: 160,
                              color:
                                  WireframeLayoutConstants.wireframeLightGray,
                              child: Icon(
                                Icons.image_not_supported,
                                color:
                                    WireframeLayoutConstants.wireframeSecondary,
                              ),
                            );
                          },
                        ),
                      ),
                    ],

                    SizedBox(height: WireframeLayoutConstants.spacingSmall),

                    // Action buttons
                    _buildMobileActions(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileActions() {
    return Row(
      children: [
        _buildMobileActionButton(
          isLiked ? Icons.favorite : Icons.favorite_outline,
          likeCount.toString(),
          onLike,
          color: isLiked ? WireframeLayoutConstants.wireframeDanger : null,
        ),
        SizedBox(width: WireframeLayoutConstants.spacingMedium),
        _buildMobileActionButton(
          Icons.chat_bubble_outline,
          commentCount > 0 ? commentCount.toString() : '',
          onComment,
        ),
        SizedBox(width: WireframeLayoutConstants.spacingMedium),
        _buildMobileActionButton(
          Icons.repeat,
          shareCount > 0 ? shareCount.toString() : '',
          null,
        ),
        SizedBox(width: WireframeLayoutConstants.spacingMedium),
        _buildMobileActionButton(
          Icons.share_outlined,
          '',
          onShare,
        ),
      ],
    );
  }

  Widget _buildMobileActionButton(
    IconData icon,
    String count,
    VoidCallback? onTap, {
    Color? color,
  }) {
    return ClickableWidget(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 12,
            color: color ?? WireframeLayoutConstants.wireframeSecondary,
          ),
          if (count.isNotEmpty) ...[
            SizedBox(width: WireframeLayoutConstants.spacingTiny),
            Text(
              count,
              style: TextStyle(
                fontSize: WireframeLayoutConstants.mobileFontSizeCaption,
                color: WireframeLayoutConstants.wireframeSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getAvatarColor(String avatarId) {
    final avatarColors = {
      'person': WireframeLayoutConstants.wireframeAccent,
      'face': WireframeLayoutConstants.wireframeSuccess,
      'account_circle': WireframeLayoutConstants.wireframeDanger,
      'sentiment_satisfied': Color(0xFF6F42C1),
      'emoji_people': Color(0xFFFD7E14),
    };
    return avatarColors[avatarId] ?? WireframeLayoutConstants.wireframeAccent;
  }

  IconData _getAvatarIcon(String avatarId) {
    final avatarIcons = {
      'person': Icons.person,
      'face': Icons.face,
      'account_circle': Icons.account_circle,
      'sentiment_satisfied': Icons.sentiment_satisfied,
      'emoji_people': Icons.emoji_people,
    };
    return avatarIcons[avatarId] ?? Icons.person;
  }
}

/// Social media style post card for desktop
class WireframeDesktopSocialCard extends StatelessWidget {
  final String author;
  final String timeAgo;
  final String content;
  final String avatarId;
  final String? imageUrl;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final bool isLiked;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onMore;

  const WireframeDesktopSocialCard({
    Key? key,
    required this.author,
    required this.timeAgo,
    required this.content,
    required this.avatarId,
    this.imageUrl,
    this.likeCount = 0,
    this.commentCount = 0,
    this.shareCount = 0,
    this.isLiked = false,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 1),
      padding: EdgeInsets.all(WireframeLayoutConstants.spacingStandard),
      decoration: BoxDecoration(
        color: WireframeLayoutConstants.wireframeWhite,
        border: Border(
          bottom:
              BorderSide(color: WireframeLayoutConstants.wireframeLightGray),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: WireframeLayoutConstants.mediumAvatarSize,
            height: WireframeLayoutConstants.mediumAvatarSize,
            decoration: BoxDecoration(
              color: _getAvatarColor(avatarId).withOpacity(0.1),
              borderRadius: BorderRadius.circular(
                  WireframeLayoutConstants.mediumAvatarSize / 2),
              border: Border.all(color: _getAvatarColor(avatarId)),
            ),
            child: Icon(
              _getAvatarIcon(avatarId),
              size: 20,
              color: _getAvatarColor(avatarId),
            ),
          ),
          SizedBox(width: WireframeLayoutConstants.spacingMedium),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with name and more button
                Row(
                  children: [
                    Text(
                      author,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: WireframeLayoutConstants.desktopFontSizeBody,
                        color: WireframeColorManager.colors.text,
                      ),
                    ),
                    Spacer(),
                    if (onMore != null)
                      ClickableWidget(
                        onTap: onMore,
                        child: Icon(
                          Icons.more_vert,
                          size: 18,
                          color: WireframeLayoutConstants.wireframeSecondary,
                        ),
                      ),
                  ],
                ),

                // Time
                Text(
                  timeAgo,
                  style: TextStyle(
                    color: WireframeColorManager
                        .colors.disabled, // affects timestamp color
                    fontSize: WireframeLayoutConstants.mobileFontSizeBody,
                  ),
                ),

                SizedBox(height: WireframeLayoutConstants.spacingSmall),

                // Content
                Text(
                  content,
                  style: TextStyle(
                    fontSize: WireframeLayoutConstants.desktopFontSizeBody,
                    color: WireframeColorManager.colors.text,
                    height: 1.4,
                  ),
                ),

                // Image if provided
                if (imageUrl != null) ...[
                  SizedBox(height: WireframeLayoutConstants.spacingMedium),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                        WireframeLayoutConstants.radiusMedium),
                    child: Image.asset(
                      imageUrl!,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 200,
                          color: WireframeLayoutConstants.wireframeLightGray,
                          child: Icon(
                            Icons.image_not_supported,
                            color: WireframeLayoutConstants.wireframeSecondary,
                            size: 48,
                          ),
                        );
                      },
                    ),
                  ),
                ],

                SizedBox(height: WireframeLayoutConstants.spacingMedium),

                // Action buttons
                _buildDesktopActions(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopActions() {
    return Row(
      children: [
        _buildDesktopActionButton(
          isLiked ? Icons.favorite : Icons.favorite_outline,
          'Like',
          likeCount > 0 ? likeCount.toString() : '',
          onLike,
          color: isLiked ? WireframeLayoutConstants.wireframeDanger : null,
        ),
        SizedBox(width: WireframeLayoutConstants.spacingLarge),
        _buildDesktopActionButton(
          Icons.chat_bubble_outline,
          'Comment',
          commentCount > 0 ? commentCount.toString() : '',
          onComment,
        ),
        SizedBox(width: WireframeLayoutConstants.spacingLarge),
        _buildDesktopActionButton(
          Icons.repeat,
          'Repost',
          shareCount > 0 ? shareCount.toString() : '',
          null,
        ),
        SizedBox(width: WireframeLayoutConstants.spacingLarge),
        _buildDesktopActionButton(
          Icons.share_outlined,
          'Share',
          '',
          onShare,
        ),
      ],
    );
  }

  Widget _buildDesktopActionButton(
    IconData icon,
    String label,
    String count,
    VoidCallback? onTap, {
    Color? color,
  }) {
    return ClickableWidget(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: color ?? WireframeLayoutConstants.wireframeSecondary,
          ),
          SizedBox(width: WireframeLayoutConstants.spacingSmall),
          Text(
            label,
            style: TextStyle(
              fontSize: WireframeLayoutConstants.desktopFontSizeBody,
              color: WireframeLayoutConstants.wireframeSecondary,
            ),
          ),
          if (count.isNotEmpty) ...[
            SizedBox(width: WireframeLayoutConstants.spacingTiny),
            Text(
              count,
              style: TextStyle(
                fontSize: WireframeLayoutConstants.desktopFontSizeBody,
                color: WireframeLayoutConstants.wireframeSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getAvatarColor(String avatarId) {
    final avatarColors = {
      'person': WireframeLayoutConstants.wireframeAccent,
      'face': WireframeLayoutConstants.wireframeSuccess,
      'account_circle': WireframeLayoutConstants.wireframeDanger,
      'sentiment_satisfied': Color(0xFF6F42C1),
      'emoji_people': Color(0xFFFD7E14),
    };
    return avatarColors[avatarId] ?? WireframeLayoutConstants.wireframeAccent;
  }

  IconData _getAvatarIcon(String avatarId) {
    final avatarIcons = {
      'person': Icons.person,
      'face': Icons.face,
      'account_circle': Icons.account_circle,
      'sentiment_satisfied': Icons.sentiment_satisfied,
      'emoji_people': Icons.emoji_people,
    };
    return avatarIcons[avatarId] ?? Icons.person;
  }
}

/// Story-style card for social feeds
class WireframeStoryCard extends StatelessWidget {
  final String userName;
  final String userAvatar;
  final String storyImageUrl;
  final bool hasNewStory;
  final VoidCallback onTap;

  const WireframeStoryCard({
    Key? key,
    required this.userName,
    required this.userAvatar,
    required this.storyImageUrl,
    this.hasNewStory = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClickableWidget(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: EdgeInsets.only(right: WireframeLayoutConstants.spacingSmall),
        child: Column(
          children: [
            // Story circle
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: hasNewStory
                      ? WireframeLayoutConstants.wireframeAccent
                      : WireframeLayoutConstants.wireframeBorder,
                  width: 2,
                ),
              ),
              child: Container(
                margin: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(storyImageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            SizedBox(height: WireframeLayoutConstants.spacingTiny),

            // User name
            Text(
              userName,
              style: TextStyle(
                fontSize: WireframeLayoutConstants.mobileFontSizeCaption,
                color: WireframeColorManager.colors.border,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Feed header component
class WireframeFeedHeader extends StatelessWidget {
  final String title;
  final Widget? action;

  const WireframeFeedHeader({
    Key? key,
    required this.title,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(WireframeLayoutConstants.spacingStandard),
      decoration: BoxDecoration(
        color: WireframeLayoutConstants.wireframeWhite,
        border: Border(
          bottom: BorderSide(color: WireframeColorManager.colors.border),
        ),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: WireframeLayoutConstants.desktopFontSizeTitle,
              fontWeight: FontWeight.bold,
              color: WireframeColorManager.colors.text,
            ),
          ),
          if (action != null) ...[
            Spacer(),
            action!,
          ],
        ],
      ),
    );
  }
}

/// Social media utilities and helpers
class WireframeSocialUtils {
  /// Create a default social post
  static Map<String, dynamic> createPost({
    required String author,
    required String content,
    String avatarId = 'person',
    String? imageUrl,
    int likeCount = 0,
    int commentCount = 0,
    int shareCount = 0,
    bool isLiked = false,
  }) {
    return {
      'author': author,
      'timeAgo': _generateTimeAgo(),
      'content': content,
      'avatarId': avatarId,
      'imageUrl': imageUrl,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'shareCount': shareCount,
      'isLiked': isLiked,
    };
  }

  /// Generate random time ago strings
  static String _generateTimeAgo() {
    final options = [
      'Just now',
      '2m ago',
      '15m ago',
      '1h ago',
      '3h ago',
      '1d ago',
      '2d ago',
    ];
    return options[DateTime.now().millisecond % options.length];
  }

  /// Get default demo posts
  static List<Map<String, dynamic>> getDefaultSocialPosts() {
    return [
      createPost(
        author: 'Aminah',
        content:
            'Jeff is a UX/UI Designer from Portland, Oregon. Check out his projects!',
        avatarId: 'person',
        likeCount: 24,
        commentCount: 8,
      ),
      createPost(
        author: 'Jeffjitsu',
        content:
            'Make sure to poke around his profile! It\'s full of fun interactive elements, themes, and modes!',
        avatarId: 'face',
        likeCount: 15,
        commentCount: 3,
        isLiked: true,
      ),
    ];
  }

  /// Available avatar types
  static List<String> getAvailableAvatars() {
    return [
      'person',
      'face',
      'account_circle',
      'sentiment_satisfied',
      'emoji_people'
    ];
  }

  /// Format engagement numbers
  static String formatEngagementCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    } else {
      return count.toString();
    }
  }

  /// Generate realistic engagement numbers
  static Map<String, int> generateEngagementNumbers() {
    final random = DateTime.now().millisecondsSinceEpoch;
    return {
      'likes': 5 + (random % 50),
      'comments': 1 + (random % 10),
      'shares': random % 5,
    };
  }
}
