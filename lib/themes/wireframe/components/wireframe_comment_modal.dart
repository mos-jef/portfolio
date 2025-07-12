import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:portfolio_website/themes/wireframe/utils/avatar_system.dart';
import 'package:portfolio_website/themes/wireframe/utils/wireframe_color_manager.dart';
import 'package:portfolio_website/themes/wireframe/widgets/clickable_widget.dart';

import '../wireframe_layout_constants.dart';

/// Mobile comment modal component
class WireframeMobileCommentModal extends StatelessWidget {
  final Animation<Offset> commentSlideAnimation;
  final AnimationController commentAnimationController;
  final TextEditingController commentController;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final int commentStep;
  final String selectedAvatar;
  final VoidCallback onAddComment;
  final VoidCallback onResetModal;
  final Function(int) onUpdateStep;
  final Function(String) onUpdateAvatar;

  const WireframeMobileCommentModal({
    Key? key,
    required this.commentSlideAnimation,
    required this.commentAnimationController,
    required this.commentController,
    required this.nameController,
    required this.emailController,
    required this.commentStep,
    required this.selectedAvatar,
    required this.onAddComment,
    required this.onResetModal,
    required this.onUpdateStep,
    required this.onUpdateAvatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClickableWidget(
      onTap: () {
        commentAnimationController.reverse().then((_) {
          onResetModal();
        });
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: WireframeLayoutConstants.wireframeBlack.withOpacity(0.5),
        ),
        child: ClickableWidget(
          onTap: () {}, // Prevent tap from bubbling up
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedBuilder(
              animation: commentSlideAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: commentSlideAnimation.value *
                      WireframeLayoutConstants.mobileModalHeight,
                  child: Container(
                    width: double.infinity,
                    height: math.min(WireframeLayoutConstants.mobileModalHeight,
                        WireframeLayoutConstants.iPhoneFrameHeight * 0.85),
                    margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    constraints: BoxConstraints(
                      maxHeight:
                          WireframeLayoutConstants.iPhoneFrameHeight * 0.8,
                      maxWidth: WireframeLayoutConstants.iPhoneFrameWidth - 4,
                    ),
                    decoration: BoxDecoration(
                      color: WireframeLayoutConstants.wireframeWhite,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                            WireframeLayoutConstants.radiusLarge),
                        topRight: Radius.circular(
                            WireframeLayoutConstants.radiusLarge),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Handle bar
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: WireframeColorManager.colors.border,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          margin: EdgeInsets.only(
                            top: WireframeLayoutConstants.spacingMedium,
                            bottom: WireframeLayoutConstants.spacingLarge,
                            left: WireframeLayoutConstants.spacingMedium,
                            right: WireframeLayoutConstants.spacingMedium,
                          ),
                        ),

                        // Header with step indicator and close button
                        _buildModalHeader(),

                        SizedBox(height: 30),

                        // Step content
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  WireframeLayoutConstants.spacingStandard,
                            ),
                            child: _buildStepContent(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModalHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: WireframeLayoutConstants.spacingStandard),
      child: Row(
        children: [
          Spacer(),

          // Step indicator dots
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: commentStep == 0
                      ? WireframeLayoutConstants.wireframeOrange
                      : WireframeLayoutConstants.wireframeBorder,
                ),
              ),
              SizedBox(width: WireframeLayoutConstants.spacingSmall),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: commentStep == 1
                      ? WireframeLayoutConstants.wireframeOrange
                      : WireframeLayoutConstants.wireframeBorder,
                ),
              ),
            ],
          ),

          Spacer(),

