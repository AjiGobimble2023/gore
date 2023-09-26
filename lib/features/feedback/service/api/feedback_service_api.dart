import '../../../../core/helper/api_helper.dart';
import '../../../../core/util/app_exceptions.dart';

class FeedbackServiceApi {
  final apiHelper = ApiHelper(
  baseUrl: 'https://data-service.gobimbelonline.net/mobile/v1/api',
  authToken: 'YourAuthTokenHere', 
);

  Future<dynamic> fetchFeedbackQuestion({
    required String userId,
    required String idRencana,
  }) async {
    final response = await apiHelper.dio.get("/feedback/question/$userId/$idRencana");

    if (response.data['meta']['code']) throw DataException(message: response.data['meta']['message']);

    return response.data['data'];
  }

  Future<void> setFeedback({
    required Map<String, dynamic> params,
  }) async {
    final response = await apiHelper.dio.post(
      '/2109/feedback/save',
      data: params,
    );

    if (!response.data['meta']['code']) throw DataException(message: response.data['meta']['message']);
  }
}
