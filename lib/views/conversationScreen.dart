import 'dart:io';

import 'package:chatup/helper/constants.dart';
import 'package:chatup/services/database.dart';
import 'package:chatup/views/imageview.dart';
import 'package:chatup/views/mapview.dart';
import 'package:chatup/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:simple_permissions/simple_permissions.dart';

class ConversationScreen extends StatefulWidget {

  final String chatRoomId;
  ConversationScreen(this.chatRoomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods _database = new DatabaseMethods();
  Location location = new Location();
//  Permission permission;


  TextEditingController messageController = new TextEditingController();
  Stream chatMessagesStream;

  File imageFile;

  Widget chatMessageList(){
    return StreamBuilder(
      stream: chatMessagesStream,
      builder: (context,snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index){
            return MessageTile(message : snapshot.data.documents[index].data["message"],
              isSentByMe: Constants.myName == snapshot.data.documents[index].data["sentBy"],);
          },
        ) : Container(
          child: Center(child: CircularProgressIndicator()),
        );
      }
    );
  }

  sendMessage(){
    if(messageController.text.isNotEmpty){
      Map<String,dynamic> messageMap = {
        "message" : messageController.text,
        "sentBy" : Constants.myName,
        "time" : DateTime.now().millisecondsSinceEpoch
      };

      _database.addConversationMessages(widget.chatRoomId, messageMap);
    }
  }

  _openGallery(BuildContext context) async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {

    });
    Navigator.push(context, MaterialPageRoute(builder: (context) => ImageDisplay(imageFile)));
  }

  _openCamera(BuildContext context) async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {

    });
    Navigator.push(context, MaterialPageRoute(builder: (context) => ImageDisplay(imageFile)));
  }

  Future<void> _showChoiceDialog(BuildContext context){
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text("Make a choice"),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                child: Text("Gallery"),
                onTap: (){
                  _openGallery(context);
                },
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 6),),
              GestureDetector(
                child: Text("Camera"),
                onTap: (){
                  _openCamera(context);
                },
              )
            ],
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    _database.getConversationMessages(widget.chatRoomId).then((value){
      setState(() {
        chatMessagesStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Image.asset("assets/images/logo.png", height:70,),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person_pin_circle),
            label: Text("Show"),
            onPressed: () async {
              final res = await SimplePermissions.requestPermission(Permission.AccessFineLocation);
              print("permission request result is " + res.toString());
              Navigator.push(context, MaterialPageRoute(builder: (context) => MapView()));
            },
          ),
          FlatButton.icon(
            icon: Icon(Icons.pin_drop),
            label: Text("Get"),
            onPressed: (){},
          )
        ],
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0x54FFFFFF),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        _showChoiceDialog(context);
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                const Color(0x36FFFFFF),
                                const Color(0x0FFFFFFF)
                              ]),
                              borderRadius: BorderRadius.circular(40)),
                          child: Icon(Icons.camera_alt, color: Colors.white,)),
                    ),
                    Expanded(
                        child: TextField(
                          controller: messageController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: "Message...",
                              hintStyle: TextStyle(color: Colors.white54),
                              border: InputBorder.none),
                        )),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
                        messageController.text = "";
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                const Color(0x36FFFFFF),
                                const Color(0x0FFFFFFF)
                              ]),
                              borderRadius: BorderRadius.circular(40)),
                          child: Image.asset("assets/images/send.png")),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSentByMe;
  MessageTile({this.message, this.isSentByMe});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      width: MediaQuery.of(context).size.width,
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical:16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSentByMe ? [
              const Color(0xff007EF4),
              const Color(0xff2A75BC)
            ]
                : [
              const Color(0x1AFFFFFF),
              const Color(0x1AFFFFFF)
            ],
          ),
          borderRadius: isSentByMe ?
          BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
            bottomLeft: Radius.circular(24)
          ) : BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
              bottomRight: Radius.circular(24)
          )
        ),
        child: Text(message, style: TextStyle(
          color: Colors.white,
          fontSize: 17
        )),
      ),
    );
  }
}

