import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  // Below is a test list
  final List<List<dynamic>> objects = [["assets/flutter.jpg", "title1"], ["assets/flutter.jpg", "title2"], ["assets/flutter.jpg", "title3"]
  , ["assets/flutter.jpg", "title4"], ["assets/flutter.jpg", "title5"], ["assets/flutter.jpg", "title6"], ["assets/flutter.jpg", "title7"]
  ,["assets/flutter.jpg", "title8"] ,["assets/flutter.jpg", "title9"] ,["assets/flutter.jpg", "title10"]];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Carousel(
        amount: 5,
        displayType: DisplayType.HORIZONTAL,
        itemBuilder: CarouselObject.objectBuilder(objects),
      ),
    );
  }
}

/// required amount : How many items to show at a time
/// required displayType: defines how to display images (vertically or horizontally)
/// required itemBuilder: list of display items
/// of format [['image','title',(Optional)component],...]
/// canClick : defines if items should be clicked
/// Size : Define the size of the display image
class Carousel extends StatefulWidget {
  final DisplayType displayType;
  final List<CarouselObject> itemBuilder;
  final bool canClick;
  final Size size;
  final int amount;

  Carousel({
    Key key,
    @required this.amount,
    @required this.displayType,
    @required this.itemBuilder,
    this.canClick = false,
    this.size = const Size(16, 16),
  }) : super(key: key);

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {

  List<List<CarouselObject>> displayObjects = [];
  int index = 0; // we look at the first set on displayObject
  // and then we increase index to look at next set.

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    var len = widget.itemBuilder.length;
    var size = widget.amount;
    for( int i = 0; i < len; i+=size){
      int end = i + size < len ? i + size : len;
      displayObjects.add(widget.itemBuilder.sublist(i, end));
    }

  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints ){
        if(constraints.maxWidth > 300 && constraints.maxHeight > 50){
          if(widget.displayType == DisplayType.HORIZONTAL){
            return Center(
              child: Dismissible(
                key: ValueKey(index),
                onDismissed: (DismissDirection direction){
                  setState((){
                    index += direction == DismissDirection.endToStart ? 1 : -1;
                    if(index > displayObjects.length - 1) {
                      index = 0;
                    } else if( index < 0) {
                      index = displayObjects.length - 1;
                    }
                  });
                },
                // On swipe, increase index (look at next set),
                child: Container(
                  color: Colors.white,
                  width: 500,
                  height: 300,
                  child: Row(
                    children: displayObjects[index].map(
                  (element) =>
                    Container(
                      width: constraints.maxWidth / widget.amount,
                      child: Column(
                        children: <Widget>[
                          Image(
                          image: AssetImage(element.displayImage),
                          ),
                          Text(
                            element.title
                          )
                        ],
                      ),
                    )
                  ).toList(),
                  )
                ),
              ),
            );
          }
          else {
            return Container(
              child : Text("Too low terrain")
            );
          }
        }
        else{
          return Container();
        }
      },
    );
  }
}

enum DisplayType {
  VERTICAL,
  HORIZONTAL,
}

///CaourselObject defines each display item.
///First argument is the image to display, second is title you want to display,
///third is its attached component to display on-click (optional)
class CarouselObject {
  final String displayImage;
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
