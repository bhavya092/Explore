import 'package:flutter/material.dart';
import 'package:BlogApp/home_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _showPwd = true;
  final pwd = TextEditingController();
  final cnfrmpwd = TextEditingController();
  bool hasUppercase;
  bool hasDigits;
  bool hasLowercase;
  bool hasSpecialCharacters;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  var _userName = '';
  var _userEmail = '';
  var _userPasswrod = '';
  bool right = false;
  bool _showCPwd = true;

  void password() {
    setState(() {
      _showPwd = !_showPwd;
    });
  }

  void passwordC() {
    setState(() {
      _showCPwd = !_showCPwd;
    });
  }

  void saveAll() async {
    var response;
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();

      try {
        setState(() {
          isLoading = true;
        });
        response = await http.post('http://10.0.2.2:5000/signup',
            body: json.encode({
              'username': _userName,
              'email': _userEmail,
              'password': _userPasswrod
            }));
        print('done123');
        setState(() {
          isLoading = false;
        });
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (ctx) => HomePage()));
      } on PlatformException catch (err) {
        setState(() {
          isLoading = false;
        });
        var message = 'An error occured. Please try again.';
        if (err.message != null) {
          message = err.message;
        }
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title:
                    Text('Some error occured.', style: TextStyle(fontSize: 18)),
                content: Text(message),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      } catch (err) {
        setState(() {
          isLoading = false;
        });
        print(err);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/auth.png"),
              fit: BoxFit.cover,
            ),
          ),

          child: Container(
            padding: EdgeInsets.all(25),
            color: Colors.black38,
            child: SingleChildScrollView(
              // child: Expanded
              //(

              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.08,
                    ),
                    Center(
                      child: Text('Create a new account',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    TextFormField(
                      initialValue: null,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 16),
                        errorStyle: TextStyle(color: Colors.white),
                      ),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) {
                        _userName = value;
                        FocusScope.of(context).unfocus();
                      },
                      onSaved: (value) {
                        _userName = value;
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    TextFormField(
                      initialValue: null,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 16),
                        errorStyle: TextStyle(color: Colors.white),
                      ),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) {
                        _userEmail = value;
                        FocusScope.of(context).unfocus();
                      },
                      onSaved: (value) {
                        _userEmail = value;
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    TextFormField(
                      initialValue: null,
                      controller: pwd,
                      decoration: InputDecoration(
                          labelText: '*Password',
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          errorStyle: TextStyle(color: Colors.white),
                          suffixIcon: IconButton(
                            icon: _showPwd
                                ? Icon(Icons.visibility_off,
                                    color: Colors.white)
                                : Icon(Icons.visibility, color: Colors.white),
                            onPressed: () => password(),
                          )),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                      obscureText: _showPwd,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) {
                        _userPasswrod = value;
                        FocusScope.of(context).unfocus();
                      },
                      onSaved: (value) {
                        _userPasswrod = value;
                      },
                    ),
                    TextFormField(
                      initialValue: null,
                      controller: cnfrmpwd,
                      decoration: InputDecoration(
                          labelText: '* Confirm Password',
                          labelStyle:
                              TextStyle(color: Colors.white, fontSize: 16),
                          errorStyle: TextStyle(color: Colors.white),
                          suffixIcon: IconButton(
                            icon: _showPwd
                                ? Icon(Icons.visibility_off,
                                    color: Colors.white)
                                : Icon(Icons.visibility, color: Colors.white),
                            onPressed: () => passwordC(),
                          )),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                      obscureText: _showCPwd,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        if (value != pwd.text) {
                          return 'Passwrods do not match!';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).unfocus();
                      },
                      onSaved: (value) {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      // padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width*0.25),
                      child: isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : FlatButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                saveAll();
                              },
                              child: Column(
                                children: <Widget>[
                                  Text('Sign Up',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontStyle: FontStyle.italic)),
                                ],
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              // ),
            ),
          ),
          // ),
        ),
      ),
    );
  }
}
