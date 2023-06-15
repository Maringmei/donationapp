// To parse this JSON data, do
//
//     final beneficiariesModel = beneficiariesModelFromJson(jsonString);

import 'dart:convert';

BeneficiariesModel beneficiariesModelFromJson(String str) => BeneficiariesModel.fromJson(json.decode(str));

String beneficiariesModelToJson(BeneficiariesModel data) => json.encode(data.toJson());

class BeneficiariesModel {
  final String grandAmount;
  final int tax;
  final int netAmount;
  final List<PaymentDetail> paymentDetails;

  BeneficiariesModel({
    required this.grandAmount,
    required this.tax,
    required this.netAmount,
    required this.paymentDetails,
  });

  factory BeneficiariesModel.fromJson(Map<String, dynamic> json) => BeneficiariesModel(
    grandAmount: json["grand_amount"],
    tax: json["tax"],
    netAmount: json["net_amount"],
    paymentDetails: List<PaymentDetail>.from(json["payment_details"].map((x) => PaymentDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "grand_amount": grandAmount,
    "tax": tax,
    "net_amount": netAmount,
    "payment_details": List<dynamic>.from(paymentDetails.map((x) => x.toJson())),
  };
}

class PaymentDetail {
  final String name;
  final String amount;

  PaymentDetail({
    required this.name,
    required this.amount,
  });

  factory PaymentDetail.fromJson(Map<String, dynamic> json) => PaymentDetail(
    name: json["name"],
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "amount": amount,
  };
}
