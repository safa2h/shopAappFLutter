class PaymentReciptData {
  final bool perchaseSuccess;
  final int payablePrice;
  final String paymentStatus;
  PaymentReciptData.fromJson(Map<String, dynamic> json)
      : perchaseSuccess = json['purchase_success'],
        payablePrice = json['payable_price'],
        paymentStatus = json['payment_status'];
}
