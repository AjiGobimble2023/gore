import 'dart:developer' as logger show log;

import 'package:flutter/foundation.dart';

import '../../../../core/helper/api_helper.dart';
import '../../../../core/util/app_exceptions.dart';

class SoalServiceAPI {
  final ApiHelper _apiHelper = ApiHelper(baseUrl: '');

  static final SoalServiceAPI _instance = SoalServiceAPI._internal();

  factory SoalServiceAPI() => _instance;

  SoalServiceAPI._internal();

  Future<bool> simpanJawaban({
    required String tahunAjaran,
    required String noRegistrasi,
    required String idSekolahKelas,
    required String tipeUser,
    required String idKota,
    required String idGedung,
    required String kodeTOB,
    required String kodePaket,
    required int idJenisProduk,
    required int jumlahSoal,
    required List<Map<String, dynamic>> detailJawaban,
  }) async {
    final response = await _apiHelper.dio.post(
      '/bukusoal/simpanjawabanV2',
      data: {
        'nis': noRegistrasi,
        'role': tipeUser,
        'idsekolahkelas': idSekolahKelas,
        'idpenanda': idKota,
        'idgedung': idGedung,
        'tahunajaran': tahunAjaran,
        'kodetob': kodeTOB,
        'kodepaket': kodePaket,
        'jenisproduk': idJenisProduk,
        'jumsoal': jumlahSoal,
        'detailJawaban': detailJawaban,
      },
    );

    return response.data['status'];
  }

  Future<dynamic> fetchSolusi({required String idSoal}) async {
    if (kDebugMode) {
      logger.log('SOAL_SERVICE_API-FetchSolusi: START with params($idSoal)');
    }

    final response = await _apiHelper.dio.get(
      '/solusi/getsolusi/$idSoal',
    );

    if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }

    return response.data['data'];
  }

  Future<dynamic> fetchVideoSolusi({required String idVideo}) async {
    final response = await _apiHelper.dio.get(
      '/solusi/getvideo/$idVideo',
    );

    if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }

    return response.data['data'];
  }

  Future<List<dynamic>> fetchSobatTips({
    required String idSoal,
    required String idBundel,
    required bool isBeliLengkap,
    required bool isBeliSingkat,
    required bool isBeliRingkas,
  }) async {
    final response = await _apiHelper.dio.get(
      '/solusi/tips/$idBundel/$idSoal',
    );

    if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }

    return response.data['data'] ?? [];
  }

  Future<List<dynamic>> fetchDetailHasilJawaban({
    required String noRegistrasi,
    required String idSekolahKelas,
    required String jenisHasil,
    required String kodePaket,
    required int jumlahSoal,
  }) async {
    final response = await _apiHelper.dio.get(
      '/bukusoal/hasil/$jenisHasil/$kodePaket/$idSekolahKelas/$noRegistrasi',
    );

    if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }

    return response.data['data'] ?? [];
  }
}
