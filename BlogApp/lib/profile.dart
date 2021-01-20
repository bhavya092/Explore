import 'package:flutter/material.dart';
import 'package:BlogApp/add_post.dart';
import 'package:BlogApp/home_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:ui';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var isLoading = false;
  var posts;

  Future<void> _getposts() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get('http://10.0.2.2:5000/profile');
    final decoded = json.decode(response.body) as Map<String, dynamic>;
    setState(() {
      posts = decoded['posts'];
    });
    setState(() {
      isLoading = false;
    });
    for (int i = 0; i < posts.length; i++) {
      print(posts[i]['author']);
    }
    print("doneprofile");
  }

  @override
  initState() {
    super.initState();
    _getposts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Container(
              height: AppBar().preferredSize.height * 0.6,
              width: 40,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/explore_icon.png'),
                      fit: BoxFit.fill)),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 6),
              child: Text('Explore',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white38,
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width * 0.35,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage('images/explore_icon.png'),
                            fit: BoxFit.fill)),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.55,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.person, color: Colors.black),
                        SizedBox(
                          height: 3,
                        ),
                        Text('Bhavya092',
                            style:
                                TextStyle(fontSize: 18, color: Colors.black)),
                        Divider(
                          color: Colors.black,
                        ),
                        Icon(Icons.mail, color: Colors.black),
                        SizedBox(
                          height: 3,
                        ),
                        Text('bhavya@gmail.com',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                ),
                color: Colors.blueGrey[900],
              ),
              margin: EdgeInsets.symmetric(horizontal: 8),
              width: double.infinity,
              child: Text(
                "My blogs",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SingleChildScrollView(),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
            color: Colors.transparent.withOpacity(0.2)),
        margin: EdgeInsets.only(left: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FloatingActionButton(
              heroTag: "btn1",
              child: Icon(Icons.perm_identity, size: 30, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (ctx) => Profile()));
              },
              backgroundColor: Colors.cyan[100],
              elevation: 10.0,
            ),
            FloatingActionButton(
              heroTag: "btn3",
              child: Icon(
                Icons.home,
                size: 30,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (ctx) => HomePage()));
              },
              backgroundColor: Colors.cyan[100],
              elevation: 10.0,
            ),
            FloatingActionButton(
              heroTag: "btn2",
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (ctx) => AddPost()));
              },
              child: Icon(Icons.add_photo_alternate,
                  size: 30, color: Colors.black),
              backgroundColor: Colors.cyan[100],
              elevation: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}
