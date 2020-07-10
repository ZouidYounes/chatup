import 'package:chatup/helper/helperfunctions.dart';
import 'package:chatup/services/auth.dart';
import 'package:chatup/services/database.dart';
import 'package:chatup/views/chatroomsScreen.dart';
import 'package:chatup/views/forgotpassword.dart';
import 'package:chatup/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";

class SignIn extends StatefulWidget {

  final Function toggle;

  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isLoading = false;
  bool isVisible = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController emailTextEditingController =
  new TextEditingController();
  TextEditingController passwordTextEditingController =
  new TextEditingController();
  AuthMethods _auth = new AuthMethods();
  DatabaseMethods _database = new DatabaseMethods();
  QuerySnapshot userInfoSnapshot;

  signMeIn() {
    if (formKey.currentState.validate()) {
      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
      setState(() {
        isLoading = true;
      });

      _database.getUserByUserEmail(emailTextEditingController.text).then((val){
        userInfoSnapshot = val;
        HelperFunctions.saveUserNameSharedPreference(userInfoSnapshot.documents[0].data["name"]);
      });

      _auth
          .signInWithEmailAndPassword(emailTextEditingController.text,
          passwordTextEditingController.text)
          .then((val) {
            if(val != null){
              HelperFunctions.saveUserLoggedInSharedPreference(true);

              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => ChatRoom()
              ));
            }else {
              setState(() {
                isLoading = false;
                isVisible = true;
              });
            }

      });

    }
  }

  @override
  Widget build(BuildContext context) {

    void _showPassReset() {
      showDialog(context: context, builder: (context) {
        return SimpleDialog(
            children: <Widget>[Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: ForgotPassword(),
            ),]

        );
      });
    }

    return Scaffold(
      appBar: appBarMain(context),
      body:isLoading
          ? Container(
        child: Center(child: CircularProgressIndicator()),
      ):
      SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height-60,
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                          validator: (val) {
                            return RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(val)
                                ? null
                                : "Enter correct email";
                          },
                          controller: emailTextEditingController,
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration("email")),
                      TextFormField(
                          validator: (val) => val.length < 6
                              ? 'Enter a 6+ character password'
                              : null,
                          obscureText: true,
                          controller: passwordTextEditingController,
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration("password")),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: InkWell(
                    onTap: () {
                      _showPassReset();
                    },
                    child: Text(
                      'Forgot Password?',
                      style: simpleTextStyle(),
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                Visibility(
                  visible: isVisible,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    child: Text("Something went wrong", style: TextStyle(
                      color: Colors.red
                    ),
                    )
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    signMeIn();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          const Color(0xff007EF4),
                          const Color(0xff2A75BC)
                        ]),
                        borderRadius: BorderRadius.circular(30)),
                    child: Text('Sign In', style: mediumTextStyle()),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(30)),
                  child: Text('Sign In With Google',
                      style: TextStyle(color: Colors.black87, fontSize: 16)),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Don't have an accout? ", style: mediumTextStyle()),
                    GestureDetector(
                      onTap: (){
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("Register now",
                            style: mediumTextStyle()
                                .copyWith(decoration: TextDecoration.underline)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 60,)
              ],
            ),
          ),
      ),
      );
  }
}
