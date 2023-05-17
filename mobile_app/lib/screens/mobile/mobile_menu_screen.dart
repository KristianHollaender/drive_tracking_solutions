import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_tracking_solutions/logic/fire_service.dart';
import 'package:drive_tracking_solutions/screens/mobile/mobile_login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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
          child: Center(
              child: Text(
            "User Information",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          )),
          height: 45.0,
        ),
        _buildProfilePicture(),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildUserInfo(fireService),
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _logoutBtn(context),
              _buildAboutUs(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutUs(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            child: Image.asset(
              'assets/Logo-lighter.png',
              width: MediaQuery.of(context).size.width * 0.75,
            ),
            height: MediaQuery.of(context).size.height * 0.25,
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
          return SizedBox(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white),
                    color: const Color(0x77AEBEAE)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(
                              left: 16.0, top: 8.0, bottom: 8.0, right: 16.0),
                          child: Icon(
                            Icons.person,
                            size: 30.0,
                            color: Color(0xff70c776),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15.0,
                            top: 8.0,
                            bottom: 8.0,
                          ),
                          child: Text(
                            "First name:  $firstName",
                            style: const TextStyle(fontSize: 20.0),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(
                              left: 16.0, top: 8.0, bottom: 8.0, right: 16.0),
                          child: Icon(Icons.person,
                              size: 30.0, color: Color(0xff70c776)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15.0,
                            top: 8.0,
                            bottom: 8.0,
                          ),
                          child: Text(
                            "Last name:  $lastName",
                            style: const TextStyle(fontSize: 20.0),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(
                              left: 16.0, top: 8.0, bottom: 8.0, right: 16.0),
                          child: Icon(Icons.email_outlined,
                              size: 30.0, color: Color(0xff70c776)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15.0,
                            top: 8.0,
                            bottom: 8.0,
                          ),
                          child: Text(
                            "Email:  ${_auth.currentUser?.email}",
                            style: const TextStyle(fontSize: 20.0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Text('Error loading user data');
        } else {
          return const CircularProgressIndicator();
        }
      },
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
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 32.0, right: 16.0),
      child: SizedBox(
        width: double.infinity,
        child: FloatingActionButton.extended(
          backgroundColor: const Color(0xff26752b),
          icon: const Icon(Icons.logout_outlined, size: 35.0),
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
          label: const Text(
            "Log out",
            style: TextStyle(fontSize: 20.0),
          ),
        ),
      ),
    );
  }
}
