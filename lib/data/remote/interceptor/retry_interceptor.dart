import 'dart:io';
// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

class RetryOnConnectionChangeInterceptor extends Interceptor {
  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    if(_shouldRetry(err)){
      err.requestOptions;
    }
    return err;
  }

  bool _shouldRetry(DioError err){
    return err.type == DioErrorType.connectTimeout &&
        err.error != null && err.error is SocketException;
  }
}