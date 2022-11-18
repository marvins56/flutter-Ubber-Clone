import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ubberapp/AllScreens/MainScreen.dart';
import 'package:ubberapp/AllScreens/regisrationScreen.dart';
import 'package:ubberapp/AllWidgets/progressDialogue.dart';

import '../main.dart';

class LoginScreen extends StatelessWidget {
  static const String idScreen = "login";
  TextEditingController emailTextEditingController = TextEditingController();

  TextEditingController passwordTextEditingController = TextEditingController();
  //const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 45.0,
              ),
              const Image(
                image: NetworkImage(
                    'https://img.freepik.com/premium-vector/african-american-man-living-with-blindness-reading-braille-book-with-hands-young-visually-impaired_503113-619.jpg?w=740'),
                width: 390.0,
                height: 250.0,
                alignment: Alignment.center,
              ),
              const SizedBox(
                height: 1.0,
              ),
              const Center(
                child: Text(
                  "Login as Rider",
                  style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    const SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    const SizedBox(
                      height: 1.0,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        /*if (emailTextEditingController.text.contains("@")) {
                          displayToastMsg("Invalid Email Address", context);
                        } else*/
                        if (passwordTextEditingController.text.isEmpty) {
                          displayToastMsg("Password required", context);
                        } else {
                          loginAuthenticateUser(context);
                        }
                      },
                      child: Container(
                        height: 50.0,
                        child: Text(
                          "login",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: "Brand Bold",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, RegisterationScreen.idScreen, (route) => false);
                },
                child: const Text("Do not Have An Account? Register here."),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, RegisterationScreen.idScreen, (route) => false);
                },
                child: const Text("SAMPLE."),
              )
            ],
          ),
        ),
      ),
    );
  }

  //creating firebase auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginAuthenticateUser(BuildContext context) async {
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext Context) {
            return progressDialogue(message: "logging in, Please wait...");
          });
      final User? firebaseUser = (await _firebaseAuth
              .signInWithEmailAndPassword(
                  email: emailTextEditingController.text.trim(),
                  password: passwordTextEditingController.text.trim())
              .catchError((errMsg) {
        Navigator.pop(context);
        displayToastMsg("Error : " + errMsg.toString(), context);
      }))
          .user;
 if (firebaseUser != null) {
//user created saving data to firebase
        usersRef.child(firebaseUser.uid);
        //check in database if user exixts or not
        // print(firebaseUser.uid);
        //saving data to databse
        usersRef.child(firebaseUser.uid).once().whenComplete(() {
          // => (DataSnapshot snap)
          // if (snap.value != null) {
          //if user exixts
          Navigator.pushNamedAndRemoveUntil(
              context, MainScreen.idScreen, (route) => false);
          displayToastMsg("Login successful", context);
          // } else {
          //   //if user doesnt exist
          //   Navigator.pop(context);
          //   _firebaseAuth.signOut();
          //   displayToastMsg("invalid email / password", context);
          // }
        });
      } else {
        Navigator.pop(context);
        //error display
        displayToastMsg("user creation failed", context);
      }
    } catch (e) {
      displayToastMsg("invalid credentials / " + e.toString(), context);
    }
  }

  displayToastMsg(String msg, BuildContext context) {
    Fluttertoast.showToast(msg: msg);
  }
}
