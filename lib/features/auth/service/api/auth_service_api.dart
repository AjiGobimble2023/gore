import 'dart:developer' as logger;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gokreasi_new/core/config/constant.dart';

import '../../../../core/config/global.dart';
import '../../../../core/helper/api_helper.dart';
import '../../../../core/util/app_exceptions.dart';

/// [AuthServiceApi] merupakan service class penghubung provider dengan request api.
class AuthServiceApi {
  final Dio dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
    baseUrl: 'https://auth-service.gobimbelonline.net',
  ));

  Future<String?> fetchImei({
    String? noRegistrasi,
    String? siapa,
  }) async {
    if (noRegistrasi == null || siapa == null) {
      return null;
    }
    logger.log('FETCH IMEI START');
    final dio = Dio();

    try {
      final response =
          await dio.get("/mobile/v1/auth/imei/${siapa}/${noRegistrasi}");

      if (kDebugMode) logger.log('FETCH IMEI: response >> ${response.data}');

      return (response.data['meta']['code'] == 200)
          ? response.data['data']
          : null;
    } catch (e) {
      return null;
    }
  }

  /// [noRegistrasi] dan [userType] diisi untuk keperluan refresh data user.
  Future<Map<String, dynamic>> login({
    required String userPhoneNumber,
    required String otp,
    required String via,
    required String imei,
    required String userType,
    String? noRegistrasi,
  }) async {
    try {
      final response = await dio.post(
        '/mobile/v1/login/${userType}',
        data: {
          'noHP': userPhoneNumber,
          'via': via,
          'imei': imei,
        },
      );
      if (response.data['meta']['code'] != 200) {
        throw DataException(message: response.data['meta']['message']);
      }

      return response.data;
    } catch (e) {
      throw DataException(message: e.toString());
    }
  }

  /// [resendOTP] service untuk request pengiriman ulang OTP kepada user.
  Future<dynamic> resendOTP({
    required String userPhoneNumber,
    required String otpCode,
    required String via,
  }) async {
    try {
      final response = await dio.post(
        '/mobile/v1/login/otp/${via}',
        data: {'noHP': userPhoneNumber, 'otp': otpCode},
      );
      if (response.data['meta']['code'] != 200) {
        throw DataException(message: response.data['message']);
      }
      return response.data['waktu'];
    } catch (e) {
      throw DataException(message: e.toString());
    }
  }

  Future<Map<String, dynamic>> cekValidasiRegistrasi({
    required String noRegistrasi,
    required String nomorHp,
    required String userType,
    String? otp,
    String? kirimOtpVia,
    String? nama,
    String? email,
    String? tanggalLahir,
    String? idSekolahKelas,
    String? namaSekolahKelas,
  }) async {
    try {
      final response = await dio.post(
        'mobile/v1/auth/registrasi/validasi',
        data: {
          'registeredNumber': nomorHp,
          'otp': otp,
          'via': kirimOtpVia,
          'noRegistrasi': noRegistrasi,
          'nama': nama,
          'email': email,
          'tanggalLahir': tanggalLahir,
          'idSekolahKelas': idSekolahKelas,
          'namaSekolahKelas': namaSekolahKelas,
          'jenis': userType.toUpperCase(),
          'imei': gDeviceID
        },
      );

      if (kDebugMode) {
        logger.log(
            'AUTH_SERVICE_API-CekValidasiRegistrasi: response >> $response');
      }

      if (response.data['meta']['code'] != 200) {
        throw DataException(message: response.data['message']);
      }

      return response.data;
    } catch (e) {
      throw DataException(message: e.toString());
    }
  }

  Future<Map<String, dynamic>> simpanRegistrasi({
    required String imei,
    String? jwtSwitchOrtu,
  }) async {
    try {
      Map<String, dynamic> bodyParams = {'imei': imei};
      final Map<String, dynamic> additionalInfo = await gGetDeviceInfo();
      bodyParams.addAll(additionalInfo);

      final response = await dio.post(
        'mobile/v1/auth/registrasi/simpan',
        data: bodyParams,
      );

      if (kDebugMode) {
        logger.log('AUTH_SERVICE_API-SimpanRegistrasi: response >> $response');
      }
      return response.data;
    } catch (e) {
      throw DataException(message: e.toString());
    }
  }

  Future<bool> simpanLogin({
    required String noRegistrasi,
    required String nomorHp,
    required String imei,
    required String siapa,
    String? jwtSwitchOrtu,
  }) async {
    try {
      Map<String, dynamic> bodyParams = {
        'noRegistrasi': noRegistrasi,
        'registeredNumber': nomorHp,
        'imei': imei,
        'siapa': siapa
      };
      final Map<String, dynamic> additionalInfo = await gGetDeviceInfo();
      bodyParams.addAll(additionalInfo);
      final response = await dio.post(
        'mobile/v1//auth/login/update',
        data: bodyParams,
      );

      if (kDebugMode) {
        logger.log('AUTH_SERVICE_API-SimpanLogin: response >> $response');
      }
      return response.data['status'];
    } catch (e) {
      throw DataException(message: e.toString());
    }
  }

  Future<dynamic> fetchDefaultTahunAjaran() async {
    try {
      final response = await dio.get('/auth/tahun_ajaran');

      return response.data['data'];
    } catch (e) {
      throw DataException(message: e.toString());
    }
  }
}
