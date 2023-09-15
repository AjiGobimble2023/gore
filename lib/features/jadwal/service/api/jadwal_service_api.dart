import 'dart:developer' as logger show log;

import 'package:flutter/foundation.dart';

import '../../../../core/helper/api_helper.dart';
import '../../../../core/util/app_exceptions.dart';

class JadwalServiceApi {
  final ApiHelper _apiHelper = ApiHelper();

  Future<dynamic> fetchJadwal({
    required String noRegistrasi,
    required String userType,
    required String feedbackTime,
  }) async {
    if (kDebugMode) {
      logger.log(
          'JADWAL_SERVICE_API-FetchJadwal: START with params($noRegistrasi, $userType, $feedbackTime)');
    }
    final response = await _apiHelper.requestPost(
      pathUrl: '/jadwal/siswa',
      bodyParams: {
        'jenis': userType,
        'noRegistrasi': noRegistrasi,
        'feedbackTime': feedbackTime
      },
    );

    if (kDebugMode) {
      logger.log('JADWAL_SERVICE_API-FetchJadwal: response >> $response');
    }

    if (!response['status']) throw DataException(message: response['message']);

    return response['data'];
    
  }

  Future<dynamic> setPresensiSiswa(Map<String, dynamic> dataPresensi) async {
    if (kDebugMode) {
      logger.log(
          'JADWAL_SERVICE_API-SetPresensiSiswa: START with params$dataPresensi');
    }

    final response = await _apiHelper.requestPost(
      bodyParams: dataPresensi,
      pathUrl: '/jadwal/student/hadirjwt',
    );

    if (kDebugMode) {
      logger.log('JADWAL_SERVICE_API-SetPresensiSiswa: response >> $response');
    }

    if (!response['status']) throw DataException(message: response['message']);

    return response['message'];
  }

  Future<dynamic> setPresensiSiswaTst(Map<String, dynamic> dataPresensi) async {
    if (kDebugMode) {
      logger.log(
          'JADWAL_SERVICE_API-SetPresensiSiswaTST: START with params$dataPresensi');
    }

    final response = await _apiHelper.requestPost(
      bodyParams: dataPresensi,
      jwt: true,
      pathUrl: '/jadwal/student/hadir/tstjwt',
    );

    if (kDebugMode) {
      logger
          .log('JADWAL_SERVICE_API-SetPresensiSiswaTST: response >> $response');
    }

    if (!response['status']) throw DataException(message: response['message']);
    return response['message'];
  }
}
