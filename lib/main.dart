import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  // await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
