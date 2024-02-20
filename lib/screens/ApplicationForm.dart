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

  Job job = Job(
    description:
        'We are looking for an experienced Senior Software Engineer to join our team.',
  );

  Future<String> generateCoverLetter(Job job) async {
    try {
      final String prompt =
          "Write a professional  cover letter for the position of Senior Software Engineer at edreams at edreams  you will play a crucial role in  '${job.description}'  this cover letter will apply this user Farah torkhani for that position (a cover letter as a user )";
      final String openaiApiKey =
          "";

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
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.56.1:5000/save-application'),
      );

      request.fields['firstName'] = _firstNameController.text;
      request.fields['lastName'] = _lastNameController.text;
      request.fields['email'] = _emailController.text;
      request.fields['coverLetter'] = _motivationalLetter ?? '';

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
                              future: generateCoverLetter(job),
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
