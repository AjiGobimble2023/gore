import 'dart:developer' as logger show log;
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../../../../../../core/helper/api_helper.dart';
import '../../../../../../core/util/app_exceptions.dart';

class LaporanTryoutServiceAPI {
  final ApiHelper _apiHelper = ApiHelper(
    baseUrl: ''
  );

  Future<dynamic> fetchLaporanTryout({
    required String noRegistrasi,
    required String idSekolahKelas,
    required String userType,
    required String jenisTO,
    required int idJurusanPilihan1,
    required int idJurusanPilihan2,
  }) async {
    if (kDebugMode) {
      logger.log('LAPORAN_TRYOUT_SERVICE-FetchLaporanTryout: START with Params '
          '($noRegistrasi, $idSekolahKelas, $userType, $jenisTO)');
      logger.log('LAPORAN_TRYOUT_SERVICE-FetchLaporanTryout: idJurusan 1 '
          '>> $idJurusanPilihan1');
      logger.log('LAPORAN_TRYOUT_SERVICE-FetchLaporanTryout: idJurusan 2 '
          '>> $idJurusanPilihan2');
    }
    final response = await _apiHelper.dio.get(
       '/tryout/laporan/tryout',
    );

   if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }

    return response.data['data'];
  }

  Future<dynamic> fetchLaporanListTryout({
    required String userId,
    required String userClassLevelId,
    required String jenisTO,
    required String jenis,
  }) async {
    if (kDebugMode) {
      logger.log("LAPORAN TRYOUT SERVICE: execute fetchLaporanTryout()");
    }
    final response = await _apiHelper.dio.get(
      '/tryout/laporan/list',
    );
    if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }

    return response.data['data'];
  }

  Future<dynamic> fetchLaporanNilai(
      {required String userId,
      required String userClassLevelId,
      required String userType,
      required String kodeTOB,
      required String penilaian,
      required String pilihan1,
      required String pilihan2}) async {
    final response = await _apiHelper.dio.get(
      '/tryout/laporan/nilai',
    );

   if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }
    return response.data['data'];
  }

  Future<void> uploadFeed(
      {String? userId, String? content, String? file64}) async {
    final response = await _apiHelper.dio.post(
       '/upload/feed',
        data: {"nis": userId, "text": content, "file64": file64});
    if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }
  }

  // Request token key to get url video stream.
  Future<dynamic> fetchEpbToken() async {
    final response = await _apiHelper.dio.get('');
    if (kDebugMode) {
      logger.log("cek nilai : $response");
    }
    Map<String, dynamic> data = jsonDecode(response.data.body);
    return data['message'];
  }
}
