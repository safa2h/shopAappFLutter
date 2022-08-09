import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nike_store/common/exception.dart';
import 'package:nike_store/data/comment.dart';
import 'package:nike_store/data/repository/commet_repository.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final ICommentRepository commentRepository;
  CommentBloc(this.commentRepository) : super(CommentLoading()) {
    on<CommentEvent>((event, emit) async {
      if (event is CommentStarted) {
        emit(CommentLoading());
        try {
          final comments = await commentRepository.getComments(event.productId);
          emit(CommentSuccess(comments));
        } catch (e) {
          emit(CommentError(AppException('خطا در دریافت نظزات')));
        }
      }
    });
  }
}
