import 'dart:developer' as logger show log;

import 'package:flutter/foundation.dart';

import '../../../../../../core/helper/api_helper.dart';
import '../../../../../../core/util/app_exceptions.dart';

class LaporanPresensiServiceAPI {
  final ApiHelper _apiHelper = ApiHelper(
    baseUrl: ''
  );

  /// [fetchPresensi] digunakan untuk mengambil data kehadiran siswa.
  ///
  /// Args:
  ///   userId (String): Nomor Registrasi Siswa.
  Future<dynamic> fetchPresensi({
    required String userId,
  }) async {
    final response = await _apiHelper.dio.get(
       '/presence/student',
    );

  if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }

    return response.data['data'];
  }
}
