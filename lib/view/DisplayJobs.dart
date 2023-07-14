// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// import 'Job_Details.dart';

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

//           final popularJobs =
//               jobDocs.take(3).toList(); // Get the first 3 jobs as popular jobs
//           final recentPosts = jobDocs
//               .skip(3)
//               .toList(); // Skip the first 3 jobs for recent posts

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
//                     final description = jobData['description'];
//                     final requirements = jobData['requirements'];
//                     final postedby = jobData['postedby'];

//                     return GestureDetector(
//                       onTap: () {
//                         // Navigate to job details page
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => JobDetailsPage(
//                               location: location,
//                               salary: salary,
//                               category: category,
//                               image: image,
//                               jobtype: jobtype,
//                               description: description,
//                               requirements: requirements,
//                               postedby: postedby,
//                             ),
//                           ),
//                         );
//                       },
//                       child: Container(
//                         width: 250,
//                         margin: EdgeInsets.only(right: 16),
//                         child: Card(
//                           elevation: 2,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Expanded(
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.vertical(
//                                     top: Radius.circular(8),
//                                   ),
//                                   child: Container(
//                                     margin: EdgeInsets.all(10),
//                                     child: Image.network(
//                                       image ?? '',
//                                       fit: BoxFit.cover,
//                                       // width: 70,
//                                       // height: 100,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.all(16),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       category,
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     SizedBox(height: 8),
//                                     Text(
//                                       jobtype,
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         color: Colors.grey[600],
//                                       ),
//                                     ),
//                                     SizedBox(height: 8),
//                                     Text(
//                                       'Location: $location',
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         color: Colors.grey[600],
//                                       ),
//                                     ),
//                                     SizedBox(height: 8),
//                                     Text(
//                                       'Salary: \$${salary}/m',
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         color: Colors.grey[600],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
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
//                   final description = jobData['description'];
//                   final requirements = jobData['requirements'];
//                   final postedby = jobData['postedby'];

//                   return GestureDetector(
//                     onTap: () {
//                       // Navigate to job details page
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => JobDetailsPage(
//                             location: location,
//                             salary: salary,
//                             category: category,
//                             image: image,
//                             jobtype: jobtype,
//                             description: description,
//                             requirements: requirements,
//                             postedby: postedby,
//                           ),
//                         ),
//                       );
//                     },
//                     child: Card(
//                       margin: EdgeInsets.only(bottom: 16),
//                       elevation: 2,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: ListTile(
//                         contentPadding: EdgeInsets.all(16),
//                         leading: image != null
//                             ? ClipRRect(
//                                 borderRadius: BorderRadius.circular(8),
//                                 child: Image.network(
//                                   image,
//                                   fit: BoxFit.cover,
//                                   width: 60,
//                                   height: 60,
//                                 ),
//                               )
//                             : Icon(Icons.image,
//                                 size:
//                                     60), // Placeholder if image is not available
//                         title: Text(
//                           category,
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(height: 8),
//                             Text(
//                               jobtype,
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                             SizedBox(height: 4),
//                             // Text(
//                             //   '\$$salary/m',
//                             //   style: TextStyle(
//                             //     fontSize: 14,
//                             //     color: Colors.grey[600],
//                             //   ),
//                             // ),
//                           ],
//                         ),
//                         trailing: Text(
//                           '\$$salary/m',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                       ),
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

class JobListPage extends StatefulWidget {
  @override
  _JobListPageState createState() => _JobListPageState();
}

class _JobListPageState extends State<JobListPage> {
  String searchQuery = '';
  String filter = '';

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String selectedFilter = '';

        return AlertDialog(
          title: Text('Select a Category'),
          content: DropdownButton<String>(
            value: selectedFilter,
            items: [
              DropdownMenuItem(
                value: '',
                child: Text('All'),
              ),
              DropdownMenuItem(
                value: 'SDE',
                child: Text('SDE'),
              ),
              DropdownMenuItem(
                value: 'UI/UX Designer',
                child: Text('UI/UX Designer'),
              ),
              DropdownMenuItem(
                value: 'Lead Product Manager',
                child: Text('Lead Product Manager'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                selectedFilter = value!;
                filter = selectedFilter;
                Navigator.pop(context);
              });
            },
          ),
        );
      },
    );
  }

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

          final filteredJobs = jobDocs.where((job) {
            final jobData = job.data() as Map<String, dynamic>?;
            if (jobData == null) {
              return false;
            }
            final category = jobData['category']?.toString().toLowerCase();
            final jobType = jobData['jobtype']?.toString().toLowerCase();
            final location = jobData['location']?.toString().toLowerCase();
            final searchLower = searchQuery.toLowerCase();
            final filterLower = filter.toLowerCase();

            if (searchQuery.isNotEmpty &&
                (category?.contains(searchLower) == true ||
                    jobType?.contains(searchLower) == true ||
                    location?.contains(searchLower) == true)) {
              return true;
            }

            if (filter.isNotEmpty && category?.contains(filterLower) == true) {
              return true;
            }

            return searchQuery.isEmpty && filter.isEmpty;
          }).toList();

          final popularJobs =
              filteredJobs.take(3).toList(); // Get the first 3 jobs as popular jobs
          final recentPosts = filteredJobs
              .skip(3)
              .toList(); // Skip the first 3 jobs for recent posts

          return ListView(
            padding: EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                              hintText: 'Search...',
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromARGB(255, 76, 175, 142),
                          ),
                          margin: EdgeInsets.only(right: 4, left: 5),
                          height: 50,
                          child: IconButton(
                            icon: Icon(Icons.filter_list),
                            color: Colors.white,
                            onPressed: () {
                              // Handle filter button press
                               _showFilterDialog(context);
                            },
                          ),
                        ),
                ],
              ),
              SizedBox(height: 16),
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
                    final postedby = jobData['postedby'];

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
                  final postedby = jobData['postedby'];

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
                            : Icon(Icons.image, size: 60),
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
