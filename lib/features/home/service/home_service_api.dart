import 'package:dio/dio.dart';

import '../../../core/helper/api_helper.dart';
import '../../../core/util/app_exceptions.dart';

class HomeServiceAPI {
  final ApiHelper _apiHelper = ApiHelper();

  static final HomeServiceAPI _instance = HomeServiceAPI._internal();

  factory HomeServiceAPI() => _instance;

  HomeServiceAPI._internal();

  Future<dynamic> fetchVersion() async {
    final response = await _apiHelper.requestPost(
      jwt: false,
      pathUrl: '/version',
    );

    if (!response['status']) throw DataException(message: 'Tidak ada update');

    return response['data'];
  }

  Future<dynamic> fetchCarousel() async {
    try {
      // Buat instance Dio
      Dio dio = Dio();
      final response =
          await dio.get('http://192.168.20.250:4002/api/v1/data/carousel');
      print(response.data);
      return response.data['data'];
    } catch (e) {
      // Tangani kesalahan jika terjadi
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
