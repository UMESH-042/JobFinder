// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class JobListPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           }

//           if (!snapshot.hasData) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }

//           final jobDocs = snapshot.data!.docs;

//           final popularJobs = jobDocs.take(3).toList(); // Get the first 3 jobs as popular jobs
//           final recentPosts = jobDocs.skip(3).toList(); // Skip the first 3 jobs for recent posts

//           return ListView(
//             padding: EdgeInsets.all(16),
//             children: [
//               Text(
//                 'Popular Jobs',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 16),
//               Container(
//                 height: 200,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: popularJobs.length,
//                   itemBuilder: (context, index) {
//                     final jobSnapshot = popularJobs[index];
//                     final jobData = jobSnapshot.data() as Map<String, dynamic>?;

//                     if (jobData == null) {
//                       // Handle null data
//                       return SizedBox.shrink();
//                     }

//                     final location = jobData['location'] ?? 'Unknown';
//                     final salary = jobData['salary'] ?? 'Unknown';
//                     final category = jobData['category'] ?? 'Unknown';
//                     final image = jobData['image'];
//                     final jobtype = jobData['jobtype'];

//                     return Container(
//                       width: 250,
//                       margin: EdgeInsets.only(right: 16),
//                       child: Card(
//                         elevation: 2,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.vertical(
//                                   top: Radius.circular(8),
//                                 ),
//                                 child: Container(
//                                  margin: EdgeInsets.all(10),
//                                   child: Image.network(
//                                     image ?? '',
//                                     fit: BoxFit.cover,
//                                     // width: 70,
//                                     // height: 100,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.all(16),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     category,
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   SizedBox(height: 8),
//                                   Text(
//                                     jobtype,
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.grey[600],
//                                     ),
//                                   ),
//                                   SizedBox(height: 8),
//                                   Text(
//                                     'Location: $location',
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.grey[600],
//                                     ),
//                                   ),
//                                   SizedBox(height: 8),
//                                   Text(
//                                     'Salary: \$${salary}/m',
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.grey[600],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               SizedBox(height: 32),
//               Text(
//                 'Recent Posts',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 16),
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemCount: recentPosts.length,
//                 itemBuilder: (context, index) {
//                   final jobSnapshot = recentPosts[index];
//                   final jobData = jobSnapshot.data() as Map<String, dynamic>?;

//                   if (jobData == null) {
//                     // Handle null data
//                     return SizedBox.shrink();
//                   }

//                   final location = jobData['location'] ?? 'Unknown';
//                   final salary = jobData['salary'] ?? 'Unknown';
//                   final category = jobData['category'] ?? 'Unknown';
//                   final image = jobData['image'];
//                   final jobtype = jobData['jobtype'];

//                   return Card(
//                     margin: EdgeInsets.only(bottom: 16),
//                     elevation: 2,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: ListTile(
//                       contentPadding: EdgeInsets.all(16),
//                       leading: image != null
//                           ? ClipRRect(
//                               borderRadius: BorderRadius.circular(8),
//                               child: Image.network(
//                                 image,
//                                 fit: BoxFit.cover,
//                                 width: 60,
//                                 height: 60,
//                               ),
//                             )
//                           : Icon(Icons.image,
//                               size: 60), // Placeholder if image is not available
//                       title: Text(
//                         category,
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(height: 8),
//                           Text(
//                             jobtype,
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                           SizedBox(height: 4),
//                           // Text(
//                           //   '\$$salary/m',
//                           //   style: TextStyle(
//                           //     fontSize: 14,
//                           //     color: Colors.grey[600],
//                           //   ),
//                           // ),
//                         ],
//                       ),
//                       trailing: Text(
//                         '\$$salary/m',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                       onTap: () {
//                         // Handle onTap event
//                       },
//                     ),
//                   );
//                 },
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Job_Details.dart';

class JobListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final jobDocs = snapshot.data!.docs;

          final popularJobs =
              jobDocs.take(3).toList(); // Get the first 3 jobs as popular jobs
          final recentPosts = jobDocs
              .skip(3)
              .toList(); // Skip the first 3 jobs for recent posts

          return ListView(
            padding: EdgeInsets.all(16),
            children: [
              Text(
                'Popular Jobs',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Container(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: popularJobs.length,
                  itemBuilder: (context, index) {
                    final jobSnapshot = popularJobs[index];
                    final jobData = jobSnapshot.data() as Map<String, dynamic>?;

                    if (jobData == null) {
                      // Handle null data
                      return SizedBox.shrink();
                    }

                    final location = jobData['location'] ?? 'Unknown';
                    final salary = jobData['salary'] ?? 'Unknown';
                    final category = jobData['category'] ?? 'Unknown';
                    final image = jobData['image'];
                    final jobtype = jobData['jobtype'];
                    final description = jobData['description'];
                    final requirements = jobData['requirements'];
                    final postedby=jobData['postedby'];


                    return GestureDetector(
                      onTap: () {
                        // Navigate to job details page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JobDetailsPage(
                              location: location,
                              salary: salary,
                              category: category,
                              image: image,
                              jobtype: jobtype,
                              description: description,
                              requirements: requirements,
                              postedby: postedby,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 250,
                        margin: EdgeInsets.only(right: 16),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(8),
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    child: Image.network(
                                      image ?? '',
                                      fit: BoxFit.cover,
                                      // width: 70,
                                      // height: 100,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      category,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      jobtype,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Location: $location',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Salary: \$${salary}/m',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 32),
              Text(
                'Recent Posts',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: recentPosts.length,
                itemBuilder: (context, index) {
                  final jobSnapshot = recentPosts[index];
                  final jobData = jobSnapshot.data() as Map<String, dynamic>?;

                  if (jobData == null) {
                    // Handle null data
                    return SizedBox.shrink();
                  }

                  final location = jobData['location'] ?? 'Unknown';
                  final salary = jobData['salary'] ?? 'Unknown';
                  final category = jobData['category'] ?? 'Unknown';
                  final image = jobData['image'];
                  final jobtype = jobData['jobtype'];
                  final description = jobData['description'];
                  final requirements = jobData['requirements'];
                  final postedby=jobData['postedby'];

                  return GestureDetector(
                    onTap: () {
                      // Navigate to job details page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobDetailsPage(
                            location: location,
                            salary: salary,
                            category: category,
                            image: image,
                            jobtype: jobtype,
                            description: description,
                            requirements: requirements,
                            postedby: postedby,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.only(bottom: 16),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        leading: image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  image,
                                  fit: BoxFit.cover,
                                  width: 60,
                                  height: 60,
                                ),
                              )
                            : Icon(Icons.image,
                                size:
                                    60), // Placeholder if image is not available
                        title: Text(
                          category,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            Text(
                              jobtype,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 4),
                            // Text(
                            //   '\$$salary/m',
                            //   style: TextStyle(
                            //     fontSize: 14,
                            //     color: Colors.grey[600],
                            //   ),
                            // ),
                          ],
                        ),
                        trailing: Text(
                          '\$$salary/m',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
