import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../Storage/storage.dart';
import '../Api_url/api_urls.dart';
import '../Interceptor/interceptor.dart';

class PaymentConfirmAPI {
  late final Dio _dio;

  PaymentConfirmAPI() {
    _dio = Dio(BaseOptions(baseUrl: ApiURL.baseUrl));
    _dio.interceptors.add(DioInterceptors());
  }

  // login endpoint
  final String _confirmUrl = ApiURL.confirmUrl;

  Map<String, dynamic>? bodyData;

  void setConfirmData(payment_id, payment_order_id, payment_signature) {
    bodyData = {
      "razorpay_payment_id": "$payment_id",
      "razorpay_order_id": "$payment_order_id",
      "razorpay_signature": "$payment_signature"
    };
  }

  Future<dynamic> ConfirmPayNow(
      payment_id, payment_order_id, payment_signature) async {
    try {
      setConfirmData(payment_id, payment_order_id, payment_signature);
      final response = await _dio.post(_confirmUrl, data: bodyData
          // onSendProgress: (int sent, int total) {
          //   double progressPercent = sent / total * 100;
          // },
          );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        // await _saveToken(response.data);
        // EasyLoading.showToast(response.data.toString());
        return true;
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();

      // await _saveToken(response.data);
      if (e.response?.data != null) {
        //EasyLoading.showToast(e.response?.data);
          EasyLoading.showToast("Error on getting payment data.");

        //EasyLoading.showToast(e.response?.data["message"]);
      } else {
        EasyLoading.showToast("Something went wrong!");
      }

      return false;
    }
    return false;
  }

// Future<String> dioGetData() async {
//   try {
//     final response = await _dio.get(_dataUrl);
//     if (response.statusCode == 200) {
//       return _getResult(response.data);
//     }
//   } on DioError catch (e) {
//     return e.response?.data ?? "Error occured";
//   }
//   return Future.value("");
// }
}
