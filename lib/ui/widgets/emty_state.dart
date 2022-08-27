import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState(
      {Key? key, required this.message, this.callToaction, required this.image})
      : super(key: key);
  final String message;
  final Widget? callToaction;
  final Widget image;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          image,
          SizedBox(
            height: 12,
          ),
          Text(
            message,
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(
            height: 12,
          ),
          if (callToaction != null) callToaction!
        ],
      ),
    );
  }
}
