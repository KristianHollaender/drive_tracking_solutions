part of 'tour_bloc.dart';

abstract class TourEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class LoadToursEvent extends TourEvent{
  @override
  List<Object?> get props => [];
}

class LoadTourEvent extends TourEvent{
  final DateTime dateTime;

  LoadTourEvent(this.dateTime);
  @override
  List<Object?> get props => [dateTime];
}

class StartTour extends TourEvent{
  final GeoPoint startPoint;
  final GeoPoint endPoint;
  final DateTime startTime;

  StartTour(this.startPoint, this.endPoint, this.startTime);

}

