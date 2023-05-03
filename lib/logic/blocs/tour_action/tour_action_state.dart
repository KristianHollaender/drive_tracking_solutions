part of 'tour_action_bloc.dart';

abstract class TourActionState extends Equatable {
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime? totalTime;

  const TourActionState(this.startTime, this.endTime, this.totalTime);

  @override
  List<Object?> get props => [startTime, endTime, totalTime];
}

class TourActionInitial extends TourActionState {
  const TourActionInitial(String msg) : super(null, null, null);
}

class TourStarted extends TourActionState {
  final DateTime startTime;
  const TourStarted(this.startTime) : super(startTime,null,null);
}

class TourPaused extends TourActionState {
  const TourPaused() : super(null,null,null);
}

class TourResumed extends TourActionState{
  const TourResumed(): super(null,null,null);
}
class TourCompleted extends TourActionState {
  final DateTime endTime;
  final DateTime totalTime;
  const TourCompleted(this.endTime, this.totalTime) : super(null, endTime, totalTime);
}
