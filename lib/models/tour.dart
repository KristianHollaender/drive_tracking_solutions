import 'package:cloud_firestore/cloud_firestore.dart';

class TourKeys {
  static const uid = 'uid';
  static const startLatitude = 'startLatitude';
  static const startLongitude = 'startLongitude';
  static const endLatitude = 'endLatitude';
  static const endLongitude = 'endLongitude';
  static const startTime = 'startTime';
  static const endTime = 'endTime';
  static const totalTime = 'totalTime';
}

class Tour {
  final String uid;
  final String startLatitude;
  final String startLongitude;
  final String endLatitude;
  final String endLongitude;
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime? totalTime;

  Tour(this.uid, this.startLatitude, this.startLongitude, this.endLatitude,
      this.endLongitude, this.startTime, this.endTime, this.totalTime);

  //Getting tour from firebase, then mapping tour to a dart object
  Tour.fromMap(this.uid, Map<String, dynamic> data)
      : startLatitude = data[TourKeys.startLatitude],
        startLongitude = data[TourKeys.startLongitude],
        endLatitude = data[TourKeys.endLatitude],
        endLongitude = data[TourKeys.endLongitude],
        startTime = (data[TourKeys.startTime] as Timestamp).toDate(),
        endTime = (data[TourKeys.endTime] as Timestamp).toDate(),
        totalTime = (data[TourKeys.totalTime] as Timestamp).toDate();

  //Mapping dart object to json object
  Map<String, dynamic> toMap(){
    return {
      TourKeys.startLatitude: startLongitude,
      TourKeys.startLongitude: startLongitude,
      TourKeys.endLatitude: endLatitude,
      TourKeys.endLongitude: endLongitude,
      TourKeys.startTime: startTime,
      TourKeys.endTime: endTime,
      TourKeys.totalTime: totalTime
    };
  }
}
