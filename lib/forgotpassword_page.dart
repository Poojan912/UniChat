import 'package:flutter/material.dart';

class forgotpassword_page extends StatefulWidget {
  const forgotpassword_page({super.key});

  @override
  State<forgotpassword_page> createState() => _forgotpassword_pageState();
}

class _forgotpassword_pageState extends State<forgotpassword_page> {
  final _emailController = TextEditingController();


  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }


  void _sendPasswordResetEmail() {
    // Add your email sending logic here
    String email = _emailController.text;
    print('Send password reset link to $email');
    // here there is use of service like Firebase Auth to send the password reset email
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password?'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Forgot Password?',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
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

            SizedBox(height: 30.0, width: 20.0,),
            Padding(padding: EdgeInsets.only(right: 20.0,left: 20.0),
             child: ElevatedButton(
               child: Text('Send Password Reset Email'),
               onPressed: _sendPasswordResetEmail,
             ),
            )
          ],
        ),
      ),
    );
  }
}
