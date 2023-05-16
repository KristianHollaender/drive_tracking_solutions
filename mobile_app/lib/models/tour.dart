import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_tracking_solutions/logic/fire_service.dart';
import 'package:drive_tracking_solutions/models/check_point.dart';
import 'package:drive_tracking_solutions/models/pause.dart';

class TourKeys {
  static const tourId = 'tourId';
  static const uid = 'uid';
  static const startPoint = 'startPoint';
  static const endPoint = 'endPoint';
  static const startTime = 'startTime';
  static const endTime = 'endTime';
  static const totalTime = 'totalTime';
  static const note = 'note';
}

class Tour {
  final String tourId;
  final String uid;
  final GeoPoint startPoint;
  final GeoPoint endPoint;
  final Pause? pause;
  final CheckPoint? checkPoint;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? totalTime;
  final String? note;

  Tour(this.tourId, this.uid, this.startPoint, this.pause, this.checkPoint,
      this.endPoint, this.startTime, this.endTime, this.totalTime, this.note);

  //Getting tour from firebase, then mapping tour to a dart object
  Tour.fromMap(Map<String, dynamic> data)
      : tourId = data[TourKeys.tourId],
        uid = data[TourKeys.uid],
        startPoint = data[TourKeys.startPoint],
        endPoint = data[TourKeys.endPoint],
        pause = data[CollectionNames.pause],
        checkPoint = data[CollectionNames.checkPoint],
        startTime = (data[TourKeys.startTime] as Timestamp).toDate(),
        endTime = (data[TourKeys.endTime] as Timestamp).toDate(),
        totalTime = data[TourKeys.totalTime],
        note = data[TourKeys.note];

  //Mapping dart object to json object
  Map<String, dynamic> toMap() {
    return {
      TourKeys.tourId: tourId,
      TourKeys.uid: uid,
      TourKeys.startPoint: startPoint,
      TourKeys.endPoint: endPoint,
      CollectionNames.pause: pause,
      CollectionNames.checkPoint: checkPoint,
      TourKeys.startTime: startTime,
      TourKeys.endTime: endTime,
      TourKeys.totalTime: totalTime,
      TourKeys.note: note
    };
  }

  String getWeekday(DateTime dateTime) {
    switch (dateTime.weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return '';
    }
  }

  String getMonth(DateTime dateTime) {
    switch (dateTime.month) {
      case DateTime.january:
        return 'January';
      case DateTime.february:
        return 'February';
      case DateTime.march:
        return 'March';
      case DateTime.april:
        return 'April';
      case DateTime.may:
        return 'May';
      case DateTime.june:
        return 'June';
      case DateTime.july:
        return 'July';
      case DateTime.august:
        return 'August';
      case DateTime.september:
        return 'September';
      case DateTime.october:
        return 'October';
      case DateTime.november:
        return 'November';
      case DateTime.december:
        return 'December';
      default:
        return '';
    }
  }
}
