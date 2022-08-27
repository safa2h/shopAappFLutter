import 'package:flutter/material.dart';

class ErrorWidgetCustom extends StatelessWidget {
  const ErrorWidgetCustom({
    Key? key,
    required this.errorMessage,
    required this.tapCallback,
  }) : super(key: key);

  final String errorMessage;
  final GestureTapCallback tapCallback;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(errorMessage),
          ElevatedButton(onPressed: tapCallback, child: Text('تلاش دوباره'))
        ],
      ),
    );
  }
}
