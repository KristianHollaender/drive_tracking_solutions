import firebase from "firebase/compat";
import Timestamp = firebase.firestore.Timestamp;

export interface Pause{
  pauseId: string,
  startTime: Timestamp,
  endTime: Timestamp,
  totalTime: string,
}
