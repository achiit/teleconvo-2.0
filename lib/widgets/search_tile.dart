import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:teleconvo/providers/general/chatroom_provider.dart';
import 'package:teleconvo/screens/chat_screen.dart';

class SearchTile extends StatelessWidget {
  SearchTile(
      {super.key,
      required this.imgLink,
      required this.userName,
      required this.userId,
      required this.email});

  late String imgLink;
  late String userId;
  late String userName;
  late String email;
  late String chatroomId;
  final _auth = FirebaseAuth.instance;

  getCurrentUserEmailID() {
    return _auth.currentUser?.email;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              Colors.lightBlueAccent,
          backgroundImage: NetworkImage(imgLink),
          child: Text(
                  userName[0].toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                )
        ),
        title: Text(userName),
        subtitle: Text(email),
        trailing: GestureDetector(
          onTap: () {
            final myEmail = getCurrentUserEmailID();
            chatroomId = Provider.of<ChatRoomProvider>(context, listen: false)
                .setChatroomID(myEmail, email);
            Map<String, dynamic> chatroomData = {
              'array': [myEmail, email],
            };
            ChatRoomProvider.createChatroom(chatroomId, chatroomData);
            Provider.of<ChatRoomProvider>(context, listen: false)
                .setOtherUserImg(imgLink);
            Navigator.push(
                (context),
                MaterialPageRoute(
                    builder: (context) => ChatScreen(
                        chatroomID: chatroomId,
                        user2: userName,
                        userImg: imgLink,
                        user2Id:
                            userId //TODO: add blank image in assets for default
                        )));
          },
          child: const Icon(
            Icons.send,
            color: Colors.lightBlueAccent,
          ),
        ),
      ),
    );
  }
}
