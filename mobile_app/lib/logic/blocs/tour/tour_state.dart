part of 'tour_bloc.dart';

abstract class TourState extends Equatable {
  const TourState();
}

class TourInitialState extends TourState{
  @override
  List<Object?> get props => [];
}

// Error if the data cannot be loaded
class TourErrorState extends TourState{
  final String error;

  const TourErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

//#region Read
// Loading the data from our api
class TourLoadingState extends TourState{
  @override
  List<Object?> get props => [];
}

// Loaded the data from our api
class TourLoadedState extends TourState{
  final List<Tour>? tours;
  final Tour? tour;

  const TourLoadedState(this.tours, this.tour);
  @override
  List<Object?> get props => [tours, tour];
}

//#endregion

//#region Create

class TourStartingState extends TourState{
  @override
  List<Object?> get props => [];
}

class TourStartedState extends TourState{
  @override
  List<Object?> get props => [];
}

//#endregion

//#region Update

//#endregion
