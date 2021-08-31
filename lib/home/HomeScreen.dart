import 'package:chat/addRoom/AddRoom.dart';
import 'package:chat/chatRoom/ChatRoomScreen.dart';
import 'package:chat/database/DataBaseHelper.dart';
import 'package:chat/model/Room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'RoomWidget.dart';

class HomeScreen extends StatelessWidget {
 static const ROUTE_NAME='home';
 late CollectionReference<Room> roomsCollectionReference;


 HomeScreen(){
   roomsCollectionReference = getRoomsCollectionWithConverter();
 }

  @override
  Widget build(BuildContext context) {
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
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Text('Chat App',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
            ),
            backgroundColor: Colors.transparent,
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                Navigator.pushNamed(context, AddRoom.ROUTE_NAME);
              },
              child: Icon(Icons.add),
            ),
            body: Container(
              margin: EdgeInsets.only(top:64, bottom: 12,left: 12,right: 12),
              child: FutureBuilder<QuerySnapshot<Room>>(
                future: roomsCollectionReference.get(),
                builder: (context,AsyncSnapshot<QuerySnapshot<Room>> snapShot){
                  if(snapShot.hasError)
                    return Text('Something Went Wrong');
                  else if(snapShot.connectionState == ConnectionState.done) {
                    final List<Room> roomsList = snapShot.data?.docs.map((singleDoc) =>
                        singleDoc.data()).toList()??[];
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                      ),
                      itemBuilder: (context, index) {
                        return RoomWidget(roomsList[index]);
                      },
                      itemCount: roomsList.length,
                    );
                  }
                  return Center(child: CircularProgressIndicator(),);
              },
              ),
            ),
          ),
        )
      ],
    );
  }
}


/*
return Scaffold(
appBar: AppBar(

),
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
 */