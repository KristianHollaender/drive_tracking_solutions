import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'tour_action_event.dart';
part 'tour_action_state.dart';

class TourActionBloc extends Bloc<TourActionEvent, TourActionState> {
  TourActionBloc() : super(const TourActionInitial('Press start to tracking your time')) {
    on<TourStart>(_onStarted);
  }

  void _onStarted(TourStart event, Emitter<TourActionState> emit){
    emit(TourStarted(event.startTime));
  }

  void _onPaused(TourPause event, Emitter<TourActionState> emit) {
    emit(const TourPaused());
  }

  void _onResumed(TourResume event, Emitter<TourActionState> emit) {
    emit(const TourResumed());
  }

  void _onCompleted(TourComplete event, Emitter<TourActionState> emit) {
    emit(TourCompleted(state.startTime!, event.totalTime));
  }


}
