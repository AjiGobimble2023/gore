import 'dart:developer' as logger show log;

import 'package:flutter/foundation.dart';

import '../../../../core/helper/api_helper.dart';
import '../../../../core/util/app_exceptions.dart';

class StandbyServiceApi {
  final ApiHelper _apiHelper = ApiHelper(baseUrl: '');

  Future<dynamic> fetchStandby(Map<String, dynamic> bodyParams) async {
    final response = await _apiHelper.dio.get(
      '/standby/schedule',
    );

    if (kDebugMode) {
      logger.log('STANDBY_SERVICE_API-FetchStandby: response >> $response');
    }

    if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }

    return response.data['data'];
  }

  Future<void> requestTST(Map<String, dynamic> bodyParams) async {
    if (kDebugMode) {
      logger
          .log('STANDBY_SERVICE_API-RequestTST: START with Params$bodyParams');
    }
    final response = await _apiHelper.dio.post(
      '/standby/tst/request',
      data: bodyParams,
    );

    if (kDebugMode) {
      logger.log('STANDBY_SERVICE_API-RequestTST: response >> $response');
    }

    if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }
  }
}
