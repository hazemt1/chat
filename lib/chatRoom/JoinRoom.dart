import 'package:chat/chatRoom/ChatRoomScreen.dart';
import 'package:chat/database/DataBaseHelper.dart';
import 'package:chat/model/Room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../AppConfigProvider.dart';
import 'TooltipShape.dart';

class JoinRoom extends StatefulWidget {
  static const ROUTE_NAME = 'join room';

  @override
  _JoinRoomState createState() => _JoinRoomState();
}

class _JoinRoomState extends State<JoinRoom> {
  late CollectionReference<Room> roomRef;

  late AppConfigProvider provider;
  late Room room;
  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppConfigProvider>(context);
    roomRef = getUserCollectionWithConverter(provider.currentUser!.id);
    final arg = ModalRoute.of(context)?.settings.arguments as RoomArgs;
    room = arg.room!;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage('assets/images/bg.png'),
                fit: BoxFit.fill,
              )),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Text(room.name),
              centerTitle: true,
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: PopupMenuButton<String>(
                    onSelected: (selected) {
                      if (selected == AppLocalizations.of(context)!.leaveRoom) {
                        leaveRoom(room, provider.currentUser!, context);
                      }
                    },
                    offset: Offset(0, 50),
                    shape: const TooltipShape(),
                    itemBuilder: (BuildContext context) {
                      return {AppLocalizations.of(context)!.leaveRoom}.map((String choice) {
                        return PopupMenuItem<String>(
                          padding: EdgeInsets.only(left: 10,right: 10),
                          height: 20,
                          value: choice,
                          child: Text(
                            choice,
                            style: TextStyle(fontSize: 13),
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ],
            ),
            body: Container(
              margin: EdgeInsets.symmetric(vertical: 48, horizontal: 24),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: Offset(4, 4),
                    color: Colors.black12,
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppLocalizations.of(context)!.joinRoomWel,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${AppLocalizations.of(context)!.join} ${room.name}!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Image.asset(
                    'assets/images/${room.category}.png',
                    height: 250,
                  ),
                  Text(
                    room.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromRGBO(127, 127, 127, 1.0),
                      fontSize: 14,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      joinRoom(room,provider.currentUser!,context);
                    },
                    child: Center(
                      child: Wrap(
                        children: [
                          Container(
                            margin: EdgeInsets.all(30),
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 30),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.join,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }


}
