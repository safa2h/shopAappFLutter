import 'package:dio/dio.dart';
import 'package:nike_store/common/consts.dart';
import 'package:nike_store/data/repository/auth_repository.dart';

class HttpService {
  late Dio _dio;

  HttpService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
    ))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (requst, handler) {
            final authInfo = AuthRepository.authInfoNotifire.value;
            if (authInfo != null && authInfo.accessToen != null) {
              requst.headers['Authorization'] = 'Bearer ${authInfo.accessToen}';
            }
            handler.next(requst);
          },
        ),
      );
  }

  Future<Response> getRequest(String endPoint) async {
    Response response;

    try {
      response = await _dio.get(endPoint);
    } on DioError catch (e) {
      print(e.message);
      throw Exception(e.message);
    }

    return response;
  }

  Future<Response> post(String endPoint, Map<String, dynamic> data) async {
    Response response;

    try {
      response = await _dio.post(endPoint, data: data);
    } on DioError catch (e) {
      print(e.message);
      throw Exception(e.message);
    }

    return response;
  }
}
