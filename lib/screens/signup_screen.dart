import 'package:airecruit/screens/login_screen.dart';
import 'package:airecruit/utils/globalColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:airecruit/controllers/userController.dart';
class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _fullname = '';
final UserController userController = UserController();


  void _submitForm() {
    if (_formKey.currentState!.validate()) {
    //  _formKey.currentState!.save();
      // Perform sign up logic here
      //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //content: Text("jawek behi chof code PIN fil mail mtaaek")));
         print(_email);
         print(_password);
         print(_fullname);
         
         userController.signupUser(_fullname, _email,_password);
    }
  }

  void _goToSignInPage() {
    Get.to(Login());
     
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60),
             Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                Text(
                'Join Ai-recruit Today ',
                 style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 239, 91, 17)),
                ),
                Text(
                 'Unlock Your Professional Career!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                 ),
                 ],
                ),
               ),
              SizedBox(height: 48),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     
                    SizedBox(height: 8),
                    TextFormField(
                      
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your fullname';
                        }
                        return null;
                      },
                      onChanged: (value) {
                      setState(() {
                      _fullname = value;
                      });
                     },
                      decoration: InputDecoration(
                        labelText: "fullname",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                         Icons.person,
                         color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                  
                    SizedBox(height: 8),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        }
                        // Check if the entered email is valid using a regular expression
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                     onChanged: (value) {
                       setState(() {
                        _email = value;
                      });
                      },
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                         prefixIcon: Icon(
                          Icons.email,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                   
                    SizedBox(height: 8),
                    TextFormField(
                      obscureText: true,
                      validator: (value) {
                        if (value!.length < 8) {
                          return 'Password must be at least 8 characters long';
                        }
                        return null;
                      },
                        onChanged: (value) {
                        setState(() {
                       _password = value;
                        });
                     },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "password",
                         prefixIcon: Icon(
                         Icons.lock,
                         color: Colors.grey,
                        ),
                         suffixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.visibility),
                        color: Color.fromARGB(255, 239, 91, 17),
                      ),
                      ),
                    ),
                    SizedBox(height: 24),
                      TextFormField(
                      obscureText: true,
                      validator: (value) {
                        if (value! != _password) {
                          return 'Your password and confirmation password do not match';
                        }
                         if (value!.isEmpty) {
                          return 'Password must be confirmed';
                        }
                        return null;
                      },
                     
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "confirm password",
                         prefixIcon: Icon(
                         Icons.lock,
                         color: Colors.grey,
                        ),
                         suffixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.visibility),
                        color: Color.fromARGB(255, 239, 91, 17),
                      ),
                      ),
                    ),
                    SizedBox(height: 24),

                    Center(
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        child: Text('Sign up'),
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 239, 91, 17),
                          onPrimary: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Center(
                      
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      SizedBox(height: 24),
                         Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already have an account?'),
                          SizedBox(width: 8),
                          InkWell(
                            onTap: _goToSignInPage, // Call the function to navigate to the sign-in page
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                color: Color.fromARGB(255, 239, 91, 17),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                        ],
                      )
                     
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

