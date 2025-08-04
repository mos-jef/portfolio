import 'dart:async';
import 'package:portfolio_website/firestore/firestore_models.dart';
import 'package:portfolio_website/firestore/firestore_service.dart';

class PostCacheService {
  static final PostCacheService _instance = PostCacheService._internal();
  factory PostCacheService() => _instance;
  PostCacheService._internal();

  List<SocialPost>? _cachedPosts;
  DateTime? _lastCacheTime;
  StreamSubscription<List<SocialPost>>? _subscription;
  final StreamController<List<SocialPost>> _controller =
      StreamController.broadcast();

  static const Duration _cacheTimeout = Duration(seconds: 1);

  Stream<List<SocialPost>> getPostsStream() {
    // If we have recent cached data, return it immediately
    if (_cachedPosts != null &&
        _lastCacheTime != null &&
        DateTime.now().difference(_lastCacheTime!) < _cacheTimeout) {
      _controller.add(_cachedPosts!);
    }

    // Start the subscription if not already running
    _subscription ??= FirestoreService().getPostsStream().listen((posts) {
      _cachedPosts = posts;
      _lastCacheTime = DateTime.now();
      _controller.add(posts);
    });

    return _controller.stream;
  }

  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
