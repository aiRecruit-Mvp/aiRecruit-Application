// edit_profile_page.dart

import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Edit your profile information:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text("Name:"),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Enter your name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implement functionality to save changes to the profile
                // For simplicity, this example just prints the new name
                print("New Name: ${nameController.text}");
                // You can add logic to save the changes to your database or backend
                // Once changes are saved, you may want to navigate back to the ProfilePage
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 239, 91, 17),
                onPrimary: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text("Save Changes"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
