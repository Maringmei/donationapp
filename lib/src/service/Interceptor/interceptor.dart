import 'package:dio/dio.dart';

import '../../Storage/storage.dart';

class DioInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async{
    // TODO: implement onRequest
    final token = await Store.getToken();
    if(token != null && token.isNotEmpty){
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';

    // options.headers['Access-Control-Allow-Origin'] = '*';
    // options.headers['Access-Control-Allow-Credentials'] = true;
    // options.headers['Access-Control-Allow-Methods'] = 'GET,HEAD,OPTIONS,POST,PUT';
    // options.headers['Access-Control-Allow-Headers'] = 'Access-Control-Allow-Headers, Origin,Accept, X-Requested-With, Content-Type, Access-Control-Request-Method, Access-Control-Request-Headers';
    //


    super.onRequest(options, handler);
  }
}