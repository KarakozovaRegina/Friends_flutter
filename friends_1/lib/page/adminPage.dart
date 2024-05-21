import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friends_1/models/user.dart';
import 'package:friends_1/page/AddUserAdmin.dart';
import 'package:friends_1/page/utils.dart';
import 'package:friends_1/services/chat/chat_service.dart';
import 'package:image_picker/image_picker.dart';


import '../components/user_admin_tile.dart';
import '../components/user_tile.dart';
import '../services/auth/auth_service.dart';


// chat & auth service
final ChatService _chatikService = ChatService();
final AuthService _authService = AuthService();

// fetch data from FireStore
final FirebaseFirestore firestore = FirebaseFirestore.instance;


Uint8List? _image;
final user = FirebaseAuth.instance.currentUser!;

final TextEditingController passwordController = TextEditingController();
final TextEditingController fullnameController = TextEditingController();
final TextEditingController ageController = TextEditingController();
final TextEditingController countryController = TextEditingController();
final TextEditingController emailController = TextEditingController();

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {


  // //save photo
  // void selectImage() async {
  //   Uint8List img = await pickImage(ImageSource.gallery);
  //   setState(() {
  //     _image = img;
  //   });
  // }

  //
  // // create user
  // Future<void> _openAlertDialog() async {
  //
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Container(
  //         child: SingleChildScrollView(
  //           child: AlertDialog(
  //             backgroundColor: Colors.purple[800],
  //             title: Text(
  //               'Create user',
  //               style: TextStyle(
  //                 fontFamily: 'MontserratSemiBold',
  //                 color: Colors.white,
  //               ),
  //             ),
  //             content: Column(
  //               children: [
  //                 SizedBox(height: 20),
  //                 Container(
  //                   decoration: BoxDecoration(
  //                     shape: BoxShape.circle,
  //                     gradient: LinearGradient(
  //                       begin: Alignment.topLeft,
  //                       end: Alignment.bottomRight,
  //                       colors: [
  //                         Color.fromRGBO(209, 135, 49, 1),
  //                         Color.fromRGBO(140, 0, 189, 1)
  //                       ],
  //                     ),
  //                     border: Border.all(
  //                       width: 5,
  //                       style: BorderStyle.solid,
  //                       color: Colors.transparent,
  //                     ),
  //                   ),
  //                   child: Stack(
  //                     children: [
  //                       _image != null
  //                           ? CircleAvatar(
  //                         radius: 50,
  //                         backgroundImage: MemoryImage(_image!),
  //                       )
  //                           : const CircleAvatar(
  //                         radius: 50,
  //                         backgroundImage: NetworkImage(
  //                             'https://n34.mx/wp-content/uploads/2021/02/user-evaluacion-notaria-34.png'),
  //                       ),
  //                       Positioned(
  //                         child: IconButton(
  //                           onPressed: selectImage,
  //                           icon: Icon(Icons.add_a_photo),
  //                         ),
  //                         bottom: -15,
  //                         left: 64,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 SizedBox(height: 30),
  //                 TextField(
  //                   controller: fullnameController,
  //                   style: TextStyle(
  //                       fontFamily: 'Montserrat', fontWeight: FontWeight.w900),
  //                   keyboardType: TextInputType.emailAddress,
  //                   decoration: InputDecoration(
  //                       hintText: "Full name",
  //                       hintStyle: TextStyle(
  //                           fontFamily: 'Montserrat',
  //                           fontWeight: FontWeight.w900,
  //                           color: Colors.pinkAccent),
  //                       prefixIcon:
  //                       Icon(Icons.person, size: 35, color: Colors.white),
  //                       border: OutlineInputBorder()),
  //                 ),
  //                 SizedBox(height: 20),
  //                 TextField(
  //                   controller: emailController,
  //                   style: TextStyle(
  //                       fontFamily: 'Montserrat', fontWeight: FontWeight.w900),
  //                   keyboardType: TextInputType.emailAddress,
  //                   decoration: InputDecoration(
  //                       hintText: "Email",
  //                       hintStyle: TextStyle(
  //                           fontFamily: 'Montserrat',
  //                           fontWeight: FontWeight.w900,
  //                           color: Colors.pinkAccent),
  //                       prefixIcon:
  //                       Icon(Icons.lock, size: 35, color: Colors.white),
  //                       border: OutlineInputBorder()),
  //                 ),
  //                 SizedBox(height: 20),
  //                 TextField(
  //                   controller: passwordController,
  //                   style: TextStyle(
  //                       fontFamily: 'Montserrat', fontWeight: FontWeight.w900),
  //                   keyboardType: TextInputType.emailAddress,
  //                   decoration: InputDecoration(
  //                       hintText: "Password",
  //                       hintStyle: TextStyle(
  //                           fontFamily: 'Montserrat',
  //                           fontWeight: FontWeight.w900,
  //                           color: Colors.pinkAccent),
  //                       prefixIcon:
  //                       Icon(Icons.lock, size: 35, color: Colors.white),
  //                       border: OutlineInputBorder()),
  //                 ),
  //                 SizedBox(height: 20),
  //                 TextField(
  //                   controller: ageController,
  //                   style: TextStyle(
  //                       fontFamily: 'Montserrat', fontWeight: FontWeight.w900),
  //                   keyboardType: TextInputType.emailAddress,
  //                   decoration: InputDecoration(
  //                       hintText: "Age",
  //                       hintStyle: TextStyle(
  //                           fontFamily: 'Montserrat',
  //                           fontWeight: FontWeight.w900,
  //                           color: Colors.pinkAccent),
  //                       prefixIcon:
  //                       Icon(Icons.numbers, size: 35, color: Colors.white),
  //                       border: OutlineInputBorder()),
  //                 ),
  //                 SizedBox(height: 20),
  //                 TextField(
  //                   controller: countryController,
  //                   style: TextStyle(
  //                       fontFamily: 'Montserrat', fontWeight: FontWeight.w900),
  //                   keyboardType: TextInputType.emailAddress,
  //                   decoration: InputDecoration(
  //                       hintText: "Country",
  //                       hintStyle: TextStyle(
  //                           fontFamily: 'Montserrat',
  //                           fontWeight: FontWeight.w900,
  //                           color: Colors.pinkAccent),
  //                       prefixIcon:
  //                       Icon(Icons.place, size: 35, color: Colors.white),
  //                       border: OutlineInputBorder()),
  //                 ),
  //               ],
  //             ),
  //             actions: [
  //               TextButton(
  //                 child: Text(
  //                   'CANCEL',
  //                   style: TextStyle(
  //                     fontFamily: 'MontserratSemiBold',
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //               TextButton(
  //                 child: Text(
  //                   'CREATE',
  //                   style: TextStyle(
  //                     fontFamily: 'MontserratSemiBold',
  //                     color: Colors.pinkAccent,
  //                   ),
  //                 ),
  //                 onPressed: () {
  //                   EditAccount();
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // Future<void> EditAccount() async {
  //   try {
  //     String base64Image = base64Encode(_image!);
  //     final _auth = AuthService();
  //     _auth.signUpWithEmailPassword(
  //       emailController.text,
  //       passwordController.text,
  //       fullnameController.text,
  //       ageController.text,
  //       countryController.text,
  //       base64Image,
  //     );
  //   } catch (e) {
  //     showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: Text(e.toString()),
  //       ),
  //     );
  //   }
  // }



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      // bar
      appBar: AppBar(
        title: Text('Admin Page',
          style: TextStyle(
              fontFamily: 'MontserratSemiBold',
              fontSize: 18),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: (){
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => AddUserAdminPage()));
              },
              icon: Icon(Icons.add))
        ],
      ),

      //body
      body:  _buildUserList(),
     // _buildUserList(),
    );
  }


  Widget _buildUserList(){
    return StreamBuilder(
        stream: _chatikService.getUsersStream(),
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
            children: snapshot.data!.map<Widget>((userData) => _buildUserListItem(userData,context)).toList(),
          );


        }
    );
  }




  // build individual list tile for user
  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context){
    if(userData["email"] != _authService.getCurrentUser()!.email){
      return UserAdminTile(
        text: userData["email"],
        onTap: (){
        },
      );
    }else{
      return Container();
    }
  }

}
