import 'package:chat/chattingscreen.dart';
import 'package:chat/helper/constants.dart';
import 'package:chat/helper/helperFunction.dart';
import 'package:chat/services/database.dart';
import 'package:chat/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chatroom.dart';


class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}
  String _myName;

class _SearchState extends State<Search> {
  TextEditingController searchtext = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot searchData;
  @override
searching(){
databaseMethods.getUsers(searchtext.text)
.then((val){
  setState(() {
  searchData = val;
  });
});
}




  Widget searchList(){
    return searchData !=null ? ListView.builder(
      shrinkWrap: true,
      itemCount: searchData.docs.length,
      itemBuilder: (context,index){
      return SearchTile(
        username:searchData.docs[index].get("name"),
        email:searchData.docs[index].get("email"),
      );
    }):Container(

    );
  }

  createChatRoomChatting({String username}){
  if(username != Constants.myName){
    String chatRoomid  = getChatRoomId(username,Constants.myName);
  List<String> users = [
    username,
    Constants.myName,
  ];
  Map<String,dynamic> chatRoomMap = {
    "users":users,
    "chatroomid":chatRoomid
  };
  DatabaseMethods().createChat(chatRoomid,chatRoomMap);
  Navigator.push(context,MaterialPageRoute(
    builder: (context) => ChattingRoom(
      chatRoomid
    ),
  ));
  }else{
    print("Saaley");
  }
}

Widget SearchTile({String username,String email}){
  return Container(
      padding: EdgeInsets.symmetric(horizontal:24.0, vertical:16.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,style:registerStyle(),
              ),
              Text(email,style: registerStyle()),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              createChatRoomChatting(username:username);
            },
                      child: Container(
              padding:EdgeInsets.symmetric(horizontal:16,vertical:16),
              child: Text("Chat",style:registerStyle()),
              decoration:BoxDecoration(
                color:Colors.purple,
                borderRadius: BorderRadius.circular(40.0),
              )
            ),
          )
        ],
      ),
    );
}

  void initState() {
    getUserInfo();
    super.initState();
  }


  getUserInfo() async{
    _myName = await HelperFunctions.getName();
    setState(() {
      
    });
  }



  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              color:Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal:24,vertical:16),
              child: Row(
                children: [
                  Expanded(child: TextField(
                    controller:searchtext,
                    style: TextStyle(
                        color:Colors.white,
                      ),
                    decoration: InputDecoration(
                      hintText: "Search !!",
                      hintStyle: TextStyle(
                        color:Colors.white54,
                      ),
                      border: InputBorder.none,
                    ),
                  )),
                  GestureDetector(
                    onTap:(){
                    searching();
                    },
                      child: Container(
                      height: 40.0,
                      width: 40.0,
                      decoration:BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Color(0x36FFFFFF),
                          Color(0x0FFFFFF),
                        ]),
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      padding: EdgeInsets.all(15.0),
                      child: Image.asset("assets/images/search_white.png")),
                  ),
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




getChatRoomId(String a,String b){
  if(a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)){
    return "$b\_$a";
  }else{
    return "$a\_$b";
  }
}

