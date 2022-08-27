part of 'comment_bloc.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();

  @override
  List<Object> get props => [];
}

class CommentStarted extends CommentEvent {
  final int productId;

  const CommentStarted(this.productId);
  @override
  List<Object> get props => [productId];
}
