import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:friends_1/models/user.dart';
import 'package:friends_1/page/chats.dart';
import 'package:friends_1/page/friends.dart';
import 'package:friends_1/page/utils.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth/auth_service.dart';
import 'editUser.dart';
import 'home.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


Uint8List? _image;




class FriendProfilePage extends StatefulWidget {
  final String text;
  const  FriendProfilePage({
    super.key,
    required this.text,
  });

  @override
  State< FriendProfilePage> createState() => _FriendProfilePageState(text
  );
}

class _FriendProfilePageState extends State< FriendProfilePage> {

  // fetch data from FireStore
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;
  final String text;
  _FriendProfilePageState(this.text);
  String? fieldValue;

  @override
  void initState() {
    super.initState();
  }


  // controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  //save photo
  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bar
      appBar: AppBar(
        title: Text(
          'Frind`s Profile',
          style: TextStyle(fontFamily: 'MontserratSemiBold', fontSize: 18),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),

      //body
      body: Container(
        child:SingleChildScrollView(
          child:  Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 15), //отступ слева и справа для виджетов
              child: Column(
                crossAxisAlignment: CrossAxisAlignment
                    .center, //выровнены по центру вдоль перекрестной оси
                mainAxisAlignment:
                MainAxisAlignment.start, //выровнены по центру вдоль главной оси
                children: [
                  //fetch data from database
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("Users")
                          .where('email', isEqualTo: text)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final client = snapshot.data?.docs.first;
                          if (client != null) {
                            String base64Image = client['imageURL'];
                            Uint8List decodedBytes = base64Decode(base64Image);

                            final clientWidget = Column(
                              children: [
                                SizedBox(
                                  height: 40,
                                ),
                                Center(
                                  child: Container(
                                      height: 130,
                                      width: 130,
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
                                        border: Border.all(
                                          width: 7,
                                          style: BorderStyle.solid,
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage: MemoryImage(
                                          decodedBytes,
                                        ),
                                      )),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                ListTile(
                                  leading: const Icon(Icons.person),
                                  title: const Text(
                                    ' Full name ',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16),
                                  ),
                                  trailing: Text(
                                    client['fullname'],
                                    style: TextStyle(
                                      fontFamily: 'MontserratSemiBold',
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.email),
                                  title: const Text(
                                    ' Email ',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16),
                                  ),
                                  trailing: Text(
                                    client['email'],
                                    style: TextStyle(
                                        fontFamily: 'MontserratSemiBold',
                                        fontSize: 16),
                                  ),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.numbers),
                                  title: const Text(
                                    ' Age ',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16),
                                  ),
                                  trailing: Text(
                                    client['age'],
                                    style: TextStyle(
                                        fontFamily: 'MontserratSemiBold',
                                        fontSize: 16),
                                  ),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.place),
                                  title: const Text(
                                    ' Country ',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16),
                                  ),
                                  trailing: Text(
                                    client['country'],
                                    style: TextStyle(
                                        fontFamily: 'MontserratSemiBold',
                                        fontSize: 16),
                                  ),
                                ),

                              ],
                            );
                            return clientWidget;
                          }
                        }

                        return CircularProgressIndicator();
                      }),
                ],
              )),
        )),


    );
  }
}
