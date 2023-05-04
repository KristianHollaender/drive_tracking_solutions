part of 'tour_bloc.dart';

abstract class TourEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadToursEvent extends TourEvent{
  @override
  List<Object?> get props => [];
}

class LoadTourEvent extends TourEvent{
  final String id;

  LoadTourEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class StartTour extends TourEvent{
  final GeoPoint startPoint;
  final GeoPoint endPoint;
  final DateTime startTime;

  StartTour(this.startPoint, this.endPoint, this.startTime);

}

