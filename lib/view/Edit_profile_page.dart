import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vuna__gigs/view/Home_Screen.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String _userId = "";
  String _imageUrl = "";
  File? _selectedImage;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          _userId = user.uid;
        });
      }
    });
  }

  Future<void> _selectAndPickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _selectedImage = File(pickedImage.path);
        _uploadImage();
      }
    });
  }

  Future<void> _uploadImage() async {
    try {
      // Show loading indicator
      setState(() {
        _isUpdating = true;
      });

      // Upload image to Firebase Storage
      final storageRef =
          FirebaseStorage.instance.ref().child('profile_images').child(_userId);
      final uploadTask = storageRef.putFile(_selectedImage!);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        _imageUrl = downloadUrl;
      });
    } catch (error) {
      print(error.toString());
    } finally {
      // Hide loading indicator
      setState(() {
        _isUpdating = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    try {
      if (_nameController.text.isEmpty ||
          _usernameController.text.isEmpty ||
          _bioController.text.isEmpty ||
          _emailController.text.isEmpty ||
          _imageUrl.isEmpty) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Error'),
            content: Text('Please fill in all the details.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
        return;
      }

      final userRef =
          FirebaseFirestore.instance.collection('users').doc(_userId);

      final updatedData = {
        'name': _nameController.text,
        'username': _usernameController.text,
        'bio': _bioController.text,
        'email': _emailController.text,
        'imageUrl': _imageUrl,
      };

      await userRef.update(updatedData);

      // Show success dialog
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Success'),
          content: Text('Profile updated successfully!'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomePage(
                      currentUserEmail: _emailController.text,
                      requiresProfileSetup: false,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred while updating the profile.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  Widget customButton(BuildContext context) {
    return InkWell(
      onTap: _isUpdating ? null : _updateProfile,
      child: Container(
        margin: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        height: 55,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 76, 175, 142),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: _isUpdating
              ? SpinKitCircle(
                  color: Colors.white,
                  size: 25.0,
                )
              : Text(
                  "Update Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Color.fromARGB(255, 76, 175, 142),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _selectAndPickImage,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey,
                    width: 2.0,
                  ),
                  image: DecorationImage(
                    image: _selectedImage != null
                        ? FileImage(_selectedImage!) // Specify the type as FileImage
                        : NetworkImage(_imageUrl) as ImageProvider<Object>, // Explicitly cast as ImageProvider<Object>
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _bioController,
              decoration: InputDecoration(
                labelText: 'Bio',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 16),
            customButton(context),
          ],
        ),
      ),
    );
  }
}
