import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_health/screens/editprofile.dart';

class Profile extends StatefulWidget {
  const Profile({ Key? key }) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  late User? _currentUser;

  @override
  void initState() {
    _currentUser = FirebaseAuth.instance.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(250,210,224, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(240,110,156, 1.0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Profile',style: TextStyle(fontSize: 25),),],
        ),
      ),
      body: Padding (
        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
        child: StreamBuilder(
              stream: firestore.collection('userprofile').doc(_currentUser!.uid).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                  }

                  return Container(
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 35,),
                        Text('Name:', style: TextStyle(color: Colors.black87, fontSize: 14),),
                        Text(snapshot.data['name'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black45, shadows: [Shadow(
                          offset: Offset(1.0, 1.0),
                          blurRadius: 1.0,
                          color: Colors.black12,
                        ),]),),
                        SizedBox(height: 15,),
                        Text('Age:', style: TextStyle(color: Colors.black87, fontSize: 14),),
                        Text(snapshot.data['age'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black45, shadows: [Shadow(
                          offset: Offset(1.0, 1.0),
                          blurRadius: 1.0,
                          color: Colors.black12,
                        ),]),),
                        SizedBox(height: 15,),
                        Text('Gender:', style: TextStyle(color: Colors.black87, fontSize: 14),),
                        Text(snapshot.data['gender'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black45, shadows: [Shadow(
                          offset: Offset(1.0, 1.0),
                          blurRadius: 1.0,
                          color: Colors.black12,
                        ),]),),
                        Row(
                          children: [
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [SizedBox(height: 15,),
                              Text('Height (cm):', style: TextStyle(color: Colors.black87, fontSize: 14),),
                              Text(snapshot.data['height'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black45, shadows: [Shadow(
                                offset: Offset(1.0, 1.0),
                                blurRadius: 1.0,
                                color: Colors.black12,
                              ),]),),],),
                            SizedBox(width: 70,),
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [SizedBox(height: 15,),
                              Text('Weight (kg):', style: TextStyle(color: Colors.black87, fontSize: 14),),
                              Text(snapshot.data['weight'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black45, shadows: [Shadow(
                                offset: Offset(1.0, 1.0),
                                blurRadius: 1.0,
                                color: Colors.black12,
                              ),]),),],),
                          ],
                        ),
                        SizedBox(height: 15,),
                        Text('Activity:', style: TextStyle(color: Colors.black87, fontSize: 14),),
                        Text(snapshot.data['activity'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black45, shadows: [Shadow(
                          offset: Offset(1.0, 1.0),
                          blurRadius: 1.0,
                          color: Colors.black12,
                        ),]),),
                        SizedBox(height: 70,),
                        Center(
                          child: ElevatedButton(
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color.fromRGBO(240,110,156, 1.0))),
                            onPressed: (){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EditProfile(
                                name: snapshot.data['name'],
                                age: int.parse(snapshot.data['age'].toString()),
                                gender: snapshot.data['gender'],
                                height: double.parse(snapshot.data['height'].toString()),
                                weight: double.parse(snapshot.data['weight'].toString())
                              )));
                            }, child: Container(
                                      height: 50,
                                      alignment: Alignment.center,
                                      child: Text('Edit', style: TextStyle(color: Colors.white, fontSize: 18)),
                          )
                          ),
                        ),
                      ],
                    ),
                  );
                }),
      ),
    );
  }
}
