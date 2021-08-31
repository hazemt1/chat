import 'package:chat/AppConfigProvider.dart';
import 'package:chat/chatRoom/DisplayedMessage.dart';
import 'package:chat/database/DataBaseHelper.dart';
import 'package:chat/model/Message.dart';
import 'package:chat/model/Room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'TooltipShape.dart';

class ChatRoomScreen extends StatefulWidget {
  static const ROUTE_NAME = 'chat room';

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  String textFieldMessage = '';

  late CollectionReference<Message> messageRef;
  late CollectionReference<Room> roomRef;

  late AppConfigProvider provider;

  late TextEditingController _controller;


  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)?.settings.arguments as RoomArgs;
    Room room = arg.room!;
    messageRef = getMessageCollectionWithConverter(room.id);
    final Stream<QuerySnapshot<Message>> messageStream =
        messageRef.orderBy('time').snapshots();
    provider = Provider.of<AppConfigProvider>(context);
    roomRef = getUserCollectionWithConverter(provider.currentUser!.id);
    _controller = TextEditingController(text: textFieldMessage);
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
                      if (selected == 'Leave Room') {
                        final roomDoc = roomRef.doc(room.id);
                        roomDoc.delete();
                        Navigator.pop(context);
                      }
                    },
                    offset: Offset(0,50),
                    shape: const TooltipShape(),
                    itemBuilder: (BuildContext context) {
                      return {'Leave Room'}.map((String choice) {
                        return PopupMenuItem<String>(
                          padding: EdgeInsets.only(left: 10),
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
                children: [
                  Expanded(
                    child: StreamBuilder(
                      stream: messageStream,
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Message>> snapshot) {
                        if (snapshot.hasError)
                          return Text(snapshot.error.toString());
                        else if (snapshot.hasData) {
                          return ListView.builder(
                            itemBuilder: (context, index) {
                              return DisplayedMessage(
                                  snapshot.data?.docs[index].data());
                            },
                            itemCount: snapshot.data?.size ?? 0,
                          );
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          onChanged: (text) {
                            textFieldMessage = text;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 5,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                              ),
                            ),
                            hintText: 'Type a massage',
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          sendMessage();
                        },
                        child: Container(
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Send',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Image.asset('assets/images/send.png'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  sendMessage() {
    if (textFieldMessage.isEmpty) return;
    final messageDoc = messageRef.doc();
    final message = Message(
      id: messageDoc.id,
      content: textFieldMessage,
      senderName: provider.currentUser?.userName ?? '',
      senderId: provider.currentUser?.id ?? '',
      time: DateTime.now().millisecondsSinceEpoch,
    );
    messageDoc.set(message).then((value) {
      setState(() {
        textFieldMessage = '';
        _controller.clear();
      });
    });
  }
}

class RoomArgs {
  Room? room;
  RoomArgs(this.room);
}
