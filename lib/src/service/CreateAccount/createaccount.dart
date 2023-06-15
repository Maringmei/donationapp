import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../Api_url/api_urls.dart';
import '../Interceptor/interceptor.dart';

class CreateAccountAPI {
  late final Dio _dio;

  CreateAccountAPI() {
    _dio = Dio(BaseOptions(baseUrl: ApiURL.baseUrl));
    _dio.interceptors.add(DioInterceptors());
  }

  // login endpoint
  final String _createaccountUrl = ApiURL.createUserUrl;

  Map<String, dynamic>? bodyData;

  void createAccountData(String name, String email,String mobile,String address, String password) {
    bodyData = {
      "name":"$name",
      "email":"$email",
      "password": "$password",
      "mobile" : "$mobile",
      "address":"$address"
    };
  }

  // Map<String, dynamic>? get _loginData => bodyData;

  Future<bool> CreateAccount(name ,email, mobile, address, password) async {
    try {
      createAccountData(name ,email, mobile, address ,password);
      final response = await _dio.post(
        _createaccountUrl,
        data: bodyData,
        // onSendProgress: (int sent, int total) {
        //   double progressPercent = sent / total * 100;
        // },
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        EasyLoading.dismiss();
        // await _saveToken(response.data);
        EasyLoading.showToast(response.data["msg"]);
        return true;
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();

      // await _saveToken(response.data);
      if (e.response?.data != null) {
        //EasyLoading.showToast(e.response?.data);
        if(e.response?.statusCode == 400){
          EasyLoading.showToast("This email address has already been taken.");
        }
        //EasyLoading.showToast("Try again later.");
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
