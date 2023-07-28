import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vuna__gigs/admin/AdminJobDetailsPage.dart';

class AllJobsPage extends StatefulWidget {
  @override
  _AllJobsPageState createState() => _AllJobsPageState();
}

class _AllJobsPageState extends State<AllJobsPage> {
  String searchQuery = '';

  Stream<int> getTotalJobsCountStream() {
    final jobsCollection = FirebaseFirestore.instance.collection('jobs');
    return jobsCollection.snapshots().map((snapshot) => snapshot.size);
  }

  Future<void> deleteJob(String documentId) async {
    try {
      final jobRef =
          FirebaseFirestore.instance.collection('jobs').doc(documentId);
      await jobRef.delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Job post deleted successfully.'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete the job post.'),
        ),
      );
    }
  }

  Future<void> confirmDeleteJob(String documentId) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete this job?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await deleteJob(documentId);
            },
            child: Text(
              'Yes',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  String getTimeDifferenceFromNow(Timestamp? timestamp) {
    if (timestamp == null) {
      return 'No timestamp available';
    }
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
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('All Jobs'),
      //   backgroundColor: Color.fromARGB(255, 76, 175, 142),
      // ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search by Category or Company Name...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          StreamBuilder<int>(
            stream: getTotalJobsCountStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final totalJobsCount = snapshot.data ?? 0;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 76, 175, 142),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.work,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          '$totalJobsCount Jobs Posted',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                final jobDocs = snapshot.data!.docs;

                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: jobDocs.length,
                  itemBuilder: (context, index) {
                    final jobSnapshot = jobDocs[index];
                    final jobData = jobSnapshot.data() as Map<String, dynamic>?;

                    if (jobData == null) {
                      return SizedBox.shrink();
                    }

                    final category =
                        jobData['category']?.toString()?.toLowerCase() ?? '';
                    final category_exact =
                        jobData['category']?.toString() ?? '';
                    final companyName =
                        jobData['companyDetails']?.toString()?.toLowerCase() ??
                            '';
                    final containsSearchQuery =
                        category.contains(searchQuery) ||
                            companyName.contains(searchQuery);

                    if (searchQuery.isNotEmpty && !containsSearchQuery) {
                      return SizedBox.shrink();
                    }

                    final location = jobData['location'] ?? 'Unknown';
                    final salary = jobData['salary'] ?? 'Unknown';
                    final image = jobData['image'];
                    final jobtype = jobData['jobtype'];
                    final description = jobData['description'];
                    final requirements = jobData['requirements'];
                    final postedby = jobData['postedby'];
                    final noOfApplicants = jobData['NoOfApplicants'] ?? 0;
                    final CompanyName = jobData['companyDetails'];
                    final timestamp = jobData['timestamp'] as Timestamp;
                    final timeDifference = getTimeDifferenceFromNow(timestamp);

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminJobDetailsPage(
                              documentId: jobSnapshot.id,
                              location: location,
                              salary: salary,
                              category: category,
                              image: image,
                              jobtype: jobtype,
                              description: description,
                              requirements: requirements,
                              postedby: postedby,
                              noOfApplicants: noOfApplicants,
                              CompanyName: CompanyName,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          // leading: image != null
                          //     ? ClipRRect(
                          //         borderRadius: BorderRadius.circular(8),
                          //         child: Image.network(
                          //           image,
                          //           fit: BoxFit.cover,
                          //           width: 60,
                          //           height: 60,
                          //         ),
                          //       )
                          //     : Icon(Icons.image, size: 60),
                          leading: image != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    imageUrl: image,
                                    fit: BoxFit.cover,
                                    width: 60,
                                    height: 60,
                                    placeholder: (context, url) => Container(
                                      color: Colors.white,
                                      width: 60,
                                      height: 60,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.image, size: 60),
                                  ),
                                )
                              : Icon(Icons.image, size: 60),

                          title: Text(
                            category_exact,
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
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              confirmDeleteJob(jobSnapshot.id);
                            },
                          ),
                        ),
                      ),
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
