import 'package:chat/addRoom/AddRoom.dart';
import 'package:chat/auth/LoginScreen.dart';
import 'package:chat/chatRoom/ChatRoomScreen.dart';
import 'package:chat/model/Room.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
 static const ROUTE_NAME='home';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
       children :[
         Center(
           child: RaisedButton(
             onPressed: () {
               Navigator.pushNamed(
                 context,
                 ChatRoomScreen.ROUTE_NAME,
                 arguments: ChatRoomArgs(
                   Room(
                     id: 'QznCh04O2nDwRI6dCznZ',
                     description: 'fun',
                     name: 'ss',
                     category: 'sports',
                   ),
                 ),
               );
             },
             child: Text('Press me'),
           ),
         ),
         Center(
           child: RaisedButton(
             onPressed: () {
               Navigator.pushNamed(
                 context,
                 AddRoom.ROUTE_NAME,

               );
             },
             child: Text('Add Room'),
           ),
         ),
       ]
      ),
    );
  }
}
