import 'dart:io';
import 'package:airecruit/models/Jobs.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:airecruit/utils/custom_textfield.dart';
import 'package:airecruit/utils/globalColors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:airecruit/models/JobApplication.dart';
import 'package:airecruit/models/JobApplicationData.dart';
import 'package:dropbox_client/dropbox_client.dart';
import 'package:airecruit/controllers/jobApplicationsController.dart';
import 'package:permission_handler/permission_handler.dart';

class ApplicationForm extends StatefulWidget {
  @override
  _ApplicationFormState createState() => _ApplicationFormState();
}

class _ApplicationFormState extends State<ApplicationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? dropboxClientId;
  String? dropboxSecret;
  int _currentStep = 0;
  String? _cvFilePath;
  String? _motivationalLetter;
  double? fitScore;
  JobApplicationController _controller = JobApplicationController(
    firstNameController: TextEditingController(),
    lastNameController: TextEditingController(),
    emailController: TextEditingController(),
  );
  JobApplication? _jobApplication;

  @override
  void initState() {
    super.initState();
    // Retrieve Dropbox credentials
    //when the widget initializes
    // _controller.retrieveDropboxCredentials();

    _controller.applyForJob((fitScore) {
      setState(() {
        this.fitScore = fitScore;
      });
    });
  }


  Future<void> uploadFileFromGoogleDrive(String fileId) async {
    try {
      // Authenticate with Google Drive

      // File uploaded successfully
      print('File uploaded from Google Drive successfully!');
    } catch (e) {
      // Handle any errors that occur during the upload process
      print('Error uploading file from Google Drive: $e');
    }
  }

Future<void> requestStoragePermission() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      // Permission granted, proceed with file picking
      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'doc', 'docx'],
        );
        if (result != null) {
          setState(() {
            _cvFilePath = result.files.single.path!;
          });
        }
      } catch (e) {
        print('File picking error: $e');
        // Handle file picking error
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('File Picking Error'),
            content: Text('An error occurred while picking the file.'),
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
    } else {
      // Permission denied, handle accordingly
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Permission Denied'),
          content: Text('Storage permission is required to pick a file.'),
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

  Future<void> listFolder(String path) async {
    if (await _controller.checkAuthorized(true)) {
      final result = await Dropbox.listFolder(path);
      setState(() {});
    }
  }

  


Job job = Job(
    description:
        'We are looking for an experienced Senior Software Engineer to join our team.',
    jobTitle: 'Senior Software Engineer',
    location: 'Tunis',
    requirements: ['Python', 'Flask', 'MongoDB'],
  );


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
        children: [
          SizedBox(height: 16.0),
          Text(
            fitScore != null
                ? 'Fit Score: ${fitScore!.toStringAsFixed(2)}%'
                : 'Fit Score: N/A',
            style: TextStyle(
              fontSize: 18, color: GlobalColors.secondaryColor,
              fontWeight:
                  FontWeight.bold, // Add this line to make the text bold
            ),
          ),

          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Stepper(
                    currentStep: _currentStep,
                    connectorColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return GlobalColors.secondaryColor;
                      },
                    ),
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
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'This field is required';
                                  } else if (!RegExp(
                                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                      .hasMatch(value)) {
                                    return 'Enter a valid email';
                                  }
                                  return null;
                                },
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
                                try {
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
                                } catch (e) {
                                  print('File picking error: $e');
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
                              future: _controller.generateCoverLetter(job),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Center(
                                        child: CircularProgressIndicator(
                                      color: GlobalColors.secondaryColor,
                                    )),
                                  );
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
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        GlobalColors.secondaryColor),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              ),
                              onPressed: () {
                                if ( //_cvFilePath != null &&
                                    _motivationalLetter != null) {
                                  _controller.saveAsPDF(
                                      _motivationalLetter!, context);
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
                          'Last Step before submission',
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
                              onPressed: () async {
                                await _controller.postulate(
                                    context); // Wait for the Future<void> to complete
                              },
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
