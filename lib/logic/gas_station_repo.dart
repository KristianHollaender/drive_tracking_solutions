import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class GasStationRepo{

  Future getNearByGasStations(GeoPoint currentLocation, String radius) async {
    try {
      final String jsonString = await rootBundle.loadString('assets/config.json');
      final jsonMap = json.decode(jsonString);
      String apiKey = jsonMap['api_Key'];
      //String httpUrl = "${jsonMap['httpURL']}${currentLocation.latitude},${currentLocation.longitude}&radius=$radius&type=gas_station&key=$apiKey";
      String httpUrl = "";
      Uri url = Uri.parse(httpUrl);
      var response = await http.get(url);

      return jsonDecode(response.body);

    } catch (e) {
      throw Exception(e.toString());
    }
  }
}