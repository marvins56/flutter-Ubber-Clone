import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ubberapp/AllScreens/MainScreen.dart';
import 'package:ubberapp/AllWidgets/progressDialogue.dart';
import 'package:ubberapp/main.dart';

import 'LoginScreen.dart';

class RegisterationScreen extends StatelessWidget {
  // const RegisterationScreen({Key? key}) : super(key: key);
  static const String idScreen = "register";
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

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
                  "Register as Rider",
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
                      controller: nameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ), //name
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
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Phone",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ), // contact
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
                      child: Container(
                        height: 50.0,
                        child: Text(
                          "Create Account",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: "Brand Bold",
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (nameTextEditingController.text.length < 4) {
                          displayToastMsg(
                              "Name must be atleast 4 characters", context);
                        } /* else if (emailTextEditingController.text
                            .contains("@")) {
                          displayToastMsg("Invalid Email Address", context);
                        }*/
                        else if (phoneTextEditingController.text.isEmpty) {
                          displayToastMsg("phone number is mandatory", context);
                        } else if (passwordTextEditingController.text.length <
                            7) {
                          displayToastMsg(
                              "Password must be atleast 6 characers", context);
                        } else {
                          registerNewUser(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.idScreen, (route) => false);
                },
                child: const Text("Already Have An Account? Login here."),
              )
            ],
          ),
        ),
      ),
    );
  }

  //creating firebase auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async {
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext Context) {
            return progressDialogue(message: "R Please wait...");
          });
      final User? firebaseUser = (await _firebaseAuth
              .createUserWithEmailAndPassword(
                  email: emailTextEditingController.text,
                  password: passwordTextEditingController.text)
              .catchError((errMsg) {
        Navigator.pop(context);
        displayToastMsg("Error : " + errMsg.toString(), context);
      }))
          .user;
      if (firebaseUser != null) {
        usersRef.child(firebaseUser.uid);
        Map userDataMap = {
          "name": nameTextEditingController.text.trim(),
          "email": emailTextEditingController.text.trim(),
          "phone": phoneTextEditingController.text.trim()
        };
        usersRef.child(firebaseUser.uid).set(userDataMap);
        displayToastMsg("Account successfully created", context);
        Navigator.pushNamedAndRemoveUntil(
            context, MainScreen.idScreen, (route) => false);
      } else {
        Navigator.pop(context);
        displayToastMsg("USER CREATION FAILED", context);
      }
    } catch (e) {
      displayToastMsg(e.toString(), context);
    }
  }

  displayToastMsg(String msg, BuildContext context) {
    Fluttertoast.showToast(msg: msg);
  }
}
