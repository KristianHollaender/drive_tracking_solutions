import 'dart:io';

import 'package:drive_tracking_solutions/logic/fire_service.dart';
import 'package:drive_tracking_solutions/screens/mobile/mobile_login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

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
              child: _buildUserForm(context),
            ),
          ),
        ),
      ),
    );
  }

  Column _buildUserForm(BuildContext context) {
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
        const SizedBox(height: 16),
        Container(
          width: MediaQuery.of(context).size.width * 0.95,
          padding: const EdgeInsets.only(bottom: 16),
          child: firstNameInput(),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.95,
          padding: const EdgeInsets.only(bottom: 16),
          child: lastNameInput(),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.95,
          padding: const EdgeInsets.only(bottom: 16),
          child: emailInput(),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.95,
          padding: const EdgeInsets.only(bottom: 16),
          child: passwordInput(),
        ),
        Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: _image == null
                        ? const Text('No image selected.')
                        : Image.file(_image!,
                            height: MediaQuery.of(context).size.height * 0.20,
                            width: MediaQuery.of(context).size.width * 0.35,
                            fit: BoxFit.cover),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                pickImageBtn(),
                createUserBtn(context),
              ],
            )
          ],
        )
      ],
    );
  }

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Get the temporary directory path
      final directory = await getTemporaryDirectory();
      final targetPath = path.join(directory.path, 'compressed_image.jpg');

      // Compress and resize the image
      await FlutterImageCompress.compressAndGetFile(
        pickedFile.path,
        targetPath,
        quality: 70, // Adjust the quality as desired (0 - 100)
        minHeight: 500, // Set the minimum height
        minWidth: 500, // Set the minimum width
      );

      setState(() {
        _image = File(targetPath);
      });
    } else {
      throw Exception();
    }
  }

  Widget pickImageBtn() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.45,
        child: FloatingActionButton.extended(
          heroTag: 'selectImgBtn',
          onPressed: () {
            pickImage();
          },
          icon: Icon(Icons.edit),
          label: const Text('Select Image'),
          backgroundColor: Color(0xff26752b),
        ),
      ),
    );
  }

  Widget createUserBtn(BuildContext context) {
    final fireService = Provider.of<FirebaseService>(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.45,
        child: FloatingActionButton.extended(
          heroTag: 'createAccountBtn',
          backgroundColor: Color(0xff26752b),
          label: const Text('Create Account'),
          onPressed: () async {
            if (!_formKey.currentState!.validate()) {
              setState(() {});
              return;
            }
            final firstname = _firstName.value.text.trim();
            final lastname = _lastName.value.text.trim();
            final email = _email.value.text.trim();
            final password = _password.value.text.trim();

            await fireService.signUp(email, password, firstname, lastname).then(
                  (value) => {
                    SystemChannels.textInput.invokeListMethod('TextInput.hide'),
                  },
                );

            if (_image != null) {
              final fileName = _auth.currentUser?.uid;
              final firebaseStorageRef = FirebaseStorage.instance
                  .ref()
                  .child('profile_images')
                  .child(fileName!);
              firebaseStorageRef.putFile(_image!);
            }

            _showSuccessSnackBar();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => MobileLoginScreen(),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account created successfully.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget firstNameInput() {
    return TextFormField(
      keyboardType: TextInputType.name,
      controller: _firstName,
      style: const TextStyle(fontSize: 18),
      decoration: const InputDecoration(
        labelText: 'First Name',
        labelStyle: TextStyle(fontSize: 20, color: Colors.white),
        prefixIcon: Icon(Icons.person, size: 28),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.0),
        ),
      ),
      validator: (value) => (value == null) ? 'First name required' : null,
    );
  }

  Widget lastNameInput() {
    return TextFormField(
      keyboardType: TextInputType.name,
      controller: _lastName,
      style: const TextStyle(fontSize: 18),
      decoration: const InputDecoration(
        labelText: 'Last name',
        labelStyle: TextStyle(fontSize: 20, color: Colors.white),
        prefixIcon: Icon(Icons.person, size: 28),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.0),
        ),
      ),
      validator: (value) => (value == null) ? 'Last name required' : null,
    );
  }

  Widget emailInput() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: _email,
      style: const TextStyle(fontSize: 18),
      decoration: const InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(fontSize: 20, color: Colors.white),
        prefixIcon: Icon(Icons.email, size: 28),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.0),
        ),
      ),
      validator: (value) =>
          (value == null || !value.contains("@")) ? 'Email required' : null,
    );
  }

  Widget passwordInput() {
    return TextFormField(
      controller: _password,
      style: const TextStyle(fontSize: 18),
      decoration: const InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(fontSize: 20, color: Colors.white),
        prefixIcon: Icon(Icons.lock, size: 28),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.0),
        ),
      ),
      obscureText: true,
      validator: (value) => (value == null || value.length < 6)
          ? 'Password required (min 6 chars)'
          : null,
    );
  }
}
