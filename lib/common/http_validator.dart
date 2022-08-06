import 'package:dio/dio.dart';
import 'package:nike_store/common/exception.dart';

mixin HttValidator {
  void responseValidator(Response response) {
    if (response.statusCode != 200) {
      throw AppException('خطایی رخ داده است');
    }
  }
}
