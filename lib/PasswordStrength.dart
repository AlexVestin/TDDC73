import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
//import 'package:password_strength/password_strength.dart';
import 'CustomCanvas.dart';
import 'package:password_strength/src/common.dart' show estimateCommonDictionaryStrength;
import "dart:math";

class PasswordStrength extends StatefulWidget {
  final OnChangeCallback onChange;
  final MeasurePasswordStrengthCallback measurePasswordStrength;
  final PasswordStrengthCallback passwordStrength;
  final int padding;

  // colors
  final List<Color> colors;
  final Color colorFrom;
  final Color colorTo;
  final int stops;
  final DrawType drawType;
  final bool obscureText;
  final String label;
  final TextStyle textStyle;

  //optional arguments for strength check. If you don't care about
  // looking at some type, you can disable by setting it to false.
  final bool smallLetters;
  final bool bigLetters;
  final bool specialChars;
  final bool numbers;


  PasswordStrength({
    Key key,
    this.colors,
    this.padding,
    this.textStyle = const TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontSize: 10.0, fontFamily: 'Roboto'),
    this.label = "Password Strength",
    this.drawType = DrawType.LINE,
    this.colorFrom = const Color.fromRGBO(0, 255, 0, 1),
    this.colorTo = const Color.fromRGBO(255, 0, 0, 1),
    this.stops = 5,
    this.obscureText = true,
    this.onChange,
    this.measurePasswordStrength,
    this.passwordStrength,
    this.smallLetters = true,
    this.bigLetters = true,
    this.numbers = true,
    this.specialChars = true,

  }) : super(key: key);

  @override
  _PasswordStrengthState createState() => _PasswordStrengthState();
}

class _PasswordStrengthState extends State<PasswordStrength> {

  OnChangeCallback onChange;
  MeasurePasswordStrengthCallback measurePasswordStrength;
  PasswordStrengthCallback passwordStrength;
  TextField myField;
  List<Color> colors;
  Color colorFrom;
  Color colorTo;
  int colorStops;
  int padding;
  DrawType drawType;
  String label;
  TextStyle textStyle;

  double strength = 0;
  void initState() {
    super.initState();
    onChange  = widget.onChange;
    measurePasswordStrength = widget.measurePasswordStrength;
    passwordStrength = widget.passwordStrength;
    colors = widget.colors;

    // Using color to / from
    colorTo = widget.colorTo;
    colorFrom = widget.colorFrom;
    colorStops = widget.stops;
    padding = widget.padding;
    drawType = widget.drawType;

    label= widget.label;
    textStyle= widget.textStyle;
  }

  void onChangeHandler(String value) {
    double passStrength = 1;
    if(measurePasswordStrength != null) {
      passStrength = measurePasswordStrength(value);
    } else {
      //passStrength = estimatePasswordStrength(value);
      passStrength = estimateBruteforceStrength(value, widget.smallLetters, widget.bigLetters,
      widget.specialChars, widget.numbers) *
          estimateCommonDictionaryStrength(value);
    }

    if(onChange != null) {
      onChange(value);
    }

    setState(() {
      strength = passStrength;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 25,
                    child: CustomPaint(
                        painter: CustomCanvas(
                          strength: strength,
                          colors: this.colors,
                          colorTo: this.colorTo,
                          colorFrom: this.colorFrom,
                          colorStops: this.colorStops,
                          padding: this.padding,
                          drawType: this.drawType,
                          label: this.label,
                          textStyle: this.textStyle
                        )
                      )
                    )
                ),
              ],
            ),

            TextField(
              onChanged: onChangeHandler,
              obscureText: widget.obscureText,
            ),
          ],
        )

    );
  }
}



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




enum DrawType {
  CIRCLE,
  LINE,
}

typedef OnChangeCallback = void Function(String value);
typedef MeasurePasswordStrengthCallback = double Function(String value);
typedef PasswordStrengthCallback = void Function(double value);

