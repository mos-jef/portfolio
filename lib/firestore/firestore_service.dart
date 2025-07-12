// File: lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio_website/firestore/firestore_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  CollectionReference get postsCollection => _firestore.collection('posts');
  CollectionReference get usersCollection => _firestore.collection('users');

  // Current user
  PortfolioUser? _currentUser;
  PortfolioUser? get currentUser => _currentUser;

  // Initialize service
  Future<void> initialize() async {

    await _loadCurrentUser();
    if (_currentUser == null) {
      await _createGuestUser();
    }
  }

  // Create guest user
  Future<void> _createGuestUser() async {
    final user = PortfolioUser(
      name: 'Portfolio Visitor',
      avatar: 'person',
      isGuest: true,
    );
    await setCurrentUser(user);
  }

  // Set current user
  Future<void> setCurrentUser(PortfolioUser user) async {
    _currentUser = user;

    // Save to Firestore (uses Timestamp)
    await usersCollection
        .doc(user.id)
        .set(user.toFirestore(), SetOptions(merge: true));

    // Save locally for persistence (uses JSON-compatible format)
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_user', jsonEncode(user.toJson()));
  }

  // Load current user from local storage
  Future<void> _loadCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('current_user');
      if (userJson != null) {
        final userData = jsonDecode(userJson);

        // Handle joinedAt properly
        DateTime joinedAt;
        if (userData['joinedAt'] is int) {
          joinedAt = DateTime.fromMillisecondsSinceEpoch(userData['joinedAt']);
        } else if (userData['joinedAt'] is String) {
          joinedAt = DateTime.parse(userData['joinedAt']);
        } else {
          joinedAt = DateTime.now();
        }

        _currentUser = PortfolioUser(
          id: userData['id'],
          name: userData['name'],
          avatar: userData['avatar'],
          joinedAt: joinedAt,
          email: userData['email'],
          isGuest: userData['isGuest'] ?? true,
        );

        print(
            '✅ Loaded existing user: ${_currentUser!.name} (${_currentUser!.id})');
      }
    } catch (e) {
      print('Error loading user: $e');
      // Only create new guest user if loading completely fails
    }
  }


  // Update user name/avatar
  Future<void> updateUser({String? name, String? avatar}) async {
    if (_currentUser == null) return;

    final updatedUser = PortfolioUser(
      id: _currentUser!.id,
      name: name ?? _currentUser!.name,
      avatar: avatar ?? _currentUser!.avatar,
      joinedAt: _currentUser!.joinedAt,
      email: _currentUser!.email,
      isGuest: _currentUser!.isGuest,
    );

    await setCurrentUser(updatedUser);
  }

  // Get posts stream (real-time updates)
  Stream<List<SocialPost>> getPostsStream() {
    return postsCollection
        .orderBy('createdAt', descending: true)
        .limit(50) // Limit for performance
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => SocialPost.fromFirestore(
              doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    });
  }

  // Get posts (one-time fetch)
  Future<List<SocialPost>> getPosts() async {
    try {
      final snapshot = await postsCollection
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();

      return snapshot.docs
          .map((doc) => SocialPost.fromFirestore(
              doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      print('Error fetching posts: $e');
      return [];
    }
  }

  // Add new post
  Future<SocialPost> addPost({
    required String content,
    String? authorName,
    String? authorAvatar,
  }) async {
    if (_currentUser == null) throw Exception('No current user');

    final post = SocialPost(
      authorName: authorName ?? _currentUser!.name,
      authorAvatar: authorAvatar ?? _currentUser!.avatar,
      authorId: _currentUser!.id,
      content: content,
    );

    // Add to Firestore
    await postsCollection.doc(post.id).set(post.toFirestore());

    return post;
  }

  // Toggle like on post
  Future<void> toggleLike(String postId) async {
    if (_currentUser == null) throw Exception('No current user');

    final postRef = postsCollection.doc(postId);

    return _firestore.runTransaction((transaction) async {
      final postSnapshot = await transaction.get(postRef);

      if (!postSnapshot.exists) {
        throw Exception('Post does not exist');
      }

      final postData = postSnapshot.data() as Map<String, dynamic>;
      final likedByUsers = List<String>.from(postData['likedByUsers'] ?? []);

      if (likedByUsers.contains(_currentUser!.id)) {
        // Remove like
        likedByUsers.remove(_currentUser!.id);
      } else {
        // Add like
        likedByUsers.add(_currentUser!.id);
      }

      // Update post
      transaction.update(postRef, {
        'likedByUsers': likedByUsers,
        'likeCount': likedByUsers.length,
      });
    });
  }

  // Update post content
  Future<void> updatePost(String postId, String newContent) async {
    if (_currentUser == null) throw Exception('No current user');

    try {
      final postRef = postsCollection.doc(postId);
      await postRef.update({
        'content': newContent,
        'updatedAt': Timestamp.now(),
      });
      print('Post updated successfully');
    } catch (e) {
      print('Error updating post: $e');
      rethrow;
    }
  }

// Delete post
  Future<bool> deletePost(String postId) async {
    if (_currentUser == null) throw Exception('No current user');

    try {
      final postRef = postsCollection.doc(postId);

      // Get post data to check if user can delete
      final postSnapshot = await postRef.get();
      if (!postSnapshot.exists) {
        return false;
      }

      final postData = postSnapshot.data() as Map<String, dynamic>;
      final postAuthorId = postData['authorId'] as String?;
      final postAuthorName = postData['authorName'] as String?;

      // Check if current user can delete (author or admin)
      if (postAuthorId == _currentUser!.id ||
          postAuthorName == _currentUser!.name) {
        await postRef.delete();
        print('Post deleted successfully');
        return true;
      } else {
        print('User not authorized to delete this post');
        return false;
      }
    } catch (e) {
      print('Error deleting post: $e');
      return false;
    }
  }

  // Add comment to post
  Future<void> addComment({
    required String postId,
    required String content,
    String? authorName,
    String? authorAvatar,
  }) async {
    if (_currentUser == null) throw Exception('No current user');

    final comment = Comment(
      authorName: authorName ?? _currentUser!.name,
      authorAvatar: authorAvatar ?? _currentUser!.avatar,
      authorId: _currentUser!.id,
      content: content,
    );

    final postRef = postsCollection.doc(postId);

    return _firestore.runTransaction((transaction) async {
      final postSnapshot = await transaction.get(postRef);

      if (!postSnapshot.exists) {
        throw Exception('Post does not exist');
      }

      final postData = postSnapshot.data() as Map<String, dynamic>;
      final comments =
          List<Map<String, dynamic>>.from(postData['comments'] ?? []);

      comments.add(comment.toFirestore());

      // Update post
      transaction.update(postRef, {
        'comments': comments,
        'commentCount': comments.length,
      });
    });
  }


  // Seed initial data (call once)
  Future<void> seedInitialData() async {
    try {
      // Check if posts already exist
      final existingPosts = await postsCollection.limit(1).get();
      if (existingPosts.docs.isNotEmpty) {
        print('Initial data already exists');
        return;
      }

      // Create sample posts
      final samplePosts = [
        SocialPost(
          authorName: 'Aminah',
          authorAvatar: 'person',
          content:
              'Jeff is a UX/UI Designer from Portland, Oregon. Check out his projects!',
          createdAt: DateTime.now().subtract(const Duration(hours: 19)),
          likeCount: 24,
          commentCount: 8,
          likedByUsers: List.generate(24, (i) => 'user_$i'),
        ),
        SocialPost(
          authorName: 'Jeffjitsu',
          authorAvatar: 'account_circle',
          content:
              'Make sure to poke around his profile! It\'s full of fun interactive elements, themes, and modes!',
          createdAt: DateTime.now().subtract(const Duration(hours: 19)),
          likeCount: 14,
          commentCount: 2,
          likedByUsers: List.generate(14, (i) => 'user_${i + 24}'),
        ),
        SocialPost(
          authorName: 'Alex Chen',
          authorAvatar: 'sentiment_satisfied',
          content:
              'This portfolio is amazing! Love the attention to detail and the interactive wireframe concept.',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          likeCount: 8,
          commentCount: 1,
          likedByUsers: List.generate(8, (i) => 'user_${i + 38}'),
        ),
      ];

      // Add sample posts to Firestore
      for (final post in samplePosts) {
        await postsCollection.doc(post.id).set(post.toFirestore());
      }

      print('Initial data seeded successfully');
    } catch (e) {
      print('Error seeding initial data: $e');
    }
  }

  // Clear all data (for testing - use with caution!)
  Future<void> clearAllData() async {
    try {
      // Delete all posts
      final posts = await postsCollection.get();
      for (final doc in posts.docs) {
        await doc.reference.delete();
      }

      // Clear local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('current_user');
      _currentUser = null;

      await initialize();
      print('All data cleared');
    } catch (e) {
      print('Error clearing data: $e');
    }
  }

  /// Pin a post with sequential ordering
  Future<void> pinPost(String postId) async {
    if (_currentUser == null) throw Exception('No current user');

    try {
      // Get the next pin order
      final nextPinOrder = await _getNextPinOrder();

      final postRef = postsCollection.doc(postId);
      await postRef.update({
        'isPinned': true,
        'pinOrder': nextPinOrder,
        'pinnedAt': Timestamp.now(),
        'pinnedBy': _currentUser!.id,
      });

      print('Post pinned successfully with order: $nextPinOrder');
    } catch (e) {
      print('Error pinning post: $e');
      rethrow;
    }
  }

  /// Unpin a post and reorder remaining pins
  Future<void> unpinPost(String postId) async {
    if (_currentUser == null) throw Exception('No current user');

    try {
      final postRef = postsCollection.doc(postId);

      // Get the post's current pin order before unpinning
      final postSnapshot = await postRef.get();
      final postData = postSnapshot.data() as Map<String, dynamic>;
      final removedPinOrder = postData['pinOrder'] as int?;

      // Unpin the post
      await postRef.update({
        'isPinned': false,
        'pinOrder': FieldValue.delete(),
        'pinnedAt': FieldValue.delete(),
        'pinnedBy': FieldValue.delete(),
      });

      // Reorder remaining pinned posts
      if (removedPinOrder != null) {
        await _reorderPinsAfterRemoval(removedPinOrder);
      }

      print('Post unpinned successfully');
    } catch (e) {
      print('Error unpinning post: $e');
      rethrow;
    }
  }

  /// Get the next available pin order
  Future<int> _getNextPinOrder() async {
    try {
      final pinnedPosts = await postsCollection
          .where('isPinned', isEqualTo: true)
          .orderBy('pinOrder', descending: true)
          .limit(1)
          .get();

      if (pinnedPosts.docs.isEmpty) {
        return 1; // First pinned post
      }

      final data = pinnedPosts.docs.first.data() as Map<String, dynamic>?;
      final highestOrder = data?['pinOrder'] as int? ?? 0;
      return highestOrder + 1;
    } catch (e) {
      print('Error getting next pin order: $e');
      return 1;
    }
  }

  /// Reorder pins after one is removed
  Future<void> _reorderPinsAfterRemoval(int removedOrder) async {
    try {
      final pinnedPosts = await postsCollection
          .where('isPinned', isEqualTo: true)
          .where('pinOrder', isGreaterThan: removedOrder)
          .get();

      // Update each post to move it down by 1
      final batch = _firestore.batch();
      for (final doc in pinnedPosts.docs) {
        final data = doc.data() as Map<String, dynamic>?;
        final currentOrder = data?['pinOrder'] as int?;
        if (currentOrder != null) {
          batch.update(doc.reference, {'pinOrder': currentOrder - 1});
        }
      }

      await batch.commit();
    } catch (e) {
      print('Error reordering pins: $e');
    }

    

  }

  /// Change pin order (move pin up/down)
  Future<void> changePinOrder(String postId, int newOrder) async {
    if (_currentUser == null) throw Exception('No current user');

    try {
      // Get current post data
      final postRef = postsCollection.doc(postId);
      final postSnapshot = await postRef.get();
      final postData = postSnapshot.data() as Map<String, dynamic>;
      final currentOrder = postData['pinOrder'] as int?;

      if (currentOrder == null || !postData['isPinned']) {
        throw Exception('Post is not pinned');
      }

      // Get the post at the target position
      final targetPosts = await postsCollection
          .where('isPinned', isEqualTo: true)
          .where('pinOrder', isEqualTo: newOrder)
          .limit(1)
          .get();

      if (targetPosts.docs.isNotEmpty) {
        // Swap orders
        final targetPostRef = targetPosts.docs.first.reference;

        final batch = _firestore.batch();
        batch.update(postRef, {'pinOrder': newOrder});
        batch.update(targetPostRef, {'pinOrder': currentOrder});
        await batch.commit();
      }

      print('Pin order changed successfully');
    } catch (e) {
      print('Error changing pin order: $e');
      rethrow;
    }
  }

  // Add emoji reaction to a post (Optimized)
  Future<void> addReactionToPost(String postId, String emojiText) async {
    if (_currentUser == null) throw Exception('No current user');

    try {
      final postRef = postsCollection.doc(postId);
      final userReactionKey = '${_currentUser!.id}_$emojiText';

      // Use a simple update with FieldValue.arrayUnion/arrayRemove if possible
      // Or use a lightweight transaction
      return _firestore.runTransaction((transaction) async {
        final postSnapshot = await transaction.get(postRef);

        if (!postSnapshot.exists) {
          throw Exception('Post does not exist');
        }

        final postData = postSnapshot.data() as Map<String, dynamic>;
        final reactions =
            Map<String, dynamic>.from(postData['reactions'] ?? {});

        if (reactions.containsKey(userReactionKey)) {
          reactions.remove(userReactionKey);
        } else {
          reactions[userReactionKey] = {
            'userId': _currentUser!.id,
            'userName': _currentUser!.name,
            'emoji': emojiText,
            'timestamp': FieldValue.serverTimestamp(),
          };
        }

        // Single atomic update
        transaction.update(postRef, {'reactions': reactions});
      });
    } catch (e) {
      print('Error adding reaction: $e');
      rethrow;
    }
  }

  // Get reaction counts for a post
  Map<String, int> getReactionCounts(Map<String, dynamic> reactions) {
    final counts = <String, int>{};

    for (final reaction in reactions.values) {
      if (reaction is Map<String, dynamic>) {
        final emoji = reaction['emoji'] as String?;
        if (emoji != null) {
          counts[emoji] = (counts[emoji] ?? 0) + 1;
        }
      }
    }

    return counts;
  }

  // Check if current user has reacted with specific emoji
  bool hasUserReacted(Map<String, dynamic> reactions, String emojiText) {
    if (_currentUser == null) return false;

    final userReactionKey = '${_currentUser!.id}_$emojiText';
    return reactions.containsKey(userReactionKey);
  }

  /// Get posts with pinned posts first, then regular posts
  Stream<List<SocialPost>> getPostsStreamWithPins() {
    return postsCollection
        .orderBy('isPinned', descending: true)
        .orderBy('pinOrder')
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => SocialPost.fromFirestore(
              doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    });
  }

  /// Get all pinned posts in order
  Future<List<SocialPost>> getPinnedPosts() async {
    try {
      final snapshot = await postsCollection
          .where('isPinned', isEqualTo: true)
          .orderBy('pinOrder')
          .get();

      return snapshot.docs
          .map((doc) => SocialPost.fromFirestore(
              doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      print('Error fetching pinned posts: $e');
      return [];
    }
  }

  // Get user statistics
  Future<Map<String, int>> getUserStats(String userId) async {
    try {
      final postsQuery =
          await postsCollection.where('authorId', isEqualTo: userId).get();

      int totalLikes = 0;
      int totalComments = 0;

      for (final doc in postsQuery.docs) {
        final data = doc.data() as Map<String, dynamic>;
        totalLikes += (data['likeCount'] as int? ?? 0);
        totalComments += (data['commentCount'] as int? ?? 0);
      }

      return {
        'posts': postsQuery.docs.length,
        'likes': totalLikes,
        'comments': totalComments,
      };
    } catch (e) {
      print('Error getting user stats: $e');
      return {'posts': 0, 'likes': 0, 'comments': 0};
    }
  }
}
