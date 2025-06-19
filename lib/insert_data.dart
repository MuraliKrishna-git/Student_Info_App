import 'package:flutter/material.dart';
import 'seed_data.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore Seeder',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SeedHomePage(),
    );
  }
}