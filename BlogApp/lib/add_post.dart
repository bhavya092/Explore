import 'dart:io';
import 'package:BlogApp/home_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
/*import 'package:dio/dio.dart';
import 'package:loading/loading.dart';
import 'package:http_parser/http_parser.dart';*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:BlogApp/home_page.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

final cloudinary = CloudinaryPublic('dnrlnufs4', 'ml_default', cache: false);

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final _formKey = GlobalKey<FormState>();
  String author = '';
  String location = '';
  String content = '';
  File image;
  final picker = ImagePicker();
  var imageUrl = '';
  bool isLoading = false;

  Future getImage() async {
    image = await ImagePicker.pickImage(source: ImageSource.gallery);

    /*setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });*/
    print("hello");
    //var image = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<void> validateForm() async {
    var response;
    final isValid = _formKey.currentState.validate();
    if (!isValid) return null;
    if (isValid && (image != null)) {
      setState(() {
        isLoading = true;
      });
      _formKey.currentState.save();

      final ref = FirebaseStorage.instance
          .ref()
          .child('locations')
          .child(DateTime.now().toString() + '.jpg');
      print("11");
      await ref.putFile(image).onComplete;
      print('22');
      final url = await ref.getDownloadURL();
      print('33');
      print(url.toString());

      response = await http.post('http://10.0.2.2:5000/post',
          body: json.encode({
            'location': location,
            'author': author,
            'content': content,
            'image': url,
            'author_id': 1234
          }));
    }
    setState(() {
      isLoading = false;
    });
    print(response.statusCode.toString());
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (ctx) => HomePage()));
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
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.file_upload, color: Colors.white),
              onPressed: () {})
        ],
      ),
      body: isLoading
          ? Container(
              height: MediaQuery.of(context).size.height * 1,
              width: double.infinity,
              color: Colors.black26,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Posting your blog....',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            )
          : Container(
              height: MediaQuery.of(context).size.height * 1,
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            image == null
                                ? Container(
                                    height: 250,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          topRight: Radius.circular(10.0),
                                          bottomLeft: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0),
                                        ),
                                        color: Colors.black38),
                                    child: Center(
                                      child: IconButton(
                                          icon:
                                              Icon(Icons.add_a_photo, size: 30),
                                          onPressed: () {
                                            getImage();
                                          }),
                                    ))
                                : Container(
                                    height: 250,
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(image,
                                            fit: BoxFit.cover))),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                                initialValue: null,
                                decoration: InputDecoration(
                                  labelText: ' Author',
                                  labelStyle:
                                      TextStyle(color: Colors.blueGrey[600]),
                                  errorStyle: TextStyle(color: Colors.red),
                                  contentPadding: EdgeInsets.all(10.0),
                                ),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color: Colors.black),
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please provide a value.';
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context).unfocus();
                                  author = value;
                                  FocusScope.of(context).unfocus();
                                },
                                onSaved: (value) {
                                  FocusScope.of(context).unfocus();
                                  author = value;
                                }),
                            TextFormField(
                                initialValue: null,
                                decoration: InputDecoration(
                                  labelText: 'Location',
                                  labelStyle:
                                      TextStyle(color: Colors.blueGrey[600]),
                                  errorStyle: TextStyle(color: Colors.red),
                                  contentPadding: EdgeInsets.all(10.0),
                                ),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color: Colors.black),
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please provide a value.';
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context).unfocus();
                                  location = value;
                                  FocusScope.of(context).unfocus();
                                },
                                onSaved: (value) {
                                  FocusScope.of(context).unfocus();
                                  location = value;
                                }),
                            TextFormField(
                                initialValue: null,
                                decoration: InputDecoration(
                                  labelText: 'Description',
                                  labelStyle:
                                      TextStyle(color: Colors.blueGrey[600]),
                                  errorStyle: TextStyle(color: Colors.red),
                                  contentPadding: EdgeInsets.all(10.0),
                                ),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color: Colors.black),
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please provide a value.';
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context).unfocus();
                                  content = value;
                                  FocusScope.of(context).unfocus();
                                },
                                onSaved: (value) {
                                  FocusScope.of(context).unfocus();
                                  content = value;
                                }),
                            SizedBox(height: 20),
                            FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(20.0)),
                              onPressed: () {
                                validateForm();
                              },
                              child: Text("Post ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              color: Colors.cyan[300],
                              splashColor: Colors.white,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
      /*floatingActionButton: Container(
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
        )*/
    );
  }
}
