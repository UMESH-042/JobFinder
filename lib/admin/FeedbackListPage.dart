import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class FeedbackListPage extends StatefulWidget {
  @override
  _FeedbackListPageState createState() => _FeedbackListPageState();
}

class _FeedbackListPageState extends State<FeedbackListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Feedbacks', // Heading "Feedbacks" added here
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('feedback').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error fetching data'),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('No feedback available'),
                  );
                }

                // Sort feedback in reverse order by timestamp
                final feedbackDocs = snapshot.data!.docs;
                feedbackDocs.sort(
                  (a, b) => b['timestamp'].compareTo(a['timestamp']),
                );

                return ListView.builder(
                  itemCount: feedbackDocs.length,
                  itemBuilder: (context, index) {
                    final feedback = feedbackDocs[index];
                    final docId = feedback.id; // Get the document ID
                    final email = feedback['email'];
                    final feedbackText = feedback['feedbackText'];
                    final selectedTypes =
                        (feedback['selectedFeedbackTypes'] as List<dynamic>)
                            .cast<String>(); // Explicit cast to List<String>
                    final timestamp = feedback['timestamp'].toDate();

                    return FeedbackCard(
                      docId: docId, // Pass the document ID
                      email: email,
                      feedbackText: feedbackText,
                      selectedTypes: selectedTypes,
                      timestamp: timestamp,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FeedbackCard extends StatefulWidget {
  final String docId; // Store the document ID
  final String email;
  final String feedbackText;
  final List<String> selectedTypes;
  final DateTime timestamp;

  FeedbackCard({
    required this.docId,
    required this.email,
    required this.feedbackText,
    required this.selectedTypes,
    required this.timestamp,
  });

  @override
  State<FeedbackCard> createState() => _FeedbackCardState();
}

class _FeedbackCardState extends State<FeedbackCard> {
  Future<String> fetchUserNameFromEmail(String email) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Assuming email is unique, so only one document will match
        String userName = snapshot.docs.first.get('name');
        return userName;
      } else {
        // Handle case when no user found with the given email
        return 'Unknown User';
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return 'Unknown User';
    }
  }

  Future<void> _deleteFeedbackFromFirestore() async {
    try {
      await FirebaseFirestore.instance
          .collection('feedback')
          .doc(widget.docId)
          .delete();
      print('Feedback deleted successfully.');
    } catch (e) {
      print('Error deleting feedback: $e');
      // You can show an error message here if needed.
    }
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Feedback'),
          content: Text('Are you sure you want to delete this feedback?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                _deleteFeedbackFromFirestore(); // Call delete function
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final timeAgo = timeago.format(widget.timestamp);
    final mediaQuery = MediaQuery.of(context);

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: mediaQuery.size.width * 0.05,
        vertical: mediaQuery.size.height * 0.01,
      ),
      child: FutureBuilder<String>(
        future: fetchUserNameFromEmail(
            widget.email), // Fetch username from the email
        builder: (context, snapshot) {
          String userName = snapshot.data ??
              'Loading...'; // Show "Loading..." while fetching username

          return ListTile(
            title: Text(
              userName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Text(
                  widget.feedbackText,
                  style: TextStyle(
                      fontSize: 20), // Bigger font for feedback message
                ),
                SizedBox(height: 16),
                Wrap(
                  spacing: 4,
                  children: widget.selectedTypes
                      .map((type) => Chip(label: Text(type)))
                      .toList(),
                ),
                SizedBox(height: 8),
                Text(timeAgo),
              ],
            ),
            trailing: IconButton(
                onPressed: () {
                  _showDeleteConfirmationDialog(context);
                },
                icon: Icon(
                  Icons.delete,
                )),
          );
        },
      ),
    );
  }
}
