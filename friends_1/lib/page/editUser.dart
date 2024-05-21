import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friends_1/page/firstPage.dart';
import 'package:friends_1/page/profile.dart';
import 'package:friends_1/page/utils.dart';
import 'package:image_picker/image_picker.dart';

// controllers
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController fullnameController = TextEditingController();
final TextEditingController ageController = TextEditingController();
final TextEditingController countryController = TextEditingController();

class EditUserPage extends StatefulWidget {
  const EditUserPage({super.key});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

Uint8List? _image;

// firestore
final FirebaseFirestore firestore = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser!;


// for edit user
CollectionReference usersRef = FirebaseFirestore.instance.collection("Users");

class _EditUserPageState extends State<EditUserPage> {
  //save photo
  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void editUser() async {
    String base64Image = base64Encode(_image!);

    try {
      QuerySnapshot querySnapshot = await usersRef
          .where('uid', isEqualTo: user.uid)
          .get();

      if (querySnapshot.size > 0) {
        querySnapshot.docs.forEach((QueryDocumentSnapshot documentSnapshot) {
          usersRef.doc(documentSnapshot.id).update({
            'password': passwordController.text,
            'fullname': fullnameController.text,
            'age': ageController.text,
            'country': countryController.text,
            'imageURL': base64Image,
          });
        });

        Navigator.of(context).pop();
      }
    } catch (error) {
      print("Error: $error");
    }
  }




  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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

              final clientWidget = Scaffold(
                  body: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            FloatingActionButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              mini: true,
                              heroTag: null,
                              child: Icon(
                                Icons.arrow_back,
                                size: 35,
                                color: Colors.black38,
                              ),
                            ),
                          ]),
                      Container(
                        margin: EdgeInsets.all(30),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 34,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Edit user',
                                  style: TextStyle(
                                      fontFamily: 'MontserratSemiBold',
                                      fontSize: 36),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                                child: Column(
                              children: [
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
                                              backgroundImage:
                                                  MemoryImage(_image!),
                                            )
                                          :  CircleAvatar(
                                              radius: 50,
                                              backgroundImage:
                                                  MemoryImage(decodedBytes),
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
                                SizedBox(height: 20),
                                TextField(
                                  controller: fullnameController,
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w900),
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.person,
                                          size: 35, color: Colors.black38),
                                      border: UnderlineInputBorder(
                                          // Нижняя граница
                                          borderSide: BorderSide(
                                        color: Colors.blue, // Цвет границы
                                        width: 2.0, // Толщина границы
                                      )),
                                      hintText: client['fullname']),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                // TextField(
                                //   controller: emailController,
                                //   style: TextStyle(
                                //       fontFamily: 'Montserrat',
                                //       fontWeight: FontWeight.w900),
                                //   keyboardType: TextInputType.emailAddress,
                                //   decoration: InputDecoration(
                                //       prefixIcon: Icon(Icons.email,
                                //           size: 35, color: Colors.black38),
                                //       border: UnderlineInputBorder(
                                //           // Нижняя граница
                                //           borderSide: BorderSide(
                                //         color: Colors.blue, // Цвет границы
                                //         width: 2.0, // Толщина границы
                                //       )),
                                //       hintText: client['email']),
                                // ),
                                // SizedBox(
                                //   height: 15,
                                // ),
                                TextField(
                                  controller: passwordController,
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w900),
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.lock,
                                          size: 35, color: Colors.black38),
                                      border: UnderlineInputBorder(
                                          // Нижняя граница
                                          borderSide: BorderSide(
                                        color: Colors.blue, // Цвет границы
                                        width: 2.0, // Толщина границы
                                      )),
                                      hintText: client['password']),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                TextField(
                                  controller: ageController,
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w900),
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.numbers,
                                          size: 35, color: Colors.black38),
                                      border: UnderlineInputBorder(
                                          // Нижняя граница
                                          borderSide: BorderSide(
                                        color: Colors.blue, // Цвет границы
                                        width: 2.0, // Толщина границы
                                      )),
                                      hintText: client['age']),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                TextField(
                                  controller: countryController,
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w900),
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.place,
                                          size: 35, color: Colors.black38),
                                      border: UnderlineInputBorder(
                                          // Нижняя граница
                                          borderSide: BorderSide(
                                        color: Colors.blue, // Цвет границы
                                        width: 2.0, // Толщина границы
                                      )),
                                      hintText: client['country']),
                                ),
                              ],
                            )),
                            SizedBox(
                              height: 49,
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
                                        editUser();
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
                                        minimumSize: Size(158, 57),
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
                        ),
                      )
                    ],
                  ),
                ),
              ));

              return clientWidget;
            }
          }

          return CircularProgressIndicator();
        });
  }
}
