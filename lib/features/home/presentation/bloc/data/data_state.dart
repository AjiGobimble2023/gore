part of 'data_bloc.dart';


class DataState extends Equatable {
  final bool updateAvailable;
  final String currentVersion;
  final String versionAvailable;
  final List<CarouselModel> items;
  final UpdateVersion? updateVersion;

   DataState({
    required this.updateAvailable,
    required this.currentVersion,
    required this.versionAvailable,
    required this.items,
    this.updateVersion
  });

   factory DataState.initial() {
    return DataLoaded(
      updateAvailable: false,
      currentVersion: '',
      versionAvailable: '',
      items: [],
    );
  }
  DataState copyWith({
    bool? updateAvailable,
    String? currentVersion,
    String? versionAvailable,
    UnmodifiableListView<CarouselModel>? items,
    final UpdateVersion? updateVersion
  }) {
    return DataState(
      updateAvailable: updateAvailable ?? this.updateAvailable,
      currentVersion: currentVersion ?? this.currentVersion,
      versionAvailable: versionAvailable ?? this.versionAvailable,
      items: items ?? this.items,
      updateVersion: updateVersion ?? this.updateVersion
    );
  }

  @override
  List<Object> get props => [updateAvailable, currentVersion, versionAvailable, items];
}

class DataInitial extends DataState {
  DataInitial({required super.updateAvailable, required super.currentVersion, required super.versionAvailable, required super.items});
}

class DataLoaded extends DataState {

  DataLoaded({required super.updateAvailable, required super.currentVersion, required super.versionAvailable, required super.items});
  
 


  @override
  List<Object> get props =>
      [updateAvailable, currentVersion, versionAvailable, items];
}

class DataError extends DataState {
  final String error;

  DataError(this.error) : super(updateAvailable: false, currentVersion: '', versionAvailable: '', items: []);

  @override
  List<Object> get props => [error];
}
