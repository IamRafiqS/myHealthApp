import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_health/screens/home.dart';
import 'package:my_health/utils/calculation.dart';
import 'package:my_health/utils/validator.dart';


class CreateProfile extends StatefulWidget {
  const CreateProfile({ Key? key }) : super(key: key);

  @override
  _CreateProfileState createState() => _CreateProfileState();
}

enum Gender { male, female }

class _CreateProfileState extends State<CreateProfile> {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final _editProfileFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _ageTextController = TextEditingController();
  final _heightTextController = TextEditingController();
  final _weightTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusAge = FocusNode();
  final _focusHeight = FocusNode();
  final _focusWeight = FocusNode();

  Gender? _gender;

  String _activityValue = 'Sedentary';

  List<TimeOfDay?> _reminderTime = [];
  TimeOfDay _initialTime = TimeOfDay(hour: 7, minute: 00);
  MyHealthCalculation calculator = MyHealthCalculation();

  double _listViewHeight = 0;

  bool _isProcessing = false;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        _focusName.unfocus();
        _focusAge.unfocus();
        _focusHeight.unfocus();
        _focusWeight.unfocus();
        debugPrint(_nameTextController.text);
      },
      child: Scaffold(
        backgroundColor: Color.fromRGBO(250,210,224, 1.0),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(240,110,156, 1.0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Create Profile',style: TextStyle(fontSize: 25),),
            ],
          ),
          actions: [
            _isProcessing? CircularProgressIndicator() : Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: IconButton(onPressed: () {
                _focusName.unfocus();
                _focusAge.unfocus();
                _focusHeight.unfocus();
                _focusWeight.unfocus();

                if (_editProfileFormKey.currentState!.validate()) {
                  setState(() {
                    _isProcessing = true;
                  });

                  firestore.collection('userprofile').doc(
                      FirebaseAuth.instance.currentUser!.uid).update({
                    "name": _nameTextController.text,
                    "age": _ageTextController.text,
                    "gender": (_gender.toString() == 'Gender.male') ? 'Male' : 'Female',
                    "height": _heightTextController.text,
                    "weight": _weightTextController.text,
                    "activity": _activityValue,
                    "reminders": _reminderTime.toString(),
                    "completed": true,
                    "bmi": calculator.calculateBMI(height: double.parse(_heightTextController.text), weight: double.parse(_weightTextController.text))
                  }).then((value) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
                  });

                  setState(() {
                    _isProcessing = false;
                  });

                }
              }, icon: Icon(Icons.done)),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: Column(
                children: [
                  Form(
                      key: _editProfileFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 30.0),
                          Container(
                            child: TextFormField(
                              controller: _nameTextController,
                              focusNode: _focusName,
                              validator: (value) => Validator.validateName(
                                name: value,
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                labelText: 'Name',
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Container(
                            child: TextFormField(
                              controller: _ageTextController,
                              focusNode: _focusAge,
                              validator: (value) => Validator.validateAge(
                                age: value,
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                labelText: 'Age',
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Color.fromRGBO(250,210,224, 1.0), width: 1)
                            ),
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text('Gender:', style: TextStyle(fontSize: 16),),
                                Radio(
                                  value: Gender.male,
                                  activeColor: Colors.pinkAccent,
                                  groupValue: _gender,
                                  onChanged: (Gender? value) {
                                    setState(() {
                                      _gender = value;
                                    });
                                  },
                                ),
                                Text(
                                  'Male',
                                  style: new TextStyle(fontSize: 15.0),
                                ),
                                Radio(
                                  value: Gender.female,
                                  activeColor: Colors.pinkAccent,
                                  groupValue: _gender,
                                  onChanged: (Gender? value) {
                                    setState(() {
                                      _gender = value;
                                    });
                                  },
                                ),
                                Text(
                                  'Female',
                                  style: new TextStyle(fontSize: 15.0),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _heightTextController,
                                        focusNode: _focusHeight,
                                        validator: (value) => Validator.validateHeight(
                                          height: value.toString(),
                                        ),
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(6.0),
                                            borderSide: BorderSide(
                                              color: Colors.red,
                                            ),
                                          ),
                                          labelText: 'Height',
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Text('cm'),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _weightTextController,
                                          focusNode: _focusWeight,
                                          validator: (value) => Validator.validateWeight(
                                            weight: value.toString(),
                                          ),
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(6.0),
                                              borderSide: BorderSide(
                                                color: Colors.red,
                                              ),
                                            ),
                                            labelText: 'Weight',
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5,),
                                      Text('kg'),
                                    ],
                                  )
                              ),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text('Activity:', style: TextStyle(fontSize: 16),textAlign: TextAlign.center,)),
                              SizedBox(width: 15,),
                              Container(
                                height: 62,
                                width: 200,
                                child: InputDecorator(
                                  decoration: const InputDecoration(border: OutlineInputBorder()),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _activityValue,
                                      icon: const Icon(Icons.arrow_downward),
                                      iconSize: 24,
                                      elevation: 16,
                                      style: const TextStyle(color: Colors.pinkAccent),
                                      underline: Container(
                                        height: 2,
                                        color: Colors.pinkAccent,
                                      ),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _activityValue = newValue!;
                                        });
                                      },
                                      items: <String>['Sedentary', 'Light', 'Moderate', 'Active', 'Super']
                                          .map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),

                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}