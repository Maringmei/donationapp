import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../Storage/storage.dart';
import '../../models/BeneficiariesModel.dart';
import '../Api_url/api_urls.dart';
import '../Interceptor/interceptor.dart';

class HistoryAPI {
  late final Dio _dio;

  HistoryAPI() {
    _dio = Dio(BaseOptions(baseUrl: ApiURL.baseUrl));
    _dio.interceptors.add(DioInterceptors());
  }

  // login endpoint
  final String _historyUrl = ApiURL.historyUrl;

  Future<dynamic> History() async {
    try {
      final response = await _dio.get(
        _historyUrl,
        // onSendProgress: (int sent, int total) {
        //   double progressPercent = sent / total * 100;
        // },
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        EasyLoading.dismiss();
        // await _saveToken(response.data);
        // EasyLoading.showToast(response.data.toString());
        return response.data;
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();

      // await _saveToken(response.data);
      if (e.response?.data != null) {
        EasyLoading.showToast("Something went wrong.");
        //  EasyLoading.showToast(e.response?.data);
        //EasyLoading.showToast(e.response?.data["message"]);
      } else {
        EasyLoading.showToast("Something went wrong!");
      }

      return false;
    }
    // return false;
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