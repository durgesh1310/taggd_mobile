// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
/*
class ConnectivityRetrier {
  final Dio dio;
  final Connectivity connectivity;

  ConnectivityRetrier({
    required this.dio,
    required this.connectivity
  });

  Future<Response> scheduleRequestRetry(RequestOptions requestOptions) async{
    connectivity.onConnectivityChanged.listen(
        (connectivityResult){
          if(connectivityResult != ConnectivityResult.none){
            dio.request(
              requestOptions.path,
              cancelToken: requestOptions.cancelToken,
              data: requestOptions.data,
              onReceiveProgress: requestOptions.onReceiveProgress,
              onSendProgress: requestOptions.onSendProgress
            );
          }
        }
    );
  }
}*/