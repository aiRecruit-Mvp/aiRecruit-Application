import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/model/quiz.dart';
import 'package:quizapp/utils/globalColor.dart';
class DetailQuizScreen extends StatefulWidget {
  const DetailQuizScreen({Key? key}) : super(key: key);

  @override
  State<DetailQuizScreen> createState() => _DetailQuizScreenState();
}

class _DetailQuizScreenState extends State<DetailQuizScreen> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    Quiz quiz = Get.arguments as Quiz;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              "assets/logo.png",
              width: 40.0,
              height: 40.0,
            ),
            SizedBox(width: 10),
            Text(
              'My Job Applications',
              style: TextStyle(
                fontSize: 20,
                fontFamily: AutofillHints.creditCardNumber,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Card(
              elevation: 3.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20), // Espacement
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.03),
                    child: Text(
                      'Brif Explanation About This Quiz',
                      style: TextStyle(
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // Espacement
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                    child: Row(
                      children: [
                        _buildCircleIcon(Icons.check_circle),
                        SizedBox(width: 10),
                        Text('${quiz.questions.length} questions'),
                      ],
                    ),
                  ),
                  SizedBox(height: 10), // Espacement
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                    child: Row(
                      children: [
                        _buildCircleIcon(Icons.timer),
                        SizedBox(width: 10),
                        Text('5 minutes'),
                      ],
                    ),
                  ),
                  SizedBox(height: 20), // Espacement
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                    child: Text(
                      'Please read the text below carefully so you can understand it :',
                      style: TextStyle(fontSize: screenWidth * 0.04),
                    ),
                  ),
                  SizedBox(height: 10), // Espacement
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                    child: Text(
                      '- Tap on options to select the correct answer',
                      style: TextStyle(fontSize: screenWidth * 0.04),
                    ),
                  ),
                  SizedBox(height: 10), // Espacement
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                    child: Text(
                      '- Click submit if you are sure you want to complete all these questions',
                      style: TextStyle(fontSize: screenWidth * 0.04),
                    ),
                  ),
                  SizedBox(height: 10), // Espacement
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                    child: Text(
                      '- You have the freedom to navigate between the quiz questions at your own pace',
                      style: TextStyle(fontSize: screenWidth * 0.04),
                    ),
                  ),
                  SizedBox(height: 10), // Espacement
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                    child: Text(
                      '- Feel free to review and modify your answers at any time before submitting the quiz',
                      style: TextStyle(fontSize: screenWidth * 0.04),
                    ),
                  ),
                  SizedBox(height: 20), // Espacement
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/quiz', arguments : quiz);
                    },
                    child: Text('Start Quiz', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: JobColor.appcolor,
                    ),
                  ),
                  SizedBox(height: 20), // Espacement
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircleIcon(IconData iconData) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: JobColor.appcolor,
      ),
      child: Icon(
        iconData,
        color: Colors.white,
        size: 24.0,
      ),
    );
  }
}
