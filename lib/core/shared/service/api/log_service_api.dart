import 'dart:developer' as logger show log;
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gokreasi_new/core/config/constant.dart';

import '../../../config/global.dart';
// import '../../../helper/api_helper.dart';
// import '../../../util/app_exceptions.dart';

class LogServiceAPI {
  // final ApiHelper _apiHelper = ApiHelper();
  final dio = Dio();

  Future<void> setLog({
    required String userType,
    required List<Map<String, dynamic>> listLog,
    required String platform,
  }) async {
    final dynamic response;
    if (kDebugMode) {
      logger.log(
          "listlog1 ${listLog.asMap().values.elementAt(0).values.elementAt(2)}");
    }
    if (gLastIdLogActivity != null &&
        gLastMenuLogActivity ==
            listLog.asMap().values.elementAt(0).values.elementAt(2) &&
        gKeteranganLogActivity ==
            listLog.asMap().values.elementAt(0).values.elementAt(3)) {
      FormData formData = FormData.fromMap({
        'jenis': userType,
        'listLog': listLog,
        'platform': platform,
        'updateId': gLastIdLogActivity
      });
       final responsedata =
          await dio.post('${Constant.baseUrl}/2210/log/save', data: formData);
      response = responsedata.data;
    } else {
      FormData formData = FormData.fromMap({
        'jenis': userType,
        'listLog': listLog,
        'platform': platform,
        'updateId': gLastIdLogActivity
      });
      final responsedata =
          await dio.post('${Constant.baseUrl}/2210/log/save', data: formData);
      response = responsedata.data;
    }
    if (kDebugMode) {
      // logger.log("cek log $listLog, $userType, $platform");
      logger.log("cek log lastId ${response['lastId']}");
    }
    // if (resp) throw DataException(message: response['message']);

    gLastIdLogActivity = response['lastId'] as int;
    gLastMenuLogActivity =
        listLog.asMap().values.elementAt(0).values.elementAt(2);
    gKeteranganLogActivity =
        listLog.asMap().values.elementAt(0).values.elementAt(3);
    if (kDebugMode) {
      logger.log("cek $gLastIdLogActivity");
    }
    return response['lastId'];
  }
}
