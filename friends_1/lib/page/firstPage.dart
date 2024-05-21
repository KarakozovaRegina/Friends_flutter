import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friends_1/services/auth/auth_service.dart';

import 'profile.dart';
import 'chats.dart';
import 'friends.dart';
import 'home.dart';




// fetch data from FireStore
final FirebaseFirestore firestore = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser!;


class FirstPage extends StatelessWidget{

  const FirstPage({Key? key});

//sing out
  loginOut() {
    try{
      final _auth = AuthService();
     _auth.singOut();



    }catch(e){

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // bar
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),


      //body
      body:Container(
        color: Color.fromRGBO(255, 255, 255, 1),
          child:Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 320,
                    height: 190,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/welcome.png'),
                          fit: BoxFit.cover,)),
                  ),

                  Text('W E L C O M E',
                      style: TextStyle(
                        fontFamily: 'MontserratSemiBold',
                        fontSize: 24,
                        color: Colors.purple[800],
                      )
                  ),
                ]
            ),
          )
      ),



      //menu
      drawer:   StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Users").where('email', isEqualTo: user.email!)
              .snapshots(),
          builder: (context, snapshot) {

            if (snapshot.hasData) {
              final client = snapshot.data?.docs.first;
              if (client != null) {
                String base64Image = client['imageURL'];
                Uint8List decodedBytes = base64Decode(base64Image);


                final clientWidget =  Drawer(
                    child:Container(
                      color: Colors.white,
                      child:  ListView(
                        children: [
                          SizedBox(height: 60,),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [

                                SizedBox(width: 20,),

                                Image(
                                image: AssetImage('assets/logoColor.png'),
                                width: 100,
                                height: 78,
                                fit: BoxFit.cover,
                              ),]
                          ),

                          SizedBox(height: 40,),


                          Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.person),
                                  title: const Text(' Profile ',
                                    style: TextStyle(
                                        fontFamily: 'MontserratSemiBold',
                                        fontSize: 16),
                                  ),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(builder: (context) => const ProfilePage()));
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.people_outline),
                                  title: const Text(' Friends ',
                                    style: TextStyle(
                                        fontFamily: 'MontserratSemiBold',
                                        fontSize: 16),
                                  ),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(builder: (context) => const FriendsPage()));
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.message),
                                  title: const Text(' Chats ',
                                    style: TextStyle(
                                        fontFamily: 'MontserratSemiBold',
                                        fontSize: 16),),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(builder: (context) => const ChatsPage()));
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
                                  title: const Text('LogOut',
                                    style: TextStyle(
                                        fontFamily: 'MontserratSemiBold',
                                        fontSize: 16),),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(builder: (context) => const HomePage()));
                                  },
                                ),
                              ],
                            ),
                          ),//DrawerHeader

                        ],
                      ),
                    )
                );
                return clientWidget;
              }
            }

            return CircularProgressIndicator();
          }),


    );
  }

}

