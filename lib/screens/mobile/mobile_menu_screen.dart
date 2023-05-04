import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_tracking_solutions/fire_service.dart';
import 'package:drive_tracking_solutions/screens/mobile/mobile_login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';

import 'mobile_edit_user_screen.dart';

class MenuScreen extends StatelessWidget {
  MenuScreen({Key? key}) : super(key: key);

  final _auth = FirebaseAuth.instance;
  final _storageRef = FirebaseStorage.instance.ref();
  final _usersCollection =
      FirebaseFirestore.instance.collection(CollectionNames.user);

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
          title: Text('Menu'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 12.0,
            ),
            FutureBuilder<String>(
              future: _getImageUrl(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return CircleAvatar(
                    radius: 65,
                    backgroundImage: NetworkImage(snapshot.data!),
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.transparent,
                  );
                } else if (snapshot.hasError) {
                  return Text('Error loading image');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            Container(
              margin: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FutureBuilder<DocumentSnapshot>(
                    future: _usersCollection.doc(_auth.currentUser!.uid).get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final data =
                            snapshot.data!.data() as Map<String, dynamic>;
                        final firstName = data['firstname'] as String;
                        final lastName = data['lastname'] as String;
                        return Text(
                          '$firstName $lastName',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error loading user data');
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                  Text(
                    "${_auth.currentUser?.email}",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _editUserBtn(context),
                  _logoutBtn(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _editUserBtn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MobileEditUserScreen(),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
          child: Text(
            'Edit info',
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
      ),
    );
  }

  Widget _logoutBtn(BuildContext context) {
    final fireService = Provider.of<FirebaseService>(context);
    return ElevatedButton(
      onPressed: () async {
        await fireService.signOut().then((_) => {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MobileLoginScreen(),
                ),
              ),
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: Text(
          'Log out',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
    );
  }
}
