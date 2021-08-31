import 'package:chat/addRoom/AddRoom.dart';
import 'package:chat/chatRoom/ChatRoomScreen.dart';
import 'package:chat/chatRoom/JoinRoom.dart';
import 'package:chat/model/Room.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
 static const ROUTE_NAME='home';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
       children :[
         Center(
           child: RaisedButton(
             onPressed: () {
               Navigator.pushNamed(
                 context,
                 JoinRoom.ROUTE_NAME,
                 arguments: RoomArgs(
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
