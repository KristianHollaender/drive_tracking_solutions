import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../models/tour.dart';
import '../../tour_repository.dart';

part 'tour_event.dart';
part 'tour_state.dart';

class TourBloc extends Bloc<TourEvent, TourState> {
  final TourRepository _tourRepository;
  final _auth = FirebaseAuth.instance;

  TourBloc(this._tourRepository) : super(TourInitialState()) {
    on<LoadToursEvent>((event, emit) async {
      emit(TourLoadingState());
      try{
        final tours = await _tourRepository.getTours(_auth.currentUser!.uid);
        emit(TourLoadedState(tours, null));
      }catch (e){
        emit(TourErrorState(e.toString()));
      }
    });

    on<LoadTourEvent>((event, emit) async{
      emit(TourLoadingState());
      try{
        final tour = await _tourRepository.getTourById(_auth.currentUser!.uid, event.id);
        emit(TourLoadedState(null, tour));
      }catch(e){
        emit(TourErrorState(e.toString()));
      }
    });

    on<StartTour>((event, emit) async {
      emit(TourStartingState());
      await Future.delayed(const Duration(seconds: 1));
      try{
        await _tourRepository.startTour(uid: _auth.currentUser!.uid, startPoint: event.startPoint, startTime: event.startTime);
        emit(TourStartedState());
      }catch(e){
        emit(TourErrorState(e.toString()));
      }
    });
  }

}
