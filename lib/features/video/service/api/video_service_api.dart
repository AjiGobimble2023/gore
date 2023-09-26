import 'dart:convert';
import 'dart:developer' as logger show log;

import 'package:flutter/foundation.dart';

import '../../../../core/helper/api_helper.dart';
import '../../../../core/util/app_exceptions.dart';

class VideoServiceApi {
  final ApiHelper _apiHelper = ApiHelper(baseUrl: '');

  Future<List> fetchVideoTeori({
    required String noRegistrasi,
    required String kodeBab,
    required String levelTeori,
    required String kelengkapan,
    required String idTeoriBab,
    required String jenisBuku,
  }) async {
    if (kDebugMode) {
      logger.log('VIDEO_SERVICE_API-FetchVideoTeori: START with '
          'params($noRegistrasi, $kodeBab, $jenisBuku)');
    }

    final response =
        await _apiHelper.dio.get("/video/teori/${kodeBab}/${idTeoriBab}");

    if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }

    return response.data['data'] ?? [];
  }

  Future<dynamic> fetchVideoSoal({required int idVideo}) async {
    final response = await _apiHelper.dio.get(
      "/solusi/getvideo/$idVideo",
    );

    if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }

    return response.data['data'];
  }

  Future<dynamic> fetchVideoTeaser({
    required String idSekolahKelas,
    required String userType,
  }) async {
    final response = await _apiHelper.dio.get(
      "/video/videoteaser/$idSekolahKelas",
    );

    if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }

    return response.data;
  }

  Future<List> fetchVideoJadwalMapel({
    required String noRegistrasi,
    required String userType,
    required bool isProdukDibeli,
  }) async {
    final response = await _apiHelper.dio.get(
      "/video/getmapel",
    );

    if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }

    return response.data['data'] ?? [];
  }

  Future<List> fetchVideoJadwal(
      {required String noRegistrasi,
      required String idMataPelajaran,
      required String tingkatSekolah}) async {
    final response = await _apiHelper.dio.get(
      "/video/getbab/$tingkatSekolah/$idMataPelajaran",
    );

    if (kDebugMode) {
      logger.log(
          'VIDEO_SERVICE_API-FetchVideoJadwal: $idMataPelajaran response >> $response');
    }

    if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }

    return response.data['data'] ?? [];
  }

  // Request token key to get url video stream.
  Future<dynamic> fetchStreamToken() async {
    final response = await _apiHelper.dio.patch('', data: {});

    Map<String, dynamic> data = jsonDecode(response.data);

    return data['message'];
  }
}
