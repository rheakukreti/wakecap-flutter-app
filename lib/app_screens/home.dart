import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainUI();
  }
}

class MainUI extends State<Home> {
  var apiUrl = "http://api.emiratesauction.com/v2/carsonline";
  List cars;
  Map jsonData;

  Future getCar() async {
    http.Response data = await http.get(apiUrl);

    jsonData = json.decode(data.body);

    setState(() {
      cars = jsonData["Cars"];
    });

    debugPrint(cars.toString());
  }

  @override
  void initState() {
    super.initState();
    getCar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cars and Machinery"),
        backgroundColor: Colors.deepOrange,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: null),
        actions: <Widget>[Icon(Icons.language)],
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 180.0,
            margin: EdgeInsets.only(
                left: 20.0, top: 10.0, right: 20.0, bottom: 10.0),
            child: Card(
              elevation: 5.0,
              child: Row(
                children: <Widget>[
                  Image.network(cars[index]["image"], height: 100.0,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Text(
                          cars[index]["makeEn"] + " " + cars[index]["modelEn"] +
                              " " + cars[index]["year"].toString()),
                      new Text(cars[index]["AuctionInfo"]["currentPrice"]
                          .toString() + " " +
                          cars[index]["AuctionInfo"]["currencyEn"]),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text("Lot #"),
                              Text(cars[index]["AuctionInfo"]["lot"].toString())
                            ],
                          ),

                          Column(
                            children: <Widget>[
                              Text("Bids"),
                              Text(
                                  cars[index]["AuctionInfo"]["bids"].toString())
                            ],
                          ),

                          Column(
                            children: <Widget>[
                              Text("Time left"),
                              Text(cars[index]["AuctionInfo"]["endDateEn"])
                            ],
                          )

                        ],
                      )
                    ],

                  ),

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

//class Cars {
//  String image = "";
//  String model = "";
//  String make = "";
//  int year = 0;
//  int price = 0;
//  String currency = "";
//  int lot = 0;
//  int bids = 0;
//
//  //countdown
//  //ticks
//
//  Cars(this.image, this.model, this.make, this.year, this.price, this.currency,
//      this.lot, this.bids);
//}
