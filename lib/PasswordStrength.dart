import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:password_strength/password_strength.dart';
import 'CustomCanvas.dart';

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

  final bool obscureText;

  PasswordStrength({
    Key key,
    this.colors,
    this.padding,
    this.colorFrom = const Color.fromRGBO(0, 255, 0, 1),
    this.colorTo = const Color.fromRGBO(255, 0, 0, 1),
    this.stops = 5,
    this.obscureText = true,
    this.onChange,
    this.measurePasswordStrength,
    this.passwordStrength,

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

  }

  void onChangeHandler(String value) {
    double passStrength = 1;
    if(measurePasswordStrength != null) {
      passStrength = measurePasswordStrength(value);
    } else {
      passStrength = estimatePasswordStrength(value);
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
                    child: CustomPaint(
                        painter: CustomCanvas(
                          strength: strength,
                          colors: this.colors,
                          colorTo: this.colorTo,
                          colorFrom: this.colorFrom,
                          colorStops: this.colorStops,
                          padding: this.padding,
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

typedef OnChangeCallback = void Function(String value);
typedef MeasurePasswordStrengthCallback = double Function(String value);
typedef PasswordStrengthCallback = void Function(double value);

