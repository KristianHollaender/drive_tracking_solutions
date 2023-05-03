import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/tour.dart';

part 'tour_event.dart';
part 'tour_state.dart';

class TourBloc extends Bloc<TourEvent, TourState> {
  TourBloc() : super(TourInitial()) {
    on<GetMyTours>(_getMyTours);
    on<GetTourByDate>(_getToursByDate);
  }


  // Call on repository methods
  Future<void> _getMyTours(GetMyTours event, Emitter<TourState> emit) async{
    List<Tour> tours;
    //tours = await _repository;

  }

  Future<void> _getToursByDate(GetTourByDate event, Emitter<TourState> emit) async{
    Tour tour;
    //tour = await _repository
  }
}
