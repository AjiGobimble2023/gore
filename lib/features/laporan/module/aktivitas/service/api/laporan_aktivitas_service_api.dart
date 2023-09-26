import '../../../../../../core/helper/api_helper.dart';
import '../../../../../../core/util/app_exceptions.dart';

class LaporanAktifitasServiceAPI {
  final ApiHelper _apiHelper = ApiHelper(
    baseUrl: ''
  );

  /// [fetchAktifitas] digunakan untuk mengambil data aktivitas dari server.
  ///
  /// Args:
  ///   userId (String): Nomor registrasi siswa.
  ///   type (String): tipe data log aktivitas Hari ini/Minggu ini
  Future<dynamic> fetchAktifitas({
    required String userId,
    required String type,
  }) async {
    final response = await _apiHelper.dio.get( '/log',
    );
    if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }
    return response.data['data'];
  }
}
