import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_health/screens/login.dart';
import 'package:my_health/screens/verifyfirst.dart';
import 'package:my_health/utils/fire_auth.dart';
import 'package:my_health/utils/validator.dart';

class Register extends StatefulWidget {
  const Register({ Key? key }) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final _registerFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusName.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromRGBO(250,210,224, 1.0),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(240,110,156, 1.0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Text('Register',
                style: TextStyle(fontSize: 25),
              ),

            ],
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Image.asset('assets/image/logo.png',
                  fit: BoxFit.contain,
                  height: 150,
                ),
                SizedBox(height: 35,),
                Form(
                  key: _registerFormKey,
                  child: Column(
                    children: [
                      Container(
                        child: TextFormField(
                          controller: _nameTextController,
                          focusNode: _focusName,
                          validator: (value) => Validator.validateName(
                            name: value,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.perm_identity),
                            border: OutlineInputBorder(),
                            errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          labelText: 'Username',
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Container(
                        child: TextFormField(
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
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          labelText: 'Email',
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Container(
                        child: TextFormField(
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
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          labelText: 'Password',
                          ),
                        ),
                      ),
                      SizedBox(height: 24.0),
                        _isProcessing
                            ? CircularProgressIndicator()
                            : Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        setState(() {
                                          _isProcessing = true;
                                        });

                                        if (_registerFormKey.currentState!.validate()) {
                                          User? user = await FireAuth.registerUsingEmailPassword(
                                            name: _nameTextController.text,
                                            email: _emailTextController.text,
                                            password: _passwordTextController.text,
                                          );

                                          if (user != null) {
                                            FirebaseFirestore.instance.collection('userprofile').doc(FirebaseAuth.instance.currentUser!.uid).set({
                                              "username": _nameTextController.text,
                                              "completed": false,
                                            }).then((value) {
                                              user.sendEmailVerification().then((value) => {
                                              Navigator.of(context).pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                builder: (context) => Verify(),
                                              ),
                                              ModalRoute.withName('/')
                                              )
                                              });
                                            });
                                          } else {
                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) => AlertDialog(
                                                title: const Text('User already exists'),
                                                content: const Text('The email entered has already registered.'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context, 'Okay'),
                                                    child: const Text('Okay', style: TextStyle(color: Colors.pinkAccent),),
                                                  ),
                                                ],
                                              ),);
                                          }
                                        }

                                        setState(() {
                                          _isProcessing = false;
                                        });
                                      },
                                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color.fromRGBO(240,110,156, 1.0))),
                                      child: Container(
                                        height: 50,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Sign up',
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
                                    Login(),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.pink)
                            ),
                            height: 50,
                            alignment: Alignment.center,
                            child: Text(
                              'Login',
                              style: TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ),
                        ),
              ],
            ),
          ),
        ),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}