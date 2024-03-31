import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:unichat/signin_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class signup_page extends StatefulWidget {
  const signup_page({super.key});

  @override
  State<signup_page> createState() => _signup_pageState();
}

class _signup_pageState extends State<signup_page> {
  TextEditingController _fullnameController = TextEditingController();
  TextEditingController _phonenumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // late DatabaseReference dbRef;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _usersRef = FirebaseFirestore.instance.collection('users');

  @override
  void dispose() {
    _fullnameController.dispose();
    _phonenumberController.dispose();
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
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "Sign Up",
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
                padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                child: TextFormField(
                  controller: _fullnameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.name,
                )),
            Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                child: TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                )),
            Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                child: TextFormField(
                  controller: _phonenumberController,
                  decoration: const InputDecoration(
                    labelText: 'Phone No',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                )),
            Padding(
                padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                child: TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.password),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                )
            ),
            Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Handle Sign-In logic Authentication
                    FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text
                    ).then((authResult) {
                      // Use the UID as the key for the user's information
                      String uid = authResult.user?.uid ?? '';
                      Map<String, String> userData = {
                        'fullname': _fullnameController.text,
                        'email': _emailController.text,
                        'phone_number': _phonenumberController.text,
                        'uid' : uid ,
                        'password' : _passwordController.text,
                        'imageUrl': 'https://drive.google.com/file/d/1JNLy9KOPhjrOas7YDC5uwusK9mhjCaOF/view?usp=sharing',
                      };
                      _usersRef.doc(uid).set(userData);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User Created Successfully')));
                      Navigator.push(context, MaterialPageRoute(builder: (context) => signin_page()));
                    }).catchError((error) {
                      print("Error ${error.toString()}");
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create user')));
                    });
                  },
                  child: const Text('Sign In'),
                )
            ),
            const SizedBox(height: 20.0),
            const Text('Or sign in with', textAlign: TextAlign.center),
            Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.email),
                  label: const Text('Google'),
                  onPressed: () {
                    // Handle Google Sign-In logic
                  },
                )
            ),

            Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.facebook),
                  label: const Text('Facebook'),
                  onPressed: () {
                    // Handle Facebook Sign-In logic
                  },
                )
            ),
            Padding(padding: const EdgeInsets.only(top:20.0),
              child: InkWell(
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => signin_page()));
                },
                child: const Text(
                  'Already have account?? Sign In',textAlign: TextAlign.center,style: TextStyle(
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