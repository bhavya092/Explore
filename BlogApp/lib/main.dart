import 'package:flutter/material.dart';

import 'package:BlogApp/signin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MyBlog',
        theme: ThemeData(
          fontFamily: 'Raleway',
        ),
        home: SignIn());
  }
}
