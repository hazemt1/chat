import 'package:chat/chatRoom/ChatRoomScreen.dart';
import 'package:chat/model/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat/model/Message.dart';
import 'package:chat/model/Room.dart';
import 'package:flutter/material.dart';


CollectionReference<User> getUsersCollectionWithConverter() {
  return FirebaseFirestore.instance.collection(User.COLLECTION_NAME)
      .withConverter<User>(
    fromFirestore: (snapshot, _) =>
        User.fromJson(snapshot.data()!),
    toFirestore: (user, _) => user.toJson(),
  );
}

CollectionReference<Room> getRoomsCollectionWithConverter(){
  return FirebaseFirestore.instance.collection(Room.COLLECTION_NAME)
      .withConverter<Room>(fromFirestore: (snapshot,_)=>Room.fromJson(snapshot.data()!)
      , toFirestore: (room,_) => room.toJson());
}

CollectionReference<User> getRoomCollectionWithConverter(String roomID){
  final userCollection =getRoomsCollectionWithConverter();

  return userCollection.doc(roomID).collection(User.COLLECTION_NAME)
      .withConverter(fromFirestore: (snapshot,_)=>User.fromJson(snapshot.data()!),
      toFirestore: (user,_)=>user.toJson());
}

CollectionReference<Message> getMessageCollectionWithConverter(String roomId){
  final roomCollection =getRoomsCollectionWithConverter();

  return roomCollection.doc(roomId).collection(Message.COLLECTION_NAME)
      .withConverter(fromFirestore: (snapshot,_)=>Message.fromJson(snapshot.data()!),
      toFirestore: (message,_)=>message.toJson());
}

CollectionReference<Room> getUserCollectionWithConverter(String userId){
  final userCollection =getUsersCollectionWithConverter();

  return userCollection.doc(userId).collection(Room.COLLECTION_NAME)
      .withConverter(fromFirestore: (snapshot,_)=>Room.fromJson(snapshot.data()!),
      toFirestore: (room,_)=>room.toJson());
}

void leaveRoom(Room room, User user, BuildContext context){
  final CollectionReference<Room> roomRef = getUserCollectionWithConverter(user.id);
  final roomDoc = roomRef.doc(room.id);
  final userDoc = getRoomCollectionWithConverter(room.id).doc(user.id);
  print(user.id);
  userDoc.delete();
  roomDoc.delete();
  Navigator.pop(context);
}

void joinRoom(Room room, User user, BuildContext context) {
  final CollectionReference<Room> roomRef = getUserCollectionWithConverter(user.id);
  final roomDoc = roomRef.doc(room.id);
  final userDoc = getRoomCollectionWithConverter(room.id).doc(user.id);
  userDoc.set(user);

  roomDoc.set(room).then((value) {
    Navigator.pushNamed(
      context,
      ChatRoomScreen.ROUTE_NAME,
      arguments: RoomArgs(room),
    );
  });
}