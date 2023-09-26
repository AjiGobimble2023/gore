import 'dart:developer' as logger show log;

import 'package:flutter/foundation.dart';

import '../../../../../core/helper/api_helper.dart';
import '../../../../../core/util/app_exceptions.dart';
import '../entity/bundel_soal.dart';

class BundelSoalServiceApi {
  final _apiHelper = ApiHelper(baseUrl: '');

  Future<List<dynamic>> fetchDaftarBundel({
    String? noRegistrasi,
    required String idSekolahKelas,
    required String idJenisProduk,
    required String roleTeaser,
    required bool isProdukDibeli,
  }) async {
    if (kDebugMode) {
      logger.log('BUNDEL_SOAL_SERVICE_API-FetchDaftarBundel: START');
    }
    final response =
        await _apiHelper.dio.get('/bukusoal/bundel/$idJenisProduk');

    if (kDebugMode) {
      logger.log(
          'BUNDEL_SOAL_SERVICE_API-FetchDaftarBundel: response >> $response');
    }

    if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }
    return response.data['data'];
  }

  Future<List<dynamic>> fetchDaftarBabSubBab(
      {required bool isJWT, required String idBundel}) async {
    final response = await _apiHelper.dio.get('/bukusoal/bab/$idBundel');

    if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }
    if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }
    return response.data['data'];
  }

  Future<List<dynamic>> fetchDaftarSoal({
    required bool isJWT,
    String? kodeBab,
    required String idBundel,
    required OpsiUrut opsiUrut,
  }) async {
    
    final response = await _apiHelper.dio.get(
      '/bukusoal/soal/${opsiUrut.name}/$idBundel'
     
    );

    if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }

    return response.data['data'] ?? [];
  }
}
