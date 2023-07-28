import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vuna__gigs/admin/UserAdminChatRoom.dart';
import 'package:timeago/timeago.dart' as timeago;

class ApplicantsListScreen extends StatelessWidget {
  final String postedByEmail;

  ApplicantsListScreen({required this.postedByEmail});

confirmDeleteDialog(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Confirm Delete',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Do you really want to delete this applicant?',
          style: TextStyle(fontSize: 16),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    },
  );
}

  void deleteApplicant(String applicantId) {
    try {
      FirebaseFirestore.instance
          .collection('applicants')
          .doc(applicantId)
          .delete()
          .then((_) {
        print("Applicant with ID $applicantId deleted successfully.");
      }).catchError((error) {
        print("Error deleting applicant: $error");
      });
    } catch (e) {
      print("An error occurred while deleting the applicant: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 76, 175, 142),
        title: Text('Applicants List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('applicants').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error fetching applicants data');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          List<QueryDocumentSnapshot> applicantsData = snapshot.data!.docs;

          // Filter applicants whose email matches postedByEmail
          List<QueryDocumentSnapshot> filteredApplicants = applicantsData
              .where(
                (applicant) =>
                    applicant.get('posted_by_email') == postedByEmail,
              )
              .toList();

          if (filteredApplicants.isEmpty) {
            return Center(child: Text('No applicants found'));
          }
          filteredApplicants.sort((a, b) {
            final timestampA = a['timestamp'] as Timestamp;
            final timestampB = b['timestamp'] as Timestamp;
            return timestampB.compareTo(
                timestampA); // Reverse the order for most recent first
          });
          return ListView.builder(
            itemCount: filteredApplicants.length,
            itemBuilder: (context, index) {
              final applicant = filteredApplicants[index];
              final applicantData = applicant.data() as Map<String, dynamic>;
              final timestamp = applicantData['timestamp'] as Timestamp;
              final timeAgo = timeago.format(
                  timestamp.toDate()); // Calculate time ago from timestamp
              final first_name = applicantData['first_name'];
              final last_name = applicantData['last_name'];
              final email = applicantData['email'];
              final applicant_email = applicantData['applicant_email'];
              final cv_url = applicantData['cv_url'];
              final message = applicantData['message'];
              final job_document_id = applicantData['job_document_id'];
              print(first_name);
              print(last_name);
              print(email);
              print(message);
              print(cv_url);

              
              return Dismissible(
                  key: Key(applicant.id),
                  background: Container(
                    color: Colors.red,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  direction: DismissDirection.startToEnd,
                  confirmDismiss: (direction) async {
                    return await confirmDeleteDialog(context);
                  },
                  onDismissed: (direction) {
                    if (direction == DismissDirection.startToEnd) {
                      deleteApplicant(applicant.id);
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 4,
                      child: ListTile(
                        onTap: () async {
                          final jobSnapshot = await FirebaseFirestore.instance
                              .collection('jobs')
                              .doc(job_document_id)
                              .get();
                          final jobData =
                              jobSnapshot.data() as Map<String, dynamic>;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ApplicantDetailsScreen(
                                firstName: first_name,
                                lastName: last_name,
                                email: email,
                                message: message,
                                jobDetails:
                                    jobData, // Pass job details to the ApplicantDetailsScreen
                                // Pass any other relevant data fields here
                              ),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Text(
                            '${first_name[0]}${last_name[0]}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          '$first_name $last_name',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              email,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.access_time),
                                SizedBox(width: 4),
                                Text(
                                  'Applied $timeAgo',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () async {
                                String cvUrl = applicantData['cv_url'];
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PdfViewer(PdfUrl: cvUrl)));
                              },
                              icon: Icon(Icons.picture_as_pdf),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ));
            },
          );
        },
      ),
    );
  }
}

class PDFViewerScreen extends StatelessWidget {
  final String pdfUrl;

  PDFViewerScreen({required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View CV'),
      ),
      body: PDFView(
        filePath: pdfUrl,
      ),
    );
  }
}

class ApplicantDetailsScreen extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String message;
  final Map<String, dynamic> jobDetails; // Add jobDetails field

  ApplicantDetailsScreen({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.message,
    required this.jobDetails, // Initialize jobDetails
  });

  @override
  Widget build(BuildContext context) {
    final category = jobDetails['category'];
    final companyDetails = jobDetails['companyDetails'];
    final jobSalary = jobDetails['salary'];
    final jobLocation = jobDetails['location'];
    final jobType = jobDetails['jobtype'];
    // Add other job details you want to display

    return Scaffold(
      appBar: AppBar(
        title: Text('Applicant Details'),
        backgroundColor:
            Color.fromARGB(255, 76, 175, 142), // Customize the app bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$firstName $lastName',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Email: $email',
              style: TextStyle(fontSize: 18, color: Colors.grey[800]),
            ),
            SizedBox(height: 16),
            Text(
              'Message:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 24),
            Text(
              'Job Details:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ListTile(
              leading: Icon(Icons.work, size: 28, color: Colors.blue),
              title: Text(
                category,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    jobType,
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Location: $jobLocation',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Salary: $jobSalary',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Company Name:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              companyDetails,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
