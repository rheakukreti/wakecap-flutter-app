import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gradient_app_bar/gradient_app_bar.dart';

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
  }

  @override
  void initState() {
    super.initState();
    getCar();
  }

  final GlobalKey<RefreshIndicatorState> refreshKey =
      new GlobalKey<RefreshIndicatorState>();

  Future<Null> refresh() {
    return getCar().then((_cars) {
      setState(() {
        cars = jsonData["Cars"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List <String> dim = ["[w]", "[h]"];
    List <double> val = [300.0, 300.0];
    Map dimensions = new Map.fromIterables(dim, val);

    return Scaffold(
        appBar: GradientAppBar(
          title: Text("Cars and Machinery"),
          backgroundColorStart: Colors.pink,
          backgroundColorEnd: Colors.deepOrange,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: null),
          actions: <Widget>[Icon(Icons.language)],
        ),
        body: RefreshIndicator(
            key: refreshKey,
            onRefresh: refresh,
            child: Column(children: <Widget>[

             Card( elevation: 5.0,
               child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton.icon(
                  padding: EdgeInsets.only(top: 25.0, bottom: 25.0, left: 10.0, right: 10.0),
                  icon: Icon(Icons.filter_list),
                  label: Text("Filter"),
                ),

                FlatButton.icon(
                  padding: EdgeInsets.only(top: 25.0, bottom: 25.0, left: 10.0, right: 10.0),
                  icon: Icon(Icons.sort),
                  label: Text("Sort"),
                ),

                FlatButton.icon(
                  padding: EdgeInsets.only(top: 25.0, bottom: 25.0, left: 10.0, right: 10.0),
                  icon: Icon(Icons.view_module),
                  label: Text("Grid View"),
                ),

              ],),),

              Expanded(child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 180.0,
                  margin: EdgeInsets.only(
                      left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
                  child: Card(
                    elevation: 5.0,
                    child: Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[

                            Stack(children: <Widget>[
                              Image.network(
                                cars[index]["image"],
                                height: 170.0,
                                width: 150.0,
                              ),

//                              IconButton(
//
//                                icon: Icon(Icons.add_circle_outline),
//                                color: likeColor,
//                                onPressed: () {
//                                  setState(() {
//                                    likeColor = Colors.red;
//                                  });
//                                },
//
//                              )

                            ],)
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new Text(cars[index]["makeEn"] +
                                " " +
                                cars[index]["modelEn"] +
                                " " +
                                cars[index]["year"].toString(), style: TextStyle(
                              fontSize: 20.0,
                            ),),
                            new Text(cars[index]["AuctionInfo"]
                            ["currentPrice"]
                                .toString() +
                                " " +
                                cars[index]["AuctionInfo"]["currencyEn"], style: TextStyle(
                              fontSize: 30.0,
                            ),),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Text("Lot #"),
                                    Text(cars[index]["AuctionInfo"]["lot"]
                                        .toString())
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Text("Bids"),
                                    Text(cars[index]["AuctionInfo"]["bids"]
                                        .toString())
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Text("Time left"),
                                    Text(cars[index]["AuctionInfo"]
                                    ["endDateEn"])
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
            ),)],)
            ));
  }
}
