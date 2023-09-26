import 'dart:developer' as logger show log;

import 'package:flutter/foundation.dart';

import '../../../../core/helper/api_helper.dart';
import '../../../../core/util/app_exceptions.dart';

class JadwalServiceApi {
  final ApiHelper _apiHelper = ApiHelper(baseUrl: '', authToken: '');

  Future<dynamic> fetchJadwal({
    required String noRegistrasi,
    required String userType,
    required String feedbackTime,
  }) async {
    if (kDebugMode) {
      logger.log(
          'JADWAL_SERVICE_API-FetchJadwal: START with params($noRegistrasi, $userType, $feedbackTime)');
    }
    final response = await _apiHelper.dio.get('/jadwal/siswa');

    if (kDebugMode) {
      logger.log('JADWAL_SERVICE_API-FetchJadwal: response >> $response');
    }

    if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }

    return response.data['data'];
  }

  Future<dynamic> setPresensiSiswa(Map<String, dynamic> dataPresensi) async {
    if (kDebugMode) {
      final response = await _apiHelper.dio.post(
        '/jadwal/student/hadirjwt',
        data: dataPresensi,
      );

      if (kDebugMode) {
        logger
            .log('JADWAL_SERVICE_API-SetPresensiSiswa: response >> $response');
      }

      if (response.data['meta']['code'] != 200) {
        throw DataException(message: response.data['meta']['message']);
      }

      return response.data['meta']['message'];
    }
  }

  Future<dynamic> setPresensiSiswaTst(Map<String, dynamic> dataPresensi) async {
    if (kDebugMode) {
      logger.log(
          'JADWAL_SERVICE_API-SetPresensiSiswaTST: START with params$dataPresensi');
    }

    final response = await _apiHelper.dio
        .post('/jadwal/student/hadir/tstjwt', data: dataPresensi);

    if (kDebugMode) {
      logger
          .log('JADWAL_SERVICE_API-SetPresensiSiswaTST: response >> $response');
    }

    if (response.data['meta']['code']) {
      throw DataException(message: response.data['meta']['message']);
    }
    return response.data['meta']['message'];
  }
}
