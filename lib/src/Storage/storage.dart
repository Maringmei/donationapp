import 'package:donationapp/src/bloc/LoginStatus/loginstatus_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Store {
  const Store._();

  static const String _tokenKey = "TOKEN";

  static Future<void> setToken(String token,context) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_tokenKey, token);
    BlocProvider.of<LoginstatusCubit>(context).setLogin();
  }

  static Future<String?> getToken() async {
    final preferences = await SharedPreferences.getInstance();
    print(preferences.getString(_tokenKey));
    return preferences.getString(_tokenKey);
  }

  static Future<void> clear(context) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}
