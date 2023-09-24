import 'dart:developer' as logger show log;

import 'package:flutter/foundation.dart';

import '../../../../../core/helper/api_helper.dart';
import '../../../../../core/util/app_exceptions.dart';

class PaketSoalServiceApi {
  final _apiHelper = ApiHelper();

  Future<List<dynamic>> fetchDaftarTOBBersyarat({
    required String kodePaket,
  }) async {
    final Map<String, dynamic> response = await _apiHelper.requestPost(
      pathUrl: '/bukusoal/prasyarat/$kodePaket',
    );

    if (response['meta']['code'] != 200) {
      throw DataException(message: response['message']);
    }

    return response['data'] ?? [];
  }

  Future<List<dynamic>> fetchDaftarPaketSoal({
    String? noRegistrasi,
    required String idSekolahKelas,
    required String idJenisProduk,
    required String roleTeaser,
    required bool isProdukDibeli,
  }) async {
    final Map<String, dynamic> response = await _apiHelper.requestPost(
        jwt: noRegistrasi != null,
        pathUrl: '/bukusoal/paket/basic/$idJenisProduk',
        bodyParams: {
          'noRegistrasi': noRegistrasi,
          'teaserRole': roleTeaser,
          'idSekolahKelas': idSekolahKelas,
          'diBeli': isProdukDibeli,
        });

    if (kDebugMode) {
      logger.log(
          'PAKET_SOAL_SERVICE_API-FetchDaftarPaket: response >> $response');
    }

    if (response['meta']['code'] != 200) {
      throw DataException(message: response['message']);
    }

    return response['data'];
  }

  Future<List<dynamic>> fetchDaftarSoal(
      {bool isJWT = true, required String kodePaket}) async {
    final Map<String, dynamic> response = await _apiHelper.requestPost(
        jwt: isJWT, pathUrl: '/bukusoal/soal/paket/$kodePaket');

    if (response['meta']['code'] != 200) {
      throw DataException(message: response['message']);
    }

    return response['data'] ?? [];
  }
}
