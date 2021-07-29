import 'package:chat/services/auth.dart';
import 'package:chat/services/database.dart';
import 'package:chat/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chattingscreen.dart';
import 'helper/helperFunction.dart';

class Signin extends StatefulWidget {
  final Function toggle;
  Signin(this.toggle);

  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final formKey = GlobalKey<FormState>();
  TextEditingController email = new TextEditingController();
   QuerySnapshot snapshotUserInfo;
  TextEditingController password = new TextEditingController();

  bool isLoading = false;
  signIn(){
    if(formKey.currentState.validate()){

      // HelperFunctions.saveUserName(userName.text);
      HelperFunctions.saveUserEmailPrefence(email.text); 
      databaseMethods.getUsersByEmail(email.text).then((val){
            snapshotUserInfo = val;
            HelperFunctions.saveUserName(snapshotUserInfo.docs[0].get("name"));
          }); 
      setState(() {
        isLoading = true;
      });
          
      authMethods.signInWithEmailAndPassword(email.text, password.text).then((val){
        if(val!=null){
           HelperFunctions.saveUser(true);  
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ChatRoom()),
                );
        }else{
          // return "First please register yourself";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key : formKey,
                    child: Column(
                    children: [
                      TextFormField(
                    controller: email,
                     validator: (val) {
                      return RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
                          )
                      .hasMatch(val)
                                      ? null
                                      : "Enter correct email";
                                },
                      style: textStyle(),
                      decoration: textFieldInputDecoration("Email")),
                  TextFormField(
                    obscureText: true,
                    validator: (val) {
                                  return val.length >= 6
                                      ? null
                                      : "Enter password of at least 6 length";
                                },
                    controller: password,
                      style: textStyle(),
                      decoration: textFieldInputDecoration("Password")),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Text(
                      "Forgot Password",
                      style: textStyle(),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap:(){
                    signIn();
                  },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(colors: [
                          Color(0xff007EF4),
                          Color(0xff2A75BC),
                        ]),
                      ),
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      )
                      ),
                ),
                SizedBox(height: 16),
                Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    child: Text(
                      "Sign In With Google",
                      style: registerStyle(),
                    )),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: registerStyle(),
                    ),
                    GestureDetector(
                      onTap: (){
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Register Now",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            decoration: TextDecoration.underline,
                          ),
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
