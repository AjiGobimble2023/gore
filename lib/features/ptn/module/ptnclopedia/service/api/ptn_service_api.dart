import 'dart:developer' as logger show log;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../../../../core/util/app_exceptions.dart';

class PtnServiceApi {
  final dio = Dio();
  final url = 'https://ptn-service.gobimbelonline.net';

  Future<dynamic> fetchUniversitas() async {
    try {
      // final response =
      //     await Dio().get('http://192.168.20.250:4005/api/v1/universitas');
      final response = await Dio().get('${url}/api/v1/universitas');
      return response.data['data'];
    } catch (error) {
      throw error;
    }
  }

  Future<dynamic> fetchJurusan({
    required int idPtn,
  }) async {
    try {
      print('kkk${idPtn}');
      // final response = await Dio()
      //     .get('http://192.168.20.250:4005/api/v1/universitas/${idPtn}');
      final response = await Dio().get('${url}/api/v1/universitas/${idPtn}');
      return response.data['data'];
    } catch (error) {
      throw error;
    }
  }

  Future<dynamic> fetchDetailJurusan({
    required int idJurusan,
  }) async {
    if (kDebugMode) {
      logger.log(
          'PTN_SERVICE_API-FetchDetailJurusan: START with params($idJurusan)');
    }

    try {
      // final response = await Dio().get(
      //     'http://192.168.20.250:4005/api/v1/universitas/jurusan/${idJurusan}');
      final response =
          await Dio().get('${url}/api/v1/universitas/jurusan/${idJurusan}');
      print(response);
      return response.data['data'];
    } catch (error) {
      throw error;
    }
  }

  Future<dynamic> fetchKampusImpianPilihan({
    required String noRegistrasi,
  }) async {
    if (kDebugMode) {
      logger.log(
          'PTN_SERVICE_API-FetchKampusImpianPilihan: START with params($noRegistrasi)');
    }

    // final response = await Dio().get(
    //     'http://192.168.20.250:4005/api/v1/db-ptn/ptn-pilihan/${noRegistrasi}');
    final response =
        await Dio().get('${url}/api/v1/db-ptn/ptn-pilihan/${noRegistrasi}');

    if (kDebugMode) {
      logger.log(
          'PTN_SERVICE_API-FetchKampusImpianPilihan: response >> $response');
    }

    if (response.data['meta']['code'] != 200)
      throw DataException(message: response.data['meta']['message']);

    return response.data;
  }

  Future<dynamic> putKampusImpian(
      {required String noRegistrasi,
      required int pilihanKe,
      required int idJurusan}) async {
    if (kDebugMode) {
      logger.log('PTN_SERVICE_API-UpdateKampusImpian: '
          'START with params($noRegistrasi, $pilihanKe, $idJurusan)');
    }

    final response = await Dio()
        .get('http://192.168.20.250:4005/api/v1/ptn-pilihan/${noRegistrasi}');

    if (kDebugMode) {
      logger.log('PTN_SERVICE_API-UpdateKampusImpian: response >> $response');
    }

    return response.data;
  }
}
