import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Applications',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: JobApplicationsScreen(),
    );
  }
}

class JobApplicationsScreen extends StatefulWidget {
  @override
  _JobApplicationsScreenState createState() => _JobApplicationsScreenState();
}

class _JobApplicationsScreenState extends State<JobApplicationsScreen> {
  List<dynamic> jobApplications = [];
  String selectedStatus = 'All'; // Default selected status
  int selectedApplicationIndex = -1;

  @override
  void initState() {
    super.initState();
    fetchJobApplications();
  }

  Future<void> fetchJobApplications() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.56.1:5000/job-applications'));
      if (response.statusCode == 200) {
        final List<dynamic> applications =
            json.decode(response.body) as List<dynamic>;
        for (final application in applications) {
          final jobID = application['job_id'];
          final jobDetails = await fetchJobDetails(jobID);
          application['jobDetails'] = jobDetails;
        }
        setState(() {
          jobApplications = applications;
        });
      } else {
        // Handle error
        print('Failed to fetch job applications: ${response.statusCode}');
      }
    } catch (e) {
      // Handle error
      print('Error fetching job applications: $e');
    }
  }

  Future<Map<String, dynamic>> fetchJobDetails(String jobID) async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.56.1:5000/jobs/$jobID'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jobDetails =
            json.decode(response.body) as Map<String, dynamic>;
        return jobDetails;
      } else {
        // Handle error
        print('Failed to fetch job details: ${response.statusCode}');
        return {}; // Return an empty map
      }
    } catch (e) {
      // Handle error
      print('Error fetching job details: $e');
      return {}; // Return an empty map
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Applications'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              children: [
                _buildStatusButton('All'),
                _buildStatusButton('In Progress'),
                _buildStatusButton('Rejected'),
                _buildStatusButton('Archived'),
                _buildStatusButton('Interview scheduled'),
                _buildStatusButton('Shortlisted'),
                _buildStatusButton('Hired'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: jobApplications.length,
              itemBuilder: (context, index) {
                final application = jobApplications[index];
                final firstName = application['firstName'];
                final lastName = application['lastName'];
                final email = application['email'];
                final jobDetails = application['jobDetails'];
                final jobTitle =
                    jobDetails != null ? jobDetails['jobTitle'] : 'N/A';
                final location =
                    jobDetails != null ? jobDetails['location'] : 'N/A';

                return Column(
                  children: [
                    ListTile(
                      title: Text('Name: $firstName $lastName'),
                      subtitle: Text('Email: $email'),
                      onTap: () {
                        setState(() {
                          selectedApplicationIndex =
                              selectedApplicationIndex == index ? -1 : index;
                        });
                      },
                    ),
                    if (selectedApplicationIndex == index)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Job Title: $jobTitle'),
                            Text('Location: $location'),
                            // Add more details here as needed
                          ],
                        ),
                      ),
                    Divider(), // Divider between each item
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton(String status) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedStatus = status;
        });
      },
      style: ElevatedButton.styleFrom(
        primary: selectedStatus == status ? Colors.blue : Colors.grey,
      ),
      child: Text(status),
    );
  }

  Widget _buildJobApplicationTile(Map<String, dynamic> application) {
    final firstName = application['firstName'];
    final lastName = application['lastName'];
    final email = application['email'];
    final job = application['job'];
    final jobTitle = job != null ? job['jobTitle'] : 'N/A';
    final location = job != null ? job['location'] : 'N/A';

    return ListTile(
      title: Text('Name: $firstName $lastName'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Email: $email'),
          Text('Job Title: $jobTitle'),
          Text('Location: $location'),
        ],
      ),
    );
  }

}
