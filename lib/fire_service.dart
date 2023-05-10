import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_tracking_solutions/models/checkPoint.dart';
import 'package:drive_tracking_solutions/models/pause.dart';
import 'package:drive_tracking_solutions/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'models/tour.dart';

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

  // Get personal tours ordered by start time
  Future<QuerySnapshot> tours(String uid) async {
    return await db
        .collection(CollectionNames.tour)
        .where('uid', isEqualTo: uid)
        .get();
  }

  // Get a single tour
  Future<DocumentSnapshot<Map<String, dynamic>>> tour(String id) async {
    return await db.collection(CollectionNames.tour).doc(id).get();
  }

  // Start the tour
  Future<DocumentSnapshot<Map<String, dynamic>>?> startTour(
      GeoPoint startPoint, DateTime startTime) async {
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
    }).catchError((e) => print(e.toString()));
    return null;
  }

  // Stop the tour
  Future<void> endTour(
      String id, GeoPoint endPoint, DateTime endTime, String totalTime) async {
    await db.collection(CollectionNames.tour).doc(id).update({
      TourKeys.endPoint: endPoint,
      TourKeys.endTime: endTime,
      TourKeys.totalTime: totalTime,
    });
  }

  // Pause the tour
  Future<String?> startPause(String? id, DateTime? pauseStartTime) async {
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
    }).catchError((e) => print(e.toString()));
    return null;
  }

  // Resume the tour
  Future<void> stopPause(String? tourId, String? pauseId, DateTime? pauseEndTime) async {
    await db
        .collection(CollectionNames.tour)
        .doc(tourId)
        .collection(CollectionNames.pause)
        .doc(pauseId)
        .update({
      TourKeys.endTime: pauseEndTime,
    });
  }

  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signUp(
      String email, String password, String firstname, String lastname) async {
    final user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await db.collection(CollectionNames.user).doc(user.user?.uid).set({
      UserKeys.uid: user.user?.uid,
      UserKeys.email: email,
      UserKeys.firstname: firstname,
      UserKeys.lastname: lastname,
    });
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<DocumentSnapshot<Object>>? getUserById(String uid) async {
    try {
      return await db.collection(CollectionNames.user).doc(uid).get();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

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
}
