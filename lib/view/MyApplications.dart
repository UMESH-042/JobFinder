// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class MyApplicationPage extends StatefulWidget {
//   final String currentUserEmail;

//   const MyApplicationPage({Key? key, required this.currentUserEmail})
//       : super(key: key);

//   @override
//   _MyApplicationPageState createState() => _MyApplicationPageState();
// }

// class _MyApplicationPageState extends State<MyApplicationPage> {
//   late Stream<QuerySnapshot> _applicationsStream;
//   String getTimeDifferenceFromNow(Timestamp timestamp) {
//     final now = DateTime.now();
//     final time = timestamp.toDate();
//     final difference = now.difference(time);

//     if (difference.inDays > 0) {
//       return '${difference.inDays}d ago';
//     } else if (difference.inHours > 0) {
//       return '${difference.inHours}hr ago';
//     } else if (difference.inMinutes > 0) {
//       return '${difference.inMinutes}min ago';
//     } else {
//       return 'just now';
//     }
//   }

//   @override
//   void initState() {
//     super.initState();

//     // Fetch applied jobs for the current user
//     String currentUserEmail = widget.currentUserEmail;
//     _applicationsStream = FirebaseFirestore.instance
//         .collection('applied_jobs')
//         .where('user_email', isEqualTo: currentUserEmail)
//         .snapshots();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Applications'),
//         backgroundColor: Color.fromARGB(255, 76, 175, 142),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _applicationsStream,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             final applications = snapshot.data!.docs;

//             if (applications.isEmpty) {
//               return Center(
//                 child: Text('You have not applied for any jobs yet.'),
//               );
//             }

//             return ListView.builder(
//               itemCount: applications.length,
//               itemBuilder: (context, index) {
//                 final application = applications[index];
//                 final jobData = application.data() as Map<String, dynamic>;

//                 final jobDetails =
//                     jobData['job_details'] as Map<String, dynamic>;
//                 final category = jobDetails['category'] as String;
//                 final jobType = jobDetails['jobtype'] as String?;
//                 final companyName = jobDetails['CompanyName'] as String;
//                 final timestamp = jobData['timestamp'] as Timestamp;

//                 final timeDifference = getTimeDifferenceFromNow(timestamp);

//                  final imageUrl = jobDetails['image'] as String?;

//                 return Dismissible(
//                   key: Key(application.id),
//                   direction: DismissDirection.endToStart,
//                   background: Container(
//                     alignment: Alignment.centerRight,
//                     padding: EdgeInsets.only(right: 16),
//                     color: Colors.red,
//                     child: Icon(
//                       Icons.delete,
//                       color: Colors.white,
//                     ),
//                   ),
//                   onDismissed: (direction) {
//                     // Delete the application from Firestore
//                     FirebaseFirestore.instance
//                         .collection('applied_jobs')
//                         .doc(application.id)
//                         .delete()
//                         .then((value) => print('Application deleted'))
//                         .catchError((error) =>
//                             print('Failed to delete application: $error'));
//                   },
//                   child: Card(
//                     elevation: 3,
//                     margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: ListTile(
//                       leading: imageUrl!=null?Image.network(imageUrl,width: 40,height: 40,fit: BoxFit.cover,):Icon(Icons.image_not_supported,size: 56,),
//                       title: Text(
//                         '${category} (${companyName})',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       subtitle: Text(
//                         jobType ?? '',
//                         style: TextStyle(
//                           fontSize: 14,
//                         ),
//                       ),
//                       trailing: Text(
//                         timeDifference,
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 14,
//                         ),
//                       ),
//                       contentPadding:
//                           EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                       onTap: () {
//                         // Handle tile tap
//                       },
//                     ),
//                   ),
//                 );
//               },
//             );
//           }

//           if (snapshot.hasError) {
//             return Center(
//               child: Text('Failed to fetch applications.'),
//             );
//           }

