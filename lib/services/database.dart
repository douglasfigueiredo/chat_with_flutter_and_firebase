import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection("users");
  CollectionReference _chatRoomCollection =
      FirebaseFirestore.instance.collection("chatRoom");

  Future<QuerySnapshot> getUserByUsername(String username) async {
    return await _usersCollection.where("name", isEqualTo: username).get();
  }

  Future<QuerySnapshot> getUserByUserEmail(String userEmail) async {
    return await _usersCollection.where("email", isEqualTo: userEmail).get();
  }

  uploadUserInfo(userMap) {
    _usersCollection.add(userMap);
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    _chatRoomCollection.doc(chatRoomId).set(chatRoomMap).catchError((onError) {
      print(onError.toString());
    });
  }

  addConversationMessages(String chatRoomId, messageMap) {
    _chatRoomCollection
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((onError) {
      print(onError.toString());
    });
  }

  getConversationMessages(String chatRoomId) async {
    return await _chatRoomCollection
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: true)
        .snapshots();
  }

  getChatRooms(String userName) async {
    return await _chatRoomCollection
        .where("users", arrayContains: userName)
        .snapshots();
  }
}
