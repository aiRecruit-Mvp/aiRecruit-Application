import 'package:airecruit/screens/ChangePassword_screen.dart';
import 'package:flutter/material.dart';

class VerificationCodePage extends StatelessWidget {
  final TextEditingController verificationCodeController =
      TextEditingController();

  void _handleVerifyCode(BuildContext context) {
    // Add logic to handle verification code and navigate to the next step (ChangePasswordPage)
    // For simplicity, print the verification code for now
    print("Verification Code entered: ${verificationCodeController.text}");

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChangePasswordPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verification Code"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enter the verification code sent to your email.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            TextField(
              controller: verificationCodeController,
              decoration: InputDecoration(
                labelText: "Verification Code",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _handleVerifyCode(context),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 239, 91, 17),
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              ),
              child: Text(
                "Verify",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
