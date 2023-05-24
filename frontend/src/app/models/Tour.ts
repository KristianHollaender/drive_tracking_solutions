import {CheckPoint} from "./CheckPoint";
import {Pause} from "./Pause";
import firebase from "firebase/compat";
import GeoPoint = firebase.firestore.GeoPoint;

export interface Tour{
  uid: string,
  tourId: string,
  startTime: string,
  endTime: string,
  totalTime: string,
  totalPauseTime: string,
  startPoint: GeoPoint,
  endPoint: GeoPoint,
  note: string,
  pause: Pause,
  checkPoint: CheckPoint,
}
