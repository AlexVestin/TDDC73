import 'package:flutter/material.dart';

/// required amount : How many items to show at a time
/// required displayType: defines how to display images (vertically or horizontally)
/// required itemBuilder: list of display items
/// of format [['image','title',(Optional)component],...]
/// canClick : defines if items should be clicked
/// Size : Define the size of the display image
/// EMBED THE CAROUSEL IN A WIDGET
class Carousel extends StatefulWidget {
  final DisplayType displayType;
  final List<CarouselObject> itemBuilder;
  final Size size;
  final int amount;

  Carousel({
    Key key,
    @required this.amount,
    @required this.displayType,
    @required this.itemBuilder,
    this.size = const Size(128, 128),
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
        if(widget.displayType == DisplayType.HORIZONTAL){
          return Dismissible(
            key: ValueKey(index),
            onDismissed: (DismissDirection direction){
              // On swipe, increase index (look at next set),
              setState((){
                index += direction == DismissDirection.endToStart ? 1 : -1;
                if(index > displayObjects.length - 1) {
                  index = 0;
                } else if( index < 0) {
                  index = displayObjects.length - 1;
                }
              });
            },
            child: Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: displayObjects[index].map(
                          (element) =>
                          Container(
                            margin: EdgeInsets.all(2),
                            width: (constraints.maxWidth / widget.amount) - 8,
                            //width : widget.size.width - 8,
                            height: widget.size.height,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Card(
                                elevation: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image(
                                      image: AssetImage(element.displayImage),
                                    ),
                                    Text(
                                      element.title
                                      , style: TextStyle(
                                      fontSize: 56,
                                    ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                  ).toList(),
                )
            ),
          );
        }
        else {
          return Dismissible(
            direction: DismissDirection.vertical,
            key: ValueKey(index),
            onDismissed: (DismissDirection direction) {
              setState(() {
                index += direction == DismissDirection.endToStart ? 1 : -1;
                if (index > displayObjects.length - 1) {
                  index = 0;
                } else if (index < 0) {
                  index = displayObjects.length - 1;
                }
              });
            },
            // On swipe, increase index (look at next set),
            child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: displayObjects[index].map(
                          (element) =>
                          Container(
                            margin: EdgeInsets.all(2),
                            height: (constraints.maxHeight / widget.amount) -
                                8,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Card(
                                elevation: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image(
                                      image: AssetImage(element.displayImage),
                                    ),
                                    Text(
                                      element.title
                                      , style: TextStyle(
                                      fontSize: 56,
                                    ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                  ).toList(),
                )
            ),
          );
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
/// Component on click has yet to be implemented.
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