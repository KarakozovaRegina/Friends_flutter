import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser ? Color.fromRGBO(140, 0, 189,1) : Colors.grey.shade500,
        borderRadius: BorderRadius.circular(12),
      ),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 25),
        child: Text(message,
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'MontserratSemiBold',
        ),),
    );
  }
}
