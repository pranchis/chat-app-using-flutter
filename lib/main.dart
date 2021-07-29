import 'package:chat/chatroom.dart';
import 'package:chat/helper/authenticate.dart';
import 'package:chat/helper/helperFunction.dart';
import 'package:chat/signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'chattingscreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogin = false;
  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async{
    await HelperFunctions.getUser().then((val){
      setState(() {
        isLogin = val;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff145C9E),
        scaffoldBackgroundColor: Color(0xff1F1F1F),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:isLogin!=null ? isLogin ? ChatRoom():Authenticate():Container(
        child: Center(
          child:Authenticate(),
        ),
      ),
    );
  }
}


class NullUser extends StatefulWidget {
  @override
  _NullUserState createState() => _NullUserState();
}

class _NullUserState extends State<NullUser> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}