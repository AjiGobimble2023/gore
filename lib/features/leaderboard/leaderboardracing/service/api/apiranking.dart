import 'dart:developer' as logger show log;

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../presentation/provider/leaderboard_racing_provider.dart';

class ApiRanking {
  Future<Map<String, dynamic>> getranking({
    required String nis,
    required String idSekolahKelas,
    required int number,
    required String level,
    required String ta,
    required String penanda,
    required String idgedung,
    required String jeniswaktu,
  }) async {
    Map<String, dynamic> result;
    final dio = Dio();

    try {
      final response = await dio.post(
        "https://zany-cuff-toad.cyclic.cloud/leaderboardracing/getleaderracing",
        data: {
          'token': "YGfdsk3452355mj56uy",
          'nis': nis,
          'idSekolahKelas': idSekolahKelas,
          'number': number,
          'level': level,
          'tahunajaran': ta,
          'penanda': penanda,
          'idgedung': idgedung,
          'jeniswaktu': jeniswaktu,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (kDebugMode) {
        logger.log(
            "number: $number, level: $level, tahunajaran: $ta, jeniswaktu: $jeniswaktu, nis: $nis, penanda: $penanda, idgedung: $idgedung, idSekolahKelas: $idSekolahKelas");
        logger.log("Parameter ${response.data}");
      }

      if (response.statusCode == 200) {
        dynamic body = response.data['data'];
        logger.log(body.toString());
        DataRanking cases = DataRanking.fromJson(body);
        result = {'status': true, 'data': cases};
      } else {
        result = {'status': false, 'data': "gagal mendapatkan data"};
      }
    } catch (e) {
      if (kDebugMode) {
        logger.log("Error: $e");
      }
      result = {'status': false, 'data': "gagal mendapatkan data"};
    }

    return result;
  }
}
