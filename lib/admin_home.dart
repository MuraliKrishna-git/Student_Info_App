import 'package:flutter/material.dart';
import 'student_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context),
            tooltip: 'Logout',
          ),
        ],),
      // body: const Center(child: Text('Welcome, Admin')),
      body: StudentListScreen(),
    );
  }
}
