part of 'tour_action_bloc.dart';

abstract class TourActionEvent extends Equatable {
  const TourActionEvent();
  @override
  List<Object> get props => [];
}

class TourStart extends TourActionEvent {
  final GeoPoint startPoint;
  final DateTime startTime;
  const TourStart(this.startPoint, this.startTime);
}

class TourPause extends TourActionEvent{
  final DateTime pauseStartTime;
  const TourPause(this.pauseStartTime);
}

class TourResume extends TourActionEvent{
  final DateTime pauseEndTime;
  const TourResume(this.pauseEndTime);
}

class TourComplete extends TourActionEvent{
  final GeoPoint endPoint;
  final DateTime endTime;
  final DateTime totalTime;
  const TourComplete(this.endPoint, this.endTime, this.totalTime);
}


