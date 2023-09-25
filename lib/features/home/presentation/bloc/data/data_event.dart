part of 'data_bloc.dart';

abstract class DataEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CheckUpdateEvent extends DataEvent {}

class LoadCarouselEvent extends DataEvent {}
