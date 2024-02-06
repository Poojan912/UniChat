import 'package:flutter/material.dart';
import 'package:unichat/signup_page.dart';

class signin_page extends StatefulWidget {
  const signin_page({super.key});

  @override
  State<signin_page> createState() => _signin_pageState();
}

class _signin_pageState extends State<signin_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "UniChat",
          style: TextStyle(fontSize: 40),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 120.20, left: 20.0, right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text("Login",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center),
            Padding(
                padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
                child: TextFormField(
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
                  },
                  child: Text('Sign In'),
                )
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
