import 'package:nike_store/common/consts.dart';
import 'package:nike_store/common/http_service.dart';
import 'package:nike_store/common/http_validator.dart';
import 'package:nike_store/data/auth_info.dart';

abstract class IAuthDataSource {
  Future<AuthInfo> login(String username, String password);
  Future<AuthInfo> register(String username, String password);
  Future<AuthInfo> refreshToken(String token);
}

class AuthRemoteDataSource with HttpValidator implements IAuthDataSource {
  final HttpService httpService;

  AuthRemoteDataSource(this.httpService);
  @override
  Future<AuthInfo> login(String username, String password) async {
    final response = await httpService.post('auth/token', {
      'grant_type': 'password',
      'client_id': 2,
      'client_secret': clientSecret,
      'username': username,
      'password': password,
    });
    responseValidator(response);

    return AuthInfo(response.data['access_token'],
        response.data['refresh_token'], username);
  }

  @override
  Future<AuthInfo> refreshToken(String token) async {
    final response = await httpService.post('auth/token', {
      'grant_type': 'refresh_token',
      'client_id': 2,
      'client_secret': clientSecret,
      'refresh_token': token,
    });
    responseValidator(response);

    return AuthInfo(
        response.data['access_token'], response.data['refresh_token'], '');
  }

  @override
  Future<AuthInfo> register(String username, String password) async {
    final response = await httpService
        .post('user/register', {'email': username, 'password': password});
    responseValidator(response);
    return login(username, password);
  }
}
