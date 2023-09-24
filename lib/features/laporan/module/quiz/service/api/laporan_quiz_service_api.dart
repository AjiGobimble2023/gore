import 'dart:developer' as logger show log;

import 'package:flutter/foundation.dart';
import 'package:gokreasi_new/core/util/app_exceptions.dart';

import '../../../../../../core/helper/api_helper.dart';

class LaporanKuisServiceAPI {
  final ApiHelper _apiHelper = ApiHelper();

  Future<Map<String, dynamic>> fetchLaporanKuis({
    required String noRegistrasi,
    required String idSekolahKelas,
    required String tahunAjaran,
  }) async {
    if (kDebugMode) {
      logger.log('LAPORAN_SERVICE_API-FetchLaporanKuis: START with '
          'params($noRegistrasi, $idSekolahKelas, $tahunAjaran)');
    }
    final response = await _apiHelper.requestPost(
      pathUrl: '/getlaporankuis',
      bodyParams: {
        'nis': noRegistrasi,
        'idsekolahkelas': idSekolahKelas,
        'tahunajaran': tahunAjaran,
      },
    );
    if (kDebugMode) {
      logger.log('LAPORAN_SERVICE_API-FetchLaporanKuis: Response >> $response');
    }

    if (response['meta']['code'] != 200) {
      throw DataException(message: response['meta']['message']);
    }

    return response;
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
    final response = await _apiHelper.requestPost(
      pathUrl: '/getlaporankuis/$kodequiz',
      bodyParams: {
        'nis': noRegistrasi,
        'idsekolahkelas': idSekolahKelas,
        'tahunajaran': tahunAjaran,
      },
    );
    if (kDebugMode) {
      logger.log('LAPORAN_SERVICE_API-FetchLaporanKuis: Response >> $response');
    }

    return response;
  }
}
