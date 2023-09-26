import 'package:dio/dio.dart';

class ApiHelper {
  final Dio dio;

  ApiHelper({
    required String baseUrl,
     String? authToken,
  }) : dio = Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
          baseUrl: baseUrl,
        )) {
    if(authToken == null ){

    }else{
       dio.options.headers['Authorization'] = 'Bearer $authToken';
    }
  }
}