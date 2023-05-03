part of 'tour_bloc.dart';

abstract class TourEvent extends Equatable {}

class GetMyTours extends TourEvent{
  final List<Tour> tours;
  final String id;

  GetMyTours({required this.tours, required this.id});
  @override
  List<Object> get props => [tours, id];
}

class GetTourByDate extends TourEvent {
  final Tour tour;
  final DateTime dateTime;

  GetTourByDate({required this.tour, required this.dateTime});

  @override
  List<Object?> get props => [tour, dateTime];
}


