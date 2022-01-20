import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_health/screens/createprofile.dart';
import 'package:my_health/screens/login.dart';
import 'package:my_health/utils/fire_auth.dart';

class Verify extends StatefulWidget {

  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {

  late bool fromLogin;

  User? user;

  bool _isSigningOut = false;

  getUser() async {
    user = await FireAuth.refreshUser(FirebaseAuth.instance.currentUser);
  }

  check() async {
    await getUser();
    debugPrint(user!.emailVerified.toString());
    if(user!.emailVerified) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreateProfile()));
    }
      
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(250,210,224, 1.0),
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () async {
                setState(() {
                  _isSigningOut = true;
                });
                await FirebaseAuth.instance.signOut();
                setState(() {
                  _isSigningOut = false;
                });
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                );
              },
              child: Icon(Icons.logout),
            ),
          )
        ],
        backgroundColor: Color.fromRGBO(240,110,156, 1.0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Image.asset('assets/image/logobar.png',
                fit: BoxFit.cover,
                height: 30,
              ),
            ),
          ],
        ),
      ),
      body: InkWell(
        onTap: () {
          check();
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Image.asset('assets/image/confirmemail.png',
            fit: BoxFit.cover,
            height: 90,
            ),
            SizedBox(height: 10,),
            Text('Please check your email for verification process.', style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
            SizedBox(height: 70,),
            Text('Didn\'t get the email?'),
            SizedBox(height: 8,),
            Container(
              height: 40,
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color.fromRGBO(240,110,156, 1.0)),),
                onPressed: () {
                  user!.sendEmailVerification();
                }, 
                label: Text('Resend'), 
                icon: Icon(Icons.arrow_upward_outlined),
                  
                ),
            ),
            ],
          ),
        ),
      )
    );
  }
}