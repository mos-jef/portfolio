// File: lib/themes/wireframe/widgets/enhanced_social_post.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:portfolio_website/services/analytics_service.dart';
import 'package:portfolio_website/themes/wireframe/widgets/clickable_widget.dart';
import 'package:portfolio_website/themes/wireframe/widgets/pin_auth_dialog.dart';
import 'package:portfolio_website/themes/wireframe/widgets/svg_icon.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../firestore/firestore_models.dart';
import '../../../firestore/firestore_service.dart';

import '../utils/avatar_system.dart';
import '../utils/wireframe_color_manager.dart';
import '../wireframe_layout_constants.dart';

// MAKING MYSELF ADMIN - HARDCODING MY ID
class AdminConfig {
  static const List<String> adminUserIds = [
    'YOUR_ACTUAL_FIREBASE_AUTH_UID', // Get this from Firebase Console > Authentication
    // Add more admin IDs as needed
  ];

  static const List<String> adminUserNames = [
    'Jeff',
    'Jeffjitsu',
    'Jeffrey Anderson', // Add your variations
  ];
}

class EnhancedSocialPost extends StatefulWidget {
  final SocialPost post;
  final bool isMobile;
  final VoidCallback? onPostUpdated;
  final VoidCallback? onPostDeleted;

  EnhancedSocialPost({
    Key? key,
    required this.post,
    required this.isMobile,
    this.onPostUpdated,
    this.onPostDeleted,
  }) : super(key: key ?? ValueKey(post.id)); // ← Add this ValueKey

  @override
  State<EnhancedSocialPost> createState() => _EnhancedSocialPostState();
}

