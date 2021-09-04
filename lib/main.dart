import 'package:chat/AppConfigProvider.dart';
import 'package:chat/addRoom/AddRoom.dart';
import 'package:chat/chatRoom/ChatRoomScreen.dart';
import 'package:chat/chatRoom/JoinRoom.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth/LoginScreen.dart';
import 'auth/RegisterationScreen.dart';
import 'home/HomeScreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
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
        final provider = Provider.of<AppConfigProvider>(context);
        final isLoggedInUser = provider.checkLoggedInUser();
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            AppLocalizations.delegate, // Add this line
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          routes: {
            RegisterationScreen.ROUTE_NAME: (context) => RegisterationScreen(),
            LoginScreen.ROUTE_NAME: (context) => LoginScreen(),
            HomeScreen.ROUTE_NAME: (context) => HomeScreen(),
            ChatRoomScreen.ROUTE_NAME: (context) => ChatRoomScreen(),
            AddRoom.ROUTE_NAME: (context) => AddRoom(),
            JoinRoom.ROUTE_NAME: (context) => JoinRoom()
          },
          locale: Locale.fromSubtags(languageCode: provider.currentLocale),
          home: (isLoggedInUser) ? HomeScreen() : LoginScreen(),
          //HomeScreen.ROUTE_NAME
        );
      },
    );
  }
}
