// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// class ApplicationFormScreen extends StatefulWidget {
//   final String documentId;
//   final String postedByEmail;

//   ApplicationFormScreen({
//     required this.documentId,
//     required this.postedByEmail,
//   });

//   @override
//   _ApplicationFormScreenState createState() => _ApplicationFormScreenState();
// }

// class _ApplicationFormScreenState extends State<ApplicationFormScreen> {
//   TextEditingController _firstNameController = TextEditingController();
//   TextEditingController _lastNameController = TextEditingController();
//   TextEditingController _emailController = TextEditingController();
//   File? _cvFile;

//   Future<void> _pickCVFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf', 'doc', 'docx'],
//     );

//     if (result != null) {
//       setState(() {
//         _cvFile = File(result.files.single.path!);
//       });
//     }
//   }

//   Future<String?> _uploadCVFile() async {
//     if (_cvFile != null) {
//       try {
//         String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
//         String fileName = 'cv_$currentUserEmail.pdf'; // You can customize the file name here.
//         Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
//         UploadTask uploadTask = storageRef.putFile(_cvFile!);
//         TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
//         return await taskSnapshot.ref.getDownloadURL();
//       } catch (e) {
//         print('Error uploading CV: $e');
//         return null;
//       }
//     }
//     return null;
//   }

//   void _submitApplication() async {
//     try {
//       String firstName = _firstNameController.text;
//       String lastName = _lastNameController.text;
//       String email = _emailController.text;
//       String postedByEmail = widget.postedByEmail;
//       String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;

//       String? cvUrl = await _uploadCVFile();

//       if (cvUrl == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to upload CV. Please try again.'),
//             backgroundColor: Colors.red,
//           ),
//         );
//         return;
//       }

//       final applicantsCollection = FirebaseFirestore.instance.collection('applicants');
//       await applicantsCollection.add({
//         'job_document_id': widget.documentId,
//         'posted_by_email': postedByEmail,
//         'applicant_email': currentUserEmail,
//         'first_name': firstName,
//         'last_name': lastName,
//         'email': email,
//         'cv_url': cvUrl, // Storing the CV URL along with other applicant details.
//       });

//       // ScaffoldMessenger.of(context).showSnackBar(
//       //   SnackBar(
//       //     content: Text('Successfully applied for the job.'),
//       //     backgroundColor: Colors.green,
//       //   ),
//       // );

//       // Navigator.pop(context);
//        Navigator.pop(context, true);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to apply for the job. Please try again.'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Apply for Job'),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextFormField(
//               controller: _firstNameController,
//               decoration: InputDecoration(labelText: 'First Name'),
//             ),
//             SizedBox(height: 16),
//             TextFormField(
//               controller: _lastNameController,
//               decoration: InputDecoration(labelText: 'Last Name'),
//             ),
//             SizedBox(height: 16),
//             TextFormField(
//               controller: _emailController,
//               decoration: InputDecoration(labelText: 'User Email'),
//               keyboardType: TextInputType.emailAddress,
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _pickCVFile,
//               child: Text('Upload CV'),
//             ),
//             _cvFile != null
//                 ? Text('Selected CV: ${_cvFile!.path}')
//                 : SizedBox.shrink(),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _submitApplication,
//               child: Text('Submit Application'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ApplicationFormScreen extends StatefulWidget {
  final String documentId;
  final String postedByEmail;

  ApplicationFormScreen({
    required this.documentId,
    required this.postedByEmail,
  });

  @override
  _ApplicationFormScreenState createState() => _ApplicationFormScreenState();
}

class _ApplicationFormScreenState extends State<ApplicationFormScreen> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _messageController = TextEditingController();
  File? _cvFile;

  Future<void> _pickCVFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        _cvFile = File(result.files.single.path!);
      });
    }
  }

  Future<String?> _uploadCVFile() async {
    if (_cvFile != null) {
      try {
        String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
        String fileName = 'cv_$currentUserEmail.pdf'; // You can customize the file name here.
        Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
        UploadTask uploadTask = storageRef.putFile(_cvFile!);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
        return await taskSnapshot.ref.getDownloadURL();
      } catch (e) {
        print('Error uploading CV: $e');
        return null;
      }
    }
    return null;
  }

  void _submitApplication() async {
    try {
      String firstName = _firstNameController.text;
      String lastName = _lastNameController.text;
      String email = _emailController.text;
      String message = _messageController.text;
      String postedByEmail = widget.postedByEmail;
      String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;

      String? cvUrl = await _uploadCVFile();

      if (cvUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload CV. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final applicantsCollection = FirebaseFirestore.instance.collection('applicants');
      await applicantsCollection.add({
        'job_document_id': widget.documentId,
        'posted_by_email': postedByEmail,
        'applicant_email': currentUserEmail,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'message': message,
        'cv_url': cvUrl, // Storing the CV URL along with other applicant details.
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully applied for the job.'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to apply for the job. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apply for Job'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'User Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _messageController,
              decoration: InputDecoration(labelText: 'Message'),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickCVFile,
              child: Text('Upload CV'),
            ),
            _cvFile != null
                ? Text('Selected CV: ${_cvFile!.path}')
                : SizedBox.shrink(),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitApplication,
              child: Text('Submit Application'),
            ),
          ],
        ),
      ),
    );
  }
}
