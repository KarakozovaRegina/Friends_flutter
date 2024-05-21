import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:friends_1/page/friendPage.dart';
import 'package:friends_1/page/friends.dart';

class GroupTile extends StatelessWidget{
  final String text;
  final void Function()? onTap;

  const GroupTile({
    super.key,
    required this.text,
    required this.onTap,
  });


  @override
  Widget build(BuildContext contex){
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("GroupChats")
            .where('users', arrayContains: text)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final client = snapshot.data?.docs.first;
            if (client != null) {

              final clientWidget =


              ListTile(
                  leading:  Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.fromRGBO(209, 135, 49, 1),
                            Color.fromRGBO(140, 0, 189, 1)
                          ],
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundImage: Image.asset('assets/group.png').image,
                      )),
                  title: Text(client['groupName'],
                    style: TextStyle(
                        fontFamily: 'MontserratSemiBold',
                        fontSize: 17),),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>FriendProfilePage(text: client["email"]),
                            ),
                          );

                          // Navigator.of(context)
                          //     .push(MaterialPageRoute(builder: (context) => FriendProfilePage(
                          //   text: client["email"],
                          // )));
                        },
                        icon: Icon(Icons.info,
                          color: Colors.pinkAccent,
                        ),
                      ),
                      IconButton(
                        onPressed: onTap,
                        icon: Icon(Icons.message,
                          color: Colors.blue,),
                      ),
                    ],
                  )

              );

              return clientWidget;
            }
          }

          return CircularProgressIndicator();
        });

  }
}