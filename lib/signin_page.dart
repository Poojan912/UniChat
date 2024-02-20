import 'package:flutter/material.dart';
import 'package:unichat/forgotpassword_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unichat/home_page.dart';
import 'package:unichat/signup_page.dart';

class signin_page extends StatefulWidget {
  const signin_page({super.key});

  @override
  State<signin_page> createState() => _signin_pageState();
}

class _signin_pageState extends State<signin_page> {

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                letterSpacing: 1.5,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black.withOpacity(0.3),
                    offset: Offset(5, 5),
                  ),
                ],
                fontFamily: "Arial",
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
                padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
                child: TextFormField(
                  controller: _emailController,
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
                  controller: _passwordController,
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

                    FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                    ).then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign In Successful')));
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>home_page()));

                    }).onError((error, stackTrace) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email/Password wrong')));
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
                   color: Colors.deepPurple,
                   decoration: TextDecoration.underline,
                 ),
                 ),
               ),
            ),
            SizedBox(height: 20.0),
            Text('Or sign in with', textAlign: TextAlign.center),
            Padding(
                padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.email),
                  label: Text('Google'),
                  onPressed: () {
                    // Handle Google Sign-In logic
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
                color: Colors.deepPurple,
                decoration: TextDecoration.underline,
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
