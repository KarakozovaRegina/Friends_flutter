import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friends_1/page/adminPage.dart';
import 'package:friends_1/page/firstPage.dart';
import 'package:friends_1/services/auth/auth_service.dart';

final _formKey = GlobalKey<FormState>();
final TextEditingController emailController= TextEditingController();
final TextEditingController passwordController= TextEditingController();


class LoginInPage extends StatefulWidget {
  const LoginInPage({super.key});

  @override
  State<LoginInPage> createState() => _LoginInPageState();
}

class _LoginInPageState extends State<LoginInPage> {

  void loginIn(BuildContext context) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (userCredential.user != null) {
        if (userCredential.user!.email == 'admin@gmail.com') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminPage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => FirstPage()),
          );
        }
      }
          } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Login error'),
          content: Text('Failed to log in. Check the correctness of the entered data.'),
          actions: [
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }


  // void dispose() {
  //   emailController.dispose();
  //   passwordController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Container(
            child:SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 20,),
                        FloatingActionButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          mini: true,
                          heroTag: null,
                          child: Icon(Icons.arrow_back,
                            size: 35,
                            color: Colors.black38,),
                        ),]
                  ),


                  Container(
                    margin: EdgeInsets.all(30),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 42,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [ Image(
                              image: AssetImage('assets/logoColor.png'),
                              width: 100,
                              height: 78,
                              fit: BoxFit.cover,
                            ),]
                        ),


                        SizedBox(
                          height: 34,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Login',
                              style: TextStyle(
                                  fontFamily: 'MontserratSemiBold',
                                  fontSize: 36
                              ),)
                          ],
                        ),


                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Please sign in to continue.',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900
                              ),)   ],
                        ),


                        SizedBox(
                          height: 46,
                        ),
                        Form(
                            key: _formKey,
                            child: Column(
                              children: [

                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  validator:(value){
                                    if(value!.isEmpty){
                                      return 'Enter email';
                                    }
                                    return null;
                                  },
                                  controller:emailController,
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w900
                                  ),
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.email,
                                          size: 35,
                                          color: Colors.black38),
                                      border: UnderlineInputBorder(  // Нижняя граница
                                          borderSide: BorderSide(
                                            color: Colors.blue,  // Цвет границы
                                            width: 2.0,  // Толщина границы
                                          )),
                                      hintText: "Email"
                                  ),
                                ),


                                SizedBox(height: 20,),
                                TextFormField(
                                  validator:(value){
                                    if(value!.isEmpty){
                                      return 'Enter Password';
                                    }
                                    return null;
                                  },
                                  controller:passwordController,
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w900
                                  ),
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.lock,
                                          size: 35,
                                          color: Colors.black38),
                                      border: UnderlineInputBorder(  // Нижняя граница
                                          borderSide: BorderSide(
                                            color: Colors.blue,  // Цвет границы
                                            width: 2.0,  // Толщина границы
                                          )),
                                      hintText: "Password"
                                  ),
                                ),

                              ],
                            )),

                        SizedBox(
                          height: 79,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromRGBO(209, 135, 49,1),
                                      Color.fromRGBO(140, 0, 189,1)],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,),
                                  borderRadius: BorderRadius.circular(30),),

                                child: Center(child:
                                ElevatedButton(
                                  onPressed: () {
                                    if(_formKey.currentState!.validate()){
                                      loginIn(context);
                                    }

                                  },
                                  child:
                                  Row(
                                    children: [
                                      Text('LOGIN',
                                        style: TextStyle(
                                            fontFamily: 'MontserratSemiBold',
                                            fontSize: 16,
                                            color: Colors.white
                                        ),),
                                      SizedBox(width: 15,),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),

                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    minimumSize: Size(158, 57),
                                    textStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),
                                    elevation: 0.0,
                                    padding: EdgeInsets.all(20),
                                  ),
                                )
                                ),
                              ),




                            ]
                        )
                      ],
                    ),
                  )

                ],
              ),
            ),
        )
    );
  }
}