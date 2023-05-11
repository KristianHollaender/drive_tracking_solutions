import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../models/util/gas_station.dart';
import '../util/location_util.dart';

class GasStationWidget extends StatefulWidget {
  const GasStationWidget({Key? key}) : super(key: key);

  @override
  State<GasStationWidget> createState() => _GasStationState();
}

class _GasStationState extends State<GasStationWidget> {
  late String radius;
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
                    radius = '2000';
                    GeoPoint currentLocation = await getCurrentLocation();
                    await getNearByGasStations(currentLocation, radius);
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

  Future<void> getNearByGasStations(GeoPoint currentLocation, String radius) async {
    try {
      final String jsonString = await rootBundle.loadString('assets/config.json');
      final jsonMap = json.decode(jsonString);
      String apiKey = jsonMap['api_Key'];
      String httpUrl = "${jsonMap['httpURL']}${currentLocation.latitude},${currentLocation.longitude}&radius=$radius&type=gas_station&key=$apiKey";
      Uri url = Uri.parse(httpUrl);
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
