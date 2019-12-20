import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'PasswordStrengthBase.dart';
import 'package:password_strength/src/common.dart' show estimateCommonDictionaryStrength;

class PasswordStrengthWithInput extends StatefulWidget {
  final PasswordStrengthData data;
  final OnChangeCallback onChange;
  final MeasurePasswordStrengthCallback measurePasswordStrength;

  // modify passwordstrength
  final bool smallLetters;
  final bool bigLetters;
  final bool specialChars;
  final bool numbers;

  PasswordStrengthWithInput({
    Key key,
    @required this.data,
    this.onChange,
    this.measurePasswordStrength,
    this.smallLetters = true,
    this.bigLetters = true,
    this.numbers = true,
    this.specialChars = true
  }) : super(key: key);

  @override
  _PasswordStrengthWithInput createState() => _PasswordStrengthWithInput();
}

class _PasswordStrengthWithInput extends State<PasswordStrengthWithInput> {
  PasswordStrengthData data;
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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: PasswordStrengthBase (
                  data: data,
                  strength: strength
              ),
            )
          ],
        ),

        Row(
          children: <Widget>[
            Expanded(
              child:  TextField(onChanged: onChangeHandler)
            )
          ],
        ),

      ],
    );
  }
}
