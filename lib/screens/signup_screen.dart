import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/Auth.dart';
import '../utils/custom_textfield.dart';
import '../utils/globalColors.dart'; // Assuming this contains your color scheme
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final AuthService authService = AuthService();
  File? _image;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
  void signupUser() {
    if (_image != null) {
      authService.signUpUser(
        context: context,
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
        imageFile: _image!,  // Pass the selected image file
      );
    } else {
      // Handle the case when an image is not selected
      // For example, show a snackbar message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select an image.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60),
              Text(
                'Join AiRecruit Today',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: GlobalColors.primaryColor), // Use global color
              ),
              SizedBox(height: 8),
              Text(
                'Unlock Your Productivity Potential!',
                style: TextStyle(fontSize: 18, color: GlobalColors.secondaryColor), // Use global color
              ),
              SizedBox(height: 48),
              Text(
                'Fullname',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: GlobalColors.primaryColor),
              ),
              SizedBox(height: 8),
              CustomTextField(
                controller: nameController,
                hintText: 'Enter your name',
              ),
              SizedBox(height: 24),
              Text(
                'Email',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: GlobalColors.primaryColor),
              ),
              SizedBox(height: 8),
              CustomTextField(
                controller: emailController,
                hintText: 'Enter your email',
              ),
              SizedBox(height: 24),
              Text(
                'Password',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: GlobalColors.primaryColor),
              ),
              SizedBox(height: 8),
              CustomTextField(
                controller: passwordController,
                hintText: 'Enter your password',
              ),
              SizedBox(height: 24),
              // Add a widget to show the selected image or a placeholder
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: _image != null
                      ? CircleAvatar(
                    radius: 60,
                    backgroundImage: FileImage(_image!),
                  )
                      : CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade200,
                    child: Icon(Icons.camera_alt, color: Colors.grey.shade800),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: signupUser,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(GlobalColors.buttonColor), // Use global color
                    minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)), // Full width button
                  ),
                  child: Text("Sign up"),
                ),
              ),
              SizedBox(height: 24),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? "),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                      },
                      child: Text("Sign In", style: TextStyle(color: GlobalColors.linkColor)), // Corrected action text and use global color
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
