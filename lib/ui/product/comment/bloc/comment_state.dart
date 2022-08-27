part of 'comment_bloc.dart';

abstract class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object> get props => [];
}

class CommentLoading extends CommentState {}

class CommentError extends CommentState {
  final AppException appException;

  const CommentError(this.appException);
  @override
  List<Object> get props => [appException];
}

class CommentSuccess extends CommentState {
  final List<CommentEntity> comments;

  const CommentSuccess(this.comments);
  @override
  List<Object> get props => [comments];
}
