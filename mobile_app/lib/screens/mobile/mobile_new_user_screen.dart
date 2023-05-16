import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:drive_tracking_solutions/logic/fire_service.dart';
import 'package:drive_tracking_solutions/screens/mobile/mobile_login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
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
          child: _image == null
              ? const Text('No image selected.')
              : Image.file(_image!, height: 300, fit: BoxFit.cover),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            pickImageBtn(),
            createUserBtn(context),
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

  ElevatedButton pickImageBtn() {
    return ElevatedButton(
      onPressed: () {
        pickImage();
      },
      child: const Text('Select Image'),
    );
  }

  ElevatedButton createUserBtn(BuildContext context) {
    final fireService = Provider.of<FirebaseService>(context);
    return ElevatedButton(
      child: const Text('Create new account'),
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
      decoration: const InputDecoration(label: Text('First Name')),
      validator: (value) => (value == null) ? 'First name required' : null,
    );
  }

  Widget lastNameInput() {
    return TextFormField(
      keyboardType: TextInputType.name,
      controller: _lastName,
      decoration: const InputDecoration(label: Text('Last Name')),
      validator: (value) => (value == null) ? 'Last name required' : null,
    );
  }

  Widget emailInput() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: _email,
      decoration: const InputDecoration(label: Text('Email')),
      validator: (value) =>
          (value == null || !value.contains("@")) ? 'Email required' : null,
    );
  }

  Widget passwordInput() {
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
