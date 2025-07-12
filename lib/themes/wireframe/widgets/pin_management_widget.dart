// File: lib/themes/wireframe/widgets/pin_management_widget.dart
import 'package:flutter/material.dart';
import '../../../firestore/firestore_service.dart';
import '../../../firestore/firestore_models.dart';
import '../utils/wireframe_color_manager.dart';
import '../wireframe_layout_constants.dart';

class PinManagementWidget extends StatefulWidget {
  final bool isMobile;

  const PinManagementWidget({
    Key? key,
    required this.isMobile,
  }) : super(key: key);

  @override
  State<PinManagementWidget> createState() => _PinManagementWidgetState();
}

class _PinManagementWidgetState extends State<PinManagementWidget> {
  List<SocialPost> _pinnedPosts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPinnedPosts();
  }

  Future<void> _loadPinnedPosts() async {
    try {
      final posts = await FirestoreService().getPinnedPosts();
      setState(() {
        _pinnedPosts = posts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading pinned posts: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.isMobile ? 400 : 500,
      padding: EdgeInsets.all(WireframeLayoutConstants.spacingStandard),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: WireframeLayoutConstants.spacingStandard),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _buildPinnedPostsList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.push_pin,
          color: WireframeColorManager.colors.primary,
        ),
        SizedBox(width: WireframeLayoutConstants.spacingSmall),
        Text(
          'Manage Pinned Posts',
          style: TextStyle(
            fontSize: widget.isMobile ? 18 : 20,
            fontWeight: FontWeight.bold,
            color: WireframeColorManager.colors.text,
          ),
        ),
        Spacer(),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _buildPinnedPostsList() {
    if (_pinnedPosts.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.push_pin_outlined,
                size: 48,
                color: WireframeColorManager.colors.textSecondary,
              ),
              SizedBox(height: 16),
              Text(
                'No pinned posts yet',
                style: TextStyle(
                  color: WireframeColorManager.colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: ReorderableListView.builder(
        itemCount: _pinnedPosts.length,
        onReorder: _onReorder,
        itemBuilder: (context, index) {
          final post = _pinnedPosts[index];
          return _buildPinnedPostItem(post, index);
        },
      ),
    );
  }

  Widget _buildPinnedPostItem(SocialPost post, int index) {
    return Container(
      key: ValueKey(post.id),
      margin: EdgeInsets.only(bottom: WireframeLayoutConstants.spacingSmall),
      padding: EdgeInsets.all(WireframeLayoutConstants.spacingMedium),
      decoration: BoxDecoration(
        color: WireframeColorManager.colors.surface,
        borderRadius:
            BorderRadius.circular(WireframeLayoutConstants.radiusMedium),
        border: Border.all(color: WireframeColorManager.colors.border),
      ),
      child: Row(
        children: [
          // Pin order indicator
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: WireframeColorManager.colors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),

          SizedBox(width: WireframeLayoutConstants.spacingMedium),

          // Post content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.authorName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: WireframeColorManager.colors.text,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  post.content,
                  style: TextStyle(
                    fontSize: 12,
                    color: WireframeColorManager.colors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Actions
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Reorder handle
              Icon(
                Icons.drag_handle,
                color: WireframeColorManager.colors.textSecondary,
              ),
              SizedBox(width: WireframeLayoutConstants.spacingSmall),

              // Unpin button
              IconButton(
                onPressed: () => _unpinPost(post),
                icon: Icon(
                  Icons.push_pin,
                  color: Colors.red,
                  size: 20,
                ),
                tooltip: 'Unpin',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _onReorder(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) newIndex--;

    final post = _pinnedPosts[oldIndex];
    final newOrder = newIndex + 1; // Pin orders start at 1

    try {
      await FirestoreService().changePinOrder(post.id, newOrder);
      setState(() {
        _pinnedPosts.removeAt(oldIndex);
        _pinnedPosts.insert(newIndex, post);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pin order updated')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reorder: $e')),
      );
    }
  }

  Future<void> _unpinPost(SocialPost post) async {
    try {
      await FirestoreService().unpinPost(post.id);
      await _loadPinnedPosts(); // Refresh the list

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post unpinned')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to unpin: $e')),
      );
    }
  }
}

/// Show pin management modal
Future<void> showPinManagementModal({
  required BuildContext context,
  bool isMobile = false,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: isMobile ? double.infinity : 600,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          decoration: BoxDecoration(
            color: WireframeColorManager.colors.surface,
            borderRadius:
                BorderRadius.circular(WireframeLayoutConstants.radiusLarge),
          ),
          child: PinManagementWidget(isMobile: isMobile),
        ),
      );
    },
  );
}
