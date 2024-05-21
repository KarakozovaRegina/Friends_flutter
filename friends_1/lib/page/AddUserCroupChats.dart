import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friends_1/models/user.dart';
import 'package:friends_1/page/GroupChatPage.dart';
import 'package:friends_1/page/utils.dart';
import 'package:friends_1/services/chat/chat_service.dart';
import 'package:image_picker/image_picker.dart';

import '../components/user_tile.dart';
import '../models/GroupChatRoom.dart';
import '../services/auth/auth_service.dart';

Uint8List? _image;


// chat & auth service
final ChatService _chatService = ChatService();
final AuthService _authService = AuthService();

// fetch data from FireStore
final FirebaseFirestore firestore = FirebaseFirestore.instance;

final user = FirebaseAuth.instance.currentUser!;

final TextEditingController nameChatController = TextEditingController();
final TextEditingController user1Controller = TextEditingController();
final TextEditingController user2Controller = TextEditingController();
final TextEditingController user3Controller = TextEditingController();

final String user1Name = user1Controller.text;
final String user2Name = user2Controller.text;
final String user3Name = user3Controller.text;

class AddUserGroupChatPage extends StatefulWidget {
  const AddUserGroupChatPage({super.key});

  @override
  State<AddUserGroupChatPage> createState() => _AddUserGroupChatPageState();
}

class _AddUserGroupChatPageState extends State<AddUserGroupChatPage> {

// Генерация случайной строки для groupId
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

  //save photo
  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  Future<void> createChat() async {
   // String base64Image = base64Encode(_image!);
    String randomGroupId = generateRandomGroupId();
    String userName = '';
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: user.email)
        .get();
    DocumentSnapshot userDoc = querySnapshot.docs[0];


    final userData1 = userDoc.data() as Map<String, dynamic>;
     userName = userData1['email'];


    GroupChat group = GroupChat(
      groupId: randomGroupId,
      groupName: nameChatController.text,
      users: [user1Name, user2Name, user3Name, userName],
      createdAt: Timestamp.now(),
    );


    try {
      await FirebaseFirestore.instance
          .collection('GroupChats').add(group.toMap());

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (contex) => GroupChatPage(
                nameChat: nameChatController.text,
                userEmail: user.email!,
              )));
    } catch (e) {
      print('Ошибка при добавлении группового чата: $e');
    }



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        // bar
        appBar: AppBar(
          title: Text(
            'Add User for Group',
            style: TextStyle(fontFamily: 'MontserratSemiBold', fontSize: 18),
          ),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),

        //body
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.all(30),
                  child: Column(
                    children: [
                      // Container(
                      //   decoration: BoxDecoration(
                      //     shape: BoxShape.circle,
                      //     gradient: LinearGradient(
                      //       begin: Alignment.topLeft,
                      //       end: Alignment.bottomRight,
                      //       colors: [
                      //         Color.fromRGBO(209, 135, 49, 1),
                      //         Color.fromRGBO(140, 0, 189, 1)
                      //       ],
                      //     ),
                      //     border: Border.all(
                      //       width: 5,
                      //       style: BorderStyle.solid,
                      //       color: Colors.transparent,
                      //     ),
                      //   ),
                      //   child: Stack(
                      //     children: [
                      //       _image != null
                      //           ? CircleAvatar(
                      //         radius: 50,
                      //         backgroundImage: MemoryImage(_image!),
                      //       )
                      //           : const CircleAvatar(
                      //         radius: 50,
                      //         backgroundImage: NetworkImage(
                      //             'https://n34.mx/wp-content/uploads/2021/02/user-evaluacion-notaria-34.png'),
                      //       ),
                      //       Positioned(
                      //         child: IconButton(
                      //           onPressed: selectImage,
                      //           icon: Icon(Icons.add_a_photo),
                      //         ),
                      //         bottom: -15,
                      //         left: 64,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(height: 20),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                          child: Column(
                        children: [
                          TextField(
                            controller: nameChatController,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w900),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.chat_outlined,
                                    size: 35, color: Colors.purple),
                                border: UnderlineInputBorder(
                                    // Нижняя граница
                                    borderSide: BorderSide(
                                  color: Colors.blue, // Цвет границы
                                  width: 2.0, // Толщина границы
                                )),
                                hintText: "Name chat"),
                          ),
                          SizedBox(height: 40),
                          TextField(
                            controller: user1Controller,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w900),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email,
                                    size: 35, color: Colors.indigo[400]),
                                border: UnderlineInputBorder(
                                    // Нижняя граница
                                    borderSide: BorderSide(
                                  color: Colors.blue, // Цвет границы
                                  width: 2.0, // Толщина границы
                                )),
                                hintText: "User 1"),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextField(
                            controller: user2Controller,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w900),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email,
                                    size: 35, color: Colors.indigo[400]),
                                border: UnderlineInputBorder(
                                    // Нижняя граница
                                    borderSide: BorderSide(
                                  color: Colors.blue, // Цвет границы
                                  width: 2.0, // Толщина границы
                                )),
                                hintText: "User 2"),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextField(
                            controller: user3Controller,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w900),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email,
                                    size: 35, color: Colors.indigo[400]),
                                border: UnderlineInputBorder(
                                    // Нижняя граница
                                    borderSide: BorderSide(
                                  color: Colors.blue, // Цвет границы
                                  width: 2.0, // Толщина границы
                                )),
                                hintText: "User 3"),
                          ),
                        ],
                      )),
                      SizedBox(
                        height: 49,
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(209, 135, 49, 1),
                                Color.fromRGBO(140, 0, 189, 1)
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                              child: ElevatedButton(
                            onPressed: () {
                              createChat();
                            },
                            child: Row(
                              children: [
                                Text(
                                  'CREATE',
                                  style: TextStyle(
                                      fontFamily: 'MontserratSemiBold',
                                      fontSize: 16,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              minimumSize: Size(158, 57),
                              textStyle: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                              elevation: 0.0,
                              padding: EdgeInsets.all(20),
                            ),
                          )),
                        ),
                      ])
                    ],
                  ),
                )
              ],
            ),
          ),
        )
        // _buildUserList(),
        );
  }
}
