import 'package:airecruit/screens/login_scren.dart';
import 'package:airecruit/utils/globalColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _fullname = '';



  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Perform sign up logic here
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
              Text(
                'Join Focusify Today ',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              Text(
                'Unlock Your Productivity Potential!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              ),
              SizedBox(height: 48),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(
                      'Fullname',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your fullname';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _fullname = value!;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.grey[200],
                        prefixIcon: Icon(
                         Icons.person,
                         color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Email',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value!;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.grey[200],
                         prefixIcon: Icon(
                          Icons.email,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Password',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      obscureText: true,
                      validator: (value) {
                        if (value!.length < 8) {
                          return 'Password must be at least 8 characters long';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value!;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.grey[200],
                         prefixIcon: Icon(
                         Icons.lock,
                         color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        child: Text('Sign up'),
                        style: ElevatedButton.styleFrom(
                          primary: GlobalColors.primaryColor,
                          onPrimary: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Center(
                      
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                       Text("or"),
                       SizedBox(height: 20),
                       OutlinedButton(
                       onPressed: () {},
                       child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                       Image.asset(
                         'images/google_icon.png',
                         height: 24,
                        ),
                        SizedBox(width: 8),
                        Text('Continue with Google'),
                        ],
                       ),
                      ),

                      SizedBox(height: 24),

                       OutlinedButton(
                       onPressed: () {},
                       child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                       Image.asset(
                         'images/linkedin-icon.png',
                         height: 24,
                        ),
                        SizedBox(width: 8),
                        Text('Continue with Linkedin'),
                        ],
                       ),
                      ),
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
                                color: GlobalColors.primaryColor,
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

