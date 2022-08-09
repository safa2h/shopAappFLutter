import 'package:flutter/material.dart';
import 'package:nike_store/common/consts.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController userNameController =
      TextEditingController(text: 'test@gmail.com');
  TextEditingController passwordController =
      TextEditingController(text: '123456');

  bool isLogin = true;
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Theme(
        data: themeData.copyWith(
            textTheme: const TextTheme(
              bodyText1: TextStyle(fontFamily: 'IranYekan'),
              bodyText2: TextStyle(fontFamily: 'IranYekan'),
              subtitle1: TextStyle(fontFamily: 'IranYekan'),
              subtitle2: TextStyle(fontFamily: 'IranYekan'),
              caption: TextStyle(fontFamily: 'IranYekan'),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
                backgroundColor: MaterialStateProperty.all(
                    themeData.colorScheme.onSecondary),
              ),
            ),
            colorScheme:
                themeData.colorScheme.copyWith(onSurface: Colors.white),
            inputDecorationTheme: InputDecorationTheme(
                labelStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white)))),
        child: Scaffold(
            backgroundColor: themeData.colorScheme.secondary,
            body: SafeArea(
              child: SingleChildScrollView(
                physics: scrollPhysic,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(48, 100, 48, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/img/nike_logo.png',
                        color: Colors.white,
                        width: 100,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Text(isLogin ? 'خوش آمدید' : 'ثبت نام',
                          style: themeData.textTheme.bodyText1!.copyWith(
                              color: themeData.colorScheme.onSecondary,
                              fontSize: 22)),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                          isLogin
                              ? 'ایمیل و رمز عبور خود را وارد کنید'
                              : 'اطلاعات خود را وارد کنید',
                          style: themeData.textTheme.bodyText1!.copyWith(
                              color: themeData.colorScheme.onSecondary,
                              fontSize: 16,
                              fontFamily: 'IranYekan')),
                      const SizedBox(
                        height: 16,
                      ),
                      TextField(
                        controller: userNameController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            label: Text(
                          'آدرس ایمیل',
                          style: themeData.textTheme.bodyText1!.copyWith(
                              color: themeData.colorScheme.onSecondary,
                              fontFamily: 'IranYekan',
                              fontSize: 16),
                        )),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      PasswordTextFiled(
                        controller: passwordController,
                        themeData: themeData,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            isLogin ? 'ورود' : 'ثبت نام',
                            style: themeData.textTheme.bodyText1!.copyWith(
                                fontFamily: 'IranYekan',
                                fontSize: 18,
                                color: themeData.colorScheme.onBackground),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              isLogin
                                  ? ' حساب کاربری نداری؟ '
                                  : ' ثبت نام کرده اید؟ ',
                              style: themeData.textTheme.bodyText1!.copyWith(
                                  color: themeData.colorScheme.onSecondary,
                                  fontSize: 18)),
                          const SizedBox(
                            width: 4,
                          ),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  isLogin = !isLogin;
                                });
                              },
                              child: Text(
                                isLogin ? 'ثبت نام' : 'ورود',
                                style: themeData.textTheme.bodyText1!.copyWith(
                                    fontSize: 16,
                                    color: themeData.colorScheme.primary),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}

class PasswordTextFiled extends StatefulWidget {
  const PasswordTextFiled({
    Key? key,
    required this.themeData,
    required this.controller,
  }) : super(key: key);

  final ThemeData themeData;
  final TextEditingController controller;

  @override
  State<PasswordTextFiled> createState() => _PasswordTextFiledState();
}

class _PasswordTextFiledState extends State<PasswordTextFiled> {
  bool isVisibile = true;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.visiblePassword,
      obscureText: isVisibile ? true : false,
      decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                isVisibile = !isVisibile;
              });
            },
            icon: Icon(
              isVisibile
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: widget.themeData.colorScheme.onSecondary.withOpacity(0.6),
              size: 20,
            ),
            splashRadius: 16,
          ),
          label: Text(
            'رمز عبور',
            style: widget.themeData.textTheme.bodyText1!.copyWith(
                color: widget.themeData.colorScheme.onSecondary,
                fontSize: 16,
                fontFamily: 'IranYekan'),
          )),
    );
  }
}
