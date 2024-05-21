import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class myUser {
  final String fullname;
  final String email;
  final String password;
  final String age;
  final String country;
  final String imageURL;

  myUser({
    required this.fullname,
    required this.email,
    required this.password,
    required this.age,
    required this.country,
   required this.imageURL,
  });

  toJson(){
    return {
      "fullname":fullname,
      "email":email,
      "password":password,
      "age":age,
      "country":country,
      "imageURL":imageURL,
    };
  }

  //convert to a map
  Map<String, dynamic> toMap(){
    return {
      'fullname':fullname,
      'email':email,
      'password':password,
      'age':age,
      'country':country,
     'imageURL':imageURL,
    };
  }


  factory myUser.fromSnapshot(DocumentSnapshot<Map<String,dynamic>> document){
    final data = document.data()!;
    return myUser(fullname: data["fullname"], email: data["email"], password: data["password"], age: data["age"], country: data["country"], imageURL: data["imageURL"]);
  }


}