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
      : startTime = data[PauseKeys.startTime],
       endTime = data[PauseKeys.endTime];

  //Mapping dart object to json object
  Map<String, dynamic> toMap(){
    return {
      PauseKeys.startTime: startTime,
      PauseKeys.endTime: endTime,
    };
  }
}