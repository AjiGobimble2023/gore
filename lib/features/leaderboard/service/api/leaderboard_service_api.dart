import 'dart:developer' as logger show log;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/helper/api_helper.dart';
import '../../../../core/util/app_exceptions.dart';

/// [LeaderboardServiceApi] merupakan service class penghubung provider dengan request api.
class LeaderboardServiceApi {
  final _apiHelper = ApiHelper(
      baseUrl: 'https://leaderboard-service.gobimbelonline.net/api/v1');
  final Dio dio = Dio();

  Future<dynamic> fetchLeaderboardBukuSakti({
    required String noRegistrasi,
    required String idSekolahKelas,
    required String idKota,
    required String idGedung,
    required int tipeJuara,
    required String tahunAjaran,
  }) async {
    if (kDebugMode) {
      logger.log('LEADERBOARD_SERVICE_API-FetchLeaderboard: START with '
          'params($noRegistrasi,$idSekolahKelas,$idKota,$idGedung,$tipeJuara,$tahunAjaran)');
    }
    final response = await _apiHelper.dio
        .post('/leaderboard/', data: {"noreg": noRegistrasi});

    if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }

    return response.data;
  }

  Future<dynamic> fetchFirstRankBukuSakti({
    required String idSekolahKelas,
    required String idKota,
    required String idGedung,
    required String tahunAjaran,
  }) async {
    if (kDebugMode) {
      logger.log('LEADERBOARD_SERVICE_API-FetchFirstRank: START with '
          'params($idSekolahKelas, $idKota, $idGedung, $tahunAjaran)');
    }

    final response =
        await _apiHelper.dio.post('/leaderboard/first-rank', data: {
      "idkelas": int.parse(idSekolahKelas),
      "idkota": int.parse(idKota),
      "idgedung": int.parse(idGedung)
    });

    if (kDebugMode) {
      logger.log('LEADERBOARD_SERVICE_API-FetchFirstRank: '
          'response >> $response');
    }

    if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }
    return response.data['data'];
  }

  Future<dynamic> fetchCapaianScoreKamu({
    required String noRegistrasi,
    required String tahunAjaran,
    required String idSekolahKelas,
    required String userType,
    required String idKota,
    required String idGedung,
  }) async {
    if (kDebugMode) {
      logger.log('LEADERBOARD_SERVICE_API-FetchCapaianScoreKamu: START with '
          'params($noRegistrasi, $idSekolahKelas, $tahunAjaran, $userType, $idKota, $idGedung)');
    }
    final response = await _apiHelper.dio.get(
      '/leaderboard/capaian',
    );

    if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }

    return response.data['data'];
  }

  Future<dynamic> fetchHasilPengerjaanSoal({
    required String noRegistrasi,
    required String idSekolahKelas,
    required String tahunAjaran,
  }) async {
    if (kDebugMode) {
      logger.log('LEADERBOARD_SERVICE_API-FetchHasilPengerjaanSoal: START with '
          'params($noRegistrasi, $idSekolahKelas, $tahunAjaran)');
    }
    final response = await _apiHelper.dio.get(
     '/capaian/bar',
      // bodyParams: {
      //   'nis': '050820090601',
      //   'tahunajaran': '2023/2024',
      //   'idSekolahKelas': '13',
      //   'semester': null
      // },
    );

    if (kDebugMode) {
      logger.log(
          "LEADERBOARD_SERVICE_API-FetchHasilPengerjaanSoal: response >> $response");
    }

    if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }

    return response.data['data'];
  }
}
