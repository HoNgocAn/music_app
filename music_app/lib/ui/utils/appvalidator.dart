class AppValidator{
  String? validateUser(value) {
    if (value!.isEmpty) {
      return "Please enter an email";
    }
    if (value.length > 30) {
      return "Email must be less than 30 characters";
    }
    return null;
  }

  String? validateEmail(value) {
    if (value!.isEmpty) {
      return "Please enter an email";
    }
    RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegExp.hasMatch(value)) {
      return "Please enter a valid email";
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    if (value!.isEmpty) {
      return "Please enter a phone number";
    }

    if (value.length < 9 || value.length > 14) {
      return "Phone number must be between 9 and 14 digits";
    }

    RegExp phoneRegExp = RegExp(
      r'^\+?\d+$',
    );
    if (!phoneRegExp.hasMatch(value)) {
      return "Please enter a valid phone number";
    }
    return null;
  }

  String? validatePassword(value) {
    if (value!.isEmpty) {
      return "Please enter a password";
    }
    if (value.length > 30) {
      return "Password must be less than 30 characters";
    }
    return null;
  }

  String? isEmptyCheck(String? value) {
    if (value == null || value.isEmpty) {
      return "Please fill details";
    }
    return null;
  }

}