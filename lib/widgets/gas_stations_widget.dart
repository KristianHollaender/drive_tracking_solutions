import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/util/gas_station.dart';
import '../util/location_util.dart';

class GasStationWidget extends StatefulWidget {
  const GasStationWidget({Key? key}) : super(key: key);

  @override
  State<GasStationWidget> createState() => _GasStationState();
}

class _GasStationState extends State<GasStationWidget> {
  static const String apiKey = 'AIzaSyAlelbjxcRHvF6e8giNCx5NnsZ05ci_H_U';
  static const String radius = '500';
  GasStation gasStation = GasStation();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby gas stations'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    GeoPoint currentLocation = await getCurrentLocation();
                    await getNearByGasStations(currentLocation);
                  },
                  child: const Text('Get nearby gas station')),
              if (gasStation.results != null)
                for (int i = 0; i < gasStation.results!.length; i++)
                  nearByGasStation(gasStation.results![i]),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getNearByGasStations(GeoPoint currentLocation) async {
    try {
      //Uri url = Uri.parse('https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${currentLocation.latitude},${currentLocation.longitude}&radius=$radius&type=gas_station&key=$apiKey');
      Uri url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=55.487770,8.446950&radius=2000&type=gas_station&key=AIzaSyAlelbjxcRHvF6e8giNCx5NnsZ05ci_H_U');
      var response = await http.post(url);

      gasStation = GasStation.fromJson(jsonDecode(response.body));

      setState(() {});
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Widget nearByGasStation(Results result) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Text("Name: ${result.name!}"),
          Text(
              "Location: ${result.geometry!.location!.lat} , ${result.geometry!.location!.lng}"),
          Text(result.vicinity!),
        ],
      ),
    );
  }
}
