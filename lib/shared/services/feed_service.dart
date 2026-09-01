import 'package:dio/dio.dart';
import '../../core/constants.dart';
import '../../core/inspector.dart';
import '../models/post_model.dart';
import '../models/story_model.dart';
import '../models/user_model.dart';

/// Production Dio client implementation of FeedService connecting directly to the Node.js backend.
class FeedService {
  FeedService({
    Dio? dio,
    String? baseUrl,
    String? userId,
  }) : _userId = userId ?? AppConstants.defaultUserId {
    _dio = dio ??
        Dio(
          BaseOptions(
            baseUrl: baseUrl ?? AppConstants.apiBaseUrl,
            connectTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 5),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'x-user-id': _userId,
            },
          ),
        );

    // Attach DioRequestInspector interceptor only when compile-time flag is enabled
    if (isDioInspectorEnabled && appDioInspector != null) {
      _dio.interceptors.add(appDioInspector!.getDioRequestInterceptor());
    }
  }

  late final Dio _dio;
  final String _userId;

  Future<List<StoryModel>> getStories() async {
    final response = await _dio.get<Map<String, dynamic>>('/stories');

    if (response.statusCode == 200 && response.data != null) {
      final jsonBody = response.data!;
      if (jsonBody['success'] == true && jsonBody['data'] is List) {
        final list = jsonBody['data'] as List<dynamic>;
        return list
            .map((item) => StoryModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    }

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      error: 'Failed to fetch stories from backend: ${response.statusCode}',
    );
  }

  Future<List<PostModel>> getPosts({String? filter, int limit = 5, int page = 1}) async {
    final queryParams = <String, dynamic>{
      'limit': limit.toString(),
      'page': page.toString(),
    };

    if (filter != null && filter.isNotEmpty && filter != 'All') {
      if (filter == 'Requests') {
        queryParams['category'] = 'request';
      } else if (filter == 'General') {
        queryParams['category'] = 'general';
      } else if (filter == 'Properties') {
        queryParams['category'] = 'property';
      }
    }

    final response = await _dio.get<Map<String, dynamic>>(
      '/posts',
      queryParameters: queryParams,
    );

    if (response.statusCode == 200 && response.data != null) {
      final jsonBody = response.data!;
      if (jsonBody['success'] == true) {
        final data = jsonBody['data'] as Map<String, dynamic>;
        final postsList = data['posts'] as List<dynamic>? ?? [];
        return postsList
            .map((item) => PostModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    }

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      error: 'Failed to fetch posts from backend: ${response.statusCode}',
    );
  }

  Future<PostModel> toggleLike(String postId) async {
    final response = await _dio.post<Map<String, dynamic>>('/posts/$postId/like');

    if (response.statusCode == 200 && response.data != null) {
      final jsonBody = response.data!;
      if (jsonBody['success'] == true) {
        final data = jsonBody['data'] as Map<String, dynamic>;
        final isLiked = data['isLiked'] as bool? ?? false;
        final likesCount = data['likesCount'] as int? ?? 0;

        return PostModel(
          id: postId,
          author: const UserModel(id: 'temp', name: 'User', avatarUrl: ''),
          category: PostCategory.request,
          content: '',
          timeAgo: 'Just Now',
          isLiked: isLiked,
          likesCount: likesCount,
        );
      }
    }

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      error: 'Failed to toggle like on backend: ${response.statusCode}',
    );
  }

  Future<PostModel> toggleBookmark(String postId) async {
    return PostModel(
      id: postId,
      author: const UserModel(id: 'temp', name: 'User', avatarUrl: ''),
      category: PostCategory.request,
      content: '',
      timeAgo: 'Just Now',
      isBookmarked: true,
    );
  }

  Future<PostModel> createPost({
    required String content,
    required PostCategory category,
    PropertyTag? tag,
    String? location,
    String? mediaUrl,
  }) async {
    final payload = {
      'content': content,
      'category': category.name,
      'tag': tag?.label,
      'location': location ?? 'Lekki Phase 1, Lagos',
      'mediaUrl': mediaUrl,
      'isVideo': false,
    };

    final response = await _dio.post<Map<String, dynamic>>(
      '/posts',
      data: payload,
    );

    if ((response.statusCode == 201 || response.statusCode == 200) &&
        response.data != null) {
      final jsonBody = response.data!;
      if (jsonBody['success'] == true && jsonBody['data'] != null) {
        return PostModel.fromJson(jsonBody['data'] as Map<String, dynamic>);
      }
    }

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      error: 'Failed to create post on backend: ${response.statusCode}',
    );
  }

  Future<List<CommentModel>> getComments(String postId) async {
    final response = await _dio.get<Map<String, dynamic>>('/posts/$postId/comments');

    if (response.statusCode == 200 && response.data != null) {
      final jsonBody = response.data!;
      if (jsonBody['success'] == true) {
        final data = jsonBody['data'] as Map<String, dynamic>;
        final commentsList = data['comments'] as List<dynamic>? ?? [];
        return commentsList
            .map((item) => CommentModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    }

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      error: 'Failed to fetch comments from backend: ${response.statusCode}',
    );
  }

  Future<CommentModel> addComment(String postId, String text) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/posts/$postId/comments',
      data: {'text': text},
    );

    if ((response.statusCode == 201 || response.statusCode == 200) &&
        response.data != null) {
      final jsonBody = response.data!;
      if (jsonBody['success'] == true && jsonBody['data'] != null) {
        return CommentModel.fromJson(jsonBody['data'] as Map<String, dynamic>);
      }
    }

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      error: 'Failed to add comment on backend: ${response.statusCode}',
    );
  }
}
