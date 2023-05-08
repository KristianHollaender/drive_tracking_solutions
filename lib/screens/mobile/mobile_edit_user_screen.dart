import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_tracking_solutions/screens/mobile/mobile_login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// TODO THIS DOESN'T WORK - REQUIRES A LOT OF WORK STILL.
// TODO THIS DOESN'T WORK - REQUIRES A LOT OF WORK STILL.
// TODO THIS DOESN'T WORK - REQUIRES A LOT OF WORK STILL.
// TODO THIS DOESN'T WORK - REQUIRES A LOT OF WORK STILL.
// TODO THIS DOESN'T WORK - REQUIRES A LOT OF WORK STILL.
// TODO THIS DOESN'T WORK - REQUIRES A LOT OF WORK STILL.


class MobileEditUserScreen extends StatefulWidget {
  const MobileEditUserScreen({super.key});

  @override
  State<MobileEditUserScreen> createState() => _MobileEditUserScreenState();
}

class _MobileEditUserScreenState extends State<MobileEditUserScreen> {
  final _email = TextEditingController();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc =
      await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();
      final userData = userDoc.data() as Map<String, dynamic>;
      setState(() {
        _email.text = userData['email'] ?? '';
        _firstName.text = userData['firstname'] ?? '';
        _lastName.text = userData['lastname'] ?? '';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit profile'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: firstNameInput(),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: lastNameInput(),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: emailInput(),
                  ),
                  Center(
                    child: _image == null ? Text('No image selected.') : Image.file(_image!, height: 300, fit: BoxFit.cover),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      pickImageBtn(),
                      editUserBtn(context),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  ElevatedButton pickImageBtn() {
    return ElevatedButton(
      onPressed: () {
        pickImage();
      },
      child: Text('Select new image'),
    );
  }

  ElevatedButton editUserBtn(BuildContext context) {
    return ElevatedButton(
      child: const Text('Confirm changes'),
      onPressed: () async {
        if (!_formKey.currentState!.validate()) {
          setState(() {});
          return;
        }
        final firstName = _firstName.value.text;
        final lastName = _lastName.value.text;
        final email = _email.value.text;

        final user = _auth.currentUser;
        if (user != null) {
          final userDoc =
          await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();
          await FirebaseFirestore.instance.collection('Users').doc(userDoc as String?).set({
            'uid': _auth.currentUser?.uid,
            'email': email,
            'firstname': firstName,
            'lastname': lastName,
          });
        }


        if (_image != null) {
          final fileName = _auth.currentUser?.uid;
          final firebaseStorageRef = FirebaseStorage.instance
              .ref()
              .child('profile_images')
              .child(fileName!);
          firebaseStorageRef.putFile(_image!);
        }
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => MobileLoginScreen(),
          ),
        );
      },
    );
  }

  TextFormField firstNameInput() {
    return TextFormField(
      keyboardType: TextInputType.name,
      controller: _firstName,
      validator: (value) => (value == null) ? 'First name required' : null,
    );
  }

  TextFormField lastNameInput() {
    return TextFormField(
      keyboardType: TextInputType.name,
      controller: _lastName,
      validator: (value) => (value == null) ? 'Last name required' : null,
    );
  }

  TextFormField emailInput() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: _email,
      validator: (value) =>
      (value == null || !value.contains("@")) ? 'Email required' : null,
    );
  }



}
