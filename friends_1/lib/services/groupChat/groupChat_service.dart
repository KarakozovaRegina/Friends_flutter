import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:friends_1/models/message.dart';

import '../../models/GroupChatRoom.dart';

class GroupChatService{

  // get instance of firestore & auth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser!;


  Stream<List<Map<String, dynamic>>> getGroupsStreamWithUser(String userName) {

      return _firestore.collection("GroupChats").snapshots().map((snapshot){
        return snapshot.docs.map((doc){
          // go thought each individual user
          final user =  doc.data();

          // return user
          return user;
        }).toList();
      });

  }

  String generateRandomGroupId() {
    final random = Random();
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final groupIdLength = 8; // Длина случайной строки groupId

    String randomGroupId = '';
    for (var i = 0; i < groupIdLength; i++) {
      final randomIndex = random.nextInt(chars.length);
      randomGroupId += chars[randomIndex];
    }

    return randomGroupId;
  }



  // // send message
  Future<void> sendMessage(String nameChat, message) async{
    //get current user info
    String randomMessageId = generateRandomGroupId();
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    //create a new message
    GroupMessage newMessage = new GroupMessage(
      messageId:randomMessageId,
      groupName: nameChat,
      senderEmail: currentUserEmail,
      content: message,
      createdAt: timestamp,
    );


    //  add new message to database
   await _firestore.collection("Group_messages").add(newMessage.toMap());


  }

  // get message
  Stream<QuerySnapshot> getMessages(String groupName){

    return _firestore
        .collection("Group_messages")
        .where("groupName", isEqualTo: groupName)
        .orderBy("createdAt", descending: false)
        .snapshots();
  }
}