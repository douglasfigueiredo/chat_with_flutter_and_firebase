import 'package:chat_in_flutter/helpers/helperFunctions.dart';
import 'package:chat_in_flutter/services/auth.dart';
import 'package:chat_in_flutter/services/database.dart';
import 'package:chat_in_flutter/views/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chatRoomsScreen.dart';

class SignIn extends StatefulWidget {
  final Function toggle;

  const SignIn({Key key, this.toggle}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;

  signIn() {
    if (formKey.currentState.validate()) {
      HelperFunctions.saveUserEmailSharedPreference(
          emailTextEditingController.text);

      databaseMethods
          .getUserByUserEmail(emailTextEditingController.text)
          .then((value) {
        setState(() {
          snapshotUserInfo = value;
          HelperFunctions.saveUserNameSharedPreference(
              value.docs[0].data()["name"]);
        });
      });

      setState(() {
        isLoading = true;
      });

      authMethods
          .signInWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then(
        (value) {
          if (value != null) {
            HelperFunctions.saveUserLoggedInSharedPreference(true);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ChatRoom(),
              ),
            );
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context, title: "SignIn"),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val)
                              ? null
                              : "Enter correct email";
                        },
                        controller: emailTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration("email"),
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (val) {
                          return val.length < 6
                              ? "Enter Password 6+ characters"
                              : null;
                        },
                        controller: passwordTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration("password"),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      "Forgot Password?",
                      style: simpleTextStyle(),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    signIn();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.deepOrange,
                            Colors.deepOrangeAccent,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30)),
                    child: Text(
                      "Sign In",
                      style: mediumTextStyle(textColor: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: Text(
                    "Sign In with Google",
                    style: mediumTextStyle(textColor: Colors.black87),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have account? ",
                      style: mediumTextStyle(textColor: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Register now",
                          style: mediumTextStyle(
                              textColor: Colors.white,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
