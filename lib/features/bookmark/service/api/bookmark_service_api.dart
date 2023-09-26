import 'dart:convert';
import 'dart:developer' as logger show log;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/util/app_exceptions.dart';
import '../../entity/bookmark.dart';

class BookmarkServiceAPI {
  final Dio dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
    baseUrl:
        'https://data-service.gobimbelonline.netmobile/v1/api', //ganti sesuai service
  ));

  final Map<String, dynamic> headers = {
    'Authorization': 'Bearer YourAuthTokenHere',
  };

  Future<dynamic> fetchBookmark({required String noRegistrasi}) async {
    try{
    final response =
        await dio.get('/bookmark/shortcut', options: Options(headers: headers));

    if (kDebugMode) {
      logger.log("BOOKMARK_SERVICE_API-FetchBookmark: response >> $response");
    }

    if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }

    return response.data['data'];
    } catch (e) {
      throw DataException(message: e.toString());
    }
  }

  Future<bool> updateBookmark(
      {required String noRegistrasi,
      required List<BookmarkMapel> daftarBookmark}) async {
    try {
      final response = await dio.post('/bookmark/save',
          data: {
            'nis': noRegistrasi,
            'bookmark': jsonEncode(daftarBookmark),
          },
          options: Options(headers: headers));

      if (kDebugMode) {
        logger
            .log("BOOKMARK_SERVICE_API-UpdateBookmark: response >> $response");
      }

      return response.data['status'];
    } catch (e) {
      throw DataException(message: e.toString());
    }
  }
}
