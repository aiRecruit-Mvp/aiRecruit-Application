 import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:airecruit/utils/globalColor.dart';


class ScreenGenerateQuiz extends StatefulWidget {
  const ScreenGenerateQuiz({super.key});

  @override
  State<ScreenGenerateQuiz> createState() => _ScreenGenerateQuizState();
}

class _ScreenGenerateQuizState extends State<ScreenGenerateQuiz> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [  
            Image.asset(
              'assets/logo.png',
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
      body: Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
           Text(
             "Generate Quiz",
             style: TextStyle(
             fontWeight: FontWeight.bold,
             color: JobColor.appcolor,
             fontSize: 25,
             ),
            ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              controller: _textController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter thematic';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Enter thematic',
                border: OutlineInputBorder(),
              ),
            ),
          ),
           SizedBox(height: 20),
           Padding(
            padding: EdgeInsets.all(20.0),
          child:ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Form is valid, do something with the text
                String theme = _textController.text;
                print(theme);
                Get.toNamed("/result_generate",arguments: theme);
              }
            },
            child: Text('Generate',style: TextStyle(color: Colors.white)),
            style:  ElevatedButton.styleFrom(
            backgroundColor: JobColor.appcolor
           ),
          ),
         ),
        ],
      ),
    ),   
    );
  }
}