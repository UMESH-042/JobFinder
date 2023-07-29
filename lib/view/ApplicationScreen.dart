import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:velocity_x/velocity_x.dart';

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
  String? _cvFileName;
  bool _isSubmitting = false;

  Future<void> _pickCVFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        _cvFile = File(result.files.single.path!);
        _cvFileName = _cvFile?.path.split('/').last;
      });
    }
  }

  Future<String?> _uploadCVFile() async {
    if (_cvFile != null) {
      try {
        String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
        String fileName =
            'cv_$currentUserEmail.pdf'; // You can customize the file name here.
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
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _messageController.text.isEmpty ||
        _cvFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all the fields and upload a CV.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() {
      _isSubmitting = true;
    });
    try {
      String firstName = _firstNameController.text;
      String lastName = _lastNameController.text;
      String email = _emailController.text;
      String message = _messageController.text;
      String postedByEmail = widget.postedByEmail;
      String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;

  //     String? cvUrl = await _uploadCVFile();

  //     if (cvUrl == null) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Failed to upload CV. Please try again.'),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //       return;
  //     }

  //     final applicantsCollection =
  //         FirebaseFirestore.instance.collection('applicants');
  //     await applicantsCollection.add({
  //       'job_document_id': widget.documentId,
  //       'posted_by_email': postedByEmail,
  //       'applicant_email': currentUserEmail,
  //       'first_name': firstName,
  //       'last_name': lastName,
  //       'email': email,
  //       'message': message,
  //       'cv_url':
  //           cvUrl, // Storing the CV URL along with other applicant details.
  //       'timestamp': FieldValue.serverTimestamp(),
  //     });

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Successfully applied for the job.'),
  //         backgroundColor: Colors.green,
  //       ),
  //     );

  //     Navigator.pop(context, true);
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Failed to apply for the job. Please try again.'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   } finally {
  //     setState(() {
  //       _isSubmitting = false;
  //     });
  //   }
  // }
  
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

    // Use batch writes to upload multiple fields in a single operation
    WriteBatch batch = FirebaseFirestore.instance.batch();
    final applicantsCollection = FirebaseFirestore.instance.collection('applicants');
    DocumentReference applicantRef = applicantsCollection.doc();

    batch.set(applicantRef, {
      'job_document_id': widget.documentId,
      'posted_by_email': postedByEmail,
      'applicant_email': currentUserEmail,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'message': message,
      'cv_url': cvUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Commit the batch write
    await batch.commit();

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
  } finally {
    setState(() {
      _isSubmitting = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apply for Job'),
        backgroundColor: Color.fromARGB(255, 76, 175, 142),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            label("First Name"),
            SizedBox(height: 10),
            firstname(),
            SizedBox(height: 20),
            label("Last Name"),
            SizedBox(height: 10),
            lastname(),
            SizedBox(height: 20),
            label("Email"),
            SizedBox(height: 10),
            useremail(),
            SizedBox(height: 20),
            label("Message"),
            SizedBox(height: 10),
            message(),
            SizedBox(height: 20),
            cvUploadField(),
            SizedBox(height: 20),
            _isSubmitting ? _buildSubmittingIndicator() : button(),
          ],
        ),
      ),
    );
  }

  Widget firstname() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 56, 47, 47),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _firstNameController,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 17,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "First Name",
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 17),
          contentPadding: EdgeInsets.only(left: 20, right: 20),
        ),
      ),
    );
  }

  Widget lastname() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 56, 47, 47),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _lastNameController,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 17,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Last Name",
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 17),
          contentPadding: EdgeInsets.only(left: 20, right: 20),
        ),
      ),
    );
  }

  Widget useremail() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 56, 47, 47),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 17,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "User Email",
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 17),
          contentPadding: EdgeInsets.only(left: 20, right: 20),
        ),
      ),
    );
  }

  Widget message() {
    return Container(
      height: 155,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 56, 47, 47),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _messageController,
        maxLines: null,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 17,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Message to Recruiter",
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 17),
          contentPadding: EdgeInsets.only(left: 20, right: 20),
        ),
      ),
    ).py12();
  }

  Widget button() {
    return InkWell(
      onTap: () async {
        _submitApplication();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 55,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 76, 175, 142),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            "Apply For Job",
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

  Widget cvUploadField() {
    return GestureDetector(
      onTap: _pickCVFile,
      child: Container(
        height: 55,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 56, 47, 47),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  _cvFileName != null
                      ? 'Selected CV: $_cvFileName'
                      : 'Select CV',
                  style: TextStyle(color: Colors.white70, fontSize: 17),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Icon(Icons.cloud_upload, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmittingIndicator() {
    return SpinKitCircle(
      color: Colors.green, // You can change the color as desired
      size: 50.0,
    );
  }

  Widget label(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.indigo[900]!,
          fontWeight: FontWeight.w600,
          fontSize: 16.5,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
