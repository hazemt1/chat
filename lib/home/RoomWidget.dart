import 'package:chat/AppConfigProvider.dart';
import 'package:chat/chatRoom/ChatRoomScreen.dart';
import 'package:chat/chatRoom/JoinRoom.dart';
import 'package:chat/model/Room.dart';
import 'package:flutter/material.dart';

class RoomWidget extends StatelessWidget {
  Room room;

  RoomWidget(this.room);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, JoinRoom.ROUTE_NAME , arguments: RoomArgs(room));
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: MyThemeData.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(4, 8), // Shadow position
              ),
            ]),
        child: Center(
          child: Column(
            children: [
              Image(image: AssetImage('assets/images/${room.category}.png'),height: 120,fit: BoxFit.fitHeight,),
              Text(room.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Colors.black,
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
