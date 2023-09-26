import 'dart:async';
import 'dart:developer' as logger show log;

import 'package:flutter/foundation.dart';

import '../../../../core/helper/api_helper.dart';
import '../../../../core/util/app_exceptions.dart';

class DataServiceAPI {
  final ApiHelper _apiHelper = ApiHelper(
    baseUrl: ''
  );

  Future<dynamic> fetchAbout() async {
    final response = await _apiHelper.dio.get( '/about');

     if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }
    return response.data['data'];
  }

  Future<dynamic> fetchAturanSiswa({
    required String noRegistrasi,
    required String tipeUser,
  }) async {
    final response = await _apiHelper.dio.get('/aturan'
    );

  if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }
    return response.data['data'];
  }

  Future<dynamic> setAturanSiswa({
    required String noRegistrasi,
    required String tipeUser,
  }) async {
    final response = await _apiHelper.dio.post(
      '/aturan/simpan',
      data: {
        'noRegistrasi': noRegistrasi,
        'siapa': tipeUser,
      },
    );

    if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }

    return response.data['data'];
  }

  Future<dynamic> fetchKelompokUjianPilihan(
      {required String noRegistrasi}) async {
    final response = await _apiHelper.dio.get(
      '/tryout/getmapelpilihan',
    );

     if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }

    return response.data['data'];
  }

  Future<dynamic> fetchListKelompokUjianPilihan(
      {required String tingkatSekolah}) async {
    final response = await _apiHelper.dio.get(
      '/kelompokUjian/$tingkatSekolah'
    );

   if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }

    return response.data['data'];
  }

  Future<dynamic> setKelompokUjianPilihan({
    required String noRegistrasi,
    required List<String> daftarIdKelompokUjian,
  }) async {
    try {
      final response = await _apiHelper.dio.post(
      '/tryout/simpanmapelpilihan',
       data: {
          'nis': noRegistrasi,
          'idmapeluji': daftarIdKelompokUjian,
        },
      );

      return (response.data['meta']['code'] == 200);
    } catch (e) {
      if (kDebugMode) {
        logger.log('FatalException-SetKelompokUjianPilihan: $e');
      }
      return false;
    }
  }

  Future<dynamic> deleteAccount({
    required String nomorHp,
    required String noRegistrasi,
  }) async {
    final response = await _apiHelper.dio.delete(
       '/auth/delete/$noRegistrasi'
    );

    return response;
  }
}
