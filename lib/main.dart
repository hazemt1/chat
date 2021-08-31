import 'package:chat/AppConfigProvider.dart';
import 'package:chat/Temp.dart';
import 'package:chat/chatRoom/ChatRoomScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth/LoginScreen.dart';
import 'auth/RegisterationScreen.dart';
import 'home/HomeScreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppConfigProvider(),
      builder: (context, widget) {
        final provider  = Provider.of<AppConfigProvider>(context);
        final isLoggedInUser = provider.checkLoggedInUser();
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          routes: {
            RegisterationScreen.ROUTE_NAME: (context) => RegisterationScreen(),
            LoginScreen.ROUTE_NAME: (context) => LoginScreen(),
            HomeScreen.ROUTE_NAME: (context) => HomeScreen(),
            ChatRoomScreen.ROUTE_NAME: (context) => ChatRoomScreen(),
            Temp.ROUTE_NAME: (context) => Temp()
          },
          initialRoute: LoginScreen.ROUTE_NAME,
         // home: (isLoggedInUser) ? HomeScreen() : LoginScreen(),
        );
      },
    );
  }
}
