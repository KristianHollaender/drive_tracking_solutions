import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/tour.dart';

class FirebaseService{
  final _tourController = StreamController<dynamic>.broadcast();

  Future<void> getMyTours(String uid) async {
    final response = await http.get(Uri.parse("someLink/${uid}"));

    if (response.statusCode == 200){
      List<Tour> tours = json.decode(response.body);
      _tourController.add(tours);
    }
  }

  Future<void> getTourByDate(String uid, DateTime dateTime) async{
    final response = await http.get(Uri.parse("someLink/${uid}/${dateTime}"));

    if (response.statusCode == 200){
      final tourData = json.decode(response.body);
      final tour = Tour.fromMap(uid, tourData);
      _tourController.add(tour);
    }
  }

  Future<void> startTour(String uid, GeoPoint startPoint, GeoPoint endPoint,DateTime startTime) async{
    final body = {uid: uid,startPoint:startPoint, endPoint: endPoint, startTime: startTime};
    final response = await http.post(Uri.parse('something'), body: body);
    if(response.statusCode == 201){

    }
  }

  Future<void> pauseTour() async{

  }

  Future<void> resumeTour() async{

  }

  Future<void> endTour() async{

  }
}



