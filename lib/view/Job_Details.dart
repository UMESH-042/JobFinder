import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class JobDetailsPage extends StatefulWidget {
  final String documentId; // Add document ID parameter
  final String location;
  final String salary;
  final String category;
  final String? image;
  final String jobtype;
  final String description;
  final String requirements;
  final String postedby;
  final int noOfApplicants;
  final String CompanyName;

  const JobDetailsPage({
    required this.location,
    required this.salary,
    required this.category,
    required this.jobtype,
    this.image,
    required this.description,
    required this.requirements,
    required this.postedby,
    required this.noOfApplicants,
    required this.documentId, required this.CompanyName,
  });

  @override
  State<JobDetailsPage> createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  bool _isLoading = false;
  int _currentApplicants = 0;

  @override
  void initState() {
    super.initState();
    _currentApplicants = widget.noOfApplicants;
  }

  String ChatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  Future<void> sendMessageToPostedByUser(String currentUserEmail) async {
    try {
      final DocumentReference jobDetailsRef =
          FirebaseFirestore.instance.collection('jobs').doc(widget.documentId);

      await jobDetailsRef.update({'NoOfApplicants': FieldValue.increment(1)});

      final FirebaseAuth _auth = FirebaseAuth.instance;
      final CollectionReference chatroomCollection =
          FirebaseFirestore.instance.collection('chatroom');

      final chatRoomId = ChatRoomId(currentUserEmail, widget.postedby);

      final chatRoomSnapshot = await chatroomCollection.doc(chatRoomId).get();
      //     if (chatRoomSnapshot.exists) {
      //   // Display snackbar message and return if already applied
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text('You have already applied for this job'),
      //       backgroundColor: Colors.red,
      //     ),
      //   );
      //   return;
      // }
      if (!chatRoomSnapshot.exists) {
        final Map<String, dynamic> chatRoomData = {
          'users': [widget.postedby, currentUserEmail],
          'createdAt': FieldValue.serverTimestamp(),
        };
        await chatroomCollection.doc(chatRoomId).set(chatRoomData);
      }

      final DocumentReference chatRoomRef = chatroomCollection.doc(chatRoomId);

      final Map<String, dynamic> messageData = {
        'sendBy': _auth.currentUser?.displayName,
        'message': 'I am interested in your Company ${widget.CompanyName} to work as ${widget.category} and I am willing to work ${widget.jobtype}',
        'time': FieldValue.serverTimestamp(),
      };

      await chatRoomRef.collection('chats').add(messageData);

      print('Message sent successfully!');
    } catch (e) {
      print('Error sending message: $e');
      throw e;
    }
  }
  Future<void> storeAppliedJob() async {
  try {
    String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
    final appliedJobsRef = FirebaseFirestore.instance.collection('applied_jobs');

    await appliedJobsRef.add({
      'user_email': currentUserEmail,
      'job_details': {
        'document_id': widget.documentId,
        'location': widget.location,
        'salary': widget.salary,
        'category': widget.category,
        'image': widget.image,
        'jobtype': widget.jobtype,
        'description': widget.description,
        'requirements': widget.requirements,
        'postedby': widget.postedby,
        'noOfApplicants': widget.noOfApplicants,
        'CompanyName': widget.CompanyName,
      },
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Successfully applied for the job.'),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to apply for the job. Please try again.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}


  Widget button(BuildContext context) {
    return InkWell(
      onTap: () async{
        String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
        setState(() {
          _isLoading = true;
        });

  await storeAppliedJob();
        
        sendMessageToPostedByUser(currentUserEmail).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Successfully Applied'),
              backgroundColor: Colors.green,
            ),
          );
          setState(() {
            _currentApplicants++; // Increase the value by one
          });
          Navigator.pop(context);
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Application Failed'),
              backgroundColor: Colors.red,
            ),
          );
        }).whenComplete(() {
          setState(() {
            _isLoading = false;
          });
        });
      },
      child: Container(
        margin: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        height: 55,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 76, 175, 142),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: _isLoading
              ? SpinKitCircle(
                  color: Colors.white,
                  size: 25.0,
                )
              : Text(
                  "Apply for Job",
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              color: Colors.black,
              child: widget.image != null
                  ? Image.network(
                      widget.image!,
                      fit: BoxFit.cover,
                      width: 200,
                      height: 200,
                    )
                  : null,
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.category,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.jobtype,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Company Name',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.CompanyName,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Requirements',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.requirements,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.location,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Posted By',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.postedby,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Salary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$${widget.salary}/m',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 16),
                  button(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
