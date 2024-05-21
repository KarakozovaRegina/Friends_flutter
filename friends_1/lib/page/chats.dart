import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friends_1/page/AddUserCroupChats.dart';
import 'package:friends_1/page/GroupChatPage.dart';

import '../components/group_tile.dart';
import '../services/auth/auth_service.dart';
import '../services/chat/chat_service.dart';
import '../services/groupChat/groupChat_service.dart';
import 'friends.dart';
import 'home.dart';
import 'profile.dart';

// fetch data from FireStore
final FirebaseFirestore firestore = FirebaseFirestore.instance;
GroupChatService group_service = GroupChatService();
final AuthService _authService = AuthService();
final user = FirebaseAuth.instance.currentUser!;

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}


class _ChatsPageState extends State<ChatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bar
      appBar: AppBar(
        title: Text(
          'Chats',
          style: TextStyle(fontFamily: 'MontserratSemiBold', fontSize: 18),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddUserGroupChatPage()));
              },
              icon: Icon(Icons.add))
        ],
      ),

      //body
      // body: _buildUserList(),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getCollectionItemsForUser(user.email!),
        builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Ошибка при загрузке данных'),
            );
          }

          List<Map<String, dynamic>> itemList = snapshot.data!;
          if (itemList.isEmpty) {
            return Center(
              child: Text('Нет элементов в коллекции для данного пользователя.'),
            );
          }

          return ListView.builder(
            itemCount: itemList.length,
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic> item = itemList[index];

              // Возвращаем виджет, отображающий данные элемента
              return ListTile(
                title: Text(item['groupName']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>GroupChatPage(
                                nameChat:item['groupName'],
                              userEmail: user.email!,
                            ),
                          ),
                        );

                      },
                      icon: Icon(Icons.arrow_forward_ios_outlined,
                        color: Colors.deepPurple,
                      ),
                    ),

                  ],
                ),
              );
            },
          );
        },
      ),

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
                      Container(
                        color: Colors.white,
                        height: 200,
                        child: DrawerHeader(
                            //BoxDecoration
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, //выровнены по центру вдоль перекрестной оси
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 110,
                              width: 110,
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
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              user.email!,
                              style: TextStyle(
                                fontFamily: 'MontserratSemiBold',
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        )),
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
                                loginOut();
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
  Future<List<Map<String, dynamic>>> getCollectionItemsForUser(String userId) async {
    List<Map<String, dynamic>> itemList = [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('GroupChats')
        .where('users', arrayContains: userId)
        .get();

    if (querySnapshot.size > 0) {
      querySnapshot.docs.forEach((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        itemList.add(data);
      });
    }

    return itemList;
  }

  // Widget _buildUserList(){
  //   final userEmail = user.email!;
  //   return StreamBuilder(
  //       stream:group_service.getGroupsStreamWithUser(userEmail),
  //       builder: (context,snapshot){
  //         // error
  //         if(snapshot.hasError){
  //           return const Text("Error");
  //         }
  //
  //         // loading
  //         if(snapshot.connectionState == ConnectionState.waiting){
  //           return const Text("Loading ...");
  //         }
  //
  //         // return list view
  //         return ListView(
  //           children: snapshot.data!.map<Widget>((userData) => _buildUserListItem(userData,context)).toList(),
  //         );
  //
  //
  //       }
  //   );
  // }
  //
  //
  // // build individual list tile for user
  // Widget _buildUserListItem(
  //     Map<String, dynamic> userData, BuildContext context){
  //   if(userData["email"] != _authService.getCurrentUser()!.email){
  //     return GroupTile(
  //       text: userData["email"],
  //       onTap: (){
  //       },
  //     );
  //   }else{
  //     return Container();
  //   }
  // }

}
