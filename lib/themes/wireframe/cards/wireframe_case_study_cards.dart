import 'package:flutter/material.dart';
import 'package:portfolio_website/themes/wireframe/utils/wireframe_color_manager.dart';
import 'package:portfolio_website/themes/wireframe/widgets/clickable_widget.dart';
import 'package:portfolio_website/themes/wireframe/wireframe_layout_constants.dart';

import '../utils/wireframe_colors.dart';
import '../utils/wireframe_helpers.dart';

/// Case study specific cards for the wireframe theme
/// Provides specialized card widgets for displaying case studies
class WireframeCaseStudyCards {
  WireframeCaseStudyCards._();

  /// Creates a case study preview card
  static Widget buildCaseStudyPreviewCard({
    required String projectId,
    required String title,
    required String subtitle,
    required String description,
    required String heroImagePath,
    required VoidCallback onTap,
    bool isMobile = false,
    bool showFullContent = false,
  }) {
    return ClickableWidget(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: isMobile ? 1 : 2),
        decoration: BoxDecoration(
          color: WireframeColorManager.colors.surface,
          borderRadius: BorderRadius.circular(
              isMobile ? 0 : WireframeLayoutConstants.radiusMedium),
          border: Border.all(
            color: WireframeColorManager.colors.border,
            width: 1,
          ),
          boxShadow: isMobile
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            _buildCaseStudyHeader(
              title: title,
              subtitle: subtitle,
              isMobile: isMobile,
            ),

            // Hero image section
            if (showFullContent)
              _buildCaseStudyHeroImage(
                heroImagePath: heroImagePath,
                isMobile: isMobile,
              ),

            // Content section
            _buildCaseStudyContent(
              description: description,
              isMobile: isMobile,
              showFullContent: showFullContent,
            ),

            // Action section
            if (showFullContent)
              _buildCaseStudyActions(
                projectId: projectId,
                isMobile: isMobile,
              ),
          ],
        ),
      ),
    );
  }

  /// Creates a compact case study list item
  static Widget buildCaseStudyListItem({
    required String projectId,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isMobile = false,
    bool isSelected = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 1),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(isMobile ? 12 : 16),
            decoration: BoxDecoration(
              color: isSelected
                  ? WireframeColors.accent.withOpacity(0.1)
                  : WireframeColorManager.colors.onPrimary,
              border: Border.all(
                color: isSelected
                    ? WireframeColors.accent
                    : WireframeColors.border,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(isMobile ? 0 : 8),
            ),
            child: Row(
              children: [
                // Project icon
                Container(
                  width: isMobile ? 40 : 48,
                  height: isMobile ? 40 : 48,
                  decoration: BoxDecoration(
                    color: WireframeHelpers.getProjectColor(projectId)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: WireframeHelpers.getProjectColor(projectId),
                    ),
                  ),
                  child: Icon(
                    WireframeHelpers.getProjectIcon(projectId),
                    color: WireframeHelpers.getProjectColor(projectId),
                    size: isMobile ? 20 : 24,
                  ),
                ),

                SizedBox(width: isMobile ? 10 : 12),

                // Project details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: isMobile ? 14 : 16,
                          color: isSelected
                              ? WireframeColors.accent
                              : WireframeColors.text,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: WireframeColors.secondary,
                          fontSize: isMobile ? 12 : 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Status indicator
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 6 : 8,
                    vertical: isMobile ? 3 : 4,
                  ),
                  decoration: BoxDecoration(
                    color: WireframeColorManager.colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: WireframeColors.border),
                  ),
                  child: Text(
                    'View',
                    style: TextStyle(
                      fontSize: isMobile ? 10 : 12,
                      color: WireframeColors.accent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Creates a case study grid item for dashboard views
  static Widget buildCaseStudyGridItem({
    required String projectId,
    required String title,
    required String subtitle,
    required String heroImagePath,
    required VoidCallback onTap,
    bool isMobile = false,
  }) {
    return ClickableWidget(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: WireframeColorManager.colors.onPrimary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: WireframeColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(11),
                    topRight: Radius.circular(11),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(11),
                    topRight: Radius.circular(11),
                  ),
                  child: Image.asset(
                    heroImagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: WireframeColorManager.colors.surfaceVariant,
                        child: Center(
                          child: Icon(
                            WireframeHelpers.getProjectIcon(projectId),
                            color: WireframeHelpers.getProjectColor(projectId),
                            size: isMobile ? 32 : 40,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Content section
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 12 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isMobile ? 14 : 16,
                        color: WireframeColors.text,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: WireframeColors.secondary,
                        fontSize: isMobile ? 11 : 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: WireframeHelpers.getProjectColor(projectId),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Case Study',
                          style: TextStyle(
                            fontSize: isMobile ? 10 : 11,
                            color: WireframeColors.secondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Private helper methods

  static Widget _buildCaseStudyHeader({
    required String title,
    required String subtitle,
    required bool isMobile,
  }) {
    return Padding(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      child: Row(
        children: [
          // Avatar placeholder
          Container(
            width: isMobile ? 32 : 40,
            height: isMobile ? 32 : 40,
            decoration: BoxDecoration(
              color: WireframeColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
              border: Border.all(color: WireframeColors.accent),
            ),
            child: Icon(
              Icons.work_outline,
              size: isMobile ? 16 : 20,
              color: WireframeColors.accent,
            ),
          ),

          SizedBox(width: isMobile ? 8 : 12),

          // Title and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isMobile ? 14 : 16,
                    color: WireframeColors.text,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: WireframeColors.secondary,
                    fontSize: isMobile ? 12 : 14,
                  ),
                ),
              ],
            ),
          ),

          // More options
          Icon(
            Icons.more_vert,
            size: isMobile ? 16 : 20,
            color: WireframeColors.secondary,
          ),
        ],
      ),
    );
  }

  static Widget _buildCaseStudyHeroImage({
    required String heroImagePath,
    required bool isMobile,
  }) {
    return Container(
      width: double.infinity,
      height: isMobile ? 160 : 200,
      margin: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: WireframeColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Image.asset(
          heroImagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: WireframeColorManager.colors.surfaceVariant,
              child: Center(
                child: Icon(
                  Icons.image_not_supported,
                  color: WireframeColors.secondary,
                  size: isMobile ? 40 : 48,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  static Widget _buildCaseStudyContent({
    required String description,
    required bool isMobile,
    required bool showFullContent,
  }) {
    return Padding(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            style: TextStyle(
              fontSize: isMobile ? 12 : 14,
              color: WireframeColors.text,
              height: 1.4,
            ),
            maxLines: showFullContent ? null : (isMobile ? 2 : 3),
            overflow: showFullContent ? null : TextOverflow.ellipsis,
          ),
          if (showFullContent) ...[
            SizedBox(height: isMobile ? 8 : 12),
            _buildCaseStudyMetrics(isMobile: isMobile),
          ],
        ],
      ),
    );
  }

  static Widget _buildCaseStudyMetrics({required bool isMobile}) {
    final metrics = [
      {'label': 'Duration', 'value': '3 months'},
      {'label': 'Team Size', 'value': '5 people'},
      {'label': 'My Role', 'value': 'UX/UI Designer'},
    ];

    return Container(
      padding: EdgeInsets.all(isMobile ? 8 : 12),
      decoration: BoxDecoration(
        color: WireframeColorManager.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: WireframeColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: metrics.map((metric) {
          return Column(
            children: [
              Text(
                metric['value']!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 12 : 14,
                  color: WireframeColors.text,
                ),
              ),
              Text(
                metric['label']!,
                style: TextStyle(
                  fontSize: isMobile ? 10 : 12,
                  color: WireframeColors.secondary,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  static Widget _buildCaseStudyActions({
    required String projectId,
    required bool isMobile,
  }) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        border: Border(
            top:
                BorderSide(color: WireframeColorManager.colors.surfaceVariant)),
      ),
      child: Row(
        children: [
          // Like button
          _buildActionButton(
            icon: Icons.favorite_outline,
            label: isMobile ? '' : 'Like',
            count: '24',
            isMobile: isMobile,
          ),

          SizedBox(width: isMobile ? 12 : 20),

          // Comment button
          _buildActionButton(
            icon: Icons.chat_bubble_outline,
            label: isMobile ? '' : 'Comment',
            count: '8',
            isMobile: isMobile,
          ),

          SizedBox(width: isMobile ? 12 : 20),

          // Share button
          _buildActionButton(
            icon: Icons.share_outlined,
            label: isMobile ? '' : 'Share',
            count: '',
            isMobile: isMobile,
          ),

          Spacer(),

          
        ],
      ),
    );
  }

  static Widget _buildActionButton({
    required IconData icon,
    required String label,
    required String count,
    required bool isMobile,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: isMobile ? 14 : 18,
          color: WireframeColors.secondary,
        ),
        if (label.isNotEmpty && !isMobile) ...[
          SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: WireframeColors.secondary,
            ),
          ),
        ],
        if (count.isNotEmpty) ...[
          SizedBox(width: 4),
          Text(
            count,
            style: TextStyle(
              fontSize: isMobile ? 11 : 14,
              color: WireframeColors.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
