import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../Storage/storage.dart';
import '../Api_url/api_urls.dart';
import '../Interceptor/interceptor.dart';

class LoginAPI {
  late final Dio _dio;

  LoginAPI() {
    _dio = Dio(BaseOptions(baseUrl: ApiURL.baseUrl));
    _dio.interceptors.add(DioInterceptors());
  }

  // login endpoint
  final String _loginUrl = ApiURL.loginUrl;

  Map<String, dynamic>? bodyData;

  void setloginData(String email, password) {
    bodyData = {
      "email":"$email",
      "password":"$password"
    };
  }

  Future<void> _saveToken(Map<String, dynamic> data,context) async {
    final token = data['token'];
    await Store.setToken(token,context);
  }

  // Map<String, dynamic>? get _loginData => bodyData;

  Future<bool> LoginUser(email, password,context) async {
    try {
      setloginData(email, password);
      final response = await _dio.post(
        _loginUrl,
        data: bodyData,
        // onSendProgress: (int sent, int total) {
        //   double progressPercent = sent / total * 100;
        // },
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        // await _saveToken(response.data);
        //EasyLoading.showToast(response.data.toString());
        _saveToken(response.data,context);
        return true;
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();

      // await _saveToken(response.data);
      if (e.response?.data != null) {
        //EasyLoading.showToast(e.response?.data);
        if(e.response!.statusCode == 400){
          EasyLoading.showToast("Invalid Email or Password.");
        }
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
