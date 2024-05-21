import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friends_1/models/user.dart';

class AuthService {


  // instance of auth & firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


 //get current user
  User? getCurrentUser(){
    return _auth.currentUser;
  }
  Stream<List<Map<String,dynamic>>> getUsersStream(){
    return _firestore.collection("Users").snapshots().map((snapshot){
      return snapshot.docs.map((doc){
        // go thought each individual user
        final user =  doc.data();

        // return user
        return user;
      }).toList();
    });
  }

  // sing in
  // Future<UserCredential> signInWithEmailPassword(String email, password) async {
  //   try {
  //     UserCredential userCredential = await _auth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //
  //     return userCredential;
  //   } on FirebaseAuthException catch (e) {
  //     throw Exception(e.code);
  //   }
  // }
  //





///////////////////////////////////////////////////////////////////////////////////////
  // sign up
  Future<UserCredential> signUpWithEmailPassword(String email, password, fullname, age, country, base64Image,) async {
    try{
      // sing user in
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );



      //save info in if it doesn`t already exist
      _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email':userCredential.user!.email,
          'password':password,
          'fullname':fullname,
          'age':age,
          'country':country,
          'imageURL':base64Image,
        }
      );


      return userCredential;
    } on FirebaseAuthException catch (e){
        throw Exception(e.code);
    }
  }

  ///////////////////////////////////////////////////////////////////////////////////////



  // sign out
  Future<void> singOut() async{
    return await _auth.signOut();

  }

  //error



}