import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'PasswordStrengthBase.dart';
import 'package:password_strength/src/common.dart' show estimateCommonDictionaryStrength;

class PasswordStrengthWithController extends StatefulWidget {
  final PasswordStrengthData data;
  final TextEditingController controller;
  final OnChangeCallback onChange;
  final MeasurePasswordStrengthCallback measurePasswordStrength;

  // modify passwordstrength
  final bool smallLetters;
  final bool bigLetters;
  final bool specialChars;
  final bool numbers;

  PasswordStrengthWithController({
    Key key,
    @required this.data,
    @required this.controller,
    this.onChange,
    this.measurePasswordStrength,
    this.smallLetters = true,
    this.bigLetters = true,
    this.numbers = true,
    this.specialChars = true,
  }) : super(key: key);

  @override
  _PasswordControllerState createState() => _PasswordControllerState();
}

class _PasswordControllerState extends State<PasswordStrengthWithController> {
  PasswordStrengthData data;
  TextEditingController controller;
  OnChangeCallback onChange;
  MeasurePasswordStrengthCallback measurePasswordStrength;
  double strength = 0;

  double checkStrength(String password) {
    if(measurePasswordStrength != null) {
      return measurePasswordStrength(password);
    }else {
      return estimateBruteforceStrength(password, widget.smallLetters, widget.bigLetters, widget.specialChars, widget.numbers) * estimateCommonDictionaryStrength(password);
    }
  }

  void onChangeHandler(String value) {
    var passStrength = checkStrength(value);

    if(onChange != null) {
      onChange(value, passStrength);
    }

    setState(() {
      strength = passStrength;
      print(strength);
    });
  }
  void initState() {
    super.initState();
    data = widget.data;
    onChange = widget.onChange;
    measurePasswordStrength = widget.measurePasswordStrength;

    widget.controller.addListener(() {
      onChangeHandler(widget.controller.text);
    });
  }
  @override
  Widget build(BuildContext context) {
    return PasswordStrengthBase (
      data: data,
      strength: strength
    );
  }
}
