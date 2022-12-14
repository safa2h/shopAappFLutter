import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nike_store/data/favorite_manager.dart';
import 'package:nike_store/data/product.dart';
import 'package:nike_store/data/repository/auth_repository.dart';
import 'package:nike_store/theme.dart';
import 'package:nike_store/ui/auth/atuh.dart';
import 'package:nike_store/ui/root.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ProductEntityAdapter());
  Hive.openBox<ProductEntity>(FavoriteManager.boxName);

  WidgetsFlutterBinding.ensureInitialized();
  authRepository.loadAuthInfo();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const defaultTextStyle = TextStyle(
      fontFamily: 'IranYekan',
      color: LightThemeColor.primaryTextColor,
    );
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: LightThemeColor.primaryTextColor.withOpacity(0.1)))),
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            foregroundColor: LightThemeColor.primaryTextColor),
        colorScheme: const ColorScheme.light(
            primary: LightThemeColor.primaryColor,
            secondary: LightThemeColor.secondryColor,
            onSecondary: Colors.white),
        textTheme: TextTheme(
            button: defaultTextStyle,
            bodyText2: defaultTextStyle,
            subtitle1: defaultTextStyle.copyWith(
                color: LightThemeColor.secondryTextColor),
            caption: defaultTextStyle.copyWith(
                fontSize: 12, color: LightThemeColor.secondryTextColor),
            headline6: defaultTextStyle.copyWith(
                fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      home: const Directionality(
          textDirection: TextDirection.rtl, child: RoootScreen()),
    );
  }
}
