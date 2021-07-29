import 'package:chat/chatroom.dart';
import 'package:chat/helper/authenticate.dart';
import 'package:chat/helper/constants.dart';
import 'package:chat/helper/helperFunction.dart';
import 'package:chat/search.dart';
import 'package:chat/services/auth.dart';
import 'package:chat/services/database.dart';
import 'package:chat/widgets/widget.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods auth = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomStream;
  Widget chatRoomList() {
    return Container(
      child: StreamBuilder(
        stream: chatRoomStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  // shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(snapshot.data.docs[index].data()['chatroomid']
                        .toString()
                        .replaceAll("_", " ").replaceAll(Constants.myName," "),snapshot
                        .data.docs[index].data()['chatroomid']);
                  })
              : Container();
        },
      ),
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getName();
    databaseMethods.getChatRooms(Constants.myName).then((val) {
      setState(() {
        chatRoomStream = val;
      });
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/logo.png",
          height: 40,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              auth.signOuts();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          ),
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Search()));
        },
      ),
    );
  }
}

class ListTile extends StatelessWidget {
  final String username;
  final String chatroomid;
  ListTile(this.username,this.chatroomid);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:(){
        Navigator.push(context, MaterialPageRoute(
          builder: (context)=>ChattingRoom(chatroomid)
        ));
      },
          child: Container(
            color: Colors.black38,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(45),
              ),
              child: Text("${username.substring(0, 1)}"),
            ),
            SizedBox(width: 8),
            Text(
              username,
              style: registerStyle(),
            ),
          ],
        ),
      ),
    );
  }
}
