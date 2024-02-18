import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:airecruit/utils/custom_textfield.dart';
import 'package:airecruit/utils/globalColors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:airecruit/models/JobApplication.dart';

class ApplicationForm extends StatefulWidget {
  @override
  _ApplicationFormState createState() => _ApplicationFormState();
}

class _ApplicationFormState extends State<ApplicationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  int _currentStep = 0;
  String? _cvFilePath;
  String? _motivationalLetter;

  JobApplication? _jobApplication;

  Future<String> generateCoverLetter() async {
    try {
      final String prompt = "Write a cover letter";
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
        return generateCoverLetter();
      } else {
        throw Exception(
            'Failed to generate cover letter: ${response.statusCode}');
      }
    } catch (e) {
      print('Error generating cover letter: $e');
      throw Exception('Failed to generate cover letter');
    }
  }

  void saveAsPDF(String coverLetter) {
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

  void _postulate() async {
    // Prepare the data to send to the backend
    Map<String, dynamic> formData = {
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'email': _emailController.text,
      'cvFileName':
          _cvFilePath ?? '', // If cvFilePath is null, send an empty string
      'coverLetter': _motivationalLetter ??
          '', // If motivationalLetter is null, send an empty string
    };

    try {
      final response = await http.post(
        Uri.parse(
            'http://192.168.56.1:5000/save-application'), // Replace with your Flask server URL
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(formData),
      );

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
      }
    } catch (e) {
      print('Error submitting application: $e');
      // Handle error
      if (e is http.ClientException) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text(
                'Failed to submit application. Please check your internet connection and try again later.'),
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
      } else if (e is FormatException) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text(
                'Invalid JSON format. Please check the data sent and try again.'),
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
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content:
                Text('An unexpected error occurred. Please try again later.'),
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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Application Form'),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(top: 20),
            child: Image.asset(
              'Assets/logo.png',
              height: 80,
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Stepper(
                    currentStep: _currentStep,
                    onStepTapped: (int index) {
                      setState(() {
                        _currentStep = index;
                      });
                    },
                    steps: [
                      Step(
                        title: Text(
                          'Personal Information',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        isActive: _currentStep == 0,
                        state: _currentStep == 0
                            ? StepState.editing
                            : StepState.indexed,
                        content: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              CustomTextField(
                                controller: _firstNameController,
                                hintText: 'First Name',
                                borderColor: GlobalColors.secondaryColor,
                                focusedBorderColor: GlobalColors.secondaryColor,
                                validator: (value) => value!.isEmpty
                                    ? 'This field is required'
                                    : null,
                              ),
                              SizedBox(height: 16.0),
                              CustomTextField(
                                controller: _lastNameController,
                                hintText: 'Last Name',
                                borderColor: GlobalColors.secondaryColor,
                                focusedBorderColor: GlobalColors.secondaryColor,
                                validator: (value) => value!.isEmpty
                                    ? 'This field is required'
                                    : null,
                              ),
                              SizedBox(height: 16.0),
                              CustomTextField(
                                controller: _emailController,
                                hintText: 'Email',
                                borderColor: GlobalColors.secondaryColor,
                                focusedBorderColor: GlobalColors.secondaryColor,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) => !value!.contains('@')
                                    ? 'Enter a valid email'
                                    : null,
                              ),
                              SizedBox(height: 16.0),
                            ],
                          ),
                        ),
                      ),
                      Step(
                        title: Text(
                          'Upload Your CV',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        isActive: _currentStep == 1,
                        state: _currentStep == 1
                            ? StepState.editing
                            : StepState.indexed,
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        GlobalColors.secondaryColor),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              ),
                              onPressed: () async {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['pdf', 'doc', 'docx'],
                                );
                                if (result != null) {
                                  setState(() {
                                    _cvFilePath = result.files.single.path!;
                                  });
                                }
                              },
                              child: Text('Choose CV File'),
                            ),
                            if (_cvFilePath != null)
                              Row(
                                children: [
                                  Icon(Icons.file_present),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Selected CV: $_cvFilePath',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      Step(
                        title: Text(
                          'Cover Letter',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        isActive: _currentStep == 2,
                        state: _currentStep == 2
                            ? StepState.editing
                            : StepState.indexed,
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            FutureBuilder<String>(
                              future: generateCoverLetter(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  _motivationalLetter = snapshot.data;
                                  return Text(snapshot.data ?? '');
                                }
                              },
                            ),
                            SizedBox(height: 16.0),
                            ElevatedButton(
                              onPressed: () {
                                if ( //_cvFilePath != null &&
                                    _motivationalLetter != null) {
                                  saveAsPDF(_motivationalLetter!);
                                  _jobApplication = JobApplication(
                                    jobId: '123', // Change to actual job ID
                                    userId: '456', // Change to actual user ID
                                    coverLetter: _motivationalLetter!,
                                    cvFileName: _cvFilePath!,
                                  );
                                  _currentStep++;
                                  setState(() {});
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Error'),
                                      content: Text(
                                          'Please Upload a Cover letter  file first.'),
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
                                }
                              },
                              child: Text('Confirm and Save as PDF'),
                            ),
                          ],
                        ),
                      ),
                      Step(
                        title: Text(
                          'Step 4',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        isActive: _currentStep == 3,
                        state: _currentStep == 3
                            ? StepState.editing
                            : StepState.indexed,
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('First Name: ${_firstNameController.text}'),
                            Text('Last Name: ${_lastNameController.text}'),
                            Text('Email: ${_emailController.text}'),
                            if (_cvFilePath != null)
                              Text('CV File: $_cvFilePath'),
                            if (_motivationalLetter != null)
                              Text('Cover Letter: $_motivationalLetter'),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        GlobalColors.secondaryColor),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              ),
                              onPressed: _postulate,
                              child: Text('Confirm'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
