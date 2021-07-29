import 'package:chat/chattingscreen.dart';
import 'package:chat/helper/helperFunction.dart';
import 'package:chat/services/auth.dart';
import 'package:chat/services/database.dart';
import 'package:chat/widgets/widget.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  final Function toggle;
  Signup(this.toggle);
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool isLoading = false;
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  // HelperFunctions helperFunction = new HelperFunctions();
  final formKey = GlobalKey<FormState>();
  TextEditingController userName = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  signMe() {
    if (formKey.currentState.validate()) {
      Map<String,String>userMap = {
                  'name' : userName.text,
                  'email' : email.text
                };
      
                
      HelperFunctions.saveUserName(userName.text);
      HelperFunctions.saveUserEmailPrefence(email.text);       
      setState(() {
        isLoading = true;
      });
      authMethods
          .signInWithEmailAndPassword(email.text, password.text)
          .then((value){
                // print(value),
                              
                databaseMethods.uploadUserInfo(userMap);
                HelperFunctions.saveUser(true);  
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ChatRoom()),
                );
              });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 50,
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                                validator: (val) {},
                                controller: userName,
                                style: textStyle(),
                                decoration:
                                    textFieldInputDecoration("UserName")),
                            TextFormField(
                                validator: (val) {
                                  return RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(val)
                                      ? null
                                      : "Enter correct email";
                                },
                                controller: email,
                                style: textStyle(),
                                decoration: textFieldInputDecoration("Email")),
                            TextFormField(
                                obscureText: true,
                                validator: (val) {
                                  return val.length >= 6
                                      ? null
                                      : "Enter password of at least 6 length";
                                },
                                controller: password,
                                style: textStyle(),
                                decoration:
                                    textFieldInputDecoration("Password")),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: Text(
                            "Forgot Password",
                            style: textStyle(),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      GestureDetector(
                        onTap: signMe,
                        child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(colors: [
                                Color(0xff007EF4),
                                Color(0xff2A75BC),
                              ]),
                            ),
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            )),
                      ),
                      SizedBox(height: 16),
                      Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                          ),
                          child: Text(
                            "Sign Up With Google",
                            style: registerStyle(),
                          )),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already Have an Account?",
                            style: registerStyle(),
                          ),
                          GestureDetector(
                            onTap:(){
                              widget.toggle();
                            },
                            child: Container(
                              child: Text(
                                "SignIn Now",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
