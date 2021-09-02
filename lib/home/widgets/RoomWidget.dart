import 'package:chat/AppConfigProvider.dart';
import 'package:chat/chatRoom/ChatRoomScreen.dart';
import 'package:chat/chatRoom/JoinRoom.dart';
import 'package:chat/model/Room.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoomWidget extends StatelessWidget {
  final Room? room;
  final joined;

  RoomWidget(this.room, this.joined);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
            context, joined ? ChatRoomScreen.ROUTE_NAME : JoinRoom.ROUTE_NAME,
            arguments: RoomArgs(room));
      },
      child: Container(
        padding: EdgeInsets.only(
          top: 15,
        ),
        margin: EdgeInsets.only(bottom: 8,right: 5),
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
              Image(
                image: AssetImage('assets/images/${room!.category}.png'),
                height: 120,
                fit: BoxFit.fitHeight,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  room!.name,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
