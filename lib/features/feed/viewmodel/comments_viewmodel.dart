import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/post_model.dart';
import 'feed_viewmodel.dart';

class CommentsState {
  const CommentsState({
    this.comments = const [],
    this.isSubmitting = false,
  });

  final List<CommentModel> comments;
  final bool isSubmitting;

  CommentsState copyWith({
    List<CommentModel>? comments,
    bool? isSubmitting,
  }) {
    return CommentsState(
      comments: comments ?? this.comments,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class CommentsNotifier extends AutoDisposeFamilyAsyncNotifier<CommentsState, String> {
  @override
  FutureOr<CommentsState> build(String arg) async {
    final service = ref.watch(feedServiceProvider);
    final comments = await service.getComments(arg);
    return CommentsState(comments: comments);
  }

  Future<void> addComment(String text) async {
    final current = state.value;
    if (current == null || current.isSubmitting) return;

    state = AsyncValue.data(current.copyWith(isSubmitting: true));

    try {
      final service = ref.read(feedServiceProvider);
      final newComment = await service.addComment(arg, text);
      
      state = AsyncValue.data(
        current.copyWith(
          comments: [...current.comments, newComment],
          isSubmitting: false,
        ),
      );
      
      ref.read(feedProvider.notifier).incrementCommentCount(arg);
    } catch (e) {
      state = AsyncValue.data(current.copyWith(isSubmitting: false));
      rethrow;
    }
  }
}

final commentsProvider = AutoDisposeAsyncNotifierProviderFamily<CommentsNotifier, CommentsState, String>(CommentsNotifier.new);
