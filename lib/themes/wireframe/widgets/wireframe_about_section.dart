import 'package:flutter/material.dart';
import 'package:portfolio_website/themes/wireframe/utils/wireframe_color_manager.dart';
import 'package:portfolio_website/themes/wireframe/widgets/clickable_widget.dart';

class WireframeAboutSection extends StatefulWidget {
  final bool isMobile;

  const WireframeAboutSection({
    Key? key,
    required this.isMobile,
  }) : super(key: key);

  @override
  State<WireframeAboutSection> createState() => _WireframeAboutSectionState();
}

class _WireframeAboutSectionState extends State<WireframeAboutSection> {
  String? _selectedImageForFullScreen;

  // Sample about images and content
  final List<AboutPost> _aboutPosts = [
    AboutPost(
      id: '1',
      imagePath: 'assets/about/house1.png',
      caption: 'Home is where creativity flows and ideas come to life.',
      size: PostSize.large,
    ),
    AboutPost(
      id: '2',
      imagePath: 'assets/about/brownbelt.png',
      caption:
          'Brazilian Jiu-Jitsu teaches me discipline and problem-solving - skills I apply to UX design.',
      size: PostSize.small,
    ),
    AboutPost(
      id: '3',
      imagePath: 'assets/about/fam1.png',
      caption:
          'Family keeps me grounded and reminds me what truly matters in life.',
      size: PostSize.small,
    ),
    AboutPost(
      id: '4',
      imagePath: 'assets/about/fam1.png',
      caption:
          'Family keeps me grounded and reminds me what truly matters in life.',
      size: PostSize.medium,
    ),
    AboutPost(
      id: '5',
      imagePath: 'assets/about/fam1.png',
      caption:
          'Family keeps me grounded and reminds me what truly matters in life.',
      size: PostSize.large,
    ),
    AboutPost(
      id: '6',
      imagePath: 'assets/about/fam1.png',
      caption:
          'Family keeps me grounded and reminds me what truly matters in life.',
      size: PostSize.small,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main about content
        Column(
          children: [
            // About header
            _buildAboutHeader(),

            // Photo grid
            Expanded(
              child: _buildPhotoGrid(),
            ),
          ],
        ),

        // Full screen image overlay
        if (_selectedImageForFullScreen != null) _buildFullScreenImageOverlay(),
      ],
    );
  }

  Widget _buildAboutHeader() {
    return Container(
      padding: EdgeInsets.all(widget.isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: WireframeColorManager.colors.onPrimary,
        border: Border(bottom: BorderSide(color: Color(0xFFE1E5E9))),
      ),
      child: Row(
        children: [
          // Profile avatar
          Container(
            width: widget.isMobile ? 32 : 40,
            height: widget.isMobile ? 32 : 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF007BFF).withOpacity(0.1),
              border: Border.all(color: Color(0xFF007BFF)),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/me_avatar.png',
                fit: BoxFit.cover,
                alignment: Alignment(0, -0.3),
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.person,
                    size: widget.isMobile ? 16 : 20,
                    color: Color(0xFF007BFF),
                  );
                },
              ),
            ),
          ),

          SizedBox(width: widget.isMobile ? 8 : 12),

          // Name and bio
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'jeffjitsu',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: widget.isMobile ? 14 : 16,
                      color: WireframeColorManager.colors.text),
                ),
                Text(
                  'UX/UI Designer & Developer',
                  style: TextStyle(
                    color: Color(0xFF6C757D),
                    fontSize: widget.isMobile ? 12 : 14,
                  ),
                ),
              ],
            ),
          ),

          // Posts count
          Column(
            children: [
              Text(
                '${_aboutPosts.length}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: widget.isMobile ? 14 : 16,
                    color: WireframeColorManager.colors.text),
              ),
              Text(
                'posts',
                style: TextStyle(
                  color: Color(0xFF6C757D),
                  fontSize: widget.isMobile ? 10 : 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoGrid() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 images per row
        crossAxisSpacing: 2, // Small gap between images horizontally
        mainAxisSpacing: 2, // Small gap between images vertically
        childAspectRatio: 1.0, // Makes all images perfectly square
      ),
      itemCount: _aboutPosts.length,
      itemBuilder: (context, index) {
        return _buildEqualSizePhotoPost(_aboutPosts[index]);
      },
    );
  }

  Widget _buildEqualSizePhotoPost(AboutPost post) {
    return ClickableWidget(
      onTap: () {
        setState(() {
          _selectedImageForFullScreen = post.imagePath;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF1F3F4),
          border: Border.all(color: Color(0xFFE1E5E9), width: 0.5),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image
            Image.asset(
              post.imagePath,
              fit: BoxFit
                  .cover, // This ensures all images fill the square container
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Color(0xFFF8F9FA),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_not_supported,
                        color: Color(0xFF6C757D),
                        size: widget.isMobile ? 20 : 24,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Image ${post.id}',
                        style: TextStyle(
                          color: Color(0xFF6C757D),
                          fontSize: widget.isMobile ? 8 : 10,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Subtle overlay gradient for better visual consistency
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoRow(int rowIndex) {
    final startIndex = rowIndex * 2;
    final endIndex = (startIndex + 2).clamp(0, _aboutPosts.length);
    final rowPosts = _aboutPosts.sublist(startIndex, endIndex);

    // Different row layouts based on post sizes
    if (rowPosts.length == 2) {
      final post1 = rowPosts[0];
      final post2 = rowPosts[1];

      // Determine layout based on post sizes
      if (post1.size == PostSize.large && post2.size == PostSize.small) {
        return _buildLargeSmallRow(post1, post2);
      } else if (post1.size == PostSize.small && post2.size == PostSize.large) {
        return _buildSmallLargeRow(post1, post2);
      } else if (post1.size == PostSize.small && post2.size == PostSize.small) {
        return _buildEqualRow(post1, post2);
      } else if (post1.size == PostSize.medium ||
          post2.size == PostSize.medium) {
        return _buildMediumRow(post1, post2);
      } else {
        return _buildEqualRow(post1, post2);
      }
    } else if (rowPosts.length == 1) {
      return _buildSinglePostRow(rowPosts[0]);
    }

    return SizedBox.shrink();
  }

  Widget _buildLargeSmallRow(AboutPost largePost, AboutPost smallPost) {
    final double largeHeight = widget.isMobile ? 200 : 250;
    final double smallHeight = widget.isMobile ? 95 : 120;

    return Container(
      margin: EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          // Large post (70% width)
          Expanded(
            flex: 7,
            child: _buildPhotoPost(largePost, largeHeight),
          ),

          SizedBox(width: 2),

          // Small post (30% width, stacked vertically in center)
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Container(
                  height: (largeHeight - smallHeight) / 2,
                  color: Color(0xFFF8F9FA),
                ),
                _buildPhotoPost(smallPost, smallHeight),
                Container(
                  height: (largeHeight - smallHeight) / 2,
                  color: Color(0xFFF8F9FA),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallLargeRow(AboutPost smallPost, AboutPost largePost) {
    final double largeHeight = widget.isMobile ? 200 : 250;
    final double smallHeight = widget.isMobile ? 95 : 120;

    return Container(
      margin: EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          // Small post (30% width, centered vertically)
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Container(
                  height: (largeHeight - smallHeight) / 2,
                  color: Color(0xFFF8F9FA),
                ),
                _buildPhotoPost(smallPost, smallHeight),
                Container(
                  height: (largeHeight - smallHeight) / 2,
                  color: Color(0xFFF8F9FA),
                ),
              ],
            ),
          ),

          SizedBox(width: 2),

          // Large post (70% width)
          Expanded(
            flex: 7,
            child: _buildPhotoPost(largePost, largeHeight),
          ),
        ],
      ),
    );
  }

  Widget _buildEqualRow(AboutPost post1, AboutPost post2) {
    final double height = widget.isMobile ? 150 : 180;

    return Container(
      margin: EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Expanded(child: _buildPhotoPost(post1, height)),
          SizedBox(width: 2),
          Expanded(child: _buildPhotoPost(post2, height)),
        ],
      ),
    );
  }

  Widget _buildMediumRow(AboutPost post1, AboutPost post2) {
    final double height = widget.isMobile ? 180 : 220;

    return Container(
      margin: EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Expanded(
            flex: post1.size == PostSize.medium ? 6 : 4,
            child: _buildPhotoPost(post1, height),
          ),
          SizedBox(width: 2),
          Expanded(
            flex: post2.size == PostSize.medium ? 6 : 4,
            child: _buildPhotoPost(post2, height),
          ),
        ],
      ),
    );
  }

  Widget _buildSinglePostRow(AboutPost post) {
    final double height = widget.isMobile ? 200 : 250;

    return Container(
      margin: EdgeInsets.only(bottom: 2),
      child: _buildPhotoPost(post, height),
    );
  }

  Widget _buildPhotoPost(AboutPost post, double height) {
    return ClickableWidget(
      onTap: () {
        setState(() {
          _selectedImageForFullScreen = post.imagePath;
        });
      },
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Color(0xFFF1F3F4),
          border: Border.all(color: Color(0xFFE1E5E9), width: 0.5),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image
            Image.asset(
              post.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Color(0xFFF8F9FA),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_not_supported,
                        color: Color(0xFF6C757D),
                        size: widget.isMobile ? 24 : 32,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Image ${post.id}',
                        style: TextStyle(
                          color: Color(0xFF6C757D),
                          fontSize: widget.isMobile ? 10 : 12,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Overlay gradient for better text readability
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),

            // Caption preview (only show for larger posts)
            if (height > 150)
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: Text(
                  post.caption,
                  style: TextStyle(
                    color: WireframeColorManager.colors.onPrimary,
                    fontSize: widget.isMobile ? 10 : 12,
                    fontWeight: FontWeight.w500,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 2,
                        color: Colors.black.withOpacity(0.8),
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullScreenImageOverlay() {
    final selectedPost = _aboutPosts.firstWhere(
      (post) => post.imagePath == _selectedImageForFullScreen,
      orElse: () => _aboutPosts.first,
    );

    return ClickableWidget(
      onTap: () {
        setState(() {
          _selectedImageForFullScreen = null;
        });
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black.withOpacity(0.9),
        child: Stack(
          children: [
            // Image
            Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                ),
                child: Image.asset(
                  selectedPost.imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 200,
                      height: 200,
                      color: WireframeColorManager.colors.text,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported,
                              color: WireframeColorManager.colors.onPrimary,
                              size: 48,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Image not found',
                              style: TextStyle(
                                color: WireframeColorManager.colors.onPrimary,
                                fontSize: 14,
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

            // Close button
            Positioned(
              top: widget.isMobile ? 40 : 20,
              right: widget.isMobile ? 20 : 20,
              child: ClickableWidget(
                onTap: () {
                  setState(() {
                    _selectedImageForFullScreen = null;
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.6),
                  ),
                  child: Icon(
                    Icons.close,
                    color: WireframeColorManager.colors.onPrimary,
                    size: 24,
                  ),
                ),
              ),
            ),

            // Caption at bottom
            Positioned(
              bottom: widget.isMobile ? 40 : 60,
              left: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  selectedPost.caption,
                  style: TextStyle(
                    color: WireframeColorManager.colors.onPrimary,
                    fontSize: widget.isMobile ? 14 : 16,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Data models
enum PostSize { small, medium, large }

class AboutPost {
  final String id;
  final String imagePath;
  final String caption;
  final PostSize size;

  AboutPost({
    required this.id,
    required this.imagePath,
    required this.caption,
    required this.size,
  });
}
