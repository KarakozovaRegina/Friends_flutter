import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:friends_1/components/chat_bubble.dart';
import 'package:friends_1/services/auth/auth_service.dart';
import 'package:friends_1/services/chat/chat_service.dart';


class ChatPage extends StatelessWidget {
  final String receiverEmail;
  final String receiverID;

  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });


  //text controller
  final TextEditingController _messageController = TextEditingController();

  // chat & auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();


  // send message
  void sendMessage() async{
     // if there is something inside the textfield
    if(_messageController.text.isNotEmpty){
      // send the message
      await _chatService.sendMessage(receiverID, _messageController.text);

      //clear text controller
      _messageController.clear();
    }
  }


  // scroll controller
  final ScrollController _scrollController = ScrollController();
  void scrollDown(){
    _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn,);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .where('email', isEqualTo: receiverEmail)
            .snapshots(),
        builder: (context, snapshot) {
    if (snapshot.hasData) {
    final client = snapshot.data?.docs.first;
    if (client != null) {

      String base64Image = client['imageURL'];
      Uint8List decodedBytes = base64Decode(base64Image);
      final clientWidget =     Scaffold(
        appBar: AppBar(
          title: Row(
            children: [ CircleAvatar(
              radius: 25,
              backgroundImage: MemoryImage(
                decodedBytes,
              ),
            ),
              SizedBox(width: 10,),
              Text(client['fullname'])
            ],
          ),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        body: Column(
          children: [
            //display all message
            Expanded(
              child: _buildMessageList(),
            ),

            //user input
            _buildUserInput(),
          ],
        ),
      );
      return clientWidget;
    }
    }
    return CircularProgressIndicator();
        }
    );



  }


  // build message list
  Widget _buildMessageList(){
    String senderID = _authService.getCurrentUser()!.uid;

    return StreamBuilder(
        stream: _chatService.getMessages(receiverID, senderID),
        builder: (contex, snapshot){
          // error
          if(snapshot.hasError){
            return const Text("Error");
          }

          // loading
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Text("Loading ...");
          }

          // return list view
          return ListView(
            controller: _scrollController,
            children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
          );

        },
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot doc){
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // is current user
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    // aling message to the right if sender is the current user, otherwise left
    var alingment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: alingment,
      child: Column(
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(message: data["message"], isCurrentUser: isCurrentUser),
        ],
      ),
    );
  }


  //build message input
  Widget _buildUserInput(){
    return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            //textfield should take up most the space
            Expanded(
                child:Container(
                  padding: EdgeInsets.all(15),
                  child:  TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                    ),
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w900
                    ),
                  ),
                ),
            ),

            //send button
            Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromRGBO(209, 135, 49,1),
                      Color.fromRGBO(140, 0, 189,1)],
                  ),
                  border: Border.all(
                    width: 3,
                    style: BorderStyle.solid,
                    color: Colors.transparent,
                  ),
                ),
                margin: const EdgeInsets.only(right: 25),
                child: IconButton(
                    onPressed: sendMessage,
                    icon:const Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                        ))),
          ],
        )
    );
  }
}