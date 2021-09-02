import 'package:chat/AppConfigProvider.dart';
import 'package:chat/chatRoom/ChatRoomScreen.dart';
import 'package:chat/database/DataBaseHelper.dart';
import 'package:chat/model/Room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddRoom extends StatefulWidget {
  static const String ROUTE_NAME = 'addRoom';

  @override
  _AddRoomState createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {
  final _addRoomFormKey = GlobalKey<FormState>();

  String roomName = '';

  String description = '';

  List<String> categories = ['movies', 'sports', 'music'];

  String selectedCategory = 'sports';

  bool isLoading = false;

  late CollectionReference<Room> roomRef;

  late AppConfigProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppConfigProvider>(context);
    roomRef = getUserCollectionWithConverter(provider.currentUser!.id);
    return Stack(children: [
      Container(
        decoration: BoxDecoration(
          color: MyThemeData.white,
        ),
        child: Image.asset(
          'assets/images/bg_top_shape.png',
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Route Chat App'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: MyThemeData.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 4,
                    offset: Offset(4, 8), // Shadow position
                  ),
                ]),
            margin: EdgeInsets.symmetric(vertical: 32, horizontal: 12),
            child: ListView(
              //    crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Create New Room',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Image(image: AssetImage('assets/images/add_room_header.png')),
                Form(
                  key: _addRoomFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        onChanged: (text) {
                          roomName = text;
                        },
                        keyboardType: TextInputType.name,

                        decoration: InputDecoration(
                            labelText: 'Enter Room Name',
                            labelStyle: GoogleFonts.poppins(
                              fontSize: 16,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.auto),
                        // The validator receives the text that the user has entered.
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Room Name';
                          }
                          return null;
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 1.0, style: BorderStyle.solid),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            value: selectedCategory,
                            items: categories.map((name) {
                              return DropdownMenuItem(
                                  value: name,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image(
                                            image: AssetImage(
                                              'assets/images/$name.png',
                                            ),
                                            width: 24,
                                            height: 24,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(name),
                                        )
                                      ],
                                    ),
                                  ));
                            }).toList(),
                            onChanged: (newSelected) {
                              setState(() {
                                selectedCategory = newSelected as String;
                              });
                            },
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                            ),
                            icon: Icon(Icons.arrow_drop_down_outlined),
                            isExpanded: true,
                          ),
                        ),
                      ),
                      TextFormField(
                        onChanged: (text) {
                          description = text;
                        },
                        decoration: InputDecoration(
                          labelText: 'Enter  Room Description',
                          labelStyle: GoogleFonts.poppins(
                            fontSize: 16,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter room Description';
                          }
                          return null;
                        },
                      )
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
                    child: ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          )),
                          padding:
                              MaterialStateProperty.all(EdgeInsets.all(20)),
                          minimumSize: MaterialStateProperty.all(Size(40, 50)),
                        ),
                        onPressed: () {
                          if (_addRoomFormKey.currentState?.validate() ==
                              true) {
                            addRoom();
                          }
                        },
                        child: isLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Text('Create'))),
              ],
            ),
          ),
        ),
      )
    ]);
  }

  void addRoom() {
    setState(() {
      isLoading = true;
    });
    final docRef = getRoomsCollectionWithConverter().doc();
    Room room = Room(
        id: docRef.id,
        name: roomName,
        description: description,
        category: selectedCategory);
    docRef.set(room).then((value) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
          msg: 'Room Added Successfully', toastLength: Toast.LENGTH_LONG);
      Navigator.pop(context);
      joinRoom(room);
    });
  }

  joinRoom(Room room) {
    final roomDoc = roomRef.doc(room.id);
    roomDoc.set(room).then((value) {
      Navigator.pushNamed(
        context,
        ChatRoomScreen.ROUTE_NAME,
        arguments: RoomArgs(room),
      );
    });
  }
}
