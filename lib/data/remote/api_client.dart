import 'dart:developer';
import 'dart:io' show Platform;
import 'package:dio/dio.dart';
import 'package:ouat/data/data_repo.dart';
import 'package:ouat/data/models/validateOTPModel.dart';
import 'package:ouat/utility/constants.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

class ApiClient {
  static bool apiDebuggin = true;
  static Dio? dio;

  static Dio? getClient() {
    if (dio == null) {
      BaseOptions baseOptions = BaseOptions(
        baseUrl: Constants.URL,
        connectTimeout: 60000,
        receiveTimeout: 60000,
        contentType: 'application/json',
        responseType: ResponseType.json,
      );

      dio = Dio(baseOptions);

      dio!.interceptors.add(InterceptorsWrapper(
        onRequest: (options, requestInterceptorHandler) async {
          String token = "";

          CustomerDetail? customerDetail =
              DataRepo.getInstance().userRepo.getSavedUser();
          if (customerDetail != null) {
            token = customerDetail.token ?? "";
          } else {
            token = "";
          }
          DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
          String androidId;
          String osName;
          String typeName;
          String user_client = Platform.isAndroid ? 'ANDROID' : 'IOS';
          if (Platform.isAndroid) {
            AndroidDeviceInfo androidDeviceInfo =
                await deviceInfoPlugin.androidInfo;
            androidId = androidDeviceInfo.androidId.toString();
            osName = androidDeviceInfo.version.release.toString();
            typeName = Device.get().isPhone ? "mobile" : "tablet";
          } else {
            IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;
            androidId = iosDeviceInfo.identifierForVendor.toString();
            osName = iosDeviceInfo.systemVersion.toString();
            typeName = Device.get().isPhone ? "mobile" : "tablet";
          }

          var jsonString = {
            'os': '$osName',
            'browser': 'chrome',
            'user-client': '$user_client',
            'device-id': '$androidId',
            'device-type': '$typeName',
            'key': '122322',
            'platform': 'MOBILE',
            'api-version': '2',
            'Content-Type': 'application/json',
            'Authorization': "Bearer $token"
          };
          if (token.isEmpty) {
            jsonString.remove('Authorization');
          }
          log(jsonString.toString());

          options.headers.addAll(jsonString);
          return requestInterceptorHandler.next(options);
        },
        onResponse: (response, responseInterceptorHandler) {
          if (apiDebuggin) {
            debugDioResponse(response);
          }
          return responseInterceptorHandler.next(response);
          // continue
        },
        onError: (e, errorInterceptorHandler) {
          if (apiDebuggin) {
            debugDioError(e);
          }

          print(e);
          return errorInterceptorHandler.next(e);
          //continue
        },
      ));
    }
    return dio;
  }

  static void clean() {
    dio = null;
  }

  static void debugDioError(DioError error) {
    if (error.response != null) {
    } else {}
  }

  static void debugDioResponse(Response response) {}
}
