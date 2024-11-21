import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white), // Color of the title
        ),
        backgroundColor: const Color.fromARGB(255, 15, 12, 226), // Background color of AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit Your Profile Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20), // Space between title and input fields

            // Name Field
            const Text('Name', style: TextStyle(fontSize: 16)),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Enter your name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16), // Space between fields

            // Phone Field
            const Text('Phone', style: TextStyle(fontSize: 16)),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Enter your phone number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 16), // Space between fields

            // Email Field
            const Text('Email', style: TextStyle(fontSize: 16)),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Enter your email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 16), // Space between fields
            
            // Address Field
            const Text('Address', style: TextStyle(fontSize: 16)),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Enter your address',
                border: OutlineInputBorder(),
              ),
            ),

            const Spacer(), // To push the button to the bottom of the page

            // Save Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle save action here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile updated')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Button color
                ),
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
