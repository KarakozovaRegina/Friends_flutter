import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friends_1/page/utils.dart';
import 'package:friends_1/services/auth/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'firstPage.dart';

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

final TextEditingController fullnameController = TextEditingController();
final TextEditingController ageController = TextEditingController();
final TextEditingController countryController = TextEditingController();

class SingUpPage extends StatefulWidget {
  const SingUpPage({super.key});

  @override
  State<SingUpPage> createState() => _SingUpPageState();
}


Uint8List? _image;

class _SingUpPageState extends State<SingUpPage> {


  //save photo
  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  //try create usr with email
  void signUserUp(BuildContext context) async {
    try {
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

      String base64Image = base64Encode(_image!);
      final _auth = AuthService();

      if (emailController.text.isEmpty ||
          passwordController.text.isEmpty ||
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
        return;
      }


      _auth.signUpWithEmailPassword(
        emailController.text,
        passwordController.text,
        fullnameController.text,
        ageController.text,
        countryController.text,
        base64Image,
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Edit user',
              style: TextStyle(
                fontFamily: 'MontserratSemiBold',
                color: Colors.black,
              ),
            ),
            content: Text(
              'User created!',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  'CLOSE',
                  style: TextStyle(
                    fontFamily: 'MontserratSemiBold',
                    color: Colors.purple,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
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
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Image(
                      image: AssetImage('assets/logoColor.png'),
                      width: 100,
                      height: 78,
                      fit: BoxFit.cover,
                    ),
                  ]),
                  SizedBox(
                    height: 34,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Create Account',
                        style: TextStyle(
                            fontFamily: 'MontserratSemiBold', fontSize: 36),
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
                            hintText: "Full name"),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextField(
                        controller: emailController,
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w900),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email,
                                size: 35, color: Colors.black38),
                            border: UnderlineInputBorder(
                                // Нижняя граница
                                borderSide: BorderSide(
                              color: Colors.blue, // Цвет границы
                              width: 2.0, // Толщина границы
                            )),
                            hintText: "Email"),
                      ),
                      SizedBox(
                        height: 15,
                      ),
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
                            hintText: "Password"),
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
                            hintText: "Age"),
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
                            hintText: "Country"),
                      ),
                    ],
                  )),
                  SizedBox(
                    height: 49,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                              signUserUp(context);
                              // Navigator.of(context)
                              //     .push(MaterialPageRoute(builder: (context) => FirstPage()));
                            },
                            child: Row(
                              children: [
                                Text(
                                  'SING UP',
                                  style: TextStyle(
                                      fontFamily: 'MontserratSemiBold',
                                      fontSize: 16,
                                      color: Colors.white),
                                )
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
                    SizedBox(width: 20),
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
                          final userCredential = FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) => FirstPage()));
                        },
                        child: Row(
                          children: [
                            Text(
                              'NEXT',
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
    ));
  }
}