//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyApplicationPage extends StatefulWidget {
  final String currentUserEmail;

  const MyApplicationPage({Key? key, required this.currentUserEmail})
      : super(key: key);

  @override
  _MyApplicationPageState createState() => _MyApplicationPageState();
}

class _MyApplicationPageState extends State<MyApplicationPage> {
  late Stream<QuerySnapshot> _applicationsStream;
  String getTimeDifferenceFromNow(Timestamp timestamp) {
    final now = DateTime.now();
    final time = timestamp.toDate();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}hr ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}min ago';
    } else {
      return 'just now';
    }
  }

  @override
  void initState() {
    super.initState();

    // Fetch applied jobs for the current user
    String currentUserEmail = widget.currentUserEmail;
    _applicationsStream = FirebaseFirestore.instance
        .collection('applied_jobs')
        .where('user_email', isEqualTo: currentUserEmail)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Applications'),
        backgroundColor: Color.fromARGB(255, 76, 175, 142),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _applicationsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final applications = snapshot.data!.docs;

            if (applications.isEmpty) {
              return Center(
                child: Text('You have not applied for any jobs yet.'),
              );
            }

            return ListView.builder(
              itemCount: applications.length,
              itemBuilder: (context, index) {
                final application = applications[index];
                final jobData = application.data() as Map<String, dynamic>;

                final jobDetails =
                    jobData['job_details'] as Map<String, dynamic>;
                final category = jobDetails['category'] as String;
                final jobType = jobDetails['jobtype'] as String?;
                final companyName = jobDetails['CompanyName'] as String;
                final timestamp = jobData['timestamp'] as Timestamp;

                final timeDifference = getTimeDifferenceFromNow(timestamp);

                final imageUrl = jobDetails['image'] as String?;

                return Dismissible(
                  key: Key(application.id),
                  direction: DismissDirection.startToEnd,
                  background: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 16),
                    color: Colors.red,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  // confirmDismiss: (direction) async {
                  //   return await showDialog(
                  //     context: context,
                  //     builder: (BuildContext context) {
                  //       return AlertDialog(
                  //         title: Text("Delete Application"),
                  //         content: Text("Are you sure you want to delete this application?"),
                  //         actions: <Widget>[
                  //           ElevatedButton(
                  //             child: Text("Cancel"),
                  //             onPressed: () {
                  //               Navigator.of(context).pop(false); // Do not delete
                  //             },
                  //           ),
                  //           ElevatedButton(
                  //             child: Text("Delete"),
                  //             onPressed: () {
                  //               Navigator.of(context).pop(true); // Delete
                  //             },
                  //           ),
                  //         ],
                  //       );
                  //     },
                  //   );
                  // },
                  confirmDismiss: (direction) async {
                    bool confirmDelete = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Delete Application"),
                          content: Text(
                              "Are you sure you want to delete this application?"),
                          actions: <Widget>[
                            TextButton(
                              child: Text("Cancel",
                                  style: TextStyle(color: Colors.black)),
                              onPressed: () {
                                Navigator.of(context).pop(
                                    false); // Close the dialog without deleting
                              },
                            ),
                            TextButton(
                              child: Text("Delete",
                                  style: TextStyle(color: Colors.white)),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop(
                                    true); // Close the dialog and confirm deletion
                              },
                            ),
                          ],
                        );
                      },
                    );

                    return confirmDelete;
                  },
                  onDismissed: (direction) {
                    // Delete the application from Firestore
                    FirebaseFirestore.instance
                        .collection('applied_jobs')
                        .doc(application.id)
                        .delete()
                        .then((value) => print('Application deleted'))
                        .catchError((error) =>
                            print('Failed to delete application: $error'));
                  },
                  child: Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: imageUrl != null
                          ? Image.network(
                              imageUrl,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              Icons.image_not_supported,
                              size: 56,
                            ),
                      title: Text(
                        '${category} (${companyName})',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        jobType ?? '',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      trailing: Text(
                        timeDifference,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      onTap: () {
                        // Handle tile tap
                      },
                    ),
                  ),
                );
              },
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Failed to fetch applications.'),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
