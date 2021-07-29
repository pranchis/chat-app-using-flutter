import 'package:chat/helper/constants.dart';
import 'package:chat/services/database.dart';
import 'package:chat/widgets/widget.dart';
import 'package:flutter/material.dart';

class ChattingRoom extends StatefulWidget {
  final String chatroomid;
  ChattingRoom(this.chatroomid);
  @override
  _ChattingRoomState createState() => _ChattingRoomState();
}

class _ChattingRoomState extends State<ChattingRoom> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();
  Stream chatMessageStream; 

// data.docs[index].data['message'],
  Widget chatMessageList(){
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context,snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context,index){
            return MessageTile(snapshot.data.docs[index].data()['message'],
            snapshot.data.docs[index].data()['sendby']==Constants.myName);
          }
          ):Container();
      },
    );
  }

  sendMessage(){
    if(messageController.text.isNotEmpty){
    Map<String,dynamic> messageMap = {
      "message":messageController.text,
      "sendby":Constants.myName,
      "time"  : DateTime.now().millisecondsSinceEpoch,
    };
    databaseMethods.addMessage(widget.chatroomid,messageMap);
    messageController.text="";
  }
  }

  @override
  void initState() {
    databaseMethods.getMessages(widget.chatroomid).then((val){
setState(() {
        chatMessageStream =  val;
});
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),

      body: Container(
        child: Stack(
          children:[
          chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color:Color(0x54FFFFFF),
                padding: EdgeInsets.symmetric(horizontal:24,vertical:16),
                child: Row(
                  children: [
                    Expanded(child: TextField(
                      controller:messageController,
                      style: TextStyle(
                          color:Colors.white,
                        ),
                      decoration: InputDecoration(
                        hintText: "Message !!",
                        hintStyle: TextStyle(
                          color:Colors.white54,
                        ),
                        border: InputBorder.none,
                      ),
                    )),
                    GestureDetector(
                      onTap:(){
                      sendMessage();
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
                        child: Image.asset("assets/images/send.png")),
                    ),
                  ],
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByme;
  MessageTile(this.message,this.isSendByme);
  @override
  Widget build(BuildContext context) {
    return Container(
       padding:EdgeInsets.only(left:isSendByme ? 0:25,right: isSendByme ? 25:0),
      margin: EdgeInsets.symmetric(vertical:8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByme ? Alignment.centerRight : Alignment.centerLeft ,
          child: Container(
            padding:EdgeInsets.symmetric(horizontal:24, vertical:18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isSendByme ? [
                const Color(0xff007EF4),
                const Color(0xff2A75BC)
              ]
                  : [
                const Color(0x1AFFFFFF),
                const Color(0x1AFFFFFF)
              ],
              ),
              borderRadius: isSendByme ? BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight:Radius.circular(25),
                bottomLeft:Radius.circular(25),
              ):BorderRadius.only(
                 topLeft: Radius.circular(25),
                 topRight:Radius.circular(25),
                 bottomRight: Radius.circular(25),
              )
            ),
        child: Text(
          message,
          style: TextStyle(
      color: Colors.black,
      fontSize: 17,
  ),
        ),
      ),
    );
  }
}