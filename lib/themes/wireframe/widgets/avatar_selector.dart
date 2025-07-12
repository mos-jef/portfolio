// File: lib/themes/wireframe/widgets/avatar_selector.dart
import 'package:flutter/material.dart';
import 'package:portfolio_website/themes/wireframe/widgets/clickable_widget.dart';

import '../utils/avatar_system.dart';
import '../utils/wireframe_color_manager.dart';
import '../wireframe_layout_constants.dart';

class AvatarSelector extends StatefulWidget {
  final String currentAvatarId;
  final String userName;
  final Function(String) onAvatarSelected;
  final bool isMobile;

  const AvatarSelector({
    Key? key,
    required this.currentAvatarId,
    required this.userName,
    required this.onAvatarSelected,
    this.isMobile = false,
  }) : super(key: key);

  @override
  State<AvatarSelector> createState() => _AvatarSelectorState();
}

class _AvatarSelectorState extends State<AvatarSelector> {
  late String _selectedAvatarId;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedAvatarId = widget.currentAvatarId;
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
          _buildCurrentSelection(),
          SizedBox(height: WireframeLayoutConstants.spacingStandard),
          _buildAvatarGrid(),
          SizedBox(height: WireframeLayoutConstants.spacingStandard),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Text(
          'Choose Avatar',
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

  Widget _buildCurrentSelection() {
    return Container(
      padding: EdgeInsets.all(WireframeLayoutConstants.spacingMedium),
      decoration: BoxDecoration(
        color: WireframeColorManager.colors.surface,
        borderRadius:
            BorderRadius.circular(WireframeLayoutConstants.radiusMedium),
        border: Border.all(color: WireframeColorManager.colors.border),
      ),
      child: Row(
        children: [
          Text(
            'Current: ',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: WireframeColorManager.colors.text,
            ),
          ),
          SizedBox(width: WireframeLayoutConstants.spacingMedium),
          AvatarSystem.buildAvatar(
            avatarId: _selectedAvatarId,
            userName: widget.userName,
            size: 40,
          ),
          SizedBox(width: WireframeLayoutConstants.spacingMedium),
          Expanded(
            child: Text(
              _getAvatarDescription(_selectedAvatarId),
              style: TextStyle(
                color: WireframeColorManager.colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarGrid() {
    final avatars = AvatarSystem.getAllAvatars();

    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.isMobile ? 3 : 4,
          crossAxisSpacing: WireframeLayoutConstants.spacingMedium,
          mainAxisSpacing: WireframeLayoutConstants.spacingMedium,
          childAspectRatio: 0.8,
        ),
        itemCount: avatars.length,
        itemBuilder: (context, index) {
          final avatar = avatars[index];
          final isSelected = _selectedAvatarId == avatar['id'];

          return _buildAvatarOption(avatar, isSelected);
        },
      ),
    );
  }

  Widget _buildAvatarOption(Map<String, dynamic> avatar, bool isSelected) {
    return ClickableWidget(
      onTap: () {
        setState(() {
          _selectedAvatarId = avatar['id'];
        });
      },
      child: Container(
        padding: EdgeInsets.all(WireframeLayoutConstants.spacingSmall),
        decoration: BoxDecoration(
          color: isSelected
              ? WireframeColorManager.colors.primary.withOpacity(0.1)
              : WireframeColorManager.colors.surface,
          borderRadius:
              BorderRadius.circular(WireframeLayoutConstants.radiusMedium),
          border: Border.all(
            color: isSelected
                ? WireframeColorManager.colors.primary
                : WireframeColorManager.colors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avatar preview
            AvatarSystem.buildAvatar(
              avatarId: avatar['id'],
              userName: widget.userName,
              size: widget.isMobile ? 40 : 50,
            ),

            SizedBox(height: WireframeLayoutConstants.spacingSmall),

            // Avatar name
            Text(
              avatar['name'],
              style: TextStyle(
                fontSize: widget.isMobile ? 10 : 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? WireframeColorManager.colors.primary
                    : WireframeColorManager.colors.text,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            // Type indicator
            Container(
              margin: EdgeInsets.only(top: 4),
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _getTypeColor(avatar['type']).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                avatar['type'].toUpperCase(),
                style: TextStyle(
                  fontSize: 8,
                  color: _getTypeColor(avatar['type']),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        // Random selection
        OutlinedButton.icon(
          onPressed: _selectRandomAvatar,
          icon: Icon(Icons.shuffle, size: 16),
          label: Text('Random'),
        ),

        SizedBox(width: WireframeLayoutConstants.spacingMedium),

        Spacer(),

        // Cancel button
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),

        SizedBox(width: WireframeLayoutConstants.spacingSmall),

        // Save button
        ElevatedButton(
          onPressed: _saveSelection,
          child: Text('Save'),
        ),
      ],
    );
  }

  void _selectRandomAvatar() {
    final avatars = AvatarSystem.getAllAvatars();
    final randomAvatar =
        avatars[DateTime.now().millisecondsSinceEpoch % avatars.length];
    setState(() {
      _selectedAvatarId = randomAvatar['id'];
    });
  }

  void _saveSelection() {
    widget.onAvatarSelected(_selectedAvatarId);
    Navigator.of(context).pop();
  }

  String _getAvatarDescription(String avatarId) {
    if (AvatarSystem.isCustomAvatar(avatarId)) {
      return 'Custom avatar image';
    } else if (AvatarSystem.isIconAvatar(avatarId)) {
      return 'Icon-based avatar';
    } else {
      return 'Generated from your name: "${widget.userName}"';
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'custom':
        return Colors.purple;
      case 'icon':
        return Colors.blue;
      case 'generated':
        return Colors.green;
      default:
        return WireframeColorManager.colors.textSecondary!;
    }
  }
}

/// Show avatar selector modal
Future<void> showAvatarSelector({
  required BuildContext context,
  required String currentAvatarId,
  required String userName,
  required Function(String) onAvatarSelected,
  bool isMobile = false,
}) async {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        decoration: BoxDecoration(
          color: WireframeColorManager.colors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(WireframeLayoutConstants.radiusLarge),
            topRight: Radius.circular(WireframeLayoutConstants.radiusLarge),
          ),
        ),
        child: AvatarSelector(
          currentAvatarId: currentAvatarId,
          userName: userName,
          onAvatarSelected: onAvatarSelected,
          isMobile: isMobile,
        ),
      );
    },
  );
}
