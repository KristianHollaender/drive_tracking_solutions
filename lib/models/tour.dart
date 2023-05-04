import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_tracking_solutions/models/pause.dart';

class TourKeys {
  static const uid = 'uid';
  static const startPoint = 'startPoint';
  static const endPoint = 'endPoint';
  static const pause = 'pause';
  static const startTime = 'startTime';
  static const endTime = 'endTime';
  static const totalTime = 'totalTime';
}

class Tour {
  final String uid;
  final GeoPoint startPoint;
  final GeoPoint endPoint;
  final Pause? pause;
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime? totalTime;

  Tour(this.uid, this.startPoint, this.endPoint, this.startTime, this.endTime, this.totalTime, this.pause);

  //Getting tour from firebase, then mapping tour to a dart object
  Tour.fromMap(Map<String, dynamic> data)
      :
        uid = data[TourKeys.uid],
        startPoint = data[TourKeys.startPoint],
        endPoint = data[TourKeys.endPoint],
        pause = data[TourKeys.pause],
        startTime = (data[TourKeys.startTime] as Timestamp).toDate(),
        endTime = (data[TourKeys.endTime] as Timestamp).toDate(),
        totalTime = (data[TourKeys.totalTime] as Timestamp).toDate();

  //Mapping dart object to json object
  Map<String, dynamic> toMap(){
    return {
      TourKeys.uid: uid,
      TourKeys.startPoint: startPoint,
      TourKeys.endPoint: endPoint,
      TourKeys.pause: pause,
      TourKeys.startTime: startTime,
      TourKeys.endTime: endTime,
      TourKeys.totalTime: totalTime
    };
  }
}
