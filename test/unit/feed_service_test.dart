import 'package:dio/dio.dart';
import 'package:expert_listing/shared/models/post_model.dart';
import 'package:expert_listing/shared/services/feed_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FeedService Tests', () {
    test('throws DioException when server endpoint fails', () async {
      final dio = Dio(
        BaseOptions(
          baseUrl: 'http://127.0.0.1:59999/api',
          connectTimeout: const Duration(milliseconds: 300),
          receiveTimeout: const Duration(milliseconds: 300),
        ),
      );
      final service = FeedService(dio: dio);

      expect(() => service.getStories(), throwsA(isA<DioException>()));
      expect(() => service.getPosts(), throwsA(isA<DioException>()));
      expect(
        () => service.createPost(
          content: 'Test content',
          category: PostCategory.request,
        ),
        throwsA(isA<DioException>()),
      );
      expect(() => service.toggleLike('test_id'), throwsA(isA<DioException>()));
    });
  });
}
