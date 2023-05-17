import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import '../models/tour.dart';

class TourRepository {
  final baseUrl = 'https://us-central1-drivetrackingsolution.cloudfunctions.net/api';

  // Get total time on tour
  Future<String> getTotalTourTime(String tourId) async{
    Response response = await get(Uri.parse('$baseUrl/tour/totalTourTime/$tourId'));
    if(response.statusCode == 200){
      final totalTime = jsonDecode(response.body)['totalTime'];
      return totalTime;
    }else{
      throw Exception(jsonDecode(response.body));
    }
  }

  // Get total pause time on pause
  Future<String> getTotalPauseTimeOnPause(String tourId, String pauseId) async{
    Response response = await get(Uri.parse('$baseUrl/pause/totalTime/$tourId/$pauseId'));
    if(response.statusCode == 200){
      final totalTime = jsonDecode(response.body)['totalTime'];
      return totalTime;
    }else{
      throw Exception(jsonDecode(response.body));
    }
  }

  // Get total pause time on tour
  Future<String> getTotalPauseTimeOnTour(String tourId) async{
    Response response = await get(Uri.parse('$baseUrl/tour/totalPauseTime/$tourId'));
    if(response.statusCode == 200){
      final totalTime = jsonDecode(response.body)['totalTime'];
      return totalTime;
    }else{
      throw Exception(jsonDecode(response.body));
    }
  }









  // Get all tours where UserID equals the authenticated user
  Future<List<Tour>> getTours(String uid) async {
    Response response = await get(Uri.parse('/tour/totalTime/$baseUrl/$uid'));
    if (response.statusCode == 200) {
      final List result = json.decode(response.body)['data'];
      return result.map((e) => Tour.fromMap(e)).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
  // Get tour by data
  Future<Tour> getTourById(String uid, String id) async {
    Response response = await get(Uri.parse('$baseUrl/$uid/$id'));
    if (response.statusCode == 200) {
      final tour = jsonDecode(response.body);
      return Tour.fromMap(tour);
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<void> startTour(
      {required String uid,
      required GeoPoint startPoint,
      required DateTime startTime}) async {
    final body = {uid: uid, startPoint: startPoint, startTime: startTime};
    try {
      await post(Uri.parse('$baseUrl/$uid'), body: body);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> stopTour(
      {required String uid,
      required GeoPoint endpoint,
      required DateTime endTime}) async {
    final body = {uid: uid};
    try {
      await put(Uri.parse('$baseUrl/$uid'), body: body);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
