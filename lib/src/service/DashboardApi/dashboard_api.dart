import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../Storage/storage.dart';
import '../Api_url/api_urls.dart';
import '../Interceptor/interceptor.dart';

class DashboardAPI {
  late final Dio _dio;

  DashboardAPI() {
    _dio = Dio(BaseOptions(baseUrl: ApiURL.baseUrl));
    _dio.interceptors.add(DioInterceptors());
  }

  // login endpoint
  final String _dashboardUrl = ApiURL.dashboardUrl;

  // Map<String, dynamic>? get _loginData => bodyData;

  Future<dynamic> dashboard() async {
    try {
      final response = await _dio.get(
        _dashboardUrl,
        // onSendProgress: (int sent, int total) {
        //   double progressPercent = sent / total * 100;
        // },
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        // await _saveToken(response.data);
        // EasyLoading.showToast(response.data.toString());
        print(response.data);
        return response.data;
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();

      // await _saveToken(response.data);
      if (e.response?.data != null) {
        //EasyLoading.showToast(e.response?.data);

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
