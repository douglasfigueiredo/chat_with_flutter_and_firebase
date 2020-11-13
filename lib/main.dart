import 'package:chat_in_flutter/helpers/authenticate.dart';
import 'package:chat_in_flutter/helpers/helperFunctions.dart';
import 'package:chat_in_flutter/search.dart';
import 'package:chat_in_flutter/views/chatRoomsScreen.dart';
import 'package:chat_in_flutter/views/signIn.dart';
import 'package:chat_in_flutter/views/signUp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF1F1F1F),
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: userIsLoggedIn != null
          ? /**/ userIsLoggedIn
              ? ChatRoom()
              : Authenticate() /**/ : blankScreen(),
    );
  }
}

class blankScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
