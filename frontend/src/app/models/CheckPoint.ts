import firebase from "firebase/compat";
import GeoPoint = firebase.firestore.GeoPoint;

export interface CheckPoint {
  truckStop: GeoPoint,
}
