import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:labb2/utils/formatters.dart';
import 'package:flip_card/flip_card.dart';

void main() => runApp(MaterialApp(home: Home()));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String month = "MM";
  String year = "YYYY";
  String cardNumber = "#### #### #### ####";
  String cardName = "Felix Westin";
  String imageName = "mastercard.png";
  String CCV;
  var imageMap = {"5": "mastercard.png", "4": "visa.png", "34" : "amex.png",
  "37" : "amex.png", "6" : "discover.png", "30" : "dinersclub.png", "36" : "dinersclub.png",
  "38" : "dinersclub.png"};

  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 150,
            left: 5,
            child: Card(
              elevation: 10,
              color: Colors.white,
              child: Container(
                width: 390,
                height: 420,
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 140, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      TextFormField(
                        onChanged: (String value) {
                          cardKey.currentState.isFront ? "" : cardKey.currentState.toggleCard();
                          imageName = imageMap.containsKey(value) ? imageMap[value]  : imageName;
                          setState(() {
                            cardNumber = value;
                          });
                        },
                        inputFormatters: <TextInputFormatter>[
                          CreditCardFormatter(),
                          LengthLimitingTextInputFormatter(19)
                        ] ,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          hintText: "",
                          labelText: "Card Number",
                        ),
                      ),
                      TextFormField(
                        onChanged: (String value) {
                          cardKey.currentState.isFront ? "" : cardKey.currentState.toggleCard();
                          setState(() {
                            cardName = value;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          hintText: "",
                          labelText: "Card Name",
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.fromLTRB(5, 10, 0, 0),
                          child: Text("Expiration date")),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            DropdownButton<String>(
                              hint: Text("Month"),
                              value: month,
                              onChanged: (String value) {
                                cardKey.currentState.isFront ? "" : cardKey.currentState.toggleCard();
                                setState(() {
                                  month = value;
                                });
                              },
                              items: <String>["MM","01", "02", "03"]
                                  .map<DropdownMenuItem<String>>((String value) {
                                return (DropdownMenuItem<String>(
                                    value: value, child: Text("$value")));
                              }).toList(),
                            ),
                            DropdownButton<String>(
                              hint: Text("Year"),
                              value: year,
                              onChanged: (String value) {
                                cardKey.currentState.isFront ? "" : cardKey.currentState.toggleCard();
                                setState(() {
                                  year = value;
                                });
                              },
                              items: <String>["YYYY","2027", "2026", "2025"]
                                  .map<DropdownMenuItem<String>>((String value) {
                                return (DropdownMenuItem<String>(
                                    value: value, child: Text("$value")));
                              }).toList(),
                            ),
                            Container(
                              width: 100,
                              child: TextFormField(
                                onChanged: (String value){
                                  cardKey.currentState.isFront ? cardKey.currentState.toggleCard() : "";
                                  setState(() {
                                    CCV = value;
                                  });
                                },
                                inputFormatters: <TextInputFormatter>[
                                  WhitelistingTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(4)
                                ],
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  hintText: "",
                                  labelText: "CCV",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      RaisedButton(
                        color: Colors.blue,
                        child: Text(
                          "Submit",
                          style: TextStyle(
                            color: Colors.grey[100],
                          ),
                        ),
                        onPressed: () {},
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 15,
            child: FlipCard(
              key: cardKey,
              flipOnTouch: true,
              front: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 10,
                color: Colors.white,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                          image: AssetImage("assets/6.jpeg"), fit: BoxFit.cover)),
                  width: 370,
                  height: 220,
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 400,
                        height: 40,
                        margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                        child: Row(
                          children: <Widget>[Image(
                            image: AssetImage("assets/chip.png"),
                          ),
                            SizedBox(width: 230,),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              width: 80,
                              height: 120,
                              child: Image(
                                  image: AssetImage("assets/" + imageName )),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 350,
                        height: 40,
                        margin: EdgeInsets.fromLTRB(10, 50 , 30, 0),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.white),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                      "$cardNumber",
                      style: TextStyle(
                            fontSize: 24,
                            letterSpacing: 1,
                            color: Colors.white,
                      ), textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 30, 10, 0),
                        child: Column(
                          children: <Widget>[Row(
                            children: <Widget>[
                              Text("Card Holder", style:
                                TextStyle(
                                  color: Colors.grey
                                ),
                              textAlign: TextAlign.start,),
                            SizedBox(width: 203,),
                              Text("Expires", style:
                              TextStyle(
                                  color: Colors.grey
                              ),
                                textAlign: TextAlign.start,)],
                          ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[Container(
                                width:275 ,
                                child: Text("$cardName",
                                  style: TextStyle(fontSize: 16, color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2),),
                              ),
                              Text(month + "/" + year.substring(2, 4),
                                style: TextStyle(fontSize: 16, color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2),)],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              back: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 10,
                color: Colors.white,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                          image: AssetImage("assets/6.jpeg"), fit: BoxFit.cover)),
                  width: 370,
                  height: 220,
                  child: Column(
                    children: <Widget>[Row(
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.black87,
                          margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                          height: 50,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      width: 310,
                      height: 45,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1, color: Colors.white),
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                        "$CCV", style: TextStyle(
                          fontSize: 16,
                        ),
                    ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 2, 30, 0),
                        width: 60,
                        height: 60,
                        child: Image(
                            image: AssetImage("assets/" + imageName )),
                      ),
                    )],
                  ),
                ),
              ) ,
            ),
          )
        ],
      ),
    );
  }
}
