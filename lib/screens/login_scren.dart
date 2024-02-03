import 'package:airecruit/controllers/userController.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Login());
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
final UserController userController = UserController();


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("ai-Recruit"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Join ai-Recruit Today",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 239, 91, 17)),
              ),
              SizedBox(height: 20),
              Text(
                "Unlock Your Professional career !",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.visibility),
                      color: Color.fromARGB(255, 239, 91, 17),
                    ),
                  ),
                  obscureText: true,
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Transform.scale(
                    scale: 0.7,
                    child: Checkbox(
                      value: false,
                      onChanged: (value) {},
                    ),
                  ),
                  Text("Remember me"),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: ElevatedButton(
                        onPressed: () {
                          userController.loginUser(
                            emailController.text,
                            passwordController.text,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 239, 91, 17),
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text("Log in"),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Doesn't have an account? "),
                  Text(
                    "Sign up",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(255, 239, 91, 17)),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.apple),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.facebook),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.branding_watermark),
                    

                  ),
                ],
              ),
             
            ],
          ),
        ),
      ),
    );
  }
}
