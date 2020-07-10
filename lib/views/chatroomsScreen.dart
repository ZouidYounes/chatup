import 'package:chatup/helper/authenticate.dart';
import 'package:chatup/helper/constants.dart';
import 'package:chatup/helper/helperfunctions.dart';
import 'package:chatup/services/auth.dart';
import 'package:chatup/services/database.dart';
import 'package:chatup/views/conversationScreen.dart';
import 'package:chatup/views/search.dart';
import 'package:chatup/views/signin.dart';
import 'package:chatup/widgets/widget.dart';
import "package:flutter/material.dart";

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods _auth = new AuthMethods();
  DatabaseMethods _database = new DatabaseMethods();

  Stream chatRoomsStream;

  Widget chatRoomsList(){
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
            return ChatRoomTile(snapshot.data.documents[index].data["chatroomId"]
                .toString().replaceAll("_", "").replaceAll(Constants.myName, ""),
                snapshot.data.documents[index].data["chatroomId"]);
            }
        ): Container();
      }
    );
  }

  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    _database.getChatRooms(Constants.myName).then((val){
      setState(() {
        chatRoomsStream = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/logo.png", height:70,),
        actions: <Widget>[
          GestureDetector(
            onTap: (){
              _auth.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => Authenticate()
              ));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: chatRoomsList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => SearchScreen()
          ));
        },
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomTile(this.userName, this.chatRoomId);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(chatRoomId)
        ));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        margin: EdgeInsets.symmetric(vertical : 5),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40)
              ),
              child: Text("${userName.substring(0,1).toUpperCase()}", style: mediumTextStyle()),
            ),
            SizedBox(width: 8),
            Text(userName, style: mediumTextStyle())
          ],
        )
      ),
    );
  }
}

