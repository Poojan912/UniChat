import 'package:flutter/material.dart';

class call_page extends StatefulWidget {
  const call_page({super.key});

  @override
  State<call_page> createState() => _call_pageState();
}

class _call_pageState extends State<call_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade100,
        title : Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset('assets/image/image_no_bg.png',width: 50,fit: BoxFit.contain,),
            Spacer(flex: 1),
            Text(
              "Call",
              style: TextStyle(fontSize: 30),
            ),
            Spacer(),
            InkWell(
              onTap: (){
                //handle search function
              } ,
              child: Icon(Icons.search,size: 32),
            )


          ],
        ),
      ),
    );
  }
}

