import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:cloud_firestore/cloud_firestore.dart';

class GroupChat {
  final String groupId;
  final String groupName;
  final List<String> users;

  final Timestamp createdAt;

  GroupChat({
    required this.groupId,
    required this.groupName,

    required this.users,
    required this.createdAt,
  });

  factory GroupChat.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return GroupChat(
      groupId: snapshot.id,
      groupName: data['groupName'],
      users: List<String>.from(data['users']),

      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groupName': groupName,

      'users': users,
      'createdAt': createdAt,
    };
  }
}

class GroupMessage {
  final String messageId;
  final String groupName;
  final String senderEmail;
  final String content;
  final Timestamp createdAt;

  GroupMessage({
    required this.messageId,
    required this.groupName,
    required this.senderEmail,
    required this.content,
    required this.createdAt,
  });

  factory GroupMessage.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return GroupMessage(
      messageId: snapshot.id,
      groupName: data['groupName'],
      senderEmail: data['senderEmail'],
      content: data['content'],
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groupName': groupName,
      'senderEmail': senderEmail,
      'content': content,
      'createdAt': createdAt,
    };
  }
}