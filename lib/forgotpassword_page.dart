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
    String email = _emailController.text;
    print('Send password reset link to $email');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "Forgot Password",
              style: TextStyle(
                fontSize: 30,
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
                fontFamily: 'YourCustomFont', // Custom font for your text
              ),
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
