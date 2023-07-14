import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Job_Details.dart';

class JobListPage extends StatefulWidget {
  @override
  _JobListPageState createState() => _JobListPageState();
}

class _JobListPageState extends State<JobListPage> {
  String searchQuery = '';
  String filterCategory = '';
  String filterJobType = '';
  String filterLocation = '';

void _showFilterDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      String selectedFilter = filterCategory;
      String selectedJobType = filterJobType;
      String selectedLocation = filterLocation;

      bool showFilterCategory = selectedFilter.isNotEmpty;
      bool showFilterJobType = selectedJobType.isNotEmpty;
      bool showFilterLocation = selectedLocation.isNotEmpty;

      return AlertDialog(
        title: Text('Select a Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            DropdownButton<String>(
              value: selectedFilter,
              isExpanded: true,
              underline: Container(
                height: 1,
                color: Colors.grey[400],
              ),
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
                  filterCategory = value!;
                  showFilterCategory = true;
                });
              },
            ),
            SizedBox(height: 16),
            Text(
              'Job Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            DropdownButton<String>(
              value: selectedJobType,
              isExpanded: true,
              underline: Container(
                height: 1,
                color: Colors.grey[400],
              ),
              items: [
                DropdownMenuItem(
                  value: '',
                  child: Text('All'),
                ),
                DropdownMenuItem(
                  value: 'Full Time',
                  child: Text('Full Time'),
                ),
                DropdownMenuItem(
                  value: 'Part Time',
                  child: Text('Part Time'),
                ),
                DropdownMenuItem(
                  value: 'Freelance',
                  child: Text('Freelance'),
                ),
                DropdownMenuItem(
                  value: 'Remote',
                  child: Text('Remote'),
                ),
                DropdownMenuItem(
                  value: 'Contract',
                  child: Text('Contract'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedJobType = value!;
                  filterJobType = value!;
                  showFilterJobType = true;
                });
              },
            ),
            SizedBox(height: 16),
            Text(
              'Location',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              onChanged: (value) {
                setState(() {
                  selectedLocation = value;
                  filterLocation = value;
                  showFilterLocation = true;
                });
              },
              decoration: InputDecoration(
                hintText: 'Enter location',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                Visibility(
                  visible: showFilterCategory,
                  maintainState: true,
                  maintainAnimation: true,
                  maintainSize: true,
                  child: Chip(
                    label: Text(selectedFilter),
                    deleteIcon: Icon(Icons.cancel),
                    onDeleted: () {
                      setState(() {
                        selectedFilter = '';
                        filterCategory = '';
                        showFilterCategory = false;
                      });
                    },
                  ),
                ),
                Visibility(
                  visible: showFilterJobType,
                  maintainState: true,
                  maintainAnimation: true,
                  maintainSize: true,
                  child: Chip(
                    label: Text(selectedJobType),
                    deleteIcon: Icon(Icons.cancel),
                    onDeleted: () {
                      setState(() {
                        selectedJobType = '';
                        filterJobType = '';
                        showFilterJobType = false;
                      });
                    },
                  ),
                ),
                Visibility(
                  visible: showFilterLocation,
                  maintainState: true,
                  maintainAnimation: true,
                  maintainSize: true,
                  child: Chip(
                    label: Text(selectedLocation),
                    deleteIcon: Icon(Icons.cancel),
                    onDeleted: () {
                      setState(() {
                        selectedLocation = '';
                        filterLocation = '';
                        showFilterLocation = false;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Apply'),
          ),
        ],
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
  final filterCategoryLower = filterCategory.toLowerCase();
  final filterJobTypeLower = filterJobType.toLowerCase();
  final filterLocationLower = filterLocation.toLowerCase();

  if (searchQuery.isNotEmpty &&
      (category?.contains(searchLower) == true ||
          jobType?.contains(searchLower) == true ||
          location?.contains(searchLower) == true)) {
    return true;
  }

  if (filterCategory.isNotEmpty &&
      category?.contains(filterCategoryLower) == true) {
    return true;
  }

  if (filterJobType.isNotEmpty &&
      jobType?.contains(filterJobTypeLower) == true) {
    return true;
  }

  if (filterLocation.isNotEmpty &&
      location?.contains(filterLocationLower) == true) {
    return true;
  }

  // Display all jobs if no filters applied
  if (searchQuery.isEmpty &&
      filterCategory.isEmpty &&
      filterJobType.isEmpty &&
      filterLocation.isEmpty) {
    return true;
  }

  return false;
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
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
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
