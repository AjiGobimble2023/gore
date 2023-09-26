import 'dart:developer' as logger show log;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/util/app_exceptions.dart';

class BeritaServiceApi {
  final Dio dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
    baseUrl: 'https://auth-service.gobimbelonline.net', //ganti sesuai service
  ));

  Future<dynamic> fetchBerita({String userType = "UMUM"}) async {
    try {
      final response = await dio.get('mobile/v1/api/information');

      if (kDebugMode && response.data['meta']['code'] != 200) {
        logger.log('BERITA_SERVICE_API-FetchBerita: response >> '
            '$response');
      }

      if (response.data['meta']['code'] != 200) {
        throw DataException(message: response.data['message']);
      }

      return response.data['data'];
    } catch (e) {
      throw DataException(message: e.toString());
    }
  }

  Future<dynamic> fetchBeritaPopUp({String userType = "UMUM"}) async {
    try {
      final response = await dio.get('mobile/v1/api/information/daily');

      if (kDebugMode && response.data['meta']['code'] != 200) {
        logger.log('BERITA_SERVICE_API-FetchBeritaPopUp: response >> '
            '$response');
      }

      if (response.data['meta']['code'] != 200) {
        throw DataException(message: response.data['message']);
      }
      return response.data['data'];
    } catch (e) {
      throw DataException(message: e.toString());
    }
  }

  Future<void> setViewer(String idBerita) async {
    try {
      final response = await dio.post(
        "mobile/v1/api/information/setviewers",
        data: {"idBerita": idBerita},
      );

      if (response.data['meta']['code'] != 200) {
        throw DataException(message: response.data['message']);
      }
    } catch (e) {
      throw DataException(message: e.toString());
    }
  }
}
