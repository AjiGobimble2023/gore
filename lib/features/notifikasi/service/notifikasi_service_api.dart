import '../../../../../core/helper/api_helper.dart';
import '../../../core/util/app_exceptions.dart';

class NotificationServiceApi {
  final _apiHelper = ApiHelper(
    baseUrl: ''
  );

  Future<dynamic> fetchNotification(String userId) async {
    final response = await _apiHelper.dio.get(
       "/notif",
    );
    if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }
    return response.data['data'];
  }

  Future<void> deleteNotification(String notifId) async {
    final response = await _apiHelper.dio.delete(
      "/notif/delete/$notifId",
    );

   if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }
  }
}
