import 'package:flutter/material.dart';

class Validators {
  static String? validateEmail({required String? value, bool firstTime = true}) {
    if (!firstTime && (value == null || value.isEmpty)) {
      return 'Email is required';
    }
    const String regex_pattern = r'\w+@\w+\.\w+';
    RegExp regex = RegExp(regex_pattern);
    if (!firstTime && !regex.hasMatch(value!)) {
      return 'Invalid Email';
    }
    return null;
  }

  static String? validatePassword({required String? value, bool firstTime = true}) {
    if (!firstTime && (value == null || value.isEmpty)) {
      return 'Password is required';
    }
    if (!firstTime && value!.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validatePhoneNumber({required String? value, bool firstTime = true}) {
    if (!firstTime && (value == null || value.isEmpty)) {
      return 'Phone Number is required';
    }
    const String regex_pattern = r'^[0-9]{10}$';
    RegExp regex = RegExp(regex_pattern);
    if (!firstTime && !regex.hasMatch(value!)) {
      return 'Invalid Phone Number';
    }
    return null;
  }
}
