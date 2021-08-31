import 'package:chat/AppConfigProvider.dart';
import 'package:chat/Temp.dart';
import 'package:chat/chatRoom/ChatRoomScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      create: (context)=> AppConfigProvider(),
      builder: (context,widget){
        return MaterialApp(
          title: 'chat',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          routes: {
            ChatRoomScreen.ROUTE_NAME: (context) => ChatRoomScreen(),
            Temp.ROUTE_NAME: (context) => Temp(),
          },

          initialRoute: Temp.ROUTE_NAME,
        );
      },
    );

  }
}
