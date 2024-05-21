import 'package:flutter/material.dart';
import 'package:friends_1/page/signUp.dart';

import 'loginIn.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        child:SingleChildScrollView(
          child:   Center(
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/background_image.jpg'),
                      fit: BoxFit.cover,
                    )
                ),
                child:
                Stack(
                  children: [
                    // Первый элемент
                    Positioned(
                      child:
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromRGBO(140, 0, 189 ,0.4), // Первый цвет градиента с прозрачностью 0.5
                                    Color.fromRGBO(209, 135, 49,0.4), // Второй цвет градиента с прозрачностью 0.2
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            )
                        ),
                      ),
                    ),
                    // Второй элемент
                    Positioned(
                        child: Column(
                          children: [

                            Container(
                                margin: EdgeInsets.only(
                                    top: 188.0),
                                child:Center(
                                  child: Image(
                                    image: AssetImage('assets/logo.png'),
                                    width: 134,
                                    height: 129,
                                    fit: BoxFit.cover,
                                  ),
                                )
                            ),


                            Container(
                              margin: EdgeInsets.only(
                                  top: 204.0),
                              child: Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(builder: (context) => const LoginInPage()));
                                    },
                                    child: Text('LOGIN IN',
                                      style: TextStyle(
                                        fontFamily: 'MontserratSemiBold',
                                        fontSize: 16,
                                      ),),
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(300, 65),
                                      textStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),
                                      backgroundColor: Color.fromRGBO(245, 245, 245,0.5),
                                      foregroundColor: Colors.white,
                                      elevation: 5.0,
                                      padding: EdgeInsets.all(20),

                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        // Устанавливаем цвет и толщину границы
                                        side: BorderSide(
                                          color: Colors.white,
                                          width: 2.0,
                                        ),
                                      ),


                                    ),)),),

                            Container(
                              margin: EdgeInsets.only(
                                  top: 27.0),
                              child: Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(builder: (context) => const SingUpPage()));
                                    },
                                    child: Text('SING UP',
                                      style: TextStyle(
                                        fontFamily: 'MontserratSemiBold',
                                        fontSize: 16,
                                      ),),
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: Size(300, 65),
                                        textStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),
                                        backgroundColor: Color.fromRGBO(245, 245, 245,0.5),
                                        foregroundColor: Colors.white,
                                        elevation: 5.0,
                                        padding: EdgeInsets.all(20),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          // Устанавливаем цвет и толщину границы
                                          side: BorderSide(
                                            color: Colors.white,
                                            width: 2.0,
                                          ),
                                        )
                                    ),
                                  )
                              )
                              ,)

                          ],
                        )
                    ),
                  ],
                ),
              )
          ),
        )),


      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
