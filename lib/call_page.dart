import 'package:flutter/material.dart';

class call_page extends StatefulWidget {
  const call_page({super.key});

  @override
  State<call_page> createState() => _call_pageState();
}

class _call_pageState extends State<call_page> {
  List<String> lastCalledUsers = (['User 1']);

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

              } ,
              child: Icon(Icons.search,size: 32),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: lastCalledUsers.isEmpty
                ? Center(
              child: Text('No recent calls'),
            )
                : ListView.builder(
              itemCount: lastCalledUsers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(lastCalledUsers[index]),
                  onTap: () {
                    // Implement logic to initiate call with selected user

                  },
                );
              },
            ),
          ),
          if (lastCalledUsers.isEmpty)
            ElevatedButton(
              onPressed: () {
                // Implement logic to navigate to user search screen

              },
              child: Text('Search for users to call'),
            ),
        ],
      ),
    );
  }
}
