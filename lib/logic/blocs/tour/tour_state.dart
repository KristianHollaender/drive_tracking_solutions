part of 'tour_bloc.dart';

abstract class TourState extends Equatable {
  const TourState();
}

class TourInitial extends TourState {
  @override
  List<Object> get props => [];
}

class TourLoading extends TourState {
  @override
  List<Object> get props => [];
}

class TourSuccessful extends TourState {
  final Tour tour;
  const TourSuccessful({required this.tour});
  @override
  List<Object> get props => [tour];
}

class TourFailure extends TourState {
  @override
  List<Object> get props => [];
}


