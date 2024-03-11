import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quizapp/model/quiz.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:quizapp/utils/constants.dart';
import 'package:quizapp/utils/globalColor.dart';

class ScreenAllQuiz extends StatefulWidget {
  const ScreenAllQuiz({Key? key}) : super(key: key);

  @override
  State<ScreenAllQuiz> createState() => _ScreenAllQuizState();
}

class _ScreenAllQuizState extends State<ScreenAllQuiz> {
 


// Fonction pour récupérer les quizzes à partir du JSON
List<Quiz> parseQuizzes(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Quiz>((json) => Quiz.fromJson(json)).toList();
}



// Fonction pour récupérer tous les quizzes depuis le serveur
Future<List<Quiz>> fetchQuiz() async {
  // URL pour récupérer les quizzes
  Uri fetchUri = Uri.parse("${Constants.BaseUri}/all_quiz");

  // En-têtes de la requête
  Map<String, String> headers = {
    "Content-Type": "application/json",
  };

  try {
    // Faire la requête HTTP GET
    final response = await http.get(fetchUri, headers: headers);

    if (response.statusCode == 200) {
      // Si la requête est réussie, désérialiser les données JSON en objets Dart
      List<Quiz> quizzes = parseQuizzes(response.body);
      return quizzes;
    } else {
      // Si la requête a échoué, afficher une boîte de dialogue d'erreur
      throw Exception('Failed to load quizzes');
    }
  } catch (e) {
    // Gérer les exceptions et afficher une boîte de dialogue d'erreur
    print('Error during fetchQuiz: $e');
    throw Exception('Failed to load quizzes');
  }
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
      body: FutureBuilder<List<Quiz>>(
        future: fetchQuiz(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: SpinKitCubeGrid(color: JobColor.appcolor, size: 50.0));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Quiz>? quizzes = snapshot.data;
            return ListView.builder(
              itemCount: quizzes!.length,
              itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: Image.asset(
                'assets/lquiz.jpg',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
              title: Text(quizzes[index].theme,style: TextStyle(color: JobColor.appcolor,fontWeight: FontWeight.bold) ),
              subtitle: Text('${quizzes[index].questions.length} questions'),
              trailing: ElevatedButton(
                onPressed: () {
                  Get.toNamed('/detailquiz',arguments: quizzes[index]);
                },
                 child: Text('continue',style: TextStyle(color: Colors.white)),
                 style:  ElevatedButton.styleFrom(
                 backgroundColor: JobColor.appcolor
                 ),              
               ),
            ),
          );
              },
            );
          }
        },
      ),
    );
  }
}
