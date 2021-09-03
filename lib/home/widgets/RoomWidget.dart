import 'package:chat/AppConfigProvider.dart';
import 'package:chat/chatRoom/ChatRoomScreen.dart';
import 'package:chat/chatRoom/JoinRoom.dart';
import 'package:chat/database/DataBaseHelper.dart';
import 'package:chat/model/Room.dart';
import 'package:chat/model/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RoomWidget extends StatelessWidget {
  final Room? room;
  final joined;

  RoomWidget(this.room, this.joined);

  @override
  Widget build(BuildContext context) {
    final roomMembers = getRoomCollectionWithConverter(room!.id).snapshots();
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
            context, joined ? ChatRoomScreen.ROUTE_NAME : JoinRoom.ROUTE_NAME,
            arguments: RoomArgs(room));
      },
      child: Container(
        height: 200,
        padding: EdgeInsets.only(
          top: 15,
        ),
        margin: EdgeInsets.only(bottom: 8, right: 5),
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8),
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
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: StreamBuilder(
                  stream: roomMembers,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<User>> snapshot) {
                    if (snapshot.hasError) {
                      return Text("0 ${AppLocalizations.of(context)!.members}");
                    } else if (snapshot.hasData) {
                      List<User> usersList = snapshot.data?.docs
                              .map((singleDoc) => singleDoc.data())
                              .toList() ??
                          [];
                      return Text(
                          "${usersList.length} ${AppLocalizations.of(context)!.members}");
                    } else
                      return Text("0 ${AppLocalizations.of(context)!.members}");
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
