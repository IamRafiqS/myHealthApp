import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_health/utils/calculation.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ProfileSummary extends StatefulWidget {
  const ProfileSummary({ Key? key }) : super(key: key);

  @override
  _ProfileSummaryState createState() => _ProfileSummaryState();
}



class _ProfileSummaryState extends State<ProfileSummary> {

  MyHealthCalculation calculation = MyHealthCalculation();

  List<LinearGaugeRange> _ranges = [LinearGaugeRange(
    startValue: 0,
    endValue: 18.4,
    color: Colors.yellow,
  ), LinearGaugeRange(
    startValue: 18.5,
    endValue: 24.9,
    color: Colors.green,
  ), LinearGaugeRange(
    startValue: 25.0,
    endValue: 29.9,
    color: Colors.yellow,
  ), LinearGaugeRange(
    startValue: 30.0,
    endValue: 50,
    color: Colors.red,
  )];

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(250,210,224, 1.0),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(240,110,156, 1.0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('Profile Summary',style: TextStyle(fontSize: 25),),],
          ),
        ),
        body: Center(
          child: StreamBuilder<Object>(
            stream: FirebaseFirestore.instance.collection('userprofile').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }

              if (snapshot.connectionState == ConnectionState.done) {
              }
              
              return Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
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
                    Text(snapshot.data['age'] + ' years old', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black45, shadows: [Shadow(
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
                    SizedBox(height: 15,),
                    Text('Activity:', style: TextStyle(color: Colors.black87, fontSize: 14),),
                    Text(snapshot.data['activity'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black45, shadows: [Shadow(
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
                    SfLinearGauge(
                      axisTrackStyle: LinearAxisTrackStyle(
                        thickness: 15,
                      ),
                      maximum: 50,
                      markerPointers: [
                        LinearWidgetPointer(
                          value: double.parse(snapshot.data['bmi'].toString()),
                          child: Container(
                              height: 20,
                              width: 8,
                              decoration: BoxDecoration(color: Colors.redAccent, border: Border.all(color: Colors.black))
                          ),
                        ),
                      ],
                      ranges: _ranges,
                    ),
                    SizedBox(height: 15,),
                    Text('BMI:', style: TextStyle(color: Colors.black87, fontSize: 14),),
                    Text(snapshot.data['bmi'].toStringAsFixed(1), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black45, shadows: [Shadow(
                      offset: Offset(1.0, 1.0),
                      blurRadius: 1.0,
                      color: Colors.black12,
                    ),]),),
                    SizedBox(height: 15,),
                    Text('BMI Status:', style: TextStyle(color: Colors.black87, fontSize: 14),),
                    Text(calculation.bmiStatus(bmi: snapshot.data['bmi'], gender: snapshot.data['gender']), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black45, shadows: [Shadow(
                      offset: Offset(1.0, 1.0),
                      blurRadius: 1.0,
                      color: Colors.black12,
                    ),]),),
                  ],
                ),
              );
            }
          ),
        ),
    );
  }
}