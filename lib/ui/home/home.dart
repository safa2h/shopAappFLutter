import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
          itemCount: 5,
          itemBuilder: (contex, index) {
            switch (index) {
              case 0:
                return Image.asset('assets/img/nike_logo.png');
              case 1:
                return Container();
              case 2:
                return Container();
              case 3:
                return Container();
              case 4:
                return Container();
              default:
                return Container();
            }
          }),
    );
  }
}
