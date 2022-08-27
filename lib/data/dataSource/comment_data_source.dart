import 'package:nike_store/common/http_service.dart';
import 'package:nike_store/common/http_validator.dart';
import 'package:nike_store/data/comment.dart';

abstract class ICommentDataSource {
  Future<List<CommentEntity>> getComments(int producttId);
}

class CommentRemoteDataSource with HttpValidator implements ICommentDataSource {
  final HttpService httpService;

  CommentRemoteDataSource(this.httpService);
  @override
  Future<List<CommentEntity>> getComments(int productId) async {
    final response =
        await httpService.getRequest('comment/list?product_id=$productId');
    responseValidator(response);
    final List<CommentEntity> comments = [];

    (response.data as List).forEach((comment) {
      comments.add(CommentEntity.fromJson(comment));
    });

    return comments;
  }
}
