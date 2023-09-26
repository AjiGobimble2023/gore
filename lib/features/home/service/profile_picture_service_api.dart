import 'dart:developer' as logger show log;

import 'package:flutter/foundation.dart';

import '../../../core/helper/api_helper.dart';
import '../../../core/util/app_exceptions.dart';

/// [ProfilePictureServiceApi] merupakan service class penghubung provider dengan request api.
class ProfilePictureServiceApi {
  final _apiHelper = ApiHelper(baseUrl:'',authToken: '' );

  Future<String?> fetchProfilePicture(
      {required String namaLengkap, required String noRegistrasi}) async {
    try {
      final response = await _apiHelper.dio.get('/profile/url/$noRegistrasi');

      if (response.data == null ||
          response.data['meta']['code'] == false ||
          response.data['data'] == null) {
        return null;
      }

      return response.data['data'];
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> setProfilePicture({
    required String noRegistrasi,
    required String photoUrl,
    bool isAvatar = true,
  }) async {
    String pesanGagal = 'Yaah, foto kamu gagal disimpan Sobat, coba lagi yaa!';
    try {
      final response = await _apiHelper.dio.post('/profile/simpan/$noRegistrasi',
        data: {'url': photoUrl, 'isAvatar': isAvatar},
      );

      if (kDebugMode) {
        logger.log('PROFILE_PICTURE-SetProfilePicture: response >> $response');
      }

      if (response.data['meta']['code']) {
        throw DataException(message: response.data['meta']['message'] ?? pesanGagal);
      }

      return response.data['meta']['message'] ?? pesanGagal;
    } catch (e) {
      return pesanGagal;
    }
  }
}
