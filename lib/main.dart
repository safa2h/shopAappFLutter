import 'package:flutter/material.dart';
import 'package:nike_store/data/product.dart';
import 'package:nike_store/data/repository/banner_repository.dart';
import 'package:nike_store/data/repository/product_reopsitory.dart';
import 'package:nike_store/theme.dart';
import 'package:nike_store/ui/home/home.dart';

void main() {
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
            headline6: defaultTextStyle.copyWith(fontWeight: FontWeight.bold)),
      ),
      home: const Directionality(
          textDirection: TextDirection.rtl, child: HomeScreen()),
    );
  }
}
