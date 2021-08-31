import 'package:chat/chatRoom/ChatRoomScreen.dart';
import 'package:flutter/material.dart';

import 'model/Room.dart';

class Temp extends StatelessWidget {
  static const ROUTE_NAME ='temp';
  const Temp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
    );
  }
}
