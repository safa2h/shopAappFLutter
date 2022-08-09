import 'package:nike_store/common/http_service.dart';
import 'package:nike_store/common/http_validator.dart';
import 'package:nike_store/data/comment.dart';
import 'package:nike_store/data/dataSource/comment_data_source.dart';

abstract class ICommentRepository {
  Future<List<CommentEntity>> getComments(int producttId);
}

final commentRepository =
    CommentRepository(CommentRemoteDataSource(HttpService()));

class CommentRepository with HttpValidator implements ICommentRepository {
  final ICommentDataSource commentDataSource;

  CommentRepository(this.commentDataSource);
  @override
  Future<List<CommentEntity>> getComments(int productId) async {
    return commentDataSource.getComments(productId);
  }
}
