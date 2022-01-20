import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_health/screens/createprofile.dart';
import 'package:my_health/screens/register.dart';
import 'package:my_health/screens/verifyfirst.dart';
import 'package:my_health/utils/fire_auth.dart';
import 'package:my_health/utils/validator.dart';
import 'package:upgrader/upgrader.dart';

import 'home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class MyUpgraderMessages extends UpgraderMessages {

  @override
  String get title => 'Update Notice';

  @override
  String get body => 'A newer version of MyHealth is available. Please update to get all the latest functionalities';
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Upgrader().clearSavedSettings(); // REMOVE this for release builds

    // On iOS, the default behavior will be to use the App Store version of
    // the app, so update the Bundle Identifier in example/ios/Runner with a
    // valid identifier already in the App Store.

    // On Android, setup the Appcast below.
    final appcastURL =
        'https://raw.githubusercontent.com/larryaasen/upgrader/master/test/testappcast.xml';
    final cfg = AppcastConfiguration(url: appcastURL, supportedOS: ['android']);

    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: UpgradeAlert(
        appcastConfig: cfg,
        messages: MyUpgraderMessages(),
        dialogStyle: UpgradeDialogStyle.material,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Color.fromRGBO(250,210,224, 1.0),
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(240,110,156, 1.0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('Log In',style: TextStyle(fontSize: 25),),],
            ),
          ),
          body: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/image/logo.png',
                          fit: BoxFit.contain,
                          height: 150,
                        ),
                        SizedBox(height: 35,),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: _emailTextController,
                                focusNode: _focusEmail,
                                validator: (value) => Validator.validateEmail(
                                  email: value,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.alternate_email),
                                  border: OutlineInputBorder(),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      borderSide: BorderSide(color: Colors.red)),
                                  labelText: 'Email',
                                ),
                              ),
                              SizedBox(height: 8.0),
                              TextFormField(
                                controller: _passwordTextController,
                                focusNode: _focusPassword,
                                obscureText: true,
                                validator: (value) => Validator.validatePassword(
                                  password: value,
                                ),
                                keyboardType: TextInputType.visiblePassword,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.vpn_key_outlined),
                                  border: OutlineInputBorder(),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      borderSide: BorderSide(color: Colors.red)),
                                  labelText: 'Password',
                                ),
                              ),
                              SizedBox(height: 24.0),
                              _isProcessing
                                  ? CircularProgressIndicator()
                                  : Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: ElevatedButton(

                                      onPressed: () async {
                                        _focusEmail.unfocus();
                                        _focusPassword.unfocus();

                                        if (_formKey.currentState!.validate()) {
                                            setState(() {
                                              _isProcessing = true;
                                            }
                                          );

                                          User? user = await FireAuth.signInUsingEmailPassword(
                                            email: _emailTextController.text,
                                            password: _passwordTextController.text,
                                          );


                                          if (user != null) {
                                            if(user.emailVerified) {
                                              FirebaseFirestore.instance.collection('userprofile').doc(user.uid)
                                                .get()
                                                .then((doc) {
                                                  if (doc.exists) {
                                                    debugPrint('Completed: ' + doc.data().toString());
                                                    if(doc['completed'])
                                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home()));
                                                    else
                                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CreateProfile()));
                                                  }
                                              });
                                            }
                                            else Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Verify()));
                                          } else {
                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) => AlertDialog(
                                                title: const Text('Invalid Credentials'),
                                                content: const Text('The email or password entered is invalid.'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context, 'Okay'),
                                                    child: const Text('Okay', style: TextStyle(color: Colors.pinkAccent),),
                                                  ),
                                                ],
                                              ),);
                                          }

                                          setState(() {
                                            _isProcessing = false;
                                          });

                                        }
                                      },
                                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color.fromRGBO(240,110,156, 1.0))),
                                      child: Container(
                                        height: 50,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Log In',
                                          style: TextStyle(color: Colors.white, fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) =>
                                    Register(),
                              ),
                            );
                            throw new Exception("Test Crash");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.pink)
                            ),
                            height: 50,
                            alignment: Alignment.center,
                            child: Text(
                              'Register',
                              style: TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )

        ),
      ),
    );
  }
}

