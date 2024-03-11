import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:airecruit/screens/DetailQuizScreen.dart';
import 'package:airecruit/screens/quiz.dart';
import 'package:airecruit/screens/DetailQuizScreen.dart';
import 'package:airecruit/screens/screen_all_quiz.dart';
import 'package:airecruit/screens/screen_generate_quiz.dart';
import 'package:airecruit/screens/screen_result_generate.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
       initialRoute: '/allquiz', 
      getPages: [
        GetPage(name: '/quiz', page: () => QuizApp()), 
        GetPage(name: '/detailquiz', page:()=> DetailQuizScreen()),
        GetPage(name: '/generate_quiz', page:()=> ScreenGenerateQuiz()),
        GetPage(name: '/result_generate', page:()=> ScreenResultGenerate()),
        GetPage(name: '/allquiz', page:()=> ScreenAllQuiz()),


      ],
    );
  }
}