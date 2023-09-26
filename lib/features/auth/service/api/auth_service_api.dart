import 'dart:developer' as logger;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gokreasi_new/core/config/constant.dart';

import '../../../../core/config/global.dart';
import '../../../../core/helper/api_helper.dart';
import '../../../../core/util/app_exceptions.dart';

/// [AuthServiceApi] merupakan service class penghubung provider dengan request api.
class AuthServiceApi {
  final _apiHelper = ApiHelper();
  final dio = Dio();

  // Future<bool> checkProfilePicture(
  //     {required String userType, required String noRegistrasi}) async {
  //   final response = await _apiHelper.requestGet(
  //       hostUrl: 'images.ganeshaoperation.com',
  //       baseUrl: '/gokreasi/profile',
  //       pathUrl: '/$userType/$noRegistrasi.jpeg');
  //
  //   return response.statusCode == 200;
  // }

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
      final response = await dio.post(
        "${Constant.baseUrl}/auth/imei",
        data: {
          'noRegistrasi': noRegistrasi,
          'role': siapa,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (kDebugMode) logger.log('FETCH IMEI: response >> ${response.data}');

      return (response.data['meta']['code'] == 200)
          ? response.data['data']['cImei']
          : null;
    } catch (e) {
      if (kDebugMode) {
        logger.log('AUTH_SERVICE_API-CatchError: $e');
      }
      return null;
    }
  }

  /// [resendOTP] service untuk request pengiriman ulang OTP kepada user.
  Future<dynamic> resendOTP({
    required String userPhoneNumber,
    required String otpCode,
    required String via,
  }) async {
    final response = await _apiHelper.requestPost(
      jwt: false,
      pathUrl: '/auth/otp/resend',
      bodyParams: {
        'registeredNumber': userPhoneNumber,
        'otp': otpCode,
        'via': via,
      },
    );

    if (kDebugMode) {
      /* Bentuk Response:
        {
          "status": true,
          "waktu": "180",
          "message": "sukses"
        }
      */
      logger.log('AUTH_SERVICE_API-ResendOTP: response >> $response');
    }

    if (response['meta']['code'] != 200) {
      throw DataException(message: response['message']);
    }

    return response['waktu'];
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
    final response = await _apiHelper.requestPost(
      jwt: otp == null,
      pathUrl: '/auth/registrasi/validasi',
      bodyParams: {
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
      logger
          .log('AUTH_SERVICE_API-CekValidasiRegistrasi: response >> $response');
    }

    if (response['meta']['code'] != 200) {
      throw DataException(message: response['message']);
    }

    return response;
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
    if (kDebugMode) {
      logger
          .log('AUTH_SERVICE_API-Login: IS REFRESH >> ${noRegistrasi != null}');
      logger.log('AUTH_SERVICE_API-Login: START with '
          'params($userPhoneNumber, $otp, $via, $imei, $noRegistrasi, $userType)');
    }

    try {
      final response = await dio.post(
        'https://auth-service.gobimbelonline.net/mobile/v1/login/${userType}', // URL sesuai dengan endpoint login Anda
        data: {
          'noHP': userPhoneNumber,
          'via': via,
          'imei': '6C86438C-4B47-424C-9B2F-FA7A15BA5089'
          // 'imei': imei,
        },
      );

      if (kDebugMode) {
        logger.log('AUTH_SERVICE_API-Login: response >> ${response.data}');
      }
      if (response.data['meta']['code'] != 200) {
        throw DataException(message: response.data['meta']['message']);
      }

      return response.data;
    } catch (e) {
      // Tangani kesalahan di sini, misalnya:
      logger.log('AUTH_SERVICE_API-Login: Error >> $e');
      throw e; // Anda dapat melempar kembali kesalahan jika diperlukan
    }
  }

  Future<Map<String, dynamic>> simpanRegistrasi({
    required String imei,
    String? jwtSwitchOrtu,
  }) async {
    Map<String, dynamic> bodyParams = {'imei': imei};
    final Map<String, dynamic> additionalInfo = await gGetDeviceInfo();
    bodyParams.addAll(additionalInfo);

    final response = await _apiHelper.requestPost(
      jwtSwitchOrtu: jwtSwitchOrtu,
      pathUrl: '/auth/registrasi/simpan',
      bodyParams: bodyParams,
    );

    if (kDebugMode) {
      logger.log('AUTH_SERVICE_API-SimpanRegistrasi: response >> $response');
    }
    return response;
  }

  Future<bool> simpanLogin({
    required String noRegistrasi,
    required String nomorHp,
    required String imei,
    required String siapa,
    String? jwtSwitchOrtu,
  }) async {
    Map<String, dynamic> bodyParams = {
      'noRegistrasi': noRegistrasi,
      'registeredNumber': nomorHp,
      'imei': imei,
      'siapa': siapa
    };
    final Map<String, dynamic> additionalInfo = await gGetDeviceInfo();
    bodyParams.addAll(additionalInfo);

    final response = await _apiHelper.requestPost(
      jwtSwitchOrtu: jwtSwitchOrtu,
      pathUrl: '/auth/login/update',
      bodyParams: bodyParams,
    );

    if (kDebugMode) {
      logger.log('AUTH_SERVICE_API-SimpanLogin: response >> $response');
    }
    return response['status'];
  }

  Future<dynamic> fetchDefaultTahunAjaran() async {
    final response =
        await _apiHelper.requestPost(jwt: false, pathUrl: '/auth/tahun_ajaran');

    return response['data'];
  }
}
