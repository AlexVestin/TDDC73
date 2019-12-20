import 'package:flutter/material.dart';
import 'PasswordStrength.dart';
import 'dart:math';

class PasswordStrengthData {
  final int padding;
  final List<Color> colors;
  final Color colorFrom;
  final Color colorTo;
  final int stops;
  final DrawType drawType;
  final bool obscureText;
  final String label;
  final TextStyle textStyle;
  final bool customInput;
  final String password;

  PasswordStrengthData({
    Key key,
    this.colors,
    this.padding,
    @required this.password,
    this.customInput = false,
    this.textStyle = const TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontSize: 10.0, fontFamily: 'Roboto'),
    this.label = "Password Strength",
    this.drawType = DrawType.LINE,
    this.colorFrom = const Color.fromRGBO(0, 255, 0, 1),
    this.colorTo = const Color.fromRGBO(255, 0, 0, 1),
    this.stops = 5,
    this.obscureText = true,
  });
}

class PasswordStrengthBase extends StatelessWidget  {
  final PasswordStrengthData data;
  final double strength;

  PasswordStrengthBase({
    @required this.strength,
    @required this.data
  });

  @override
  Widget build(BuildContext context) {
    print(strength);

    return Container(
        height: 25,
        child: CustomPaint(
            painter: PasswordStrength(
                strength: strength,
                colors: data.colors,
                colorTo: data.colorTo,
                colorFrom: data.colorFrom,
                colorStops: data.stops,
                padding: data.padding,
                drawType: data.drawType,
                label: data.label,
                textStyle: data.textStyle
            )
        )
    );
  }
}


enum DrawType {
  CIRCLE,
  LINE,
}

typedef OnChangeCallback = void Function(String value, double strength);
typedef MeasurePasswordStrengthCallback = double Function(String value);


/// Estimates the strength of a password against a brute force attack.
/// The passwords length as well as the characters use are taken into
/// consideration.
/// (ADAPTED FROM password_strength package TO LET THE USER DECIDE TYPE)
double estimateBruteforceStrength(String password, bool small, bool big,
    bool special, bool numbers) {
  if (password.isEmpty) return 0.0;

  double charsetBonus = 0.1;
  double normalizationConstant = 15.0;


  if(!small) normalizationConstant -= 1;
  if(!big) normalizationConstant -= 2;
  if(!special) normalizationConstant -= 8;
  if (!numbers) normalizationConstant -= 4;
  if(normalizationConstant == 0) normalizationConstant += 1;

  // Check which types of characters are used and create an opinionated bonus.
  if (password.contains(RegExp(r'[a-z]')) && small) {
    charsetBonus += 1.0;
  }
  if (password.contains(RegExp(r'[0-9]')) && (numbers)) {
    charsetBonus += 4.0;
  }
  if (password.contains(RegExp(r'[A-Z]')) && (big)) {
    charsetBonus += 2.0;
  }
  if (password.contains(RegExp(r'[\-_!?@&%*]')) && (special)){
    charsetBonus += 8.0;
  }

  charsetBonus = (charsetBonus / normalizationConstant) + 1;

  final logisticFunction = (double x) {
    return 1.0 / (1.0 + exp(-x));
  };

  final curve = (double x) {
    return logisticFunction((x / 3.0) - 4.0);
  };

  return curve(password.length * charsetBonus);
}
