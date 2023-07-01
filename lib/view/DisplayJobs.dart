import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

          return ListView.builder(
            itemCount: jobDocs.length,
            itemBuilder: (context, index) {
              final jobSnapshot = jobDocs[index];
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

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                          size: 60), // Placeholder if image is not available
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
                      Text(jobtype,
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
                  onTap: () {
                    // Handle onTap event
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
