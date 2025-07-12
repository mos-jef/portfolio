// File: lib/themes/wireframe/widgets/enhanced_social_post.dart
import 'package:animated_emoji/animated_emoji.dart';
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
    'your-user-id-here', // Replace with your actual user ID
    // Add more admin IDs as needed
  ];

  static const List<String> adminUserNames = [
    'Jeff',
    'Jeffjitsu',
    // Add your variations
  ];
}

class EnhancedSocialPost extends StatefulWidget {
  final SocialPost post;
  final bool isMobile;
  final VoidCallback? onPostUpdated;
  final VoidCallback? onPostDeleted;

  const EnhancedSocialPost({
    Key? key,
    required this.post,
    required this.isMobile,
    this.onPostUpdated,
    this.onPostDeleted,
  }) : super(key: key);

  @override
  State<EnhancedSocialPost> createState() => _EnhancedSocialPostState();
}

class _EnhancedSocialPostState extends State<EnhancedSocialPost>
    with TickerProviderStateMixin {
  late SocialPost _currentPost;
  late AnimationController _likeAnimationController;
  late Animation<double> _likeScaleAnimation;
  bool _showEmojiPicker = false;
  bool _isEditing = false;
  late TextEditingController _editController;

  @override
  void initState() {
    super.initState();
    _currentPost = widget.post;
    _editController = TextEditingController(text: _currentPost.content);

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
  void dispose() {
    _likeAnimationController.dispose();
    _editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 1),
      padding: EdgeInsets.all(widget.isMobile
          ? WireframeLayoutConstants.spacingMedium
          : WireframeLayoutConstants.spacingStandard),
      decoration: BoxDecoration(
        color: WireframeColorManager.colors.surface,
        border: Border(
          bottom: BorderSide(
              color: WireframeColorManager.colors.border.withOpacity(0.3)),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAvatar(),
              SizedBox(width: WireframeLayoutConstants.spacingMedium),
              Expanded(child: _buildPostContent()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    final size = widget.isMobile
        ? WireframeLayoutConstants.smallAvatarSize
        : WireframeLayoutConstants.mediumAvatarSize;

    return AvatarSystem.buildAvatar(
      avatarId: _currentPost.authorAvatar,
      userName: _currentPost.authorName,
      size: size,
    );
  }

  Widget _buildPostContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPostHeader(),
        SizedBox(height: WireframeLayoutConstants.spacingSmall),
        _buildPostBody(),
        SizedBox(height: WireframeLayoutConstants.spacingMedium),
        _buildPostActions(),
      ],
    );
  }

  Widget _buildPostHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _currentPost.authorName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: widget.isMobile
                      ? WireframeLayoutConstants.mobileFontSizeBody
                      : WireframeLayoutConstants.desktopFontSizeBody,
                  color: WireframeColorManager.colors.focused,
                ),
              ),
              Text(
                timeago.format(_currentPost.createdAt),
                style: TextStyle(
                  color: WireframeColorManager.colors.disabled,
                  fontSize: widget.isMobile
                      ? WireframeLayoutConstants.mobileFontSizeCaption
                      : WireframeLayoutConstants.mobileFontSizeBody,
                ),
              ),
            ],
          ),
        ),
        _buildMoreMenu(),
      ],
    );
  }

  Widget _buildMoreMenu() {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        size: 18,
        color: WireframeLayoutConstants.wireframeSecondary,
      ),
      itemBuilder: (context) {
        List<PopupMenuEntry<String>> items = [];

        // Show edit/delete only if current user is the author
        if (_canModifyPost()) {
          items.addAll([
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 16, color: Colors.blue),
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
                  Text('Delete'),
                ],
              ),
            ),
            PopupMenuDivider(),
          ]);
        }

        // Pin/Unpin option
        if (_canPin()) {
          items.add(
            PopupMenuItem(
              value: _currentPost.isPinned ? 'unpin' : 'pin',
              child: Row(
                children: [
                  Icon(
                    _currentPost.isPinned
                        ? Icons.push_pin
                        : Icons.push_pin_outlined,
                    size: 16,
                    color: _currentPost.isPinned ? Colors.red : Colors.blue,
                  ),
                  SizedBox(width: 8),
                  Text(_currentPost.isPinned ? 'Unpin' : 'Pin'),
                ],
              ),
            ),
          );
        }

        // Always show report option
        items.add(
          PopupMenuItem(
            value: 'report',
            child: Row(
              children: [
                Icon(Icons.flag, size: 16, color: Colors.orange),
                SizedBox(width: 8),
                Text('Report'),
              ],
            ),
          ),
        );

        return items;
      },
      onSelected: _handleMenuAction,
    );
  }

  Widget _buildPostBody() {
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
              Spacer(),
              IconButton(
                onPressed: () =>
                    setState(() => _showEmojiPicker = !_showEmojiPicker),
                icon: Icon(Icons.emoji_emotions),
              ),
            ],
          ),
        ],
      );
    }

    return Text(
      _currentPost.content,
      style: TextStyle(
        fontSize: widget.isMobile
            ? WireframeLayoutConstants.mobileFontSizeBody
            : WireframeLayoutConstants.desktopFontSizeBody,
        color: WireframeColorManager.colors.text,
        height: 1.4,
      ),
    );
  }

  Widget _buildPostActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Show existing reactions if any
        _buildExistingReactions(),

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

  Widget _buildExistingReactions() {
    final reactions = _getPostReactions();

    if (reactions.isEmpty) return SizedBox.shrink();

    return Wrap(
      spacing: 4,
      children: reactions.entries.map((entry) {
        final hasUserReacted = FirestoreService()
            .hasUserReacted(_currentPost.reactions, entry.key);

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
    try {
      if (FirestoreService()
          .hasUserReacted(_currentPost.reactions, emojiText)) {
        await FirestoreService().addReactionToPost(
            _currentPost.id, emojiText); // This will remove it since it toggles
      } else {
        await FirestoreService()
            .addReactionToPost(_currentPost.id, emojiText); // This will add it
      }

      widget.onPostUpdated?.call();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update reaction: $e')),
      );
    }
  }

  Widget _buildEmojiReactionPicker() {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      height: widget.isMobile ? 50 : 60, // Set fixed height
      decoration: BoxDecoration(
        color: WireframeColorManager.colors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: WireframeColorManager.colors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: _getReactionEmojis().map((emoji) {
            return ClickableWidget(
              onTap: () => _addEmojiReaction(emoji),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 2),
                child: AnimatedEmoji(
                  emoji['data'],
                  size: widget.isMobile ? 20 : 24, // Smaller sizes
                  repeat: false,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }


  // LIST OF AVAILABLE ANIMATED EMOJIS  REACTION EMOJI LIST 
  List<Map<String, dynamic>> _getReactionEmojis() {
     return [
      {'data': AnimatedEmojis.callMeHand, 'text': '🤙'},
      {'data': AnimatedEmojis.redHeart, 'text': '❤️'},
      {'data': AnimatedEmojis.thumbsUp, 'text': '👍'},
      {'data': AnimatedEmojis.clap, 'text': '👏'},
      {'data': AnimatedEmojis.fire, 'text': '🔥'},
      {'data': AnimatedEmojis.partyingFace, 'text': '🥳'},
      {'data': AnimatedEmojis.winkyTongue,'text': '😝'},
      {'data': AnimatedEmojis.joy, 'text': '😂'},
      {'data': AnimatedEmojis.thinkingFace, 'text': '🤔'},
      {'data': AnimatedEmojis.astonished, 'text': '😲'},
      {'data': AnimatedEmojis.wave, 'text': '👋'},
      {'data': AnimatedEmojis.muscle, 'text': '💪'},
      {'data': AnimatedEmojis.mindBlown, 'text': '🤯'},
      {'data': AnimatedEmojis.oneHundred, 'text': '💯'}, 
      {'data': AnimatedEmojis.checkMark, 'text': '✅'},
      {'data': AnimatedEmojis.martialArtsUniform, 'text': '🥋'},
    ];
  }

  void _addEmojiReaction(Map<String, dynamic> emoji) async {
    final emojiText = emoji['text'];
    print('🐛 DEBUG: Adding reaction $emojiText to post ${_currentPost.id}');

    // 1. IMMEDIATE UI UPDATE (Optimistic)
    setState(() {
      _showEmojiPicker = false;

      // Create optimistic reaction update
      final currentReactions =
          Map<String, dynamic>.from(_currentPost.reactions);
      final userReactionKey =
          '${FirestoreService().currentUser?.id}_$emojiText';

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

      // Update current post with optimistic data
      _currentPost = _currentPost.copyWith(reactions: currentReactions);
    });

    // 2. BACKGROUND OPERATIONS (Fire and forget)
    _performBackgroundReactionUpdate(emojiText);
  }

// Separate method for background operations
  void _performBackgroundReactionUpdate(String emojiText) async {
    try {
      // Run Firestore and Analytics in parallel (not sequential)
      final futures = [
        FirestoreService().addReactionToPost(_currentPost.id, emojiText),
        AnalyticsService().trackSocialReaction(_currentPost.id, emojiText),
      ];

      await Future.wait(futures);

      print('🐛 DEBUG: Background reaction update completed');

      // Optional: Refresh from server to ensure consistency
      widget.onPostUpdated?.call();
    } catch (e) {
      print('🐛 DEBUG: Background reaction error: $e');

      // Revert optimistic update on error
      setState(() {
        // Re-fetch current state from server or revert changes
        widget.onPostUpdated?.call();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add reaction: $e')),
      );
    }
  }

  

  Map<String, int> _getPostReactions() {
    final reactions =
        FirestoreService().getReactionCounts(_currentPost.reactions);
    print('🐛 DEBUG: Post reactions: $reactions'); // ✅ Add debug
    return reactions;
  }

// method to get popular animated emojis
  List<Map<String, dynamic>> _getPopularEmojis() {
    return [
      {'data': AnimatedEmojis.grinning, 'text': '😀'},
      {'data': AnimatedEmojis.fire, 'text': '❤️'},
      {'data': AnimatedEmojis.thumbsUp, 'text': '👍'},
      {'data': AnimatedEmojis.clap, 'text': '👏'},
      {'data': AnimatedEmojis.rocket, 'text': '🚀'},
      {'data': AnimatedEmojis.fire, 'text': '🔥'},
      {'data': AnimatedEmojis.raisedFist, 'text': '⭐'},
      {'data': AnimatedEmojis.partyingFace, 'text': '🥳'},
      {'data': AnimatedEmojis.winkyTongue, 'text': '😉'},
      {'data': AnimatedEmojis.laughing, 'text': '😂'},
      {'data': AnimatedEmojis.warmSmile, 'text': '😍'},
      {'data': AnimatedEmojis.kissingHeart, 'text': '😘'},
      {'data': AnimatedEmojis.thinkingFace, 'text': '🤔'},
      {'data': AnimatedEmojis.happyCry, 'text': '😢'},
      {'data': AnimatedEmojis.angry, 'text': '😠'},
      {'data': AnimatedEmojis.surprised, 'text': '😲'},
      {'data': AnimatedEmojis.victory, 'text': '✌️'},
      {'data': AnimatedEmojis.wave, 'text': '👋'},
      {'data': AnimatedEmojis.muscle, 'text': '💪'},
      {'data': AnimatedEmojis.mindBlown, 'text': '🧠'},
      {'data': AnimatedEmojis.lightBulb, 'text': '💡'},
      {'data': AnimatedEmojis.trophy, 'text': '🏆'},
      {'data': AnimatedEmojis.oneHundred, 'text': '🎯'},
      {'data': AnimatedEmojis.checkMark, 'text': '✅'},
    ];
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'edit':
        setState(() => _isEditing = true);
        break;
      case 'delete':
        _confirmDelete();
        break;
      case 'pin':
        _pinPost();
        break;
      case 'unpin':
        _unpinPost();
        break;
      case 'report':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Post reported')),
        );
        break;
    }
  }

  void _confirmDelete() {
    final currentUser = FirestoreService().currentUser;
    final isAuthor = _currentPost.authorId == currentUser?.id;

    if (isAuthor) {
      // Authors can delete immediately
      _showActualDeleteDialog();
    } else {
      // Non-authors need admin password
      showDialog(
        context: context,
        builder: (context) => PinAuthDialog(
          onSuccess: () => _showActualDeleteDialog(),
        ),
      );
    }
  }

  void _showActualDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Post'),
          content: Text('Are you sure you want to delete this post?'),
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
      final success = await FirestoreService().deletePost(_currentPost.id);
      if (success) {
        widget.onPostDeleted?.call();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Post deleted')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cannot delete this post')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete post: $e')),
      );
    }
  }

  Future<void> _saveEdit() async {
    final newContent = _editController.text.trim();
    if (newContent.isEmpty) return;

    try {
      // Update post in Firestore
      await FirestoreService().updatePost(_currentPost.id, newContent);
      setState(() {
        _isEditing = false;
        _currentPost = _currentPost.copyWith(content: newContent);
      });
      widget.onPostUpdated?.call();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post updated')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update post: $e')),
      );
    }
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      _editController.text = _currentPost.content;
    });
  }

  bool _canModifyPost() {
    final currentUser = FirestoreService().currentUser;
    if (currentUser == null) return false;

    // Allow post authors to modify their own posts
    bool isAuthor = _currentPost.authorId == currentUser.id ||
        _currentPost.authorName == currentUser.name;

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

  Future<void> _pinPost() async {
    // Show password dialog first
    showDialog(
      context: context,
      builder: (context) => PinAuthDialog(
        onSuccess: () => _actuallyPinPost(),
      ),
    );
  }

  // The actual pin logic (moved from _pinPost)
  Future<void> _actuallyPinPost() async {
    try {
      await FirestoreService().pinPost(_currentPost.id);
      setState(() {
        _currentPost = _currentPost.copyWith(isPinned: true);
      });
      widget.onPostUpdated?.call();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post pinned successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pin post: $e')),
      );
    }
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

  Future<void> _actuallyUnpinPost() async {
    try {
      await FirestoreService().unpinPost(_currentPost.id);
      setState(() {
        _currentPost = _currentPost.copyWith(isPinned: false, pinOrder: null);
      });
      widget.onPostUpdated?.call();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post unpinned successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to unpin post: $e')),
      );
    }
  }
}
