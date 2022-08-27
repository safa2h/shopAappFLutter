import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  const Badge({Key? key, required this.value}) : super(key: key);
  final int value;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: value > 0 ? true : false,
      child: Container(
        width: 18,
        alignment: Alignment.center,
        height: 18,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle),
        child: Text(
          value.toString(),
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 12,
              fontFamily: 'IranYekan'),
        ),
      ),
    );
  }
}
