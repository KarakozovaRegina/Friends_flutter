import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:friends_1/page/UserInfoAdmin.dart';
import 'package:friends_1/page/friendPage.dart';
import 'package:friends_1/page/friends.dart';

class UserAdminTile extends StatelessWidget{
  final String text;
  final void Function()? onTap;

  const UserAdminTile({
    super.key,
    required this.text,
    required this.onTap,
  });


  @override
  Widget build(BuildContext contex){
    return StreamBuilder<QuerySnapshot>(
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
                        backgroundImage: MemoryImage(
                          decodedBytes,
                        ),
                      )),
                  title: Text(client['fullname'],
                    style: TextStyle(
                        fontFamily: 'MontserratSemiBold',
                        fontSize: 17),),
                  subtitle: Text(client['country'],
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>UserInfoAdminPage(text: client["email"]),
                            ),
                          );

                        },
                        icon: Icon(Icons.info,
                          color: Colors.pinkAccent,
                        ),
                      ),

                    ],
                  )

                // Container(
                //   child: RawMaterialButton(
                //     onPressed: onTap,
                //     elevation: 2.0,
                //     fillColor: Colors.white,
                //     child: Icon(
                //       Icons.pause,
                //       size: 25.0,
                //     ),
                //     shape: CircleBorder(),
                //   ),
                // )

              );



              // GestureDetector(
              //   onTap: onTap,
              //   child: Container(
              //     decoration: BoxDecoration(
              //       color: Theme.of(contex).colorScheme.secondary,
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //     margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
              //     padding: EdgeInsets.all(10),
              //     child:  Expanded(
              //       child:   Row(
              //         children: [
              //           // icon
              //           Container(
              //               decoration: BoxDecoration(
              //                 shape: BoxShape.circle,
              //                 gradient: LinearGradient(
              //                   begin: Alignment.topLeft,
              //                   end: Alignment.bottomRight,
              //                   colors: [
              //                     Color.fromRGBO(209, 135, 49, 1),
              //                     Color.fromRGBO(140, 0, 189, 1)
              //                   ],
              //                 ),
              //               ),
              //               child: CircleAvatar(
              //                 radius: 35,
              //                 backgroundImage: MemoryImage(
              //                   decodedBytes,
              //                 ),
              //               )),
              //
              //           SizedBox(width: 20),
              //
              //
              //           Column(
              //             children: [
              //               Row(
              //                   mainAxisAlignment: MainAxisAlignment.start,
              //                   children:[
              //                     Container(
              //                       width: 200,
              //                       color: Colors.pinkAccent,
              //                       child: Text(client['fullname'],
              //                         style: TextStyle(
              //                             fontFamily: 'MontserratSemiBold',
              //                             fontSize: 17),),
              //                     ),
              //                   ]
              //               ),
              //               Row(
              //                   mainAxisAlignment: MainAxisAlignment.start,
              //                   children:[
              //                     Padding(
              //                         padding: EdgeInsets.only(right: 2.0),
              //                       child:    Container(
              //                         width: 200,
              //                         color: Colors.red,
              //                         child: Row(
              //                           children: [
              //                             RawMaterialButton(
              //                               onPressed: () {},
              //                               elevation: 2.0,
              //                               fillColor: Colors.white,
              //                               child: Icon(
              //                                 Icons.pause,
              //                                 size: 25.0,
              //                               ),
              //                               shape: CircleBorder(),
              //                             ),
              //                             RawMaterialButton(
              //                               onPressed: () {},
              //                               elevation: 2.0,
              //                               fillColor: Colors.white,
              //                               child: Icon(
              //                                 Icons.pause,
              //                                 size: 25.0,
              //                               ),
              //                               shape: CircleBorder(),
              //                             )
              //                           ],
              //                         ),
              //                       ),
              //                     )
              //
              //
              //                   ]
              //               )
              //             ],
              //           ),
              //         ],
              //       ),
              //     )
              //
              //
              //
              //
              //   ),
              // );
              return clientWidget;
            }
          }

          return CircularProgressIndicator();
        });




    GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(contex).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            //icon
            Icon(Icons.person),

            SizedBox(width: 20),

            //usser name
            Text(text),
          ],
        ),
      ),
    );
  }
}