import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:airecruit/models/Jobs.dart';
import 'package:flutter/material.dart';
import 'dart:io'; // Import File class
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart'; // Import this package for ChangeNotifier
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shared_preferences/shared_preferences.dart';

class JobApplicationController {
//Job score
  String? dropboxClientId;
  String? dropboxSecret;
  int _currentStep = 0;
  String? _cvFilePath;
  String? _motivationalLetter;
  double? _fitScore;
  TextEditingController firstNameController;
  TextEditingController lastNameController;
  TextEditingController emailController;

  JobApplicationController({
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
  });
  double? get fitScore => _fitScore;

  void updateFitScore(double score) {
    _fitScore = score;
  }

  void applyForJob(Function(double fitScore) onSuccess) async {
    String userID = "1";
    String jobID = "65db33c5dfddfc844cb739d3";
    List<String> userSkills = ["Python", "Flask", "Symfony"];

    // Create a Map to represent the request data
    Map<String, dynamic> requestData = {
      "user_id": userID,
      "job_id": jobID,
      "skills": userSkills,
    };

    try {
      // Convert requestData to JSON string
      String requestBody = jsonEncode(requestData);

      // Create a Uri object from the URL string
      Uri url = Uri.parse('http://192.168.20.5:5000/apply-for-job');

      // Send job application data to the backend
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestBody,
      );

      // Handle response from the backend
      if (response.statusCode == 200) {
        // Parse fit score from response body
        dynamic responseBody = jsonDecode(response.body);
        double? fitScore =
            double.tryParse(responseBody['fit_score'].toString());
        if (fitScore != null) {
          // Call the success callback with the fit score
          onSuccess(fitScore);
        } else {
          print('Invalid fit score format');
        }
      } else {
        print('Failed to submit job application: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending job application: $e');
    }
  }

  // Future<void> importFromDropbox(BuildContext context) async {
  //   try {
  //     // Show a dialog to choose the file source
  //     showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: Text('Choose File Upload Source'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           children: [
  //             ElevatedButton(
  //               onPressed: () {
  //                 // User chose to upload from Google Drive
  //                 // Implement logic for Google Drive upload
  //                 // In this example, we'll simply print a message
  //                 print('Uploading from Google Drive');
  //                 Navigator.of(context).pop();
  //               },
  //               child: Text('Upload from Google Drive'),
  //             ),
  //             ElevatedButton(
  //               onPressed: () async {
  //                 // User chose to upload from Dropbox
  //                 // Implement logic for Dropbox upload
  //                 // Here, we'll directly call _chooseFileFromDropbox function
  //                 await _chooseFileFromDropbox();
  //                 Navigator.of(context).pop();
  //               },
  //               child: Text('Upload from Dropbox'),
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   } catch (e) {
  //     print('Error importing file: $e');
  //   }
  // }

  // Future<void> _chooseFileFromDropbox() async {
  //   // Implement logic to choose file from Dropbox
  //   // For simplicity, let's assume we directly set _cvFilePath to a sample file
  //   setState(() {
  //     _cvFilePath = 'sample_cv.pdf'; // Set a sample file path
  //   });
  // }

  // Future<void> retrieveDropboxCredentials() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     dropboxClientId = 'w7jd9vd3upxiobl';
  //     dropboxSecret = 'c04r60y0ma7fapp';
  //   });
  // }

  Future<bool> checkAuthorized(bool authorize) async {
    // Check if Dropbox credentials are available
    if (dropboxClientId == null || dropboxSecret == null) {
      print('Dropbox credentials not found.');
      return false;
    }

    return false;
  }

  void saveAsPDF(String coverLetter, BuildContext context) {
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Text(coverLetter),
        );
      },
    ));

    // final output = File('cover_letter.pdf').openWrite();
    // pdf.save().then((_) => output.close());
  }

  Future<void> postulate(BuildContext context) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.56.1:5000/save-application'),
      );

      request.fields['firstName'] = firstNameController.text;
      request.fields['lastName'] = lastNameController.text;
      request.fields['email'] = emailController.text;
      request.fields['coverLetter'] = _motivationalLetter ?? '';
      request.fields['job_id'] = '65db5ddb9d13bc846f0d474e'; // Add the job ID

      var cvFile = File(_cvFilePath!);
      var cvStream = http.ByteStream(cvFile.openRead());
      var cvLength = await cvFile.length();
      var cvMultipartFile = http.MultipartFile(
        'cvPdf',
        cvStream,
        cvLength,
        filename: _cvFilePath!.split('/').last,
      );
      request.files.add(cvMultipartFile);

      var response = await request.send();
      if (response.statusCode == 200) {
        // Application saved successfully
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Application Submitted'),
            content: Text('Your application has been submitted successfully.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      } else {
        // Handle unsuccessful response
        print('Failed to submit application: ${response.statusCode}');
        // Show appropriate error message to the user
      }
    } catch (e) {
      print('Error submitting application: $e');
      // Handle error
      // Show appropriate error message to the user
    }
  }

  Future<String> generateCoverLetter(Job job) async {
    try {
      final String prompt =
          "Write a professional  cover letter for the position of Senior Software Engineer at edreams  you will play a crucial role in  '${job.description}'  this cover letter will apply this user Farah torkhani for that position (a cover letter as a user )";
      final String openaiApiKey =
          "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";

      final response = await http.post(
        Uri.parse('https://api.openai.com/v1//completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openaiApiKey',
        },
        body: json.encode({
          'prompt': prompt,
          'max_tokens': 150,
          'model': 'davinci-002',
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['choices'][0]['text'];
      } else if (response.statusCode == 429) {
        await Future.delayed(Duration(seconds: 20));
        return generateCoverLetter(job);
      } else {
        throw Exception(
            'Failed to generate cover letter: ${response.statusCode}');
      }
    } catch (e) {
      print('Error generating cover letter: $e');
      throw Exception('Failed to generate cover letter');
    }
  }

  // Future<void> listFolder(String path) async {
  //   if (await _controller.checkAuthorized(true)) {
  //     final result = await Dropbox.listFolder(path);
  //     setState(() {});
  //   }
  // }
}
