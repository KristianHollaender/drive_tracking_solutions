import 'package:cloud_firestore/cloud_firestore.dart';

class PauseKeys{
  static const startTime = 'startTime';
  static const endTime = 'endTime';
}

class Pause{
  final DateTime startTime;
  final DateTime endTime;

  Pause(this.startTime, this.endTime);

  //Getting pause from firebase, then mapping pause to a dart object
  Pause.fromMap(Map<String, dynamic> data)
      : startTime = (data[PauseKeys.startTime] as Timestamp).toDate(),
       endTime = (data[PauseKeys.endTime] as Timestamp).toDate();

  //Mapping dart object to json object
  Map<String, dynamic> toMap(){
    return {
      PauseKeys.startTime: startTime,
      PauseKeys.endTime: endTime,
    };
  }
}