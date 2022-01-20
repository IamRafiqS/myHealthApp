import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_health/models/user_notification.dart';
import 'package:my_health/screens/login.dart';
import 'package:my_health/screens/profile.dart';
import 'package:my_health/screens/profilesummary.dart';
import 'package:my_health/utils/notification_service.dart';


class Home extends StatefulWidget {


  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool _isSigningOut = false;

  late NotificationService notificationService;
  String name = '';

  getData(){
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('userprofile').doc(FirebaseAuth.instance.currentUser!.uid.toString()).get().then((data) {
      name = data['name'];
    });
  }

  @override
  void initState() {
    super.initState();
    notificationService = NotificationService();
    getData();
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('myHealth', style: TextStyle(fontSize: 25),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50,),
            Image.asset('assets/image/logo.png',
              fit: BoxFit.contain,
              height: 120,
            ),
            SizedBox(height: 15,),
            Text('Hi! ' + name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black45, shadows: [Shadow(
              offset: Offset(1.0, 1.0),
              blurRadius: 1.0,
              color: Colors.black12,
            ),]),),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()))
                  },
                  child: Column(
                    children: [
                      Image.asset('assets/image/profile.png',
                        fit: BoxFit.contain,
                        height: 130,),
                    ],
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Notification'),
                      content: const Text('Not yet implemented.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Okay'),
                          child: const Text('Okay', style: TextStyle(color: Colors.pinkAccent),),
                        ),
                      ],
                    ),),
                  child: Column(
                    children: [
                      Image.asset('assets/image/data.png',
                        fit: BoxFit.contain,
                        height: 130,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileSummary()))
              },
              child: Column(
                children: [
                  Image.asset('assets/image/summary.png',
                    fit: BoxFit.contain,
                    height: 130,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}