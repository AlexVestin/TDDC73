import 'package:flutter/material.dart';
import 'package:flutter_proj/PasswordStrengthBase.dart';

class PasswordStrength extends CustomPainter {
  List<Color> colors;
  double strength;
  Color colorTo;
  Color colorFrom;
  int colorStops;
  int padding;
  DrawType drawType;
  String label;
  TextStyle textStyle;

  PasswordStrength({
      @required this.strength,
      this.textStyle = const TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontSize: 10.0, fontFamily: 'Roboto'),
      this.label = "Password Strength",
      this.drawType = DrawType.LINE,
      this.colorFrom = const Color.fromRGBO(0, 255, 0, 1),
      this.colorTo = const Color.fromRGBO(255, 0, 0, 1),
      this.colors,
      this.colorStops,
      this.padding,
    });

  Color getColor(Color color1, Color color2, double percent) {
    int r = (color1.red + percent * (color2.red - color1.red)).round();
    int g = (color1.green + percent * (color2.green - color1.green)).round();
    int b = (color1.blue + percent * (color2.blue - color1.blue)).round();
    return Color.fromRGBO(r, g, b, 1);
  }

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    var _colors = [
      Color.fromRGBO(255, 0, 0, 1),
      Color.fromRGBO(200, 50, 0, 1),
      Color.fromRGBO(120, 120, 0, 1),
      Color.fromRGBO(100, 200, 0, 1),
      Color.fromRGBO(0, 255, 0, 1),
    ];
    if (colors != null) {
      _colors = colors;
      if ((colorTo != Color.fromRGBO(0, 255, 0, 1) ||
          colorFrom != Color.fromRGBO(255, 0, 0, 1) ||
          colorStops != 5)) {
        print(
            "Color array defined along using colorTo/colorFrom, defaulting to color array");
      }
    } else {
      _colors = [];
      for (var i = 0; i < colorStops; i++) {
        _colors.add(getColor(colorFrom, colorTo, i / colorStops));
      }
    }

    for (var i = 0; i < _colors.length; i++) {
      if (strength > i / _colors.length) {
        paint.color = _colors[i];
      } else {
        paint.color = Color.fromRGBO(100, 100, 100, 0.3);
      }

      var startX = (i / _colors.length) * size.width;
      var width = (1 / _colors.length) * size.width;
      var _padding = padding != null ? padding : width * 0.1;

      double verticalOffset = 20;
      if (drawType == DrawType.LINE) {
        canvas.drawLine(Offset(startX + _padding / 2, verticalOffset),
            Offset(startX + width - _padding, verticalOffset), paint);
      } else if (drawType == DrawType.CIRCLE) {
        canvas.drawCircle(Offset(startX + width / 2, verticalOffset), 3, paint);
      }

      TextSpan span = new TextSpan(style: textStyle, text: label);
      TextPainter tp =
          new TextPainter(text: span, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, new Offset(0.0, -5.0));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
