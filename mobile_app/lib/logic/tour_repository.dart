import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';

class TourRepository {
  final baseUrl =
      'https://us-central1-drivetrackingsolution.cloudfunctions.net/api';

  // Get total time on tour
  Future<String> getTotalTourTime(String tourId) async {
    final token = await getToken();
    print('-------------------');
    print(token);
    final header = {
      'Authorization': 'Bearer $token'
    };
    Response response = await get(Uri.parse('$baseUrl/tour/totalTourTime/$tourId'));
    if(response.statusCode == 200){
      final totalTime = jsonDecode(response.body)['totalTime'];
      return totalTime;
    }else{
      throw Exception(jsonDecode(response.body));
    }
  }

  // Get total pause time on pause
  Future<String> getTotalPauseTimeOnPause(String tourId, String pauseId) async {
    final token = await getToken();
    print('-------------------');
    print(token);
    final header = {
      'Authorization': 'Bearer $token'
    };
    Response response = await get(
        Uri.parse('$baseUrl/pause/totalTime/$tourId/$pauseId'));
    if (response.statusCode == 200) {
      final totalTime = jsonDecode(response.body)['totalTime'];
      return totalTime;
    } else {
      throw Exception(jsonDecode(response.body));
    }
  }

  // Get total pause time on tour
  Future<String> getTotalPauseTimeOnTour(String tourId) async {
    final token = await getToken();
    print('-------------------');
    print(token);
    final header = {
      'Authorization': 'Bearer $token'
    };
    Response response = await get(
        Uri.parse('$baseUrl/tour/totalPauseTime/$tourId'));
    if (response.statusCode == 200) {
      final totalTime = jsonDecode(response.body)['totalTime'];
      return totalTime;
    } else {
      throw Exception(jsonDecode(response.body));
    }
  }

  Future<String?> getToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // User is not signed in
      return null;
    }else{
      final token = await user.getIdToken();
      return token;
    }
  }
}
