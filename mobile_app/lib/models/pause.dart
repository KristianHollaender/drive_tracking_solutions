import 'package:cloud_firestore/cloud_firestore.dart';

class PauseKeys {
  static const pauseId = 'pauseId';
  static const startTime = 'startTime';
  static const endTime = 'endTime';
  static const totalTime = 'totalTime';
}

class Pause {
  final String pauseId;
  final DateTime startTime;
  final DateTime endTime;
  final String? totalTime;

  Pause(this.pauseId, this.startTime, this.endTime, this.totalTime);

  // Getting pause from firebase, then mapping pause to a dart object
  Pause.fromMap(Map<String, dynamic> data)
      : pauseId = data[PauseKeys.pauseId],
        startTime = (data[PauseKeys.startTime] as Timestamp).toDate(),
        endTime = (data[PauseKeys.endTime] as Timestamp).toDate(),
        totalTime = data[PauseKeys.totalTime];

  // Mapping dart object to json object
  Map<String, dynamic> toMap() {
    return {
      PauseKeys.pauseId: pauseId,
      PauseKeys.startTime: startTime,
      PauseKeys.endTime: endTime,
      PauseKeys.totalTime: totalTime,
    };
  }
}
