import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_tracking_solutions/logic/fire_service.dart';
import 'package:drive_tracking_solutions/screens/mobile/mobile_login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatelessWidget {
  MenuScreen({Key? key}) : super(key: key);

  final _auth = FirebaseAuth.instance;
  final _storageRef = FirebaseStorage.instance.ref();

  Future<String> _getImageUrl() async {
    final imageRef = _storageRef
        .child('profile_images')
        .child(_auth.currentUser!.uid)
        .getDownloadURL();
    return imageRef;
  }

  @override
  Widget build(BuildContext context) {
    final fireService = Provider.of<FirebaseService>(context);
    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Menu'),
        ),
        body: _buildUserInfoAndBtn(fireService, context),
      ),
    );
  }

  Column _buildUserInfoAndBtn(
      FirebaseService fireService, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(
          height: 12.0,
        ),
        _buildProfilePicture(),
        Container(
          margin: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildUserInfo(fireService),
              _buildUserEmail(),
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _logoutBtn(context),
            ],
          ),
        ),
      ],
    );
  }

  FutureBuilder<DocumentSnapshot<Object?>> _buildUserInfo(
      FirebaseService fireService) {
    return FutureBuilder<DocumentSnapshot>(
      future: fireService.getUserById(_auth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          final firstName = data['firstname'] as String;
          final lastName = data['lastname'] as String;
          return Text(
            '$firstName $lastName',
            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          );
        } else if (snapshot.hasError) {
          return const Text('Error loading user data');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget _buildUserEmail() {
    return Text(
      "${_auth.currentUser?.email}",
      style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
    );
  }

  FutureBuilder<String> _buildProfilePicture() {
    return FutureBuilder<String>(
      future: _getImageUrl(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CircleAvatar(
            radius: 65,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.transparent,
            child: ClipOval(
              child: Image.network(
                snapshot.data!,
                fit: BoxFit.cover,
                width: 130,
                height: 130,
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Text('Error loading image');
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }



  Widget _logoutBtn(BuildContext context) {
    final fireService = Provider.of<FirebaseService>(context);
    return ElevatedButton(
      onPressed: () async {
        await fireService.signOut().then(
              (_) => {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MobileLoginScreen(),
                  ),
                ),
              },
            );
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: Text(
          'Log out',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
