class MyHealthCalculation {

  double calculateBMI({required double height, required double weight}){
    double _bmi = 0, _height = 0;
    _height = height/100;
    _bmi = weight/(_height*_height);
    return _bmi;
  }

  String bmiStatus({required double bmi, required String gender}){
    if(bmi < 18.5)
      return 'Underweight';
    else if(bmi >= 18.5 && bmi <= 24.9)
      return 'Healthy Weight';
    else if(bmi >= 25 && bmi <= 29.9)
      return 'Overweight';
    else 
      return 'Obesity';
  }
}