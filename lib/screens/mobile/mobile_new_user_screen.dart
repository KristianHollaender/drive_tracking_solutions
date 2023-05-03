import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_tracking_solutions/screens/mobile/mobile_login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class MobileNewUserScreen extends StatefulWidget {
  const MobileNewUserScreen({super.key});

  @override
  State<MobileNewUserScreen> createState() => _MobileNewUserScreenState();
}

class _MobileNewUserScreenState extends State<MobileNewUserScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  File? _image;
  final picker = ImagePicker();


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Account'),
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
                  Container(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: passwordInput(),
                  ),
                  Center(
                    child: _image == null ? Text('No image selected.') : Image.file(_image!, height: 300, fit: BoxFit.cover),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      pickImageBtn(),
                      createUserBtn(context),
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
      child: Text('Select Image'),
    );
  }

  ElevatedButton createUserBtn(BuildContext context) {
    return ElevatedButton(
      child: const Text('Create new account'),
      onPressed: () async {
        if (!_formKey.currentState!.validate()) {
          setState(() {});
          return;
        }
        final firstName = _firstName.value.text;
        final lastName = _lastName.value.text;
        final email = _email.value.text;
        final password = _password.value.text;
        final userCredential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        final userUid = userCredential.user!.uid;
        await FirebaseFirestore.instance.collection('Users').doc(userUid).set({
          'uid': _auth.currentUser?.uid,
          'email': email,
          'firstname': firstName,
          'lastname': lastName,
        });

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
            builder: (context) => const MobileLoginScreen(),
          ),
        );
      },
    );
  }

  TextFormField firstNameInput() {
    return TextFormField(
      keyboardType: TextInputType.name,
      controller: _firstName,
      decoration: const InputDecoration(label: Text('First Name')),
      validator: (value) => (value == null) ? 'First name required' : null,
    );
  }

  TextFormField lastNameInput() {
    return TextFormField(
      keyboardType: TextInputType.name,
      controller: _lastName,
      decoration: const InputDecoration(label: Text('Last Name')),
      validator: (value) => (value == null) ? 'Last name required' : null,
    );
  }

  TextFormField emailInput() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: _email,
      decoration: const InputDecoration(label: Text('Email')),
      validator: (value) =>
          (value == null || !value.contains("@")) ? 'Email required' : null,
    );
  }

  TextFormField passwordInput() {
    return TextFormField(
      controller: _password,
      decoration: const InputDecoration(label: Text('Password')),
      obscureText: true,
      validator: (value) => (value == null || value.length < 6)
          ? 'Password required (min 6 chars)'
          : null,
    );
  }
}
