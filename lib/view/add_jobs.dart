import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';

class AddJobs extends StatefulWidget {
  final String otherUserEmail;

  const AddJobs({Key? key, required this.otherUserEmail}) : super(key: key);

  @override
  State<AddJobs> createState() => _AddJobsState();
}

class _AddJobsState extends State<AddJobs> {
  TextEditingController _locationController = TextEditingController();
  TextEditingController _salaryController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _subcategoryController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _requirementsController = TextEditingController();
  String jobtype = "";

  List<String> availableJobTypes = [
    "Full-time",
    "Part-time",
    "Remote",
    "Contract",
    "Freelance"
  ];

  late DateTime _selectedDate;
  String dateText = "";
  late String time;
  XFile? imageXfile;
  final ImagePicker _picker = ImagePicker();
  bool _isAddingJob = false;

  Future<void> _getImage() async {
    imageXfile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXfile;
    });
  }

  String bookImageUrl = "";

  Future<void> uploadImage() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    fStorage.Reference reference = fStorage.FirebaseStorage.instance
        .ref()
        .child("JobPhoto")
        .child(fileName);

    fStorage.UploadTask uploadTask = reference.putFile(File(imageXfile!.path));

    fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    await taskSnapshot.ref.getDownloadURL().then((url) {
      bookImageUrl = url;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Colors.white),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      CupertinoIcons.arrow_left_circle,
                      color: Colors.blue[300],
                      size: 28,
                    )),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              _getImage();
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius:
                                      MediaQuery.of(context).size.width * 0.1,
                                  backgroundColor: Colors.grey[600],
                                  backgroundImage: imageXfile == null
                                      ? null
                                      : FileImage(File(imageXfile!.path)),
                                  child: imageXfile == null
                                      ? Icon(
                                          Icons.add_a_photo_outlined,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                "Choose the picture".text.make()
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      label("Category"),
                      const SizedBox(
                        height: 20,
                      ),
                      Category(),
                      const SizedBox(
                        height: 25,
                      ),
                      label("Sub Category"),
                      const SizedBox(
                        height: 20,
                      ),
                      SubCategory(),
                      const SizedBox(
                        height: 30,
                      ),
                      label("Description"),
                      const SizedBox(
                        height: 20,
                      ),
                      Description(),
                      const SizedBox(
                        height: 30,
                      ),
                      label("Requirements"),
                      const SizedBox(
                        height: 20,
                      ),
                      requirements(),
                      const SizedBox(
                        height: 30,
                      ),
                      label("Location"),
                      const SizedBox(
                        height: 12,
                      ),
                      Location(),
                      const SizedBox(
                        height: 25,
                      ),
                      label("Salary"),
                      const SizedBox(
                        height: 12,
                      ),
                      Salary(),
                      const SizedBox(
                        height: 20,
                      ),
                      label("Job Type"),
                      const SizedBox(
                        height: 12,
                      ),
                      Wrap(
                        runSpacing: 10,
                        children: [
                          JobType("Full Time", Colors.white,
                              jobtype == "Full Time"),
                          const SizedBox(
                            width: 20,
                          ),
                          JobType("Freelance", Colors.white,
                              jobtype == "Freelance"),
                          const SizedBox(
                            width: 20,
                          ),
                          JobType(
                              "Contract", Colors.white, jobtype == "Contract"),
                          const SizedBox(
                            width: 20,
                          ),
                          JobType("Part Time", Colors.white,
                              jobtype == "Part Time"),
                          const SizedBox(
                            width: 20,
                          ),
                          JobType("Remote", Colors.white, jobtype == "Remote"),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      _isAddingJob
                          ? SpinKitCircle(
                              color: Colors.blue,
                              size: 40.0,
                            )
                          : button(),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget Category() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 56, 47, 47),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _categoryController,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 17,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Job's Category",
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 17),
          contentPadding: EdgeInsets.only(left: 20, right: 20),
        ),
      ),
    );
  }

  Widget SubCategory() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 56, 47, 47),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _subcategoryController,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 17,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Job's SubCategory",
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 17),
          contentPadding: EdgeInsets.only(left: 20, right: 20),
        ),
      ),
    );
  }

  Widget Location() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 56, 47, 47),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _locationController,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 17,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Job's Location",
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 17),
          contentPadding: EdgeInsets.only(left: 20, right: 20),
        ),
      ),
    );
  }

  Widget Salary() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 56, 47, 47),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _salaryController,
        keyboardType: TextInputType.number,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 17,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Enter figures in Dollars",
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 17),
          contentPadding: EdgeInsets.only(left: 20, right: 20),
        ),
      ),
    );
  }

  Widget Description() {
    return Container(
      height: 155,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 56, 47, 47),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _descriptionController,
        maxLines: null,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 17,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Description",
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 17),
          contentPadding: EdgeInsets.only(left: 20, right: 20),
        ),
      ),
    ).py12();
  }

  Widget requirements() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 56, 47, 47),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _requirementsController,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 17,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Requirements",
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 17),
          contentPadding: EdgeInsets.only(left: 20, right: 20),
        ),
      ),
    );
  }

  Widget label(String label) {
    return Text(label,
        style: TextStyle(
          color: Colors.indigo[900]!,
          fontWeight: FontWeight.w600,
          fontSize: 16.5,
          letterSpacing: 0.2,
        ));
  }

  Widget JobType(String label, Color color, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          jobtype = label;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.white : Colors.grey,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Chip(
          backgroundColor:
              isSelected ? Color.fromARGB(255, 76, 175, 142) : color,
          label: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontSize: 17,
            ),
          ),
          labelPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 3.8),
        ),
      ),
    );
  }

  Widget button() {
    return InkWell(
      onTap: () async {
        if (_locationController.text.isNotEmpty &&
            _salaryController.text.isNotEmpty &&
            _categoryController.text.isNotEmpty &&
            _subcategoryController.text.isNotEmpty && _descriptionController.text.isNotEmpty && _requirementsController.text.isNotEmpty &&
            jobtype.isNotEmpty &&
            imageXfile != null) {
          setState(() {
            _isAddingJob = true;
          });

          await uploadImage();

          FirebaseFirestore.instance.collection("jobs").add({
            "location": _locationController.text,
            "salary": _salaryController.text,
            "category": _categoryController.text,
            "subcategory": _subcategoryController.text,
            "description":_descriptionController.text,
            "requirements":_requirementsController.text,
            "jobtype": jobtype,
            "image": bookImageUrl,
            "postedby":widget.otherUserEmail,
          }).then((value) {
            setState(() {
              _isAddingJob = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Job Added Successfully"),
              ),
            );

            Navigator.pop(context);
          }).catchError((error) {
            setState(() {
              _isAddingJob = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Failed to add job. Please try again."),
              ),
            );
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Please fill all the required fields"),
            ),
          );
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 55,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 76, 175, 142),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            "Add Job",
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
}
