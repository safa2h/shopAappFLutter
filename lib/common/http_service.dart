import 'package:dio/dio.dart';
<<<<<<< HEAD
=======
import 'package:nike_store/common/consts.dart';
>>>>>>> safa

class HttpService {
  late Dio _dio;

<<<<<<< HEAD
  final baseUrl = "http://expertdevelopers.ir/api/v1/";

=======
>>>>>>> safa
  HttpService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
    ));

    //  initializeInterceptors();
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

  initializeInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (e, handler) {},
        onRequest: (requst, handler) {},
        onResponse: (response, handler) {},
      ),
    );
  }
}
