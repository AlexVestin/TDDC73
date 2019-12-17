import 'package:flutter/material.dart';
import 'package:flutter_proj/carousel.dart';
import 'PasswordStrength.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  // Below is a test list
  final List<List<dynamic>> objects = [["assets/phone.jpg", "longer title"], ["assets/flutter.jpg", "title2"], ["assets/wide.jpg", "title3"]
  , ["assets/flutter.jpg", "title4"], ["assets/flutter.jpg", "title5"], ["assets/flutter.jpg", "title6"], ["assets/flutter.jpg", "title7"]
  ,["assets/flutter.jpg", "title8"] ,["assets/flutter.jpg", "title9"] ,["assets/flutter.jpg", "title10"]];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Demo carousel"),
        ),
        body: Column(
          children: <Widget>[

            Container(
              margin: EdgeInsets.all(10),
              width: 400,
              height: 150,
              child: Carousel(
                amount: 4,
                displayType: DisplayType.HORIZONTAL,
                itemBuilder: CarouselObject.objectBuilder(objects),
              ),
            ),  Container(
                width: 200,
                child: PasswordStrength(
                    obscureText: true,
                    padding: 1,
                    colorFrom: Color.fromRGBO(255, 0, 0, 1),
                    colorTo: Color.fromRGBO(0, 255, 0, 1),
                    stops: 10,
                    drawType: DrawType.CIRCLE,
                )
            ),
            Row(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.all(2),
                    width : 310,
                    height: 200,
                    child: Carousel(
                      amount: 2,
                      displayType: DisplayType.VERTICAL,
                        itemBuilder: CarouselObject.objectBuilder(objects),
                    ),
                  ),
                ),
                Flexible(
                  flex : 1,
                  child: Container(
                    margin: EdgeInsets.all(2),
                    width : 310,
                    height: 200,
                    child: Carousel(
                      amount: 2,
                      displayType: DisplayType.HORIZONTAL,
                      itemBuilder: CarouselObject.objectBuilder(objects),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(2),
                child: Carousel(
                  size: Size(128, 128),
                  amount: 1,
                  displayType: DisplayType.HORIZONTAL,
                  itemBuilder: CarouselObject.objectBuilder(objects),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

