import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_health/screens/login.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Crashlytics.setup();
  runApp(MyHealth());
}

class MyHealth extends StatefulWidget {
  const MyHealth({ Key? key }) : super(key: key);

  @override
  _MyHealthState createState() => _MyHealthState();
}

class _MyHealthState extends State<MyHealth> {

  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    // initPlatformState();
  }

  // Future<void> initPlatformState() async {
  //   String platformVersion = '2';
  //
  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;
  //
  //   setState(() {
  //     _platformVersion = platformVersion;
  //   });
  // }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}