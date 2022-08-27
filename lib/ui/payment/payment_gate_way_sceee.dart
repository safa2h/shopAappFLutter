import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class PaymentGetWayScreen extends StatefulWidget {
  const PaymentGetWayScreen({Key? key, required this.bankGateWay})
      : super(key: key);
  final String bankGateWay;

  @override
  State<PaymentGetWayScreen> createState() => _PaymentGetWayScreenState();
}

class _PaymentGetWayScreenState extends State<PaymentGetWayScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
