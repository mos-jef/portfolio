import 'package:animated_to/animated_to.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_website/themes/wireframe/widgets/clickable_widget.dart';

import '../utils/avatar_system.dart';
import '../utils/wireframe_color_manager.dart';
import '../wireframe_layout_constants.dart';

class AnimatedAvatarSelector extends StatefulWidget {
  final String selectedAvatarId;
  final String userName;
  final Function(String) onAvatarSelected;
  final VoidCallback onClose;
  final bool isMobile;

  const AnimatedAvatarSelector({
    Key? key,
    required this.selectedAvatarId,
    required this.userName,
    required this.onAvatarSelected,
    required this.onClose,
    this.isMobile = false,
  }) : super(key: key);

  @override
  State<AnimatedAvatarSelector> createState() => _AnimatedAvatarSelectorState();
}

class _AnimatedAvatarSelectorState extends State<AnimatedAvatarSelector>
    with TickerProviderStateMixin {
  String _selectedAvatarId = '';
  List<Map<String, dynamic>> _avatars = [];
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _selectedAvatarId = widget.selectedAvatarId;
    _loadAvatars();
  }

  void _loadAvatars() {
    // Delay to create staggered animation effect
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _avatars = AvatarSystem.getAllAvatars();
        _isLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(widget.isMobile ? 16 : 40),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: widget.isMobile ? double.infinity : 600,
          maxHeight:
              widget.isMobile ? MediaQuery.of(context).size.height * 0.9 : 700,
        ),
        decoration: BoxDecoration(
          color: WireframeColorManager.colors.surface,
          borderRadius: BorderRadius.circular(
            widget.isMobile ? 16 : 20,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            _buildCurrentSelection(),
            Expanded(child: _buildAnimatedAvatarGrid()),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return AnimatedTo.spring(
      globalKey: const GlobalObjectKey('avatar_header'),
      appearingFrom: const Offset(0, -50),
      child: Container(
        padding: EdgeInsets.all(
          widget.isMobile ? 16 : 20,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: WireframeColorManager.colors.border!,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.account_circle_outlined,
              size: widget.isMobile ? 24 : 28,
              color: WireframeColorManager.colors.primary,
            ),
            SizedBox(width: WireframeLayoutConstants.spacingMedium),
            Text(
              'Choose Your Avatar',
              style: TextStyle(
                fontSize: widget.isMobile ? 18 : 22,
                fontWeight: FontWeight.bold,
                color: WireframeColorManager.colors.text,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: widget.onClose,
              icon: const Icon(Icons.close),
              style: IconButton.styleFrom(
                backgroundColor: WireframeColorManager.colors.surface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentSelection() {
    return AnimatedTo.spring(
      globalKey: const GlobalObjectKey('current_selection'),
      appearingFrom: const Offset(-50, 0),
      child: Container(
        margin: EdgeInsets.all(
          widget.isMobile ? 16 : 20,
        ),
        padding: EdgeInsets.all(
          widget.isMobile ? 12 : 16,
        ),
        decoration: BoxDecoration(
          color: WireframeColorManager.colors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(
            WireframeLayoutConstants.radiusMedium,
          ),
          border: Border.all(
            color: WireframeColorManager.colors.primary.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Text(
              'Current: ',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: widget.isMobile ? 14 : 16,
                color: WireframeColorManager.colors.text,
              ),
            ),
            SizedBox(width: WireframeLayoutConstants.spacingMedium),
            AvatarSystem.buildAvatar(
              avatarId: _selectedAvatarId,
              userName: widget.userName,
              size: widget.isMobile ? 40 : 48,
              showBorder: true,
              borderColor: WireframeColorManager.colors.primary,
            ),
            SizedBox(width: WireframeLayoutConstants.spacingMedium),
            Expanded(
              child: Text(
                _getAvatarDescription(_selectedAvatarId),
                style: TextStyle(
                  color: WireframeColorManager.colors.textSecondary,
                  fontSize: widget.isMobile ? 12 : 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedAvatarGrid() {
    if (!_isLoaded) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.isMobile ? 16 : 20,
      ),
      child: GridView.builder(
        shrinkWrap: true, // Important for mobile
        physics: widget.isMobile
            ? const BouncingScrollPhysics()
            : const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(
          bottom: widget.isMobile ? 16 : 20,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              widget.isMobile ? 4 : 6, // Increased count since no labels
          crossAxisSpacing: widget.isMobile ? 4 : 8, // Reduced spacing
          mainAxisSpacing: widget.isMobile ? 4 : 8, // Reduced spacing
          childAspectRatio: 1.0, // Perfect circles
        ),
        itemCount: _avatars.length,
        itemBuilder: (context, index) {
          final avatar = _avatars[index];
          final isSelected = _selectedAvatarId == avatar['id'];

          return _buildAnimatedAvatarOption(
            avatar,
            isSelected,
            index,
          );
        },
      ),
    );
  }

  Widget _buildAnimatedAvatarOption(
    Map<String, dynamic> avatar,
    bool isSelected,
    int index,
  ) {
    return AnimatedTo.spring(
      globalKey: GlobalObjectKey('avatar_${avatar['id']}_$index'),
      appearingFrom: Offset(
        (index % 2 == 0) ? -100 : 100,
        50,
      ),
      child: ClickableWidget(
        onTap: () {
          setState(() {
            _selectedAvatarId = avatar['id'];
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.all(
            widget.isMobile ? 6 : 8, // Reduced padding
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? WireframeColorManager.colors.primary.withOpacity(0.15)
                : Colors.transparent, // Remove background for unselected
            shape: BoxShape.circle, // Make it truly circular
            border: isSelected
                ? Border.all(
                    color: WireframeColorManager.colors.primary,
                    width: 3,
                  )
                : null, // No border when not selected
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color:
                          WireframeColorManager.colors.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar preview with hero animation
              Hero(
                tag: 'avatar_${avatar['id']}',
                child: AvatarSystem.buildAvatar(
                  avatarId: avatar['id'],
                  userName:
                      widget.userName.isNotEmpty ? widget.userName : 'User',
                  size: widget.isMobile ? 36 : 48,
                  showBorder: isSelected,
                  borderColor: WireframeColorManager.colors.primary,
                ),
              ),

              SizedBox(height: widget.isMobile ? 2 : 4), // Reduced spacing

              // Avatar type indicator (smaller)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 3,
                  vertical: 1,
                ),
                decoration: BoxDecoration(
                  color: _getTypeColor(avatar['type']).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  avatar['type'].toString().toUpperCase(),
                  style: TextStyle(
                    fontSize: widget.isMobile ? 7 : 8, // Smaller text
                    fontWeight: FontWeight.bold,
                    color: _getTypeColor(avatar['type']),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Removed avatar names for cleaner look

              /*
            // Avatar name (commented out for future use)
            if (!widget.isMobile)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  avatar['name'] ?? '',
                  style: TextStyle(
                    fontSize: 10,
                    color: isSelected
                        ? WireframeColorManager.colors.primary
                        : WireframeColorManager.colors.textSecondary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            */
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActions() {
    return AnimatedTo.spring(
      globalKey: const GlobalObjectKey('avatar_actions'),
      appearingFrom: const Offset(0, 50),
      child: Container(
        padding: EdgeInsets.all(
          widget.isMobile ? 16 : 20,
        ),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: WireframeColorManager.colors.border!,
            ),
          ),
        ),
        child: Row(
          children: [
            // Random selection button
            OutlinedButton.icon(
              onPressed: _selectRandomAvatar,
              icon: const Icon(Icons.shuffle, size: 16),
              label: Text(widget.isMobile ? 'Random' : 'Surprise Me'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: widget.isMobile ? 12 : 16,
                  vertical: widget.isMobile ? 8 : 12,
                ),
              ),
            ),

            const Spacer(),

            // Cancel button
            TextButton(
              onPressed: widget.onClose,
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: widget.isMobile ? 14 : 16,
                ),
              ),
            ),

            SizedBox(width: WireframeLayoutConstants.spacingSmall),

            // Save button
            ElevatedButton(
              onPressed: _saveSelection,
              style: ElevatedButton.styleFrom(
                backgroundColor: WireframeColorManager.colors.primary,
                foregroundColor: WireframeColorManager.colors.onPrimary,
                padding: EdgeInsets.symmetric(
                  horizontal: widget.isMobile ? 16 : 24,
                  vertical: widget.isMobile ? 8 : 12,
                ),
              ),
              child: Text(
                'Save Avatar',
                style: TextStyle(
                  fontSize: widget.isMobile ? 14 : 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectRandomAvatar() {
    final randomAvatar =
        _avatars[DateTime.now().millisecondsSinceEpoch % _avatars.length];
    setState(() {
      _selectedAvatarId = randomAvatar['id'];
    });
  }

  void _saveSelection() {
    widget.onAvatarSelected(_selectedAvatarId);
    widget.onClose();
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