          // Close button (X)
          IconButton(
            onPressed: () {
              commentAnimationController.reverse().then((_) {
                onResetModal();
              });
            },
            icon: Icon(
              Icons.close,
              size: 20,
              color: WireframeLayoutConstants.wireframeSecondary,
            ),
            padding: EdgeInsets.all(4),
            constraints: BoxConstraints(minWidth: 0, minHeight: 0),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(BuildContext context) {
    if (commentStep == 0) {
      return _buildCommentStep();
    } else {
      return _buildDetailsStep(context);
    }
  }

  Widget _buildCommentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Comment text area
        Expanded(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(WireframeLayoutConstants.spacingStandard),
            decoration: BoxDecoration(
              border: Border.all(
                color: WireframeColorManager.colors.border!,
                width: 1,
              ),
              borderRadius:
                  BorderRadius.circular(WireframeLayoutConstants.radiusLarge),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Leave a comment/post!',
                  style: TextStyle(
                    color: WireframeColorManager.colors.text!.withAlpha(160),
                    fontSize: WireframeLayoutConstants.mobileFontSizeBodyLarge,
                  ),
                ),
                SizedBox(height: WireframeLayoutConstants.spacingSmall),
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: TextField(
                      controller: commentController,
                      maxLines: null,
                      expands: true,
                      maxLength: 300,
                      onChanged: (value) => onUpdateStep(commentStep),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'This is a working forum!',
                        hintStyle: TextStyle(
                          color:
                              WireframeColorManager.colors.text!.withAlpha(160),
                          fontSize:
                              WireframeLayoutConstants.mobileFontSizeBodyLarge,
                        ),
                        counterText: '${commentController.text.length}/300',
                        counterStyle: TextStyle(
                          color: WireframeLayoutConstants.wireframeSecondary,
                          fontSize: WireframeLayoutConstants.mobileFontSizeBody,
                        ),
                      ),
                      style: TextStyle(
                        fontSize:
                            WireframeLayoutConstants.mobileFontSizeLargeTitle,
                        color: WireframeColorManager.colors.text,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: WireframeLayoutConstants.spacingLarge),

        // Next button at bottom right
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: commentController.text.trim().isEmpty
                ? null
                : () => onUpdateStep(1),
            style: TextButton.styleFrom(
              backgroundColor: commentController.text.trim().isEmpty
                  ? WireframeColorManager.colors.disabled
                  : WireframeColorManager.colors.primary,
              padding: EdgeInsets.symmetric(
                horizontal: WireframeLayoutConstants.spacingMedium,
                vertical: WireframeLayoutConstants.spacingSmall,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(WireframeLayoutConstants.radiusSmall),
              ),
            ),
            child: Text(
              'Next',
              style: TextStyle(
                color: WireframeColorManager.colors.onPrimary,
                fontSize: WireframeLayoutConstants.mobileFontSizeBody,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        SizedBox(height: WireframeLayoutConstants.spacingLarge),
      ],
    );
  }

  Widget _buildDetailsStep(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Name field
          Container(
            width: double.infinity,
            child: TextField(
              controller: nameController,
              onChanged: (value) => onUpdateStep(commentStep),
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(
                  color: WireframeColorManager.colors.textSecondary,
                ),
                filled: true,
                fillColor: WireframeColorManager.colors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      WireframeLayoutConstants.radiusMedium),
                  borderSide:
                      BorderSide(color: WireframeColorManager.colors.border!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      WireframeLayoutConstants.radiusMedium),
                  borderSide:
                      BorderSide(color: WireframeColorManager.colors.border!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      WireframeLayoutConstants.radiusMedium),
                  borderSide: BorderSide(
                      color: WireframeColorManager.colors.primary, width: 2),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: WireframeLayoutConstants.spacingStandard,
                  vertical: WireframeLayoutConstants.spacingStandard,
                ),
              ),
              style: TextStyle(
                fontSize: WireframeLayoutConstants.mobileFontSizeBody,
                color: WireframeColorManager.colors.text,
              ),
            ),
          ),

          SizedBox(height: WireframeLayoutConstants.spacingMedium),

          // Email field
          Container(
            width: double.infinity,
            child: TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => onUpdateStep(commentStep),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
                  color: WireframeColorManager.colors.textSecondary,
                ),
                filled: true,
                fillColor: WireframeColorManager.colors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      WireframeLayoutConstants.radiusMedium),
                  borderSide:
                      BorderSide(color: WireframeColorManager.colors.border!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      WireframeLayoutConstants.radiusMedium),
                  borderSide:
                      BorderSide(color: WireframeColorManager.colors.border!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      WireframeLayoutConstants.radiusMedium),
                  borderSide: BorderSide(
                      color: WireframeColorManager.colors.primary, width: 2),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: WireframeLayoutConstants.spacingStandard,
                  vertical: WireframeLayoutConstants.spacingStandard,
                ),
              ),
              style: TextStyle(
                fontSize: WireframeLayoutConstants.mobileFontSizeBody,
                color: WireframeColorManager.colors.text,
              ),
            ),
          ),

          SizedBox(height: WireframeLayoutConstants.spacingLarge),

          // Back and Post buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => onUpdateStep(0),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: WireframeColorManager.colors.textSecondary,
                  padding: EdgeInsets.symmetric(
                    horizontal: WireframeLayoutConstants.spacingMedium,
                    vertical: WireframeLayoutConstants.spacingSmall,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        WireframeLayoutConstants.radiusSmall),
                    side:
                        BorderSide(color: WireframeColorManager.colors.border!),
                  ),
                ),
                child: Text(
                  'Back',
                  style: TextStyle(
                    color: WireframeColorManager.colors.textSecondary,
                    fontSize: WireframeLayoutConstants.mobileFontSizeBody,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: (nameController.text.trim().isEmpty ||
                        emailController.text.trim().isEmpty)
                    ? null
                    : onAddComment,
                style: TextButton.styleFrom(
                  backgroundColor: (nameController.text.trim().isEmpty ||
                          emailController.text.trim().isEmpty)
                      ? WireframeColorManager.colors.disabled
                      : WireframeColorManager.colors.primary,
                  padding: EdgeInsets.symmetric(
                    horizontal: WireframeLayoutConstants.spacingMedium,
                    vertical: WireframeLayoutConstants.spacingSmall,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        WireframeLayoutConstants.radiusSmall),
                  ),
                ),
                child: Text(
                  'Post',
                  style: TextStyle(
                    color: WireframeColorManager.colors.onPrimary,
                    fontSize: WireframeLayoutConstants.mobileFontSizeBody,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: WireframeLayoutConstants.spacingMedium),

          // Divider line
          Container(
            height: 1,
            color: WireframeColorManager.colors.border,
            margin: EdgeInsets.symmetric(
                vertical: WireframeLayoutConstants.spacingSmall),
          ),

          // Choose Avatar section
          Text(
            'Choose Avatar (optional)',
            style: TextStyle(
              fontSize: WireframeLayoutConstants.mobileFontSizeBody,
              color: WireframeColorManager.colors.text,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: WireframeLayoutConstants.spacingSmall),

          // Always visible avatar grid
          _buildAlwaysVisibleAvatarGrid(context),

          SizedBox(height: WireframeLayoutConstants.spacingMedium),
        ],
      ),
    );
  }

  Widget _buildAlwaysVisibleAvatarGrid(BuildContext context) {
    final avatars = AvatarSystem.getAllAvatars();

    return Container(
      padding: EdgeInsets.all(WireframeLayoutConstants.spacingSmall),
      decoration: BoxDecoration(
        color: WireframeColorManager.colors.surface!.withOpacity(0.3),
        borderRadius:
            BorderRadius.circular(WireframeLayoutConstants.radiusSmall),
        border: Border.all(color: WireframeColorManager.colors.border!),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // Perfect for mobile modal width
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
          childAspectRatio: 1.0,
        ),
        itemCount: avatars.length,
        itemBuilder: (context, index) {
          final avatar = avatars[index];
          final isSelected = selectedAvatar == avatar['id'];

          return ClickableWidget(
            onTap: () => onUpdateAvatar(avatar['id']),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? WireframeColorManager.colors.primary.withOpacity(0.15)
                    : Colors.transparent,
                border: isSelected
                    ? Border.all(
                        color: WireframeColorManager.colors.primary,
                        width: 2,
                      )
                    : null,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: WireframeColorManager.colors.primary
                              .withOpacity(0.3),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: AvatarSystem.buildAvatar(
                avatarId: avatar['id'],
                userName: nameController.text.isNotEmpty
                    ? nameController.text
                    : 'User',
                size: 28,
                showBorder: isSelected,
                borderColor: WireframeColorManager.colors.primary,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Desktop comment modal component
class WireframeDesktopCommentModal extends StatelessWidget {
  final TextEditingController commentController;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final int commentStep;
  final String selectedAvatar;
  final VoidCallback onAddComment;
  final Function(int) onUpdateStep;
  final Function(String) onUpdateAvatar;

  const WireframeDesktopCommentModal({
    Key? key,
    required this.commentController,
    required this.nameController,
    required this.emailController,
    required this.commentStep,
    required this.selectedAvatar,
    required this.onAddComment,
    required this.onUpdateStep,
    required this.onUpdateAvatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (commentStep == 0) {
      return _buildDesktopCommentStep();
    } else {
      return _buildDesktopDetailsStep(context);
    }
  }

  Widget _buildDesktopCommentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Comment text area
        Expanded(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(WireframeLayoutConstants.spacingStandard),
            decoration: BoxDecoration(
              border: Border.all(
                color: WireframeColorManager.colors.border!,
                width: 1,
              ),
              borderRadius:
                  BorderRadius.circular(WireframeLayoutConstants.radiusLarge),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Leave a comment/post!',
                  style: TextStyle(
                    color: WireframeColorManager.colors.text!.withAlpha(160),
                    fontSize: WireframeLayoutConstants.desktopFontSizeBody,
                  ),
                ),
                SizedBox(height: WireframeLayoutConstants.spacingSmall),
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: TextField(
                      controller: commentController,
                      maxLines: null,
                      expands: true,
                      maxLength: 300,
                      onChanged: (value) => onUpdateStep(commentStep),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'This is a working forum!',
                        hintStyle: TextStyle(
                          color:
                              WireframeColorManager.colors.text!.withAlpha(160),
                          fontSize:
                              WireframeLayoutConstants.desktopFontSizeBody,
                        ),
                        counterText: '${commentController.text.length}/300',
                        counterStyle: TextStyle(
                          color: WireframeLayoutConstants.wireframeSecondary,
                          fontSize: WireframeLayoutConstants.mobileFontSizeBody,
                        ),
                      ),
                      style: TextStyle(
                        fontSize:
                            WireframeLayoutConstants.desktopFontSizeBodyLarge,
                        color: WireframeColorManager.colors.text,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: WireframeLayoutConstants.spacingLarge),

        // Next button at bottom right
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: commentController.text.trim().isEmpty
                ? null
                : () => onUpdateStep(1),
            style: TextButton.styleFrom(
              backgroundColor: commentController.text.trim().isEmpty
                  ? WireframeColorManager.colors.disabled
                  : WireframeColorManager.colors.primary,
              padding: EdgeInsets.symmetric(
                horizontal: WireframeLayoutConstants.spacingMedium,
                vertical: WireframeLayoutConstants.spacingSmall,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(WireframeLayoutConstants.radiusSmall),
              ),
            ),
            child: Text(
              'Next',
              style: TextStyle(
                color: WireframeColorManager.colors.onPrimary,
                fontSize: WireframeLayoutConstants.desktopFontSizeBody,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        SizedBox(height: WireframeLayoutConstants.spacingLarge),
      ],
    );
  }

  Widget _buildDesktopDetailsStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name field
        Material(
          color: Colors.transparent,
          child: Container(
            width: double.infinity,
            child: TextField(
              controller: nameController,
              onChanged: (value) => onUpdateStep(commentStep),
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(
                  color: WireframeColorManager.colors.textSecondary,
                ),
                filled: true,
                fillColor: WireframeColorManager.colors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      WireframeLayoutConstants.radiusMedium),
                  borderSide:
                      BorderSide(color: WireframeColorManager.colors.border!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      WireframeLayoutConstants.radiusMedium),
                  borderSide:
                      BorderSide(color: WireframeColorManager.colors.border!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      WireframeLayoutConstants.radiusMedium),
                  borderSide: BorderSide(
                      color: WireframeColorManager.colors.primary, width: 2),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: WireframeLayoutConstants.spacingStandard,
                  vertical: WireframeLayoutConstants.spacingStandard,
                ),
              ),
              style: TextStyle(
                fontSize: WireframeLayoutConstants.desktopFontSizeBodyLarge,
                color: WireframeColorManager.colors.text,
              ),
            ),
          ),
        ),

        SizedBox(height: WireframeLayoutConstants.spacingLarge),

        // Email field
        Material(
          color: Colors.transparent,
          child: Container(
            width: double.infinity,
            child: TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => onUpdateStep(commentStep),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
                  color: WireframeColorManager.colors.textSecondary,
                ),
                filled: true,
                fillColor: WireframeColorManager.colors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      WireframeLayoutConstants.radiusMedium),
                  borderSide:
                      BorderSide(color: WireframeColorManager.colors.border!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      WireframeLayoutConstants.radiusMedium),
                  borderSide:
                      BorderSide(color: WireframeColorManager.colors.border!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      WireframeLayoutConstants.radiusMedium),
                  borderSide: BorderSide(
                      color: WireframeColorManager.colors.primary, width: 2),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: WireframeLayoutConstants.spacingStandard,
                  vertical: WireframeLayoutConstants.spacingStandard,
                ),
              ),
              style: TextStyle(
                fontSize: WireframeLayoutConstants.desktopFontSizeBodyLarge,
                color: WireframeColorManager.colors.text,
              ),
            ),
          ),
        ),

        SizedBox(height: WireframeLayoutConstants.spacingLarge),

        // Back and Post buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Back button
            TextButton(
              onPressed: () => onUpdateStep(0),
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: WireframeColorManager.colors.textSecondary,
                padding: EdgeInsets.symmetric(
                  horizontal: WireframeLayoutConstants.spacingMedium,
                  vertical: WireframeLayoutConstants.spacingSmall,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      WireframeLayoutConstants.radiusSmall),
                  side: BorderSide(color: WireframeColorManager.colors.border!),
                ),
              ),
              child: Text(
                'Back',
                style: TextStyle(
                  color: WireframeColorManager.colors.textSecondary,
                  fontSize: WireframeLayoutConstants.desktopFontSizeBody,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            SizedBox(width: WireframeLayoutConstants.spacingLarge),

            // Post button
            TextButton(
              onPressed: (nameController.text.trim().isEmpty ||
                      emailController.text.trim().isEmpty)
                  ? null
                  : onAddComment,
              style: TextButton.styleFrom(
                backgroundColor: (nameController.text.trim().isEmpty ||
                        emailController.text.trim().isEmpty)
                    ? WireframeColorManager.colors.disabled
                    : WireframeColorManager.colors.primary,
                padding: EdgeInsets.symmetric(
                  horizontal: WireframeLayoutConstants.spacingMedium,
                  vertical: WireframeLayoutConstants.spacingSmall,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      WireframeLayoutConstants.radiusSmall),
                ),
              ),
              child: Text(
                'Post',
                style: TextStyle(
                  color: WireframeColorManager.colors.onPrimary,
                  fontSize: WireframeLayoutConstants.desktopFontSizeBody,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 30),

        // Divider line
        Container(
          height: 1,
          color: WireframeColorManager.colors.border,
          margin: EdgeInsets.symmetric(
              vertical: WireframeLayoutConstants.spacingMedium),
        ),

        // Avatar selection
        Text(
          'Choose Avatar (optional)',
          style: TextStyle(
            fontSize: WireframeLayoutConstants.desktopFontSizeBodyLarge,
            color: WireframeColorManager.colors.text,
            fontWeight: FontWeight.w500,
          ),
        ),

        SizedBox(height: WireframeLayoutConstants.spacingStandard),

        // Desktop avatar grid - scrollable with more height
        Container(
          height: 230, // Increased height to show more avatars
          child: _buildDesktopInlineAvatarGrid(context),
        ),

        SizedBox(height: WireframeLayoutConstants.spacingLarge),
      ],
    );
  }

  Widget _buildDesktopInlineAvatarGrid(BuildContext context) {
    final avatars = AvatarSystem.getAllAvatars();

    return Container(
      padding: EdgeInsets.all(WireframeLayoutConstants.spacingSmall),
      decoration: BoxDecoration(
        color: WireframeColorManager.colors.surface!.withOpacity(0.3),
        borderRadius:
            BorderRadius.circular(WireframeLayoutConstants.radiusSmall),
        border: Border.all(color: WireframeColorManager.colors.border!),
      ),
      child: Scrollbar(
        thumbVisibility: true, // Always show scrollbar
        child: GridView.builder(
          shrinkWrap: false, // Allow scrolling
          physics: AlwaysScrollableScrollPhysics(), // Enable scrolling
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6, // 6 columns for desktop
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.0,
          ),
          itemCount: avatars.length,
          itemBuilder: (context, index) {
            final avatar = avatars[index];
            final isSelected = selectedAvatar == avatar['id'];

            return ClickableWidget(
              onTap: () => onUpdateAvatar(avatar['id']),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? WireframeColorManager.colors.primary.withOpacity(0.15)
                      : Colors.transparent,
                  border: isSelected
                      ? Border.all(
                          color: WireframeColorManager.colors.primary,
                          width: 2,
                        )
                      : null,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: WireframeColorManager.colors.primary
                                .withOpacity(0.3),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: AvatarSystem.buildAvatar(
                  avatarId: avatar['id'],
                  userName: nameController.text.isNotEmpty
                      ? nameController.text
                      : 'User',
                  size: 32,
                  showBorder: isSelected,
                  borderColor: WireframeColorManager.colors.primary,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
