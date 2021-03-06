import 'package:chat/AppConfigProvider.dart';
import 'package:chat/database/DataBaseHelper.dart';
import 'package:chat/home/widgets/RoomWidget.dart';
import 'package:chat/model/Room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class MyRoomsScreen extends StatefulWidget {
  @override
  _MyRoomsScreenState createState() => _MyRoomsScreenState();
}

class _MyRoomsScreenState extends State<MyRoomsScreen> {
  late CollectionReference<Room> roomRef;

  late AppConfigProvider provider;
  late Stream<QuerySnapshot<Room>> roomStream;
  bool loading =false;
  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppConfigProvider>(context);
    getRoomRef();
    return Container(
      margin: EdgeInsets.only(top: 30, bottom: 20, left: 12, right: 12),
      child:loading? StreamBuilder(
        stream: roomStream,
        builder: (context, AsyncSnapshot<QuerySnapshot<Room>> snapshot) {
          if (snapshot.hasError)
            return Text(snapshot.error.toString());
          else if (snapshot.hasData && snapshot.data != null) {
            List<Room> roomsList = snapshot.data?.docs
                    .map((singleDoc) => singleDoc.data())
                    .toList() ??
                [];

            if(roomsList.length==0)
              return Center(
                child: Text(
                  AppLocalizations.of(context)!.noRooms,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            else {
              List<Room> roomsList1=[];
              if(provider.searchText!=''){
                for(int i= 0;i<roomsList.length;i++){
                  String temp =roomsList[i].name.toLowerCase();
                  if (temp.contains(provider.searchText.toLowerCase(),))
                    roomsList1.add(roomsList[i]);
                }
                roomsList= roomsList1;
              }
              if(roomsList.length==0){
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!.nothingFound,
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
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, index) {
                    return RoomWidget(roomsList[index], true);
                },
                itemCount: roomsList.length,
              );
            }
          } else if (snapshot.hasData && snapshot.data == null) {
            return Center(
              child: Text(
                AppLocalizations.of(context)!.noRooms,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ): Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
  getRoomRef() {
    String id = provider.currentUser?.id ?? "";
    if (id != "") {
      roomRef = getUserCollectionWithConverter(provider.currentUser!.id);
      roomStream = roomRef.snapshots();
      loading = true;
      return;
    } else {
      Future.delayed(
        Duration(milliseconds: 100),
            () {
          setState(() {
            getRoomRef();
          });
        },
      );
    }
    return;
  }
}
