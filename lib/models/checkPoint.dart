import 'package:cloud_firestore/cloud_firestore.dart';

class CheckPointKeys{
  static const truckStop = 'truckStop';
}

class CheckPoint{
  final GeoPoint truckStop;

  CheckPoint(this.truckStop);

  CheckPoint.fromMap(Map<String, dynamic> data)
      : truckStop = data[CheckPointKeys.truckStop];

  Map<String, dynamic> toMap(){
    return {
      CheckPointKeys.truckStop: truckStop,
    };
  }
}