class _EnhancedSocialPostState extends State<EnhancedSocialPost>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  // Use ValueNotifier to prevent flickering
  late ValueNotifier<SocialPost> _postNotifier;
  late AnimationController _likeAnimationController;
  late Animation<double> _likeScaleAnimation;
  bool _showEmojiPicker = false;
  bool _isEditing = false;
  late TextEditingController _editController;

  // Debouncing timer to prevent excessive updates
  Timer? _updateDebounceTimer;
  static const Duration _debounceDuration = Duration(milliseconds: 300);

  // Add these for stability
  String? _cachedPostId;
  bool _isDisposed = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _cachedPostId = widget.post.id;
    _postNotifier = ValueNotifier<SocialPost>(widget.post);
    _editController = TextEditingController(text: widget.post.content);

    // Initialize the animation controller
    _likeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _likeScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _likeAnimationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void didUpdateWidget(EnhancedSocialPost oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only update if this is the same post (prevent flickering from rebuilds)
    if (oldWidget.post.id == widget.post.id && !_isDisposed) {
      // Debounce updates to prevent excessive rebuilds
      _updateDebounceTimer?.cancel();
      _updateDebounceTimer = Timer(Duration(milliseconds: 50), () {
        if (!_isDisposed && mounted) {
          _postNotifier.value = widget.post;
        }
      });
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _updateDebounceTimer?.cancel();
    _likeAnimationController.dispose();
    _editController.dispose();
    _postNotifier.dispose();
    super.dispose();
  }

  // Debounced update method to prevent excessive parent rebuilds
  void _debouncedParentUpdate() {
    _updateDebounceTimer?.cancel();
    _updateDebounceTimer = Timer(_debounceDuration, () {
      widget.onPostUpdated?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // ← Add this line for AutomaticKeepAliveClientMixin
    return ValueListenableBuilder<SocialPost>(
      valueListenable: _postNotifier,
      builder: (context, currentPost, child) {
      // Prevent rebuilding if disposed
      if (_isDisposed) {
        return SizedBox.shrink();
      }
      
      return RepaintBoundary(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 1),
          padding: EdgeInsets.all(widget.isMobile
              ? WireframeLayoutConstants.spacingMedium
              : WireframeLayoutConstants.spacingStandard),
          decoration: BoxDecoration(
            color: WireframeColorManager.colors.surface,
            border: Border(
              bottom: BorderSide(
                color: WireframeColorManager.colors.border!,
                width: 0.5,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPostHeader(currentPost),
              SizedBox(height: WireframeLayoutConstants.spacingSmall),
              _buildPostContent(currentPost),
              SizedBox(height: WireframeLayoutConstants.spacingMedium),
              _buildPostActions(currentPost),
             ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPostHeader(SocialPost post) {
    return Row(
      children: [
        // Avatar
        Container(
          width: widget.isMobile ? 32 : 40,
          height: widget.isMobile ? 32 : 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: WireframeColorManager.colors.surfaceVariant,
          ),
          child: ClipOval(
            child: AvatarSystem.buildAvatar(
              avatarId: post.authorAvatar,
              userName: post.authorName,
              size: widget.isMobile ? 32.0 : 40.0,
              showBorder: false,
            ),
          ),
        ),
        SizedBox(width: WireframeLayoutConstants.spacingSmall),

        // Author info and timestamp
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    post.authorName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: widget.isMobile
                          ? WireframeLayoutConstants.mobileFontSizeBody
                          : WireframeLayoutConstants.desktopFontSizeBody,
                      color: WireframeColorManager.colors.text,
                    ),
                  ),
                  if (post.isPinned) ...[
                    SizedBox(width: 4),
                    Icon(
                      Icons.push_pin,
                      size: 12,
                      color: WireframeColorManager.colors.primary,
                    ),
                  ],
                ],
              ),
              Text(
                timeago.format(post.createdAt),
                style: TextStyle(
                  fontSize: widget.isMobile
                      ? WireframeLayoutConstants.mobileFontSizeCaption
                      : WireframeLayoutConstants.mobileFontSizeBody - 2,
                  color: WireframeColorManager.colors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        // More options menu
        if (_canModifyPost(post) || _canPin())
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(value, post),
            icon: Icon(
              Icons.more_vert,
              size: 16,
              color: WireframeColorManager.colors.textSecondary,
            ),
            itemBuilder: (context) => [
              if (_canModifyPost(post)) ...[
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 16),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 16, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
              if (_canPin()) ...[
                PopupMenuItem(
                  value: post.isPinned ? 'unpin' : 'pin',
                  child: Row(
                    children: [
                      Icon(
                        post.isPinned
                            ? Icons.push_pin_outlined
                            : Icons.push_pin,
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Text(post.isPinned ? 'Unpin' : 'Pin'),
                    ],
                  ),
                ),
              ],
            ],
          ),
      ],
    );
  }

  Widget _buildPostContent(SocialPost post) {
    if (_isEditing) {
      return Column(
        children: [
          TextField(
            controller: _editController,
            maxLines: null,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Edit your post...',
            ),
            style: TextStyle(
              fontSize: widget.isMobile
                  ? WireframeLayoutConstants.mobileFontSizeBody
                  : WireframeLayoutConstants.desktopFontSizeBody,
              color: WireframeColorManager.colors.text,
              height: 1.4,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              ElevatedButton(
                onPressed: _saveEdit,
                child: Text('Save'),
              ),
              SizedBox(width: 8),
              TextButton(
                onPressed: _cancelEdit,
                child: Text('Cancel'),
              ),
            ],
          ),
        ],
      );
    }

    return Text(
      post.content,
      style: TextStyle(
        fontSize: widget.isMobile
            ? WireframeLayoutConstants.mobileFontSizeBody
            : WireframeLayoutConstants.desktopFontSizeBody,
        color: WireframeColorManager.colors.text,
        height: 1.4,
      ),
    );
  }

  Widget _buildPostActions(SocialPost post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Show existing reactions if any
        _buildExistingReactions(post),

        SizedBox(height: WireframeLayoutConstants.spacingSmall),

        Row(
          children: [
            // Only emoji reaction button - no more shaka
            ClickableWidget(
              onTap: () => setState(() => _showEmojiPicker = !_showEmojiPicker),
              child: Row(
                children: [
                  SvgIcon(
                    assetPath: SvgIconPaths.shakayellow,
                    size: widget.isMobile ? 16 : 20,
                    color: _showEmojiPicker
                        ? WireframeColorManager.colors.primary
                        : WireframeColorManager.colors.textSecondary,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'React',
                    style: TextStyle(
                      fontSize: widget.isMobile
                          ? WireframeLayoutConstants.mobileFontSizeCaption
                          : WireframeLayoutConstants.mobileFontSizeBody,
                      color: _showEmojiPicker
                          ? WireframeColorManager.colors.primary
                          : WireframeColorManager.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Emoji reaction picker
        if (_showEmojiPicker && !_isEditing) _buildEmojiReactionPicker(),
      ],
    );
  }

  Widget _buildExistingReactions(SocialPost post) {
    final reactions = _getPostReactions(post);

    if (reactions.isEmpty) return SizedBox.shrink();

    return Wrap(
      spacing: 4,
      children: reactions.entries.map((entry) {
        final hasUserReacted =
            FirestoreService().hasUserReacted(post.reactions, entry.key);

        return ClickableWidget(
          onTap: () => _toggleReaction(entry.key),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: hasUserReacted
                  ? WireframeColorManager.colors.primary.withOpacity(0.1)
                  : WireframeColorManager.colors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasUserReacted
                    ? WireframeColorManager.colors.primary
                    : WireframeColorManager.colors.border!,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  entry.key, // ✅ Show emoji as text
                  style: TextStyle(
                      fontSize: widget.isMobile ? 12 : 14), // Smaller emoji
                ),
                SizedBox(width: 2), // Smaller spacing
                Text(
                  '${entry.value}', // The count
                  style: TextStyle(
                    fontSize: widget.isMobile ? 10 : 12, // Smaller count text
                    color: WireframeColorManager.colors.text,
                    fontWeight:
                        hasUserReacted ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void _toggleReaction(String emojiText) async {
    // IMMEDIATE UI UPDATE (Optimistic) - NO setState, use ValueNotifier
    final currentReactions =
        Map<String, dynamic>.from(_postNotifier.value.reactions);
    final userReactionKey = '${FirestoreService().currentUser?.id}_$emojiText';

    if (currentReactions.containsKey(userReactionKey)) {
      // Remove reaction optimistically
      currentReactions.remove(userReactionKey);
    } else {
      // Add reaction optimistically
      currentReactions[userReactionKey] = {
        'userId': FirestoreService().currentUser?.id,
        'userName': FirestoreService().currentUser?.name,
        'emoji': emojiText,
        'timestamp':
            DateTime.now(), // Use local timestamp for immediate display
      };
    }

    // Update using ValueNotifier instead of setState - prevents flickering
    _postNotifier.value =
        _postNotifier.value.copyWith(reactions: currentReactions);

    // Background operations (Fire and forget)
    _performBackgroundReactionUpdate(emojiText);
  }

  // Separate method for background operations
  void _performBackgroundReactionUpdate(String emojiText) async {
    try {
      // Run Firestore and Analytics in parallel (not sequential)
      final futures = [
        FirestoreService().addReactionToPost(_postNotifier.value.id, emojiText),
        AnalyticsService()
            .trackSocialReaction(_postNotifier.value.id, emojiText),
      ];

      await Future.wait(futures);

      print('🐛 DEBUG: Background reaction update completed');

      // Use debounced parent update to prevent excessive rebuilds
      _debouncedParentUpdate();
    } catch (e) {
      print('🐛 DEBUG: Background reaction error: $e');

      // Revert optimistic update on error - use debounced update
      _debouncedParentUpdate();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add reaction: $e')),
        );
      }
    }
  }

  Map<String, int> _getPostReactions(SocialPost post) {
    final reactions = FirestoreService().getReactionCounts(post.reactions);
    return reactions;
  }

  // method to get popular emojis (renamed - they're not animated)
  List<Map<String, dynamic>> _getPopularEmojis() {
    return [
      {'emoji': '👍', 'name': 'thumbs_up'},
      {'emoji': '❤️', 'name': 'heart'},
      {'emoji': '😂', 'name': 'joy'},
      {'emoji': '😮', 'name': 'open_mouth'},
      {'emoji': '😢', 'name': 'cry'},
      {'emoji': '😡', 'name': 'rage'},
      {'emoji': '🚀', 'name': 'rocket'},
      {'emoji': '🎉', 'name': 'party_popper'},
      {'emoji': '🔥', 'name': 'fire'},
      {'emoji': '💯', 'name': 'hundred'},
    ];
  }

  Widget _buildEmojiReactionPicker() {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      height: widget.isMobile ? 50 : 60,
      decoration: BoxDecoration(
        color: WireframeColorManager.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: WireframeColorManager.colors.border!),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _getPopularEmojis().length,
        itemBuilder: (context, index) {
          final emojiData = _getPopularEmojis()[index];
          return ClickableWidget(
            onTap: () => _selectEmoji(emojiData['emoji']),
            child: Container(
              margin: EdgeInsets.only(right: 8),
              padding: EdgeInsets.all(4),
              child: Text(
                emojiData['emoji'],
                style: TextStyle(fontSize: widget.isMobile ? 24 : 28),
              ),
            ),
          );
        },
      ),
    );
  }

  void _selectEmoji(String emoji) {
    setState(() => _showEmojiPicker = false);
    _toggleReaction(emoji);
  }

  void _handleMenuAction(String action, SocialPost post) {
    switch (action) {
      case 'edit':
        setState(() => _isEditing = true);
        break;
      case 'delete':
        _showDeleteConfirmation();
        break;
      case 'pin':
        _pinPost();
        break;
      case 'unpin':
        _unpinPost();
        break;
    }
  }

  Future<void> _pinPost() async {
    // Show password dialog first
    showDialog(
      context: context,
      builder: (context) => PinAuthDialog(
        onSuccess: () => _actuallyPinPost(),
      ),
    );
  }

  Future<void> _unpinPost() async {
    // Show password dialog for unpinning too
    showDialog(
      context: context,
      builder: (context) => PinAuthDialog(
        onSuccess: () => _actuallyUnpinPost(),
      ),
    );
  }

  Future<void> _actuallyPinPost() async {
    try {
      await FirestoreService().pinPost(_postNotifier.value.id);

      // Update using ValueNotifier with copyWith
      _postNotifier.value = _postNotifier.value.copyWith(
        isPinned: true,
        pinOrder: 1,
      );

      // Use debounced parent update
      _debouncedParentUpdate();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Post pinned successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pin post: $e')),
        );
      }
    }
  }

  Future<void> _actuallyUnpinPost() async {
    try {
      await FirestoreService().unpinPost(_postNotifier.value.id);

      // Update using ValueNotifier with copyWith
      _postNotifier.value = _postNotifier.value.copyWith(
        isPinned: false,
        pinOrder: null,
      );

      // Use debounced parent update
      _debouncedParentUpdate();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Post unpinned successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to unpin post: $e')),
        );
      }
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Post'),
          content: Text(
              'Are you sure you want to delete this post? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _deletePost,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deletePost() async {
    Navigator.of(context).pop();

    try {
      final success =
          await FirestoreService().deletePost(_postNotifier.value.id);
      if (success) {
        widget.onPostDeleted?.call();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Post deleted')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cannot delete this post')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete post: $e')),
        );
      }
    }
  }

  Future<void> _saveEdit() async {
    final newContent = _editController.text.trim();
    if (newContent.isEmpty) return;

    try {
      // Update post in Firestore
      await FirestoreService().updatePost(_postNotifier.value.id, newContent);

      // Update local state using ValueNotifier
      _postNotifier.value = _postNotifier.value.copyWith(content: newContent);

      setState(() => _isEditing = false);

      // Use debounced parent update
      _debouncedParentUpdate();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Post updated')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update post: $e')),
        );
      }
    }
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      _editController.text = _postNotifier.value.content;
    });
  }

  bool _canModifyPost(SocialPost post) {
    final currentUser = FirestoreService().currentUser;
    if (currentUser == null) return false;

    // Allow post authors to modify their own posts
    bool isAuthor =
        post.authorId == currentUser.id || post.authorName == currentUser.name;

    // Allow admin (you) to modify any post
    bool isAdmin =
        currentUser.name == 'Jeff' || currentUser.name == 'Jeffjitsu';

    return isAuthor || isAdmin;
  }

  bool _canPin() {
    // Allow anyone to TRY to pin - the password will protect it
    final currentUser = FirestoreService().currentUser;
    return currentUser != null;
  }
}
