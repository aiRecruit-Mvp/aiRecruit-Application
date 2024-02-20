import 'package:airecruit/utils/globalColors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JobApplicationsScreen extends StatefulWidget {
  @override
  _JobApplicationsScreenState createState() => _JobApplicationsScreenState();
}

class _JobApplicationsScreenState extends State<JobApplicationsScreen> {
  List<dynamic> jobApplications = [];
  String selectedStatus = ''; // Variable to store the selected status

  @override
  void initState() {
    super.initState();
    fetchJobApplications();
    selectedStatus = 'In Progress';
  }

  Future<void> fetchJobApplications() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.56.1:5000/job-applications'));
      if (response.statusCode == 200) {
        setState(() {
          jobApplications = json.decode(response.body) as List<dynamic>;
        });
        print(jobApplications);
      } else {
        // Handle error
        print('Failed to load job applications: ${response.statusCode}');
      }
    } catch (e) {
      // Handle error
      print('Error loading job applications: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'Assets/logo.png',
              width: 40,
              height: 40,
            ),
            SizedBox(width: 10),
            Text(
              'My Job Applications',
              style: TextStyle(
                  fontSize: 20, fontFamily: AutofillHints.creditCardNumber),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                _buildStatusButton('In Progress'),
                SizedBox(
                    width: 10), // Adjust the space between buttons as needed
                _buildStatusButton('Rejected'),
                SizedBox(width: 10),
                _buildStatusButton('Archived'),
                SizedBox(width: 10),
                _buildStatusButton('Interview scheduled'),
                SizedBox(width: 10),
                _buildStatusButton('Shortlisted'),
                SizedBox(width: 10),
                _buildStatusButton('Hired'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: jobApplications.length,
              itemBuilder: (context, index) {
                final application = jobApplications[index];
                return ListTile(
                  title: Text('Job ID: ${application['firstName']}'),
                  subtitle: Text('Status: ${application['lastName']}'),
                  onTap: () {
                    // Handle tapping on a job application
                    // You can navigate to a detailed view of the job application here
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton(String status) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedStatus = status; // Update the selected status
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        decoration: BoxDecoration(
          color: selectedStatus == status
              ? GlobalColors.secondaryColor
              : Colors.transparent,
          border: selectedStatus == status
              ? null
              : Border.all(
                  width: 0.5,
                  color: Colors.black), // Add border when not selected
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Text(
          status,
          style: TextStyle(
              color: selectedStatus == status
                  ? Colors.white
                  : Colors.black), // Set text color based on selected status
        ),
      ),
    );
  }
}
