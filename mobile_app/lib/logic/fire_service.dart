import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_tracking_solutions/models/check_point.dart';
import 'package:drive_tracking_solutions/models/pause.dart';
import 'package:drive_tracking_solutions/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/tour.dart';

class CollectionNames {
  static const user = 'User';
  static const tour = 'Tour';
  static const pause = 'Pause';
  static const checkPoint = 'CheckPoint';
}

class FirebaseService {
  final _auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  String? tourId;
  String? pauseId;

  //#region Tour
  // Create
  Future<DocumentSnapshot<Map<String, dynamic>>?> startTour(
      GeoPoint startPoint, DateTime startTime) async {
    try {
      await db.collection(CollectionNames.tour).add({
        TourKeys.uid: _auth.currentUser?.uid,
        TourKeys.startPoint: startPoint,
        TourKeys.startTime: startTime,
      }).then((value) async {
        await db.collection(CollectionNames.tour).doc(value.id).update({
          TourKeys.tourId: value.id,
        });
        DocumentSnapshot tourDoc =
            await db.collection(CollectionNames.tour).doc(value.id).get();
        tourId = tourDoc.id;
        return tourId;
      });
    } catch (e) {
      throw Exception(e.toString());
    }
    return null;
  }

  // Read
  Stream<DocumentSnapshot<Map<String, dynamic>>> getTourSnapshotStream(
      String tourId) {
    try {
      return db.collection(CollectionNames.tour).doc(tourId).snapshots();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<QuerySnapshot> getAllTours(String uid) async {
    try {
      return await db
          .collection(CollectionNames.tour)
          .where('uid', isEqualTo: uid)
          .get();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getTourByID(
      String tourId) async {
    try {
      return await db.collection(CollectionNames.tour).doc(tourId).get();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Update
  Future<void> endTour(
      String id, GeoPoint endPoint, DateTime endTime, String totalTime) async {
    try {
      await db.collection(CollectionNames.tour).doc(id).update({
        TourKeys.endPoint: endPoint,
        TourKeys.endTime: endTime,
        TourKeys.totalTime: totalTime,
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> addNote(String id, String note) async {
    try {
      await db.collection(CollectionNames.tour).doc(id).update({
        TourKeys.note: note,
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //#endregion

  //#region Pause
  // Create
  Future<String?> startPause(String? id, DateTime? pauseStartTime) async {
    try {
      await db
          .collection(CollectionNames.tour)
          .doc(id)
          .collection(CollectionNames.pause)
          .add({TourKeys.startTime: pauseStartTime}).then((value) async {
        await db
            .collection(CollectionNames.tour)
            .doc(id)
            .collection(CollectionNames.pause)
            .doc(value.id)
            .update({
          PauseKeys.pauseId: value.id,
        });
        DocumentSnapshot pauseDoc = await db
            .collection(CollectionNames.tour)
            .doc(id)
            .collection(CollectionNames.pause)
            .doc(value.id)
            .get();
        pauseId = pauseDoc.id;
        return pauseId;
      });
    } catch (e) {
      throw Exception(e.toString());
    }
    return null;
  }

  // Read
  Future<QuerySnapshot> getPauseFromTour(String id) async {
    try {
      return await db
          .collection(CollectionNames.tour)
          .doc(id)
          .collection(CollectionNames.pause)
          .get();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Update
  Future<void> stopPause(
      String? tourId, String? pauseId, DateTime? pauseEndTime) async {
    try {
      await db
          .collection(CollectionNames.tour)
          .doc(tourId)
          .collection(CollectionNames.pause)
          .doc(pauseId)
          .update({
        TourKeys.endTime: pauseEndTime,
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //#endregion

  //#region User
  Future<void> signUp(
      String email, String password, String firstname, String lastname) async {
    try {
      final user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await db.collection(CollectionNames.user).doc(user.user?.uid).set({
        UserKeys.uid: user.user?.uid,
        UserKeys.email: email,
        UserKeys.firstname: firstname,
        UserKeys.lastname: lastname,
        UserKeys.role: 'User',
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<DocumentSnapshot<Object>>? getUserById(String uid) async {
    try {
      return await db.collection(CollectionNames.user).doc(uid).get();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //#endregion

  //#region CheckPoint
  // Create
  Future<void> addCheckpoint(String id, GeoPoint truckStop) async {
    try {
      await db
          .collection(CollectionNames.tour)
          .doc(id)
          .collection(CollectionNames.checkPoint)
          .add({
        CheckPointKeys.truckStop: truckStop,
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Read
  Future<QuerySnapshot> getCheckPointFromTour(String id) async {
    try {
      return await db
          .collection(CollectionNames.tour)
          .doc(id)
          .collection(CollectionNames.checkPoint)
          .get();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
//#endregion
}
