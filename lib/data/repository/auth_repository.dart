import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:nike_store/common/http_service.dart';
import 'package:nike_store/data/dataSource/auth_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth_info.dart';

abstract class IAuthReposoitory {
  Future<void> login(String username, String password);
  Future<void> register(String username, String password);
  Future<void> refreshToken();
}

final authRepository = AuthRepository(AuthRemoteDataSource(HttpService()));

class AuthRepository implements IAuthReposoitory {
  final IAuthDataSource dataSource;

  static final ValueNotifier<AuthInfo?> authInfoNotifire = ValueNotifier(null);

  AuthRepository(this.dataSource);
  @override
  Future<void> login(String username, String password) async {
    final AuthInfo authInfo = await dataSource.login(username, password);
    _persitToken(authInfo);
  }

  @override
  Future<void> refreshToken() async {
    if (authInfoNotifire.value != null) {
      final AuthInfo authInfo =
          await dataSource.refreshToken(authInfoNotifire.value!.refreshToken);
      _persitToken(authInfo);
    }
  }

  @override
  Future<void> register(String username, String password) async {
    AuthInfo authInfo = await dataSource.register(username, password);
    _persitToken(authInfo);
  }

  Future<void> _persitToken(AuthInfo authInfo) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('access_token', authInfo.accessToen);
    sharedPreferences.setString('refresh_token', authInfo.refreshToken);
    sharedPreferences.setString('email', authInfo.email);
    loadAuthInfo();
  }

  Future<void> loadAuthInfo() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final accessToken = sharedPreferences.getString('access_token') ?? '';
    final refreshToken = sharedPreferences.getString('refresh_token') ?? '';
    final email = sharedPreferences.getString('email') ?? '';

    if (accessToken.isNotEmpty && refreshToken.isNotEmpty) {
      authInfoNotifire.value = AuthInfo(accessToken, refreshToken, email);
    }
  }

  Future<void> signOut() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    authInfoNotifire.value = null;
  }
}
