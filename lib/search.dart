import 'package:chat_in_flutter/helpers/constants.dart';
import 'package:chat_in_flutter/services/database.dart';
import 'package:chat_in_flutter/views/coversation_screen.dart';
import 'package:chat_in_flutter/views/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController searchTextEditingController = TextEditingController();

  QuerySnapshot searchSnapshot;

  initiateSearch() {
    databaseMethods
        .getUserByUsername(searchTextEditingController.text)
        .then((value) {
      setState(() {
        searchSnapshot = value;
      });
    });
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot.docs.length,
            itemBuilder: (context, index) {
              return searchTile(
                userName: searchSnapshot.docs[index].data()["name"],
                userEmail: searchSnapshot.docs[index].data()["email"],
              );
            },
          )
        : Center(child: CircularProgressIndicator());
  }

// create chatroom, send user to conversation screen, push replacement.
  createChatRoomAndStartConversation({String userName}) {
    if (userName != Constants.myName) {
      String chatRoomId = getChatRoomId(userName, Constants.myName);

      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomId": chatRoomId
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConversationScreen(chatRoomId: chatRoomId),
        ),
      );
    } else {
      print("you cannot send message to youself");
    }
  }

  Widget searchTile({String userName, String userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: simpleTextStyle(),
              ),
              Text(
                userEmail,
                style: simpleTextStyle(),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomAndStartConversation(userName: userName);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(30)),
              child: Text(
                "Message",
                style: simpleTextStyle(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    initiateSearch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context, title: "Search"),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: searchTextEditingController,
                    style: TextStyle(color: Colors.white54),
                    decoration: InputDecoration(
                      hintText: "search username...",
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                    ),
                  )),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            const Color(0x36FFFFFF),
                            const Color(0x0FFFFFFF)
                          ]),
                          borderRadius: BorderRadius.circular(40)),
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
