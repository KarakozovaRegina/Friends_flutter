import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friends_1/services/chat/chat_service.dart';


import '../components/user_tile.dart';
import '../services/auth/auth_service.dart';
import 'chatPage.dart';
import 'chats.dart';
import 'home.dart';
import 'profile.dart';


// chat & auth service
final ChatService _chatService = ChatService();
final AuthService _authService = AuthService();

// fetch data from FireStore
final FirebaseFirestore firestore = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser!;



//sing out
loginOut(){
 // final _auth = AuthService();
  _authService.singOut();
}




class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {


  List _allResults = [];
  List _resultList = [];
  final TextEditingController _searchContraller = TextEditingController();

  @override
  void initState() {
    _searchContraller.addListener(_onSeachChanged);
    super.initState();
  }


  _onSeachChanged(){
    print(_searchContraller.text);
    seachresultList();
  }

  seachresultList(){
    var showResults = [];
    if(_searchContraller.text != ""){

      for(var clientSnapshot in _allResults){
        var name = clientSnapshot["fullname"].toString().toLowerCase();
        
        if(name.contains(_searchContraller.text.toLowerCase())){
          showResults.add(clientSnapshot);
        }
      }

    }else{
      showResults = List.from(_allResults);
    }

    setState(() {
      _resultList = showResults;
    });
  }

  getClientStream() async {
   var data = await FirebaseFirestore.instance.collection("Users").orderBy("fullname").get();

   setState(() {
     _allResults= data.docs;
   });

   seachresultList();
  }


  @override
  void dispose(){
    _searchContraller.removeListener(_onSeachChanged);
    _searchContraller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getClientStream();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      // bar
      appBar: AppBar(
        title: CupertinoSearchTextField(
          controller: _searchContraller,
          style: TextStyle(color: Colors.white),
        ),




        // Text('Friends',
        //   style: TextStyle(
        //       fontFamily: 'MontserratSemiBold',
        //       fontSize: 18),
        // ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),

      //body
      body:
      _buildUserList(),


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
                                    loginOut();
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
  
  
  Widget _buildUserList(){
    return StreamBuilder(
        stream: _chatService.getUsersStream(),
        builder: (context,snapshot){
        // error
          if(snapshot.hasError){
            return const Text("Error");
          }

        // loading
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Text("Loading ...");
          }

        // return list view
          return ListView(
            children: _resultList.map<Widget>((userData) => _buildUserListItem(userData.data(), context)).toList(),

          );


    }
    );
  }




  // build individual list tile for user
Widget _buildUserListItem(
    Map<String, dynamic> userData, BuildContext context){
   if(userData["email"] != _authService.getCurrentUser()!.email){
     return UserTile(
       text: userData["email"],
       onTap: (){
         Navigator.push(context, MaterialPageRoute(builder: (contex) => ChatPage(
           receiverEmail: userData["email"],
           receiverID: userData["uid"],
         )));
       },
     );
   }else{
     return Container();
   }
}

}
