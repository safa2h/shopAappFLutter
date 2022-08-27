import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_store/common/consts.dart';
import 'package:nike_store/data/repository/auth_repository.dart';
import 'package:nike_store/theme.dart';
import 'package:nike_store/ui/auth/bloc/auth_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController userNameController =
      TextEditingController(text: 'test433333333366@gmail.com');
  TextEditingController passwordController =
      TextEditingController(text: '123456');
  late StreamSubscription stream;

  @override
  void dispose() {
    // TODO: implement dispose
    stream.cancel();
    super.dispose();
  }

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
            snackBarTheme: SnackBarThemeData(
                backgroundColor: themeData.colorScheme.primary),
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
            body: SingleChildScrollView(
              physics: scrollPhysic,
              child: BlocProvider<AuthBloc>(
                create: (context) {
                  final bloc = AuthBloc(authRepository);
                  bloc.add(AuthStatrted());
                  stream = bloc.stream.listen((state) {
                    if (state is AuthSuccess) {
                      Navigator.of(context).pop();
                    } else if (state is AuthError) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          'مسکلی پیش آمده یا ایمیلی تکراری است',
                          style: TextStyle(
                              color: LightThemeColor.primaryTextColor),
                        ),
                      ));
                    }
                  });
                  return bloc;
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(48, 100, 48, 0),
                  child: BlocBuilder<AuthBloc, AuthState>(
                    buildWhen: (previous, current) {
                      return current is AuthLoading ||
                          current is AuthInitial ||
                          current is AuthError;
                    },
                    builder: (context, state) {
                      return Column(
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
                          Text(state.isLoginMode ? 'خوش آمدید' : 'ثبت نام',
                              style: themeData.textTheme.bodyText1!.copyWith(
                                  color: themeData.colorScheme.onSecondary,
                                  fontSize: 22)),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                              state.isLoginMode
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
                              onPressed: () {
                                BlocProvider.of<AuthBloc>(context).add(
                                    AuthButtonClicked(userNameController.text,
                                        passwordController.text));
                              },
                              child: state is AuthLoading
                                  ? const CupertinoActivityIndicator()
                                  : Text(
                                      state.isLoginMode ? 'ورود' : 'ثبت نام',
                                      style: themeData.textTheme.bodyText1!
                                          .copyWith(
                                              fontFamily: 'IranYekan',
                                              fontSize: 18,
                                              color: themeData
                                                  .colorScheme.onBackground),
                                    ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  state.isLoginMode
                                      ? ' حساب کاربری نداری؟ '
                                      : ' ثبت نام کرده اید؟ ',
                                  style: themeData.textTheme.bodyText1!
                                      .copyWith(
                                          color:
                                              themeData.colorScheme.onSecondary,
                                          fontSize: 18)),
                              const SizedBox(
                                width: 4,
                              ),
                              TextButton(
                                  onPressed: () {
                                    BlocProvider.of<AuthBloc>(context)
                                        .add(AuthModeChangedClicked());
                                  },
                                  child: Text(
                                    state.isLoginMode ? 'ثبت نام' : 'ورود',
                                    style: themeData.textTheme.bodyText1!
                                        .copyWith(
                                            fontSize: 16,
                                            color:
                                                themeData.colorScheme.primary),
                                  ))
                            ],
                          )
                        ],
                      );
                    },
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
