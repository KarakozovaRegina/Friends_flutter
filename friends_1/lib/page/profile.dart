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


final TextEditingController passwordController = TextEditingController();
final TextEditingController fullnameController = TextEditingController();
final TextEditingController ageController = TextEditingController();
final TextEditingController countryController = TextEditingController();

Uint8List? _image;




class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // fetch data from FireStore
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;

  String? fieldValue;

  @override
  void initState() {
    super.initState();
  }

// //sing out
//   loginOut() {
//     final _auth = AuthService();
//     _auth.singOut();
//   }

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

  // edit user
  Future<void> _openAlertDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: SingleChildScrollView(
            child: AlertDialog(
              backgroundColor: Colors.purple[800],
              title: Text(
                'Edit user',
                style: TextStyle(
                  fontFamily: 'MontserratSemiBold',
                  color: Colors.white,
                ),
              ),
              content: Column(
                children: [
                  SizedBox(height: 20),
                  Container(
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
                        width: 5,
                        style: BorderStyle.solid,
                        color: Colors.transparent,
                      ),
                    ),
                    child: Stack(
                      children: [
                        _image != null
                            ? CircleAvatar(
                          radius: 50,
                          backgroundImage: MemoryImage(_image!),
                        )
                            : const CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                              'https://n34.mx/wp-content/uploads/2021/02/user-evaluacion-notaria-34.png'),
                        ),
                        Positioned(
                          child: IconButton(
                            onPressed: selectImage,
                            icon: Icon(Icons.add_a_photo),
                          ),
                          bottom: -15,
                          left: 64,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: fullnameController,
                    style: TextStyle(
                        fontFamily: 'Montserrat', fontWeight: FontWeight.w900),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: "Full name",
                        hintStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w900,
                            color: Colors.pinkAccent),
                        prefixIcon:
                            Icon(Icons.person, size: 35, color: Colors.white),
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    style: TextStyle(
                        fontFamily: 'Montserrat', fontWeight: FontWeight.w900),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w900,
                            color: Colors.pinkAccent),
                        prefixIcon:
                        Icon(Icons.lock, size: 35, color: Colors.white),
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: ageController,
                    style: TextStyle(
                        fontFamily: 'Montserrat', fontWeight: FontWeight.w900),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: "Age",
                        hintStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w900,
                            color: Colors.pinkAccent),
                        prefixIcon:
                        Icon(Icons.numbers, size: 35, color: Colors.white),
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: countryController,
                    style: TextStyle(
                        fontFamily: 'Montserrat', fontWeight: FontWeight.w900),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: "Country",
                        hintStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w900,
                            color: Colors.pinkAccent),
                        prefixIcon:
                        Icon(Icons.place, size: 35, color: Colors.white),
                        border: OutlineInputBorder()),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text(
                    'CANCEL',
                    style: TextStyle(
                      fontFamily: 'MontserratSemiBold',
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(
                    'SAVE',
                    style: TextStyle(
                      fontFamily: 'MontserratSemiBold',
                      color: Colors.pinkAccent,
                    ),
                  ),
                  onPressed: () {

                    if (_image == null) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text('Upload a photo.'),
                            actions: [
                              TextButton(
                                child: Text('Ok'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                      return;
                    }

                    if (passwordController.text.isEmpty ||
                        fullnameController.text.isEmpty ||
                        ageController.text.isEmpty ||
                        countryController.text.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text('Fill in all the fields.'),
                            actions: [
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }else{
                      EditAccount();
                      Navigator.of(context).pop();
                    }

                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> EditAccount() async {
    try {
      String base64Image = base64Encode(_image!);
      FirebaseFirestore.instance
          .collection("Users")
          .where('uid', isEqualTo: user.uid!)
          .get()
          .then((QuerySnapshot snapshot) {
        if (snapshot.docs.isNotEmpty) {
          DocumentReference userRef = snapshot.docs[0].reference;
          userRef.update({
            "fullname": fullnameController.text,
            "password": passwordController.text,
            "age": ageController.text,
            "country": countryController.text,
            "imageURL": base64Image,
          });
        }
      });


    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Ошибка входа'),
            content: Text(e.code),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ));
    }

  }

  // delete user
  Future<void> deleteUser() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Message',
            style: TextStyle(
              fontFamily: 'MontserratSemiBold',
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.purple[800],
          content: Text(
            "Are you sure you want to delete your account?",
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'CANCEL',
                style: TextStyle(
                  fontFamily: 'MontserratSemiBold',
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'DELETE',
                style: TextStyle(
                  fontFamily: 'MontserratSemiBold',
                  color: Colors.pinkAccent,
                ),
              ),
              onPressed: () async {
                // DocumentReference userDocRef = FirebaseFirestore.instance.collection('Users').doc(user.uid);
                // userDocRef.delete();

                // await FirebaseFirestore.instance
                //     .collection("Users")
                //     .doc(user.uid)
                //     .delete();

                deleteUserAccount();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteUserAccount() async {
    try {
      await FirebaseAuth.instance.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Ошибка входа'),
                content: Text(e.code),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ));
      // Handle general exception
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bar
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(fontFamily: 'MontserratSemiBold', fontSize: 18),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),

      //body
      body: Container(
        child:SingleChildScrollView(
          child:   Padding(
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
                          .where('uid', isEqualTo: user.uid!)
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
                                SizedBox(
                                  height: 220,
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
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
                                                _openAlertDialog();
                                              },
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'UPDATE',
                                                    style: TextStyle(
                                                        fontFamily:
                                                        'MontserratSemiBold',
                                                        fontSize: 16,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.transparent,
                                                minimumSize: Size(180, 57),
                                                textStyle: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500),
                                                elevation: 0.0,
                                                padding: EdgeInsets.all(20),
                                              ),
                                            )),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
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
                                                deleteUser();
                                              },
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'DELETE',
                                                    style: TextStyle(
                                                        fontFamily:
                                                        'MontserratSemiBold',
                                                        fontSize: 16,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.transparent,
                                                minimumSize: Size(180, 57),
                                                textStyle: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500),
                                                elevation: 0.0,
                                                padding: EdgeInsets.all(20),
                                              ),
                                            )),
                                      ),
                                    ])
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




      //menu
      drawer: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .where('email', isEqualTo: user.email!)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final client = snapshot.data?.docs.first;
              if (client != null) {
                String base64Image = client['imageURL'];
                Uint8List decodedBytes = base64Decode(base64Image);

                final clientWidget = Drawer(
                    child: Container(
                  color: Colors.white,
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 60,
                      ),

                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Image(
                              image: AssetImage('assets/logoColor.png'),
                              width: 100,
                              height: 78,
                              fit: BoxFit.cover,
                            ),
                          ]),

                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.person),
                              title: const Text(
                                ' Profile ',
                                style: TextStyle(
                                    fontFamily: 'MontserratSemiBold',
                                    fontSize: 16),
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const ProfilePage()));
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.people_outline),
                              title: const Text(
                                ' Friends ',
                                style: TextStyle(
                                    fontFamily: 'MontserratSemiBold',
                                    fontSize: 16),
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const FriendsPage()));
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.message),
                              title: const Text(
                                ' Chats ',
                                style: TextStyle(
                                    fontFamily: 'MontserratSemiBold',
                                    fontSize: 16),
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const ChatsPage()));
                              },
                            ),
                            // ListTile(
                            //   leading: const Icon(Icons.edit),
                            //   title: const Text(' Edit Profile ',
                            //     style: TextStyle(
                            //         fontFamily: 'MontserratSemiBold',
                            //         fontSize: 16),),
                            //   onTap: () {
                            //     Navigator.pop(context);
                            //   },
                            // ),
                            ListTile(
                              leading: const Icon(Icons.logout),
                              title: const Text(
                                'LogOut',
                                style: TextStyle(
                                    fontFamily: 'MontserratSemiBold',
                                    fontSize: 16),
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const HomePage()));
                              },
                            ),
                          ],
                        ),
                      ), //DrawerHeader
                    ],
                  ),
                ));
                return clientWidget;
              }
            }

            return CircularProgressIndicator();
          }),
    );
  }
}
