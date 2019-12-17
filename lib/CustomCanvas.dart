import 'package:flutter/material.dart';

class CustomCanvas extends CustomPainter {
  List<Color> colors;
  double strength;

  Color colorTo;
  Color colorFrom;
  int colorStops;
  int padding;

  CustomCanvas({this.colors, this.strength, this.colorTo, this.colorFrom, this.colorStops, this.padding});

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
    if(colors != null) {
      _colors = colors;
      if( (colorTo != Color.fromRGBO(0, 255, 0, 1) || colorFrom != Color.fromRGBO(255, 0, 0, 1) || colorStops != 5)) {
        print("Color array defined along using colorTo/colorFrom, defaulting to color array");
      }

    } else  {
      _colors = [];
      for(var i = 0; i < colorStops; i++) {
        _colors.add(getColor(colorFrom, colorTo, i / colorStops));
      }
    }

    for(var i = 0; i < _colors.length; i++) {
      if(strength > i / _colors.length) {
        paint.color = _colors[i];
      } else {
        paint.color = Color.fromRGBO(100, 100, 100, 0.3);
      }

      var startX = (i / _colors.length) * size.width;
      var width = (1 / _colors.length) * size.width;
      var _padding = padding != null ? padding :  width*0.1;

      canvas.drawLine(Offset(startX + _padding / 2, 0), Offset(startX + width - _padding, 0), paint);
    }

  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}