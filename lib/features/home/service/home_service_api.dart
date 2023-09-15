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
    // final response = await _apiHelper.requestPost(
    //   jwt: false,
    //   pathUrl: '/carousel',
    // );
    final response = {
      "data": [
        {
          "nama_file":
              "https://1.bp.blogspot.com/-lTJvQzNtTRw/XMTxH9UGFCI/AAAAAAAAPFQ/iVfu94tODOQ_AVuG1m-zN1Hl4NcipaCIACLcBGAs/s1600/event.png",
          "keterangan": "Gambar Carousel 1",
          "link": "https://www.example.com/carousel1",
          "status": "aktif",
          "tanggal": "2023-08-30"
        },
        {
          "nama_file":
              "https://www.lalamove.com/hubfs/event%20organizer%20%283%29.jpg",
          "keterangan": "Gambar Carousel 2",
          "link": "https://www.example.com/carousel2",
          "status": "aktif",
          "tanggal": "2023-08-31"
        },
        {
          "nama_file":
              "https://1.bp.blogspot.com/-lTJvQzNtTRw/XMTxH9UGFCI/AAAAAAAAPFQ/iVfu94tODOQ_AVuG1m-zN1Hl4NcipaCIACLcBGAs/s1600/event.png",
          "keterangan": "Gambar Carousel 3",
          "link": "https://www.example.com/carousel3",
          "status": "nonaktif",
          "tanggal": "2023-09-01"
        }
      ]
    };

    return response['data'];
  }
}
