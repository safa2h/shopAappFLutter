import 'package:intl/intl.dart';

extension priceLable on int {
  String get withPriceLable => this > 0 ? '$seperateByComma تومان' : 'رایگان';
  String get seperateByComma {
    final numberFormat = NumberFormat.decimalPattern();
    return numberFormat.format(this);
  }
}
