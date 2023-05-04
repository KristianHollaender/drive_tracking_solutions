import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_tracking_solutions/fire_service.dart';
import 'package:drive_tracking_solutions/models/tour.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';

final _auth = FirebaseAuth.instance;
final fireService = FirebaseService();

final kTours = LinkedHashMap<DateTime, List<Tour>>(
  equals: isSameDay,
  hashCode: getHashCode,
);

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
        (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}
void populateTours() async {
  final snapshot = await fireService.tours(_auth.currentUser!.uid);
  if(snapshot.docs.isEmpty){
    kTours.clear();
  }
  for (final doc in snapshot.docs) {
    final tour = Tour.fromMap(doc.data() as Map<String, dynamic>);
    final date = (doc[TourKeys.startTime] as Timestamp).toDate();
    final key = DateTime.utc(date.year, date.month, date.day);
    if (!kTours.containsKey(key)) {
      kTours[key] = [];
    }
    kTours[key]?.add(tour);
  }
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);