import 'package:flutter/material.dart';
import 'package:BlogApp/add_post.dart';
import 'package:BlogApp/profile.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:ui';
import 'package:flip_card/flip_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var posts;
  bool isLoading = false;
  Widget blogsList() {
    return Container(
      child: Column(
        children: <Widget>[ListView.builder(itemBuilder: null)],
      ),
    );
  }

  Future<void> _getposts() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get('http://10.0.2.2:5000');
    final decoded = json.decode(response.body) as Map<String, dynamic>;
    setState(() {});
    posts = decoded['posts'];
    print("hello");
    setState(() {
      isLoading = false;
    });
    for (int i = 0; i < posts.length; i++) {
      print(posts[i]['author']);
    }
    print("done");
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
          elevation: 5.0,
        ),
        body: RefreshIndicator(
            onRefresh: () {
              return _getposts();
            },
            child: Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (context, i) {
                          return BlogsTile(
                            location: posts[i]['location'],
                            author: posts[i]['author'],
                            content: posts[i]['content'],
                            imageurl: posts[i]['image'],
                          );
                        },
                      )
                /*Center(
                  child: Text("hello"),
                )*/
                )),
        floatingActionButton: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
              color: Colors.black38.withOpacity(0.5)),
          margin: EdgeInsets.only(left: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              /*FloatingActionButton(
                heroTag: "btn1",
                child: Icon(Icons.perm_identity, size: 30, color: Colors.black),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (ctx) => Profile()));
                },
                backgroundColor: Colors.cyan[100],
                elevation: 10.0,
              ),*/
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
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (ctx) => AddPost()));
                },
                child: Icon(Icons.add_photo_alternate,
                    size: 30, color: Colors.black),
                backgroundColor: Colors.cyan[100],
                elevation: 10.0,
              ),
            ],
          ),
        ));
  }
}

class BlogsTile extends StatelessWidget {
  String imageurl, author, location, content;
  BlogsTile(
      {@required this.location,
      @required this.author,
      @required this.content,
      @required this.imageurl});
  @override
  Widget build(BuildContext context) {
    return FlipCard(
      direction: FlipDirection.HORIZONTAL,
      front: Container(
        height: 175,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Stack(
          children: <Widget>[
            Container(
              height: 175,
              width: double.infinity,
              // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(imageurl, fit: BoxFit.cover),
              ),
            ),
            Container(
              height: 175,
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            Container(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      location,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '~ ' + author,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w300),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      back: Container(
        height: 175,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Stack(
          children: <Widget>[
            Container(
              height: 175,
              width: double.infinity,
              // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(imageurl, fit: BoxFit.cover),
              ),
            ),
            Container(
              height: 175,
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: Center(
                  child: Text(content,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500))),
            )
          ],
        ),
      ), // default
    );
  }
}
