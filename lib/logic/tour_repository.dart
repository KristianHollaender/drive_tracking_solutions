import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';

import '../models/tour.dart';


//TODO Get tours sorted by start date
class TourRepository{
  final baseUrl = '';
  // Get all tours where uid equals the authenticated user
  Future<List<Tour>> getTours(String uid) async{
    Response response = await get(Uri.parse('$baseUrl/$uid'));
    if(response.statusCode == 200){
      final List result = json.decode(response.body)['data'];
      return result.map((e) => Tour.fromMap(e)).toList();
    }else{
      throw Exception(response.reasonPhrase);
    }
  }

  // Get tour by data
  Future<Tour> getTourById(String uid, String id) async{
    Response response = await get(Uri.parse('$baseUrl/$uid/$id'));
    if(response.statusCode == 200){
      final tour = jsonDecode(response.body);
      return Tour.fromMap(tour);
    }else{
      throw Exception(response.reasonPhrase);
    }
  }

  Future<void> startTour({required String uid, required GeoPoint startPoint, required DateTime startTime}) async{
    final body = {uid: uid, startPoint: startPoint, startTime: startTime};
    try{
      await post(Uri.parse('$baseUrl/$uid'), body: body);
    }catch(e){
      throw Exception(e.toString());
    }
  }

  Future<void> stopTour({required String uid, required GeoPoint endpoint, required DateTime endTime}) async{
    final body = {uid: uid};
    try{
      await put(Uri.parse('$baseUrl/$uid'), body: body);
    }catch(e){
      throw Exception(e.toString());
    }
  }

}