import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gradient_app_bar/gradient_app_bar.dart';

var apiUrl = "http://api.emiratesauction.com/v2/carsonline";
List cars;
Map jsonData;
List<String> dim = ["[w]", "[h]"], val = ["0", "0"];
Map<String, String> map = new Map.fromIterables(dim, val);
String flag = "En";
var textDir = TextDirection.ltr;

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainUI();
  }
}

class MainUI extends State<Home> {
  var lang = ["English", "عربى"];
  var currentItem = "English";

  //Get future data from API
  Future getCar() async {
    http.Response data = await http.get(apiUrl);

    jsonData = json.decode(data.body);

    setState(() {
      cars = jsonData["Cars"];
    });
  }

  //Define initial state of app
  @override
  void initState() {
    super.initState();
    getCar();
  }

  final GlobalKey<RefreshIndicatorState> refreshKey =
      new GlobalKey<RefreshIndicatorState>();

  //Future state after refresh
  Future<Null> refresh() {
    return getCar().then((_cars) {
      setState(() {
        cars = jsonData["Cars"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //Main layout of the app

    return MaterialApp(
      title: 'Cars and Machinery',
      debugShowCheckedModeBanner: false,
      home: Scaffold(

          //Appbar layout
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100.0),
            child: GradientAppBar(
              title: Text(
                "Cars and Machinery",
                style: TextStyle(
                    fontFamily: 'RobotoCondensed', fontWeight: FontWeight.w700),
              ),
              backgroundColorStart: Colors.pink,
              backgroundColorEnd: Colors.deepOrange,
              centerTitle: true,

              //Language button on appbar
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: null),
              actions: <Widget>[
                DropdownButton<String>(
                  icon: Icon(
                    Icons.language,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  underline: SizedBox(
                    width: 0.0,
                  ),
                  items: lang.map((String menuItem) {
                    return DropdownMenuItem<String>(
                      value: menuItem,
                      child: Text(menuItem),
                    );
                  }).toList(),

                  //Changing language values through dropdown menu
                  onChanged: (String selectedValue) {
                    //
                    setState(() {
                      this.currentItem = selectedValue;
                      currentItem == "English" ? flag = "En" : flag = "Ar";
                    });
                  },
                )
              ],
            ),
          ),

          //App body beyond appbar
          body: RefreshIndicator(
              key: refreshKey,
              onRefresh: refresh,
              child: Column(
                children: <Widget>[
                  //Top bar widget
                  topBar(),

                  //Scroll to refresh test widget
                  scrollText(),

                  //Car information long list widget
                  carsList(),
                ],
              ))),
    );
  }
}

//Top bar widget
Widget topBar() {
  return Card(
    elevation: 5.0,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        FlatButton.icon(
          padding:
              EdgeInsets.only(top: 25.0, bottom: 25.0, left: 10.0, right: 10.0),
          icon: Icon(Icons.filter_list),
          label: Text("Filter",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.w700)),
        ),
        Container(
          height: 55.0,
          width: 1.0,
          color: Colors.grey,
        ),
        FlatButton.icon(
          padding:
              EdgeInsets.only(top: 25.0, bottom: 25.0, left: 10.0, right: 10.0),
          icon: Icon(Icons.sort),
          label: Text(
            "Sort",
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.w700),
          ),
        ),
        Container(
          height: 55.0,
          width: 1.0,
          color: Colors.grey,
        ),
        FlatButton.icon(
          padding:
              EdgeInsets.only(top: 25.0, bottom: 25.0, left: 10.0, right: 10.0),
          icon: Icon(Icons.view_module),
          label: Text("Grid View",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.w700)),
        ),
      ],
    ),
  );
}

//Scroll to refresh test widget
Widget scrollText() {
  return Container(
    margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
    child: Text(
      "Scroll down to search",
      style: TextStyle(color: Colors.grey),
    ),
  );
}

String fixDimensions(String x) {
  return map.entries.fold(x, (prev, e) => prev.replaceAll(e.key, e.value));
}

//Car information long list widget
Widget carsList() {
  return Expanded(
    child: ListView.builder(
      itemCount: cars == null ? 0 : cars.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 150.0,
          margin:
              EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
          child: Card(
            elevation: 5.0,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Container(
                      foregroundDecoration: BoxDecoration(
                    image: DecorationImage(
                        image:
                            NetworkImage(fixDimensions(cars[index]["image"])),
                        fit: BoxFit.fill),
                  )),
                ),
                Expanded(
                    flex: 6,
                    child: Container(
                      margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            cars[index]["make$flag"] +
                                " " +
                                cars[index]["model$flag"] +
                                " " +
                                cars[index]["year"].toString(),
                            style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'RobotoCondensed',
                                fontWeight: FontWeight.w700),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                cars[index]["AuctionInfo"]["currentPrice"]
                                    .toString(),
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 28.0,
                                    fontFamily: 'RobotoCondensed',
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                cars[index]["AuctionInfo"]["currency$flag"],
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Lot #",
                                    style: TextStyle(
                                        fontFamily: 'RobotoCondensed',
                                        fontWeight: FontWeight.w300,
                                        color: Colors.grey),
                                  ),
                                  Text(
                                    cars[index]["AuctionInfo"]["lot"]
                                        .toString(),
                                    style: TextStyle(
                                        fontFamily: 'RobotoCondensed',
                                        fontWeight: FontWeight.w700),
                                  )
                                ],
                              ),
                              Container(
                                height: 25.0,
                                width: 1.0,
                                color: Colors.grey,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Bids",
                                    style: TextStyle(
                                        fontFamily: 'RobotoCondensed',
                                        fontWeight: FontWeight.w300,
                                        color: Colors.grey),
                                  ),
                                  Text(
                                    cars[index]["AuctionInfo"]["bids"]
                                        .toString(),
                                    style: TextStyle(
                                        fontFamily: 'RobotoCondensed',
                                        fontWeight: FontWeight.w700),
                                  )
                                ],
                              ),
                              Container(
                                height: 25.0,
                                width: 1.0,
                                color: Colors.grey,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Time left",
                                    style: TextStyle(
                                        fontFamily: 'RobotoCondensed',
                                        fontWeight: FontWeight.w300,
                                        color: Colors.grey),
                                  ),
                                  Text(
                                    "00:00:00",
                                    style: TextStyle(
                                        fontFamily: 'RobotoCondensed',
                                        fontWeight: FontWeight.w700),
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    )),
              ],
            ),
          ),
        );
      },
    ),
  );
}
