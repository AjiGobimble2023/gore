import 'dart:developer' as logger show log;

import 'package:flutter/foundation.dart';
import 'package:gokreasi_new/core/util/app_exceptions.dart';

import '../../../../../../core/helper/api_helper.dart';

class LaporanKuisServiceAPI {
  final ApiHelper _apiHelper = ApiHelper(
    baseUrl: ''
  );

  Future<Map<String, dynamic>> fetchLaporanKuis({
    required String noRegistrasi,
    required String idSekolahKelas,
    required String tahunAjaran,
  }) async {
    if (kDebugMode) {
      logger.log('LAPORAN_SERVICE_API-FetchLaporanKuis: START with '
          'params($noRegistrasi, $idSekolahKelas, $tahunAjaran)');
    }
    final response = await _apiHelper.dio.get('/getlaporankuis');
    if (kDebugMode) {
      logger.log('LAPORAN_SERVICE_API-FetchLaporanKuis: Response >> $response');
    }

   if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }

    return response.data;
  }

  Future<Map<String, dynamic>> fetchLaporanJawabanKuis(
      {required String noRegistrasi,
      required String idSekolahKelas,
      required String tahunAjaran,
      required String kodequiz}) async {
    if (kDebugMode) {
      logger.log('LAPORAN_SERVICE_API-FetchLaporanKuis: START with '
          'params($noRegistrasi, $idSekolahKelas, $tahunAjaran)');
    }
    final response = await _apiHelper.dio.get(
      '/getlaporankuis/$kodequiz'
    );

    if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }

    return response.data;
  }
}
