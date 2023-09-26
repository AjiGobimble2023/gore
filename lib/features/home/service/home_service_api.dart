import 'package:dio/dio.dart';

import '../../../core/helper/api_helper.dart';
import '../../../core/util/app_exceptions.dart';

class HomeServiceAPI {
  final ApiHelper _apiHelper =
      ApiHelper(baseUrl: 'https://data-service.gobimbelonline.net');

  static final HomeServiceAPI _instance = HomeServiceAPI._internal();

  factory HomeServiceAPI() => _instance;

  HomeServiceAPI._internal();

  Future<dynamic> fetchVersion() async {
    final response = await _apiHelper.dio.get('/version');

    if (response.data['meta']['code'] != 200) {
      throw DataException(message: 'Tidak ada update');
    }

    return response.data['data'];
  }

  Future<dynamic> fetchCarousel() async {
    try {
      final response = await _apiHelper.dio.get('/api/v1/data/carousel');
      return response.data['data'];
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
