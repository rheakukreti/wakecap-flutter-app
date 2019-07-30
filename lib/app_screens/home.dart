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
var textDir=TextDirection.ltr;

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainUI();
  }
}

class MainUI extends State<Home> {

  var lang=["English", "عربى"];
  var currentItem = "English";

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

    return MaterialApp(
      title: 'Cars and Machinery',
      debugShowCheckedModeBanner: false,

      home: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100.0),
            child: GradientAppBar(
              title: Text("Cars and Machinery"),
              backgroundColorStart: Colors.pink,
              backgroundColorEnd: Colors.deepOrange,
              centerTitle: true,
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: null),
              actions: <Widget>[
                DropdownButton<String>(icon: Icon(Icons.language, color: Colors.white, size: 30.0,),

                  underline: SizedBox(width: 0.0,),

                  items: lang.map((String menuItem){
                    return DropdownMenuItem<String>(
                      value: menuItem,
                      child: Text(menuItem),
                    );
                  }).toList(),

                  onChanged: (String selectedValue){

                  setState(() {
                    this.currentItem=selectedValue;
                    currentItem=="English"?flag="En":flag="Ar";
                  });

                  debugPrint(flag);

                  },

                )
              ],
            ),
          ),
          body: RefreshIndicator(
              key: refreshKey,
              onRefresh: refresh,
              child: Column(
                children: <Widget>[
                  topBar(),
                  scrollText(),
           carsList(),
                ],
              ))),
    );
  }
}

//Widget appBarDesign() {
//  return PreferredSize(
//    preferredSize: Size.fromHeight(100.0),
//    child: GradientAppBar(
//      title: Text("Cars and Machinery"),
//      backgroundColorStart: Colors.pink,
//      backgroundColorEnd: Colors.deepOrange,
//      centerTitle: true,
//      leading: IconButton(
//          icon: Icon(
//            Icons.arrow_back,
//            color: Colors.white,
//          ),
//          onPressed: null),
//      actions: <Widget>[
//        DropdownButton<String>(icon: Icon(Icons.language),
//
//          items: lang.map((String menuItem){
//            return DropdownMenuItem<String>(
//              value: menuItem,
//              child: Text(menuItem),
//            );
//          }).toList(),
//
//          onChanged: (String selectedValue){
//
//
//          },
//
//        )
//      ],
//    ),
//  );
//}

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
          label: Text("Filter", style: TextStyle(color: Colors.black)),
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
            style: TextStyle(color: Colors.black),
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
          label: Text("Grid View", style: TextStyle(color: Colors.black)),
        ),
      ],
    ),
  );
}

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

Widget carsList(){

  return Expanded(child: ListView.builder(
    itemCount: cars == null ? 0 : cars.length,
    itemBuilder: (BuildContext context, int index) {
      return Container(
        height: 150.0,
        margin: EdgeInsets.only(
            left: 10.0,top: 10.0,bottom: 10.0, right: 10.0),
        child: Card(
          elevation: 5.0,
          child: Row(
            children: <Widget>[
              Expanded(flex: 5,
                child: Container(foregroundDecoration: BoxDecoration(image: DecorationImage(image: NetworkImage(fixDimensions(cars[index]["image"])),
                    fit: BoxFit.fill
                ),) ),


              ),
              Expanded(
                flex: 6,
                child: Container(margin: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment
                      .spaceEvenly,
                  children: <Widget>[
                     Text(cars[index]["make$flag"] +
                        " " +
                        cars[index]["model$flag"] +
                        " " +
                        cars[index]["year"].toString(),
                      style: TextStyle(
                        fontSize: 20.0,
                      ),),
                     Text(cars[index]["AuctionInfo"]
                    ["currentPrice"]
                        .toString() +
                        " " +
                        cars[index]["AuctionInfo"]["currency$flag"],
                      style: TextStyle(
                        fontSize: 30.0,
                      ),),
                    Row(crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Lot #",),
                             Text(cars[index]["AuctionInfo"]["lot"]
                                .toString())
                          ],
                        ),

                        Container(
                          height: 25.0,
                          width: 1.0,
                          color: Colors.grey,
                        ),
                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Bids"),
                            Text(
                                cars[index]["AuctionInfo"]["bids"]
                                    .toString())
                          ],
                        ),

                        Container(
                          height: 25.0,
                          width: 1.0,
                          color: Colors.grey,
                        ),

                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                           children: <Widget>[
                            Text("Time left"),

                          ],
                        )
                      ],
                    )
                  ],
                ),) ),
            ],
          ),
        ),
      );
    },
  ),);

}
