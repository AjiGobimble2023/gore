import 'dart:developer' as logger show log;

import 'package:flutter/foundation.dart';

import '../../../../core/helper/api_helper.dart';
import '../../../../core/util/app_exceptions.dart';

class PembayaranServiceAPI {
  final ApiHelper _apiHelper = ApiHelper(
    baseUrl: ''
  );

  Future<dynamic> fetchPembayaran({required String noRegistrasi}) async {
    final response = await _apiHelper.dio.get(
     '/pembayaran/info',
    );

    if (kDebugMode) {
      logger
          .log('PEMBAYARAN_SERVICE_API-FetchPembayaran: response >> $response');
    }

    if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }

    return response.data;
  }

  Future<dynamic> fetchDetailPembayaran({required String noRegistrasi}) async {
    final response = await _apiHelper.dio.get(
    '/pembayaran/infodetail'
    );


    if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }

    return response.data['data'];
  }
}
