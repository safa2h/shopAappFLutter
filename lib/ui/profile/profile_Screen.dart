import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nike_store/data/auth_info.dart';
import 'package:nike_store/data/repository/auth_repository.dart';
import 'package:nike_store/data/repository/cart_repository.dart';
import 'package:nike_store/ui/auth/atuh.dart';
import 'package:nike_store/ui/order/order_screen.dart';
import 'package:nike_store/ui/ui/favorites_Screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('پروفایل'),
      ),
      body: ValueListenableBuilder<AuthInfo?>(
        valueListenable: AuthRepository.authInfoNotifire,
        builder: (context, value, child) {
          final isLogin = value != null && value.accessToen.isNotEmpty;
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(top: 32, bottom: 8),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Theme.of(context).dividerColor, width: 1)),
                  width: 65,
                  height: 65,
                  child: Image.asset('assets/img/nike_logo.png'),
                ),
                Text(isLogin ? value.email : 'کاربر مهمان'),
                const SizedBox(
                  height: 32,
                ),
                const Divider(thickness: 1),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => FavoriteScreen()));
                  },
                  child: Container(
                    height: 56,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Row(
                      children: const [
                        Icon(CupertinoIcons.heart),
                        SizedBox(
                          width: 16,
                        ),
                        Text('لیست علاقه مندی ها')
                      ],
                    ),
                  ),
                ),
                const Divider(thickness: 1),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (contex) => OrderScreen()));
                  },
                  child: Container(
                    height: 56,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Row(
                      children: const [
                        Icon(CupertinoIcons.cart),
                        SizedBox(
                          width: 16,
                        ),
                        Text('سوابق سفارش')
                      ],
                    ),
                  ),
                ),
                const Divider(thickness: 1),
                InkWell(
                  onTap: () {
                    if (isLogin) {
                      showDialog(
                          useRootNavigator: true,
                          context: context,
                          builder: (context) {
                            return Directionality(
                              textDirection: TextDirection.rtl,
                              child: AlertDialog(
                                title: Text('خروج از حساب کاربری'),
                                content:
                                    Text('آیا می خواهید از حساب خود خارج شوید'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      CartRepository.cartNotifierCount.value =
                                          0;
                                      authRepository.signOut();
                                      Navigator.pop(context);
                                    },
                                    child: Text('بله'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('خیر'),
                                  ),
                                ],
                              ),
                            );
                          });
                    } else {
                      Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (context) => AuthScreen()));
                    }
                  },
                  child: Container(
                    height: 56,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Row(
                      children: [
                        Icon(isLogin ? Icons.logout : Icons.login),
                        SizedBox(
                          width: 16,
                        ),
                        Text(isLogin
                            ? 'خروج از حساب کاربری'
                            : 'ورود به حساب کاربری')
                      ],
                    ),
                  ),
                ),
                const Divider(thickness: 1),
              ],
            ),
          );
        },
      ),
    );
  }
}
