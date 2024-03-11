import 'package:flutter/material.dart';
import 'package:airecruit/models/question.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:airecruit/utils/constants.dart';
import 'package:airecruit/utils/globalColor.dart';

class ScreenResultGenerate extends StatefulWidget {
  const ScreenResultGenerate({Key? key}) : super(key: key);

  @override
  State<ScreenResultGenerate> createState() => _ScreenResultGenerateState();
}

class _ScreenResultGenerateState extends State<ScreenResultGenerate> {
  final String theme = Get.arguments as String;
  final List<Question> questions = [];
  late Future<bool> fetchedData;

     Future<void> addQuiz() async {
  try {
    List<Map<String, dynamic>> questionsJson = questions.map((question) => question.toJson()).toList();
    final response = await http.post(
      Uri.parse('${Constants.BaseUri}/add_quiz'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'theme': theme,
        'questions': questionsJson,
      }),
    );

    if (response.statusCode == 200) {
          showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Information"),
              content: const Text("Quiz inserted seccessfuly."),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Dismiss"))
              ],
            );
          },
        );
    } 
  } catch (e) {
    print('Error during addquiz: $e');
    // Handle network or other exceptions
  }

}

  Future<bool> fetchData() async {
    //url
    Uri fetchUri = Uri.parse("${Constants.BaseUri}/generer_quiz/${theme}");

    //data to send
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    await http.get(fetchUri, headers: headers).then((response) {
      if (response.statusCode == 200) {
        print(response.body);
        //Selialization
      List<dynamic> data = json.decode(response.body);
       for (var item in data) {
         // Convertit les options en List<String> à partir de item['options']
         List<String> options = List<String>.from(item['options']);
         // Ajoute la nouvelle question à la liste
         questions.add(Question(question: item['question'], options: options, correct: item['correct']));
        }
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Information"),
              content: const Text("Server Error! Try agaim later."),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Dismiss"))
              ],
            );
          },
        );
      }
    });

    return true;

  }

  void initState() {
    super.initState();
    fetchedData = fetchData();
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
        style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
      ),
    ],
  ),
  actions: [
   // if(questions.length != 0)
   IconButton(
  onPressed: () {
    addQuiz();
    Get.toNamed('/allquiz');
  },
  icon: Icon(Icons.save, color: JobColor.appcolor,size: 28),
  color: JobColor.appcolor,
)
  ],
),

    body: FutureBuilder<bool>(
      future: fetchedData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: SpinKitCubeGrid(color: JobColor.appcolor, size: 50.0));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return SingleChildScrollView(
            child: Column(
              children: questions
                  .asMap()
                  .entries
                  .map(
                    (entry) => Card(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              "Question ${entry.key + 1}: ${entry.value.question}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: entry.value.options.length,
                            itemBuilder: (context, optionIndex) {
                              String option = entry.value.options[optionIndex];
                              bool iscorrect = optionIndex == entry.value.correct;
                              return ListTile(
                                   title: Text(option),
                                   // Appliquer la bordure orange si c'est la bonne réponse
                                   tileColor: iscorrect ? JobColor.appcolor.withOpacity(0.3) : null,
                                   shape: iscorrect ? RoundedRectangleBorder(
                                   side: BorderSide(color:JobColor.appcolor, width: 2.0),
                                   borderRadius: BorderRadius.circular(8.0),
                                   ) : null,
                                onTap: () {
                                  // Logique à exécuter lorsque l'option est sélectionnée
                                },
                              );
                            },
                          ),
                        ],
                        
                      ),
                    ),
                  )
                  .toList(),
            ),
            
          );
        }
      },
    ),
  );
}
}
