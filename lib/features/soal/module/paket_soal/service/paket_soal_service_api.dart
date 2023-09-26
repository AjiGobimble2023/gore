import 'dart:developer' as logger show log;

import 'package:flutter/foundation.dart';

import '../../../../../core/helper/api_helper.dart';
import '../../../../../core/util/app_exceptions.dart';

class PaketSoalServiceApi {
  final _apiHelper = ApiHelper(baseUrl: '');

  Future<List<dynamic>> fetchDaftarTOBBersyarat({
    required String kodePaket,
  }) async {
    final response = await _apiHelper.dio.get(
      '/bukusoal/prasyarat/$kodePaket',
    );
    if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }

    return response.data['data'] ?? [];
  }

  Future<List<dynamic>> fetchDaftarPaketSoal({
    String? noRegistrasi,
    required String idSekolahKelas,
    required String idJenisProduk,
    required String roleTeaser,
    required bool isProdukDibeli,
  }) async {
    final response = await _apiHelper.dio.get(
      '/bukusoal/paket/basic/$idJenisProduk',
    );

    if (kDebugMode) {
      logger.log(
          'PAKET_SOAL_SERVICE_API-FetchDaftarPaket: response >> $response');
    }

    if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }

    return response.data['data'];
  }

  Future<List<dynamic>> fetchDaftarSoal(
      {bool isJWT = true, required String kodePaket}) async {
    final response =
        await _apiHelper.dio.get('/bukusoal/soal/paket/$kodePaket');

    if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }

    return response.data['data'] ?? [];
  }
}
