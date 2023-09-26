import 'dart:developer' as logger show log;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gokreasi_new/core/helper/api_helper.dart';
import '../../../../core/util/app_exceptions.dart';

class BukuServiceAPI {
  // final Dio dio = Dio(BaseOptions(
  //   connectTimeout: const Duration(seconds: 60),
  //   receiveTimeout: const Duration(seconds: 60),
  //   baseUrl:
  //       'https://data-service.gobimbelonline.netmobile/v1/api', //ganti sesuai service
  // ));

  // final Map<String, dynamic> headers = {
  //   'Authorization': 'Bearer YourAuthTokenHere',
  // };

final apiHelper = ApiHelper(
  baseUrl: 'https://data-service.gobimbelonline.net/mobile/v1/api',
  authToken: 'YourAuthTokenHere', 
);

  Future<List> fetchDaftarBuku({
    String? noRegistrasi,
    String jenisBuku = 'teori',
    required String idSekolahKelas,
    required String roleTeaser,
    required bool isProdukDibeli,
  }) async {
    if (kDebugMode) {
      logger.log(
          'BUKU_SERVICE_API-FetchBuku: START params(NoReg: $noRegistrasi, jenis: $jenisBuku, '
          '$idSekolahKelas, $roleTeaser, $isProdukDibeli)');
    }

    final response = await apiHelper.dio.get(
    '/14.06.23/buku/$jenisBuku',
      data: {
        'noRegistrasi': noRegistrasi,
        'teaserRole': roleTeaser,
        'idSekolahKelas': idSekolahKelas,
        'diBeli': isProdukDibeli
      },
    );

    if (kDebugMode) {
      logger.log('BUKU_SERVICE_API-FetchBuku: response >> $response');
    }

    if (response.data['meta']['code'] !=200) throw DataException(message: response.data['meta']['message']);

    return response.data['data'] ?? [];
  }

  Future<List> fetchDaftarBab({
    // String jenisBuku = 'teori',
    required String kodeBuku,
    required String kelengkapan,
    required String levelTeori,
  }) async {
    final response = await apiHelper.dio.get(
     '/buku/bab/$kodeBuku',
      data: {
        'kelengkapan': kelengkapan,
        'levelTeori': levelTeori,
      },
    );
    if (response.data['meta']['code'] != 200) throw DataException(message: response.data['meta']['message']);

    return response.data['data'] ?? [];
  }

  Future<dynamic> fetchContent({required String idTeoriBab}) async {
    if (kDebugMode) {
      logger.log(
          'BUKU_SERVICE_API-FetchContent: START params(idTeoriBab: $idTeoriBab)');
    }

    final response = await apiHelper.dio.get(
       '/buku/content/$idTeoriBab',
    );

    if (response.data['meta']['code']!=200) throw DataException(message: response.data['meta']['message']);

    return response.data['data'];
  }
}
