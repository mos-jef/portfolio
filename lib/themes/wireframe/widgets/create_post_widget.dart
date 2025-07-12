// File: lib/themes/wireframe/widgets/create_post_widget.dart
import 'package:animated_emoji/animated_emoji.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_website/themes/wireframe/widgets/animated_avatar_selector.dart';
import 'package:portfolio_website/themes/wireframe/widgets/clickable_widget.dart';

import '../../../firestore/firestore_service.dart';
import '../utils/avatar_system.dart';
import '../utils/wireframe_color_manager.dart';
import '../wireframe_layout_constants.dart';

class CreatePostWidget extends StatefulWidget {
  final bool isMobile;
  final VoidCallback? onPostCreated;

  const CreatePostWidget({
    Key? key,
    required this.isMobile,
    this.onPostCreated,
  }) : super(key: key);

  @override
  State<CreatePostWidget> createState() => _CreatePostWidgetState();
}

class _CreatePostWidgetState extends State<CreatePostWidget> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isPosting = false;
  bool _showEmojiPicker = false;
  String _selectedAvatarId = '';

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  void _initializeUserData() {
    final currentUser = FirestoreService().currentUser;
    if (currentUser != null) {
      _nameController.text = currentUser.name;
      _selectedAvatarId = currentUser.avatar;
    } else {
      _selectedAvatarId = AvatarSystem.getDefaultAvatar();
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(WireframeLayoutConstants.spacingStandard),
      decoration: BoxDecoration(
        color: WireframeColorManager.colors.surface,
        borderRadius:
            BorderRadius.circular(WireframeLayoutConstants.radiusMedium),
        border: Border.all(color: WireframeColorManager.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          SizedBox(height: WireframeLayoutConstants.spacingMedium),
          _buildUserInfo(),
          SizedBox(height: WireframeLayoutConstants.spacingMedium),
          _buildContentInput(),
          SizedBox(height: WireframeLayoutConstants.spacingMedium),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.edit,
          size: 20,
          color: WireframeColorManager.colors.primary,
        ),
        SizedBox(width: WireframeLayoutConstants.spacingSmall),
        Text(
          'Create Post',
          style: TextStyle(
            fontSize: widget.isMobile ? 16 : 18,
            fontWeight: FontWeight.bold,
            color: WireframeColorManager.colors.text,
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo() {
    return Row(
      children: [
        // Avatar selection
        ClickableWidget(
          onTap: _showAvatarSelector,
          child: Stack(
            children: [
              AvatarSystem.buildAvatar(
                avatarId: _selectedAvatarId,
                userName: _nameController.text,
                size: widget.isMobile ? 40 : 48,
              ),
              Positioned(
                bottom: -2,
                right: -2,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: WireframeColorManager.colors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: WireframeColorManager.colors.surface,
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.edit,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(width: WireframeLayoutConstants.spacingMedium),

        // Name input
        Expanded(
          child: TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Your Name',
              hintText: 'Enter your name',
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(WireframeLayoutConstants.radiusSmall),
              ),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            style: TextStyle(
              fontSize: widget.isMobile ? 14 : 16,
              color: WireframeColorManager.colors.text,
            ),
            onChanged: (value) {
              // Refresh avatar if using generated type
              if (AvatarSystem.isGeneratedAvatar(_selectedAvatarId)) {
                setState(() {});
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContentInput() {
    return TextField(
      controller: _contentController,
      maxLines: widget.isMobile ? 3 : 4,
      decoration: InputDecoration(
        hintText: 'What\'s on your mind?',
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(WireframeLayoutConstants.radiusSmall),
        ),
        contentPadding: EdgeInsets.all(12),
      ),
      style: TextStyle(
        fontSize: widget.isMobile ? 14 : 16,
        color: WireframeColorManager.colors.text,
      ),
    );
  }

  Widget _buildEmojiPicker() {
    return Container(
      height: widget.isMobile ? 200 : 250,
      margin: EdgeInsets.only(top: WireframeLayoutConstants.spacingMedium),
      decoration: BoxDecoration(
        color: WireframeColorManager.colors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: WireframeColorManager.colors.border!),
      ),
      child: GridView.builder(
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.isMobile ? 6 : 8,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: _getPopularEmojis().length,
        itemBuilder: (context, index) {
          final emoji = _getPopularEmojis()[index];
          return ClickableWidget(
            onTap: () {
              // Get current cursor position
              final currentText = _contentController.text;
              final selection = _contentController.selection;
              final cursorPosition = selection.baseOffset == -1
                  ? currentText.length
                  : selection.baseOffset;

              // Insert emoji at cursor position
              final newText = currentText.replaceRange(
                cursorPosition,
                cursorPosition,
                emoji['text'],
              );

              // Update text and move cursor after emoji
              _contentController.text = newText;
              _contentController.selection = TextSelection.fromPosition(
                TextPosition(
                    offset: cursorPosition + emoji['text'].length as int),
              );

              setState(() => _showEmojiPicker = false);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.transparent,
              ),
              child: AnimatedEmoji(
                emoji['data'],
                size: widget.isMobile ? 24.0 : 32.0,
                repeat: false,
                source: AnimatedEmojiSource.asset,
              ),
            ),
          );
        },
      ),
    );
  }

// Add the same _getPopularEmojis() method to CreatePostWidget too
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

  Widget _buildActions() {
    return Row(
      children: [
        // Emoji button
        IconButton(
          onPressed: () => setState(() => _showEmojiPicker = !_showEmojiPicker),
          icon: _showEmojiPicker
              ? AnimatedEmoji(
                  AnimatedEmojis.grinning,
                  size: widget.isMobile ? 20.0 : 24.0,
                )
              : Icon(
                  Icons.emoji_emotions,
                  color: WireframeColorManager.colors.textSecondary,
                ),
          tooltip: 'Add Emoji',
        ),

        Spacer(),

        // Character count
        if (_contentController.text.isNotEmpty)
          Text(
            '${_contentController.text.length}/500',
            style: TextStyle(
              fontSize: 12,
              color: _contentController.text.length > 500
                  ? Colors.red
                  : WireframeColorManager.colors.textSecondary,
            ),
          ),

        SizedBox(width: WireframeLayoutConstants.spacingMedium),

        // Post button
        ElevatedButton(
          onPressed: _isPosting || !_canPost() ? null : _createPost,
          style: ElevatedButton.styleFrom(
            backgroundColor: WireframeColorManager.colors.primary,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: WireframeLayoutConstants.spacingLarge,
              vertical: WireframeLayoutConstants.spacingSmall,
            ),
          ),
          child: _isPosting
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text('Post'),
        ),
      ],
    );
  }

  void _showAvatarSelector() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AnimatedAvatarSelector(
        selectedAvatarId: _selectedAvatarId,
        userName: _nameController.text,
        isMobile: widget.isMobile,
        onAvatarSelected: (avatarId) {
          setState(() {
            _selectedAvatarId = avatarId;
          });
        },
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }

  bool _canPost() {
    return _nameController.text.trim().isNotEmpty &&
        _contentController.text.trim().isNotEmpty &&
        _contentController.text.length <= 500;
  }

  Future<void> _createPost() async {
    if (!_canPost()) return;

    setState(() => _isPosting = true);

    try {
      // Update current user if needed
      await _updateCurrentUser();

      // Create the post
      await FirestoreService().addPost(
        content: _contentController.text.trim(),
        authorName: _nameController.text.trim(),
        authorAvatar: _selectedAvatarId,
      );

      // Clear the form
      _contentController.clear();
      setState(() => _showEmojiPicker = false);

      // Notify parent
      widget.onPostCreated?.call();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Post created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create post: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isPosting = false);
    }
  }

  Future<void> _updateCurrentUser() async {
    final currentUser = FirestoreService().currentUser;
    final newName = _nameController.text.trim();
    final newAvatar = _selectedAvatarId;

    // Update user if name or avatar changed
    if (currentUser == null ||
        currentUser.name != newName ||
        currentUser.avatar != newAvatar) {
      await FirestoreService().updateUser(
        name: newName,
        avatar: newAvatar,
      );
    }
  }
}

/// Show create post modal
Future<void> showCreatePostModal({
  required BuildContext context,
  required bool isMobile,
  VoidCallback? onPostCreated,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: isMobile ? double.infinity : 500,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: CreatePostWidget(
            isMobile: isMobile,
            onPostCreated: () {
              Navigator.of(context).pop();
              onPostCreated?.call();
            },
          ),
        ),
      );
    },
  );
}
