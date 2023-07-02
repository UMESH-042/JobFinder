class JobModel {
  late String category;
  late String subcategory;
  late String description;
  late String requirements;
  late String location;
  late String salary;
  late String imageUrl;
  late String jobtype;

  JobModel(
      {required this.category,
      required this.subcategory,
      required this.description,
      required this.requirements,
      required this.location,
      required this.salary,
      required this.imageUrl,
      required this.jobtype});

  JobModel.fromJson(Map<String, dynamic> json) {
    category = json["category"];
    subcategory = json["subcategory"];
    description = json["description"];
    requirements = json["requirements"];
    location = json["location"];
    salary = json["salary"];
    imageUrl = json["image"];
    jobtype = json["jobtype"];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map<String, dynamic>();

    data["category"] = category;
    data["subcategory"] = subcategory;
    data["description"] = description;
    data["requirements"] = requirements;
    data["location"] = location;
    data["salary"] = salary;
    data["image"] = imageUrl;
    data["jobtype"] = jobtype;

    return data;
  }
}
