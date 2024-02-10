import 'dart:js_interop';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:unichat/forgotpassword_page.dart';
import 'package:unichat/home_page.dart';
import 'package:unichat/signup_page.dart';

class signin_page extends StatefulWidget {
  const signin_page({super.key});

  @override
  State<signin_page> createState() => _signin_pageState();
}

class _signin_pageState extends State<signin_page> {

  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        title : Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset('assets/image/image_no_bg.png',width: 60,fit: BoxFit.contain,),

            Text(
              "UniChat",
              style: TextStyle(fontSize: 40),
            )
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "Login",
              style: TextStyle(
                fontSize: 40, // Size of the text
                fontWeight: FontWeight.w700, // Thickness of the text
                color: Colors.black, // Color of the text. You can choose any color that fits your design.
                letterSpacing: 1.5, // Space between each letter
                shadows: [
                  Shadow(
                    blurRadius: 10.0, // How much the shadow should be blurred
                    color: Colors.black.withOpacity(0.3), // Color of the shadow
                    offset: Offset(5, 5), // Horizontal and vertical offset of the shadow
                  ),
                ],
                fontFamily: 'YourCustomFont', // Custom font for your text
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
                padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
                child: TextFormField(
                  controller: _emailTextController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                )),
            Padding(
                padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                child: TextFormField(
                  controller: _passwordTextController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.password),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                )
            ),
            Padding(
                padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Handle Sign-In logic
                    print("Sign In pressed");
                    FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: _emailTextController.text,
                        password: _passwordTextController.text)
                        .then((value) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomeScreen()));
                    }).onError((error, stackTrace) {
                      print("Error ${error.toString()}");
                    });
                  },
                  child: Text('Sign In'),
                )
            ),
            Padding(padding: EdgeInsets.only(right: 20.0),
               child: InkWell(
                 onTap: (){
                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => forgotpassword_page()));
                 },
                 child: Text(
                   'Forgot password',textAlign: TextAlign.right,style: TextStyle(
                   color: Colors.deepPurple, // Adjust the color as needed
                   decoration: TextDecoration.underline, // Underline to mimic hyperlink
                 ),
                 ),
               ),
            ),
            SizedBox(height: 20.0),
            Text('Or sign in with', textAlign: TextAlign.center),
            Padding(
                padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.email), // Placeholder icon for Google
                  label: Text('Google'),
                  onPressed: () {
                    // Handle Google Sign-In logic
                    print("Google Sign In pressed");
                  },
                )
            ),

            Padding(
                padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.facebook), // Placeholder icon for Facebook
                  label: Text('Facebook'),
                  onPressed: () {
                    // Handle Facebook Sign-In logic
                    print("Facebook Sign In pressed");
                  },
                )
            ),
            Padding(padding: EdgeInsets.only(top:20.0),
            child: InkWell(
              onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => signup_page()));
              },
              child: Text(
                'Don\'t have account?? Sign Up',textAlign: TextAlign.center,style: TextStyle(
                color: Colors.deepPurple, // Adjust the color as needed
                decoration: TextDecoration.underline, // Underline to mimic hyperlink
              ),
              ),
            ),
            )
          ],
        ),
      ),
    );
  }
}
