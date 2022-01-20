

class Validator {

  static String? validateName({required String? name}) {

    if (name == null) return null;

    if (name.isEmpty) return 'Name can\'t be empty';

    return null;

  }

  static String? validateAge({required String? age}) {

    if (age == null) return null;

    if (age.isEmpty) return 'Age can\'t be empty';

    if(int.parse(age) <= 0) return 'Invalid age';

    return null;

  }

  static String? validateHeight({required String? height}) {

    if (height == null) return null;

    if (height.isEmpty) return 'Can\'t empty';

    if(double.parse(height) <= 0) return 'Invalid height';

    return null;

  }

  static String? validateWeight({required String? weight}) {

    if (weight == null) return null;

    if (weight.isEmpty) return 'Can\'t empty';

    if(double.parse(weight) <= 0) return 'Invalid weight';

    return null;

  }


  static String? validateEmail({required String? email}) {
    if (email == null) return null;
    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    if (email.isEmpty) return 'Email can\'t be empty';
    else if (!emailRegExp.hasMatch(email)) return 'Enter a correct email';

    return null;
  }

  static String? validatePassword({required String? password}) {
    if (password == null) return null;
    if (password.isEmpty) return 'Password can\'t be empty';
    else if (password.length < 6) return 'Enter a password with length at least 6';

    return null;
  }
}