import '../../../../../../core/helper/api_helper.dart';
import '../../../../../../core/util/app_exceptions.dart';

class LeaderboardFriendsServiceApi {
  final _apiHelper = ApiHelper(
    baseUrl: ''
  );

  Future<dynamic> fetchLeaderboardFriends(String userId) async {
    final response = await _apiHelper.dio.get(
     "/friend/leaderboard",
    );

   
       if (response.data['meta']['code'] != 200) {
      throw DataException(message: response.data['meta']['message']);
    }

    return response.data['data'];
  }
}
