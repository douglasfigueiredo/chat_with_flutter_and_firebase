import 'package:chat_in_flutter/helpers/authenticate.dart';
import 'package:chat_in_flutter/helpers/constants.dart';
import 'package:chat_in_flutter/helpers/helperFunctions.dart';
import 'package:chat_in_flutter/search.dart';
import 'package:chat_in_flutter/services/auth.dart';
import 'package:chat_in_flutter/services/database.dart';
import 'package:chat_in_flutter/views/coversation_screen.dart';
import 'package:chat_in_flutter/views/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();

  Stream<QuerySnapshot> chatRoomsStream;

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return ChatRoomTile(
                    userName: snapshot.data.docs[index]
                        .data()["chatroomId"]
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),
                    chatRoomId: snapshot.data.docs[index].data()["chatroomId"],
                  );
                },
              )
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((value) {
      setState(() {
        chatRoomsStream = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(
        context,
        title: "Chat Room",
        actions: [
          GestureDetector(
            onTap: () {
              authMethods.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Authenticate(),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchScreen(),
            ),
          );
        },
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  const ChatRoomTile({Key key, this.userName, this.chatRoomId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConversationScreen(chatRoomId: chatRoomId),
          ),
        );
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text(
                "${userName.substring(0, 1).toUpperCase()}",
                style: simpleTextStyle(),
              ),
            ),
            SizedBox(width: 8),
            Text(
              userName,
              style: simpleTextStyle(),
            ),
          ],
        ),
      ),
    );
  }
}
