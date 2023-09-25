import 'dart:collection';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gokreasi_new/core/util/app_exceptions.dart';
import 'package:gokreasi_new/features/home/model/carousel_model.dart';
import 'package:gokreasi_new/features/home/model/update_version.dart';
import 'package:gokreasi_new/features/home/service/home_service_api.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'data_event.dart';
part 'data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  final HomeServiceAPI _apiService;
  DataBloc(this._apiService) : super(DataState.initial()) {
    on<CheckUpdateEvent>((event, emit) async {
      try {
        final responseData = await _apiService.fetchVersion();
        if (responseData != null) {
          emit(state.copyWith(
              updateVersion: UpdateVersion.fromJson(responseData)));
        }
        if (state.updateVersion != null) {
          PackageInfo packageInfo = await PackageInfo.fromPlatform();

          String responseVersion = (Platform.isIOS)
              ? state.updateVersion!.ios.version
              : state.updateVersion!.android.version;
          int responseVersionNumber = (Platform.isIOS)
              ? state.updateVersion!.ios.versionNumber
              : state.updateVersion!.android.versionNumber;
          int responseBuildNumber = (Platform.isIOS)
              ? state.updateVersion!.ios.buildNumber
              : state.updateVersion!.android.buildNumber;

          String version = packageInfo.version;
          int versionNumber = int.tryParse(version.replaceAll('.', '')) ?? 0;
          int buildNumber = int.parse(packageInfo.buildNumber);

          emit(state.copyWith(
            currentVersion: '$version ($buildNumber)',
            versionAvailable: '$responseVersion ($responseBuildNumber)',
            updateAvailable: (versionNumber == responseVersionNumber)
                ? buildNumber < responseBuildNumber
                : versionNumber < responseVersionNumber,
          ));
        }
      } catch (e) {
        emit(DataError(e.toString()));
      }
    });

    on<LoadCarouselEvent>((event, emit) async {
      try {
        final responseData = await _apiService.fetchCarousel();

        final List<CarouselModel> _items = [];
        if (responseData.length > 0) {
          for (int i = 0; i < responseData.length; i++) {
            _items.add(CarouselModel.fromJson(responseData[i]));
          }
          UnmodifiableListView<CarouselModel> items =
              UnmodifiableListView(_items);
          emit(state.copyWith(items: items));
        } else {
          emit(DataError('Tidak ada data Carousel.'));
        }
      } on NoConnectionException {
        emit(DataError('Tidak ada koneksi internet.'));
      } catch (e) {
        emit(DataError(
            'Terjadi kesalahan saat mengambil data.\nMohon coba kembali nanti.'));
      }
    });
  }
}
