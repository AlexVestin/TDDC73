import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final List<List<dynamic>> objects = [["image1", "title1"]];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Carousel(
        amount: 10,
        displayType: DisplayType.HORIZONTAL,
        itemBuilder: CarouselObject.objectBuilder(objects),
      ),
    );
  }
}

class Carousel extends StatefulWidget {
  final int amount;
  final DisplayType displayType;
  final List<CarouselObject> itemBuilder;
  final bool canClick;

  Carousel({
    Key key,
    @required this.amount,
    @required this.displayType,
    @required this.itemBuilder,
    this.canClick = false,
  }) : super(key: key);

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

enum DisplayType {
  VERTICAL,
  HORIZONTAL,
}

///CaourselObject defines each display item.
///First argument is the image to display, second is title you want to display,
///third is its attached component for on-click (optional)
class CarouselObject {
  final Image displayImage;
  final String title;
  var componentElement;

  CarouselObject(this.displayImage, this.title, [componentElement]) {
    this.componentElement = componentElement ?? DefaultBox();
  }

  static List<CarouselObject> objectBuilder(List<List<dynamic>> object) {
    object.forEach((element) =>
      element.length < 2 ? throw Exception("List item ${object.indexOf(element)} has too few items") : ""
     );
    return object
        .map((listObject) => CarouselObject(listObject[0], listObject[1],
            listObject.length > 2 ? listObject[2] : DefaultBox()))
        .toList();
  }
}

class DefaultBox extends StatelessWidget {
  DefaultBox();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
