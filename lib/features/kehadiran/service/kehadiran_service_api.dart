import 'dart:convert';

import '../../../../core/helper/api_helper.dart';
import '../../../../core/util/app_exceptions.dart';

/// [KehadiranServiceApi] merupakan service class penghubung provider dengan request api.
class KehadiranServiceApi {
  final _apiHelper = ApiHelper(
    baseUrl: '',
    authToken: ''
  );

  Future<dynamic> fetchKehadiranMingguIni({
    required String noRegistrasi,
  }) async {
    var response = await _apiHelper.dio.get('/presence/getkehadiran');

    if (response.data is String) {
      response = jsonDecode(response.data);
    }

    if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }

    return response.data['data'];
  }
}
