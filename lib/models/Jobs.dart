class Job {
  final String description;
  final String jobTitle;
  final String location;
  final List<String> requirements;

  Job({
    required this.description,
    required this.jobTitle,
    required this.location,
    required this.requirements,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      description: json['description'],
      jobTitle: json['jobTitle'],
      location: json['location'],
      requirements: List<String>.from(json['requirements']),
    );
  }
}
