import 'dart:developer' as logger show log;

import 'package:flutter/foundation.dart';

import '../../../../../../core/helper/api_helper.dart';
import '../../../../../../core/util/app_exceptions.dart';

class LaporanServiceAPI {
  final ApiHelper _apiHelper = ApiHelper(
    baseUrl: ''
  );

  Future<dynamic> fetchLaporanVak({
    required String noRegistrasi,
    required String userType,
  }) async {
    if (kDebugMode) {
      logger.log(
          'LAPORAN_VAK_SERVICE_API-FetchLaporanVak: START with params($noRegistrasi, $userType)');
    }

    final response = await _apiHelper.dio.get(
      '/vak',
  
    );

    if (kDebugMode) {
      logger.log(
          'LAPORAN_VAK_SERVICE_API-FetchLaporanVak: response >> $response');
    }

   if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }
    return response.data['data'];
  }
}
