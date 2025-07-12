// File: lib/models/firestore_models.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class SocialPost {
  final String id;
  final String authorName;
  final String authorAvatar;
  final String content;
  final DateTime createdAt;
  final int likeCount;
  final int commentCount;
  final List<String> likedByUsers;
  final List<Comment> comments;
  final String? authorId; // Optional: for user tracking
  final bool isPinned;
  final int? pinOrder; // For sequential pinning (1, 2, 3, etc.)
  final DateTime? pinnedAt;
  final String? pinnedBy; // Who pinned it
  final Map<String, dynamic> reactions;

  SocialPost({
    String? id,
    required this.authorName,
    required this.authorAvatar,
    required this.content,
    DateTime? createdAt,
    this.likeCount = 0,
    this.commentCount = 0,
    this.likedByUsers = const [],
    this.comments = const [],
    this.authorId,
    this.isPinned = false, // 
    this.pinOrder, //
    this.pinnedAt, // 
    this.pinnedBy, // 
    this.reactions = const {},
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  // Check if current user liked this post
  bool isLikedBy(String userId) {
    return likedByUsers.contains(userId);
  }

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    Map<String, dynamic> data = {
      'id': id,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'likeCount': likeCount,
      'commentCount': commentCount,
      'likedByUsers': likedByUsers,
      'comments': comments.map((c) => c.toFirestore()).toList(),
      'authorId': authorId,
      'isPinned': isPinned,
    };

    if (pinOrder != null) data['pinOrder'] = pinOrder;
    if (pinnedAt != null) data['pinnedAt'] = Timestamp.fromDate(pinnedAt!);
    if (pinnedBy != null) data['pinnedBy'] = pinnedBy;
    data['reactions'] = reactions;

    return data;
  }

  // Create from Firestore document
  factory SocialPost.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return SocialPost(
      id: data['id'] ?? snapshot.id,
      authorName: data['authorName'] ?? '',
      authorAvatar: data['authorAvatar'] ?? 'person',
      content: data['content'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      likeCount: data['likeCount'] ?? 0,
      commentCount: data['commentCount'] ?? 0,
      likedByUsers: List<String>.from(data['likedByUsers'] ?? []),
      comments: (data['comments'] as List<dynamic>? ?? [])
          .map((c) => Comment.fromMap(c))
          .toList(),
      authorId: data['authorId'],
      isPinned: data['isPinned'] ?? false,
      pinOrder: data['pinOrder'],
      pinnedAt: data['pinnedAt'] != null
          ? (data['pinnedAt'] as Timestamp).toDate()
          : null,
      pinnedBy: data['pinnedBy'],
      reactions: Map<String, dynamic>.from(data['reactions'] ?? {}),
    );
  }

  // Create from Map (for subcollections)
  factory SocialPost.fromMap(Map<String, dynamic> data) {
    return SocialPost(
      id: data['id'],
      authorName: data['authorName'] ?? '',
      authorAvatar: data['authorAvatar'] ?? 'person',
      content: data['content'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      likeCount: data['likeCount'] ?? 0,
      commentCount: data['commentCount'] ?? 0,
      likedByUsers: List<String>.from(data['likedByUsers'] ?? []),
      comments: (data['comments'] as List<dynamic>? ?? [])
          .map((c) => Comment.fromMap(c))
          .toList(),
      authorId: data['authorId'],
    );
  }

  // Create updated copy
  SocialPost copyWith({
    String? id,
    String? authorName,
    String? authorAvatar,
    String? content,
    DateTime? createdAt,
    int? likeCount,
    int? commentCount,
    List<String>? likedByUsers,
    List<Comment>? comments,
    String? authorId,
    bool? isPinned,
    int? pinOrder,
    DateTime? pinnedAt,
    String? pinnedBy,
    Map<String, dynamic>? reactions,
  }) {
    return SocialPost(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      likedByUsers: likedByUsers ?? this.likedByUsers,
      comments: comments ?? this.comments,
      authorId: authorId ?? this.authorId,
      isPinned: isPinned ?? this.isPinned,
      pinOrder: pinOrder ?? this.pinOrder,
      pinnedAt: pinnedAt ?? this.pinnedAt,
      pinnedBy: pinnedBy ?? this.pinnedBy,
      reactions: reactions ?? this.reactions,
    );
  }
}

class Comment {
  final String id;
  final String authorName;
  final String authorAvatar;
  final String content;
  final DateTime createdAt;
  final String? authorId;

  Comment({
    String? id,
    required this.authorName,
    required this.authorAvatar,
    required this.content,
    DateTime? createdAt,
    this.authorId,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'authorId': authorId,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> data) {
    return Comment(
      id: data['id'],
      authorName: data['authorName'] ?? '',
      authorAvatar: data['authorAvatar'] ?? 'person',
      content: data['content'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      authorId: data['authorId'],
    );
  }
}

class PortfolioUser {
  final String id;
  final String name;
  final String avatar;
  final DateTime joinedAt;
  final String? email;
  final bool isGuest;

  PortfolioUser({
    String? id,
    required this.name,
    required this.avatar,
    DateTime? joinedAt,
    this.email,
    this.isGuest = true,
  })  : id = id ?? const Uuid().v4(),
        joinedAt = joinedAt ?? DateTime.now();

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'joinedAt': Timestamp.fromDate(joinedAt),
      'email': email,
      'isGuest': isGuest,
    };
  }

  // Add this new method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'joinedAt':joinedAt.millisecondsSinceEpoch, // Store as milliseconds for JSON
      'email': email,
      'isGuest': isGuest,
    };
  }

  factory PortfolioUser.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return PortfolioUser(
      id: data['id'] ?? snapshot.id,
      name: data['name'] ?? '',
      avatar: data['avatar'] ?? 'person',
      joinedAt: (data['joinedAt'] as Timestamp).toDate(),
      email: data['email'],
      isGuest: data['isGuest'] ?? true,
    );
  }
}
