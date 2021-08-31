import 'package:chat/model/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat/model/Message.dart';
import 'package:chat/model/Room.dart';


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