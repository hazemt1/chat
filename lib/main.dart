 import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
 import 'package:chat/Appprovider.dart';
import 'package:provider/provider.dart';
 import 'auth/LoginScreen.dart';
 import 'auth/RegisterationScreen.dart';
import 'home/HomeScreen.dart';


 Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
   runApp(MyApp());
 }

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      builder: (context, widget) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            RegisterationScreen.ROUTE_NAME: (context) => RegisterationScreen(),
            LoginScreen.ROUTE_NAME: (context) => LoginScreen(),
            HomeScreen.ROUTE_NAME: (context) => HomeScreen(),
          },
          initialRoute: LoginScreen.ROUTE_NAME,
        );
      },
    );
  }
 }
