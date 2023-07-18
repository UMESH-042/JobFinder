import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vuna__gigs/admin/UserAdminChatRoom.dart';

class ApplicantsListScreen extends StatelessWidget {
  final String postedByEmail;

  ApplicantsListScreen({required this.postedByEmail});

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

          return ListView.builder(
            itemCount: filteredApplicants.length,
            itemBuilder: (context, index) {
              final applicant = filteredApplicants[index];
              final applicantData = applicant.data() as Map<String, dynamic>;
              print(applicantData['cv_url']);
              return Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                      '${applicantData['first_name']} ${applicantData['last_name']}'),
                  subtitle: Text(applicantData['email']),
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
              );
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
