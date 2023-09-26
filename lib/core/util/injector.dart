import 'package:get_it/get_it.dart';
import 'package:gokreasi_new/features/home/presentation/bloc/data/data_bloc.dart';
import 'package:gokreasi_new/features/home/service/home_service_api.dart';
import 'package:gokreasi_new/features/ptn/module/ptnclopedia/service/api/ptn_service_api.dart';

final GetIt locator = GetIt.instance;

void init() {
  locator.registerFactory(() => DataBloc(locator()));

  locator.registerLazySingleton<HomeServiceAPI>(() => HomeServiceAPI());
  locator.registerLazySingleton<PtnServiceApi>(() => PtnServiceApi());
}
