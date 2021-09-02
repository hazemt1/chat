import 'package:chat/database/DataBaseHelper.dart';
import 'package:chat/home/widgets/RoomWidget.dart';
import 'package:chat/model/Room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../AppConfigProvider.dart';

class BrowseScreen extends StatelessWidget {
  late CollectionReference<Room> roomsCollectionReference;
  late AppConfigProvider provider;

  @override
  Widget build(BuildContext context) {
    roomsCollectionReference = getRoomsCollectionWithConverter();
    provider = Provider.of<AppConfigProvider>(context);
    final Stream<QuerySnapshot<Room>> roomStream =
        roomsCollectionReference.snapshots();
    return Container(
      margin: EdgeInsets.only(top: 30, bottom: 20, left: 12, right: 12),
      child: StreamBuilder(
        stream: roomStream,
        builder: (context, AsyncSnapshot<QuerySnapshot<Room>> snapshot) {
          if (snapshot.hasError)
            return Text(snapshot.error.toString());
          else if (snapshot.hasData) {
            List<Room> roomsList = snapshot.data?.docs
                    .map((singleDoc) => singleDoc.data())
                    .toList() ??
                [];
            List<Room> roomsList1=[];
            if(provider.searchText!=''){
              for(int i= 0;i<roomsList.length;i++){
                if(roomsList[i].name.contains(provider.searchText))
                  roomsList1.add(roomsList[i]);
              }
              roomsList= roomsList1;
            }
            if(roomsList.length==0){
              return Center(
                child: Text(
                  'Nothing Found',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                return RoomWidget(roomsList[index], false);
              },
              itemCount: roomsList.length,
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
