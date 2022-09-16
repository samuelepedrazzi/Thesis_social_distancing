import 'dart:async';
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tesi/Components/background.dart';
import 'package:tesi/Components/stat.dart';
import 'package:tesi/Screens/Temperature/Components/temperature_list.dart';
import 'package:tesi/global.dart' as globals;
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:tesi/data.dart' as data;

class TemperaturePage extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const TemperaturePage({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  _TemperaturePageState createState() => _TemperaturePageState();
}

class _TemperaturePageState extends State<TemperaturePage>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Color textColor;
  Color containerColor;
  int _updateTime = 0;
  double _lastTemperature = 36.9;
  double _averageTemperature = 36;
  int _temperatureNumber = 0;

  int _lastTemperatureTime;
  Timer timer;
  TabController _tabController;
  List<FlSpot> _chartValues = <FlSpot>[
    FlSpot(0, 0),
    FlSpot(1, 0),
    FlSpot(2, 0),
    FlSpot(3, 0),
    FlSpot(4, 0),
    FlSpot(5, 0),
    FlSpot(6, 0),
    FlSpot(7, 0),
    FlSpot(8, 0),
    FlSpot(9, 0),
    FlSpot(10, 0),
    FlSpot(11, 0),
    FlSpot(12, 0),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 4);
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1))
          ..repeat();
    _controller.stop();
    textColor = Color(globals.textColor);
    containerColor = Color(globals.containerColor);
    _lastTemperature = data.temperatures.first;
    _lastTemperatureTime =
        DateTime.now().difference(data.temperatureDates.first).inMinutes;
    updateDay();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context)
        .size; //this size provide us total height and width of our screen

    return WillPopScope(
        onWillPop: () async {
          globals.streamController.add(0);
          return false;
        },
        child: Scaffold(
            body: Background(
                child: SingleChildScrollView(
                    child: Column(children: <Widget>[
          Container(
              height: size.height * 0.2,
              width: size.width * 0.9,
              child: Column(children: <Widget>[
                Flexible(
                    child: Row(children: <Widget>[
                  Container(
                      child: Column(children: <Widget>[
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            padding:
                                EdgeInsets.only(top: 100, right: 0, bottom: 0),
                            child: Text("Temperatura",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 36,
                                    color: textColor))))
                  ])),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.only(top: 75),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: AnimatedBuilder(
                          animation: _controller,
                          builder: (_, child) {
                            return Transform.rotate(
                              angle: _controller.value * 4 * math.pi,
                              child: child,
                            );
                          },
                          child: IconButton(
                            icon: Icon(Icons.refresh, color: textColor),
                            iconSize: 30,
                            onPressed: () {
                              _controller.forward();
                              fetchData();
                            },
                          )),
                    ),
                  ))
                ]))
              ])),
          Container(
              height: size.height * 0.18,
              width: size.width * 0.9,
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: new Column(children: <Widget>[
                Container(
                    height: size.height * 0.13,
                    width: size.width * 0.8,
                    child: Container(
                        height: size.height * 0.04,
                        width: size.width * 0.6,
                        child: Column(children: <Widget>[
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          Flexible(
                              child: Row(children: <Widget>[
                            Container(
                                width: size.width * 0.43,
                                margin: EdgeInsets.only(top: 4),
                                height: size.height * 0.08,
                                child: Column(children: <Widget>[
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Temperatura attuale",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 28,
                                            color: textColor,
                                          )))
                                ])),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(top: 10),
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      _lastTemperature.toStringAsPrecision(3) +
                                          "°",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 46,
                                          color: _lastTemperature > 37
                                              ? Colors.red
                                              : Color(0xff5BBA6F)),
                                    )),
                              ),
                            )
                          ]))
                        ]))),
                SizedBox(
                  height: size.height * 0.006,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding: EdgeInsets.only(left: 20, top: 10),
                    child: Text(
                      ("Ultimo aggiornamento: " +
                          _updateTime.toString() +
                          " minuti fa"),
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 11,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
              ])),
          SizedBox(height: size.height * 0.02),
          Container(
              height: size.height * 0.20,
              width: size.width * 0.9,
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Center(
                  child: Column(children: <Widget>[
                Text("Ultime Misurazioni",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      color: textColor,
                    )),
                SizedBox(height: size.height * 0.02),
                TemperatureList(temperatures: data.temperatures.sublist(0, 9)),
              ]))),
          SizedBox(height: size.height * 0.02),
          Container(
              height: size.height * 0.27,
              width: size.width * 0.9,
              padding: EdgeInsets.only(left: 20, right: 20, top: 10),
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: new Column(children: <Widget>[
                DefaultTabController(
                  length: 4,
                  child: Container(
                    height: 50.0,
                    child: TabBar(
                      controller: _tabController,
                      indicator: BubbleTabIndicator(
                        tabBarIndicatorSize: TabBarIndicatorSize.tab,
                        indicatorHeight: 40.0,
                        indicatorColor: textColor,
                      ),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                      ),
                      labelColor: containerColor,
                      unselectedLabelColor: textColor,
                      tabs: <Widget>[
                        Text("giorno"),
                        Text("sett"),
                        Text("mese"),
                        Text("anno")
                      ],
                      onTap: (index) {
                        switch (index) {
                          case 0:
                            updateDay();
                            break;
                          case 1:
                            updateWeek();
                            break;
                          case 2:
                            updateMonth();
                            break;
                          case 3:
                            updateYear();
                            break;
                          default:
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(height: 12),
                SizedBox(height: 15),
                Stat(
                  label: "Numero misurazioni:",
                  data: (_temperatureNumber).toString(),
                  dataColor: textColor,
                ),
                SizedBox(height: 15),
                Stat(
                  label: "Temperatura media:",
                  data: _averageTemperature.toStringAsPrecision(3) + "°",
                  dataColor:
                      _averageTemperature < 37.0 ? textColor : Colors.red,
                ),
                SizedBox(height: 15),
                Stat(
                  label: "Ultima temperatura:",
                  data: _lastTemperatureTime < 60
                      ? (_lastTemperatureTime).toString() + " minuti fa"
                      : _lastTemperatureTime < 1440
                          ? (_lastTemperatureTime ~/ 60).toString() + " ore fa"
                          : (_lastTemperatureTime ~/ 1440).toString() +
                              " giorni fa",
                  dataColor: textColor,
                ),
              ]))
        ])))));
  }

  void fetchData() {
    data.fetchTemperature().then((result) {
      setState(() {
        _lastTemperature = data.temperatures.first;
        updateDay();
        _tabController.index = 0;
        _controller.stop();
        _controller.value = 0;
      });
    });
  }

  // void updateHour() {
  //   setState(() {
  //     var fetchedTemperatures = data.temperatures;
  //     var temperatureNumber = data.temperatureDates
  //         .where((i) =>
  //             DateTime.now().difference(i).inHours <= 1 &&
  //             DateTime.now().difference(i).inSeconds > 0)
  //         .length;
  //     _temperatureNumber = temperatureNumber;
  //     var temperatures = fetchedTemperatures.sublist(0, temperatureNumber);
  //     _averageTemperature = temperatures.length > 0
  //         ? temperatures.reduce((a, b) => a + b) / temperatures.length
  //         : 0;

  //     _chartValues = <FlSpot>[
  //       FlSpot(0, 34),
  //       FlSpot(1, 34),
  //       FlSpot(2, 34),
  //       FlSpot(3, 34),
  //       FlSpot(4, 34),
  //       FlSpot(5, 34),
  //       FlSpot(6, 34),
  //       FlSpot(7, 34),
  //       FlSpot(8, 34),
  //       FlSpot(9, 34),
  //       FlSpot(10, 34),
  //       FlSpot(11, 34),
  //     ];
  //     temperatures = data.temperatures;
  //     for (int i = 1; i <= 12; i++) {
  //       var temperatureNumber = data.temperatureDates
  //           .where((d) =>
  //               DateTime.now().difference(d).inMinutes <= 5 * i &&
  //               DateTime.now().difference(d).inMinutes >= 5 * (i - 1) &&
  //               DateTime.now().difference(d).inSeconds > 0)
  //           .length;

  //       var selectedTemperatures = temperatures.sublist(0, temperatureNumber);
  //       print(i);
  //       print(selectedTemperatures);

  //       temperatures =
  //           temperatures.sublist(temperatureNumber, temperatures.length);
  //       if (selectedTemperatures.length > 0) {
  //         var average = selectedTemperatures.reduce((a, b) => a + b) /
  //             selectedTemperatures.length;
  //         _chartValues[i - 1] =
  //             FlSpot((i - 1) / 1, math.min(math.max(average, 34), 39));
  //       } else
  //         _chartValues[i - 1] = FlSpot((i - 1) / 1, 34);
  //     }
  //   });
  // }

  void updateDay() {
    var fetchedTemperatures = data.temperatures;

    setState(() {
      var temperatureNumber = data.temperatureDates
          .where((i) =>
              DateTime.now().day == i.day &&
              DateTime.now().month == i.month &&
              DateTime.now().year == i.year &&
              DateTime.now().difference(i).inSeconds > 0)
          .length;

      _temperatureNumber = temperatureNumber;

      var temperatures = fetchedTemperatures.sublist(0, temperatureNumber);

      _averageTemperature = temperatures.length > 0
          ? temperatures.reduce((a, b) => a + b) / temperatures.length
          : 0.0;
    });
  }

  void updateWeek() {
    var fetchedTemperatures = data.temperatures;

    setState(() {
      var temperatureNumber = data.temperatureDates
          .where((i) =>
              DateTime.now().difference(i).inDays < 7 &&
              DateTime.now().difference(i).inSeconds > 0)
          .length;

      _temperatureNumber = temperatureNumber;

      var temperatures = fetchedTemperatures.sublist(0, temperatureNumber);

      _averageTemperature = temperatures.length > 0
          ? temperatures.reduce((a, b) => a + b) / temperatures.length
          : 0.0;
    });
  }

  void updateMonth() {
    var fetchedTemperatures = data.temperatures;

    setState(() {
      var temperatureNumber = data.temperatureDates
          .where((i) =>
              DateTime.now().difference(i).inDays < 30 &&
              DateTime.now().difference(i).inSeconds > 0)
          .length;

      _temperatureNumber = temperatureNumber;

      var temperatures = fetchedTemperatures.sublist(0, temperatureNumber);

      _averageTemperature = temperatures.length > 0
          ? temperatures.reduce((a, b) => a + b) / temperatures.length
          : 0.0;
    });
  }

  void updateYear() {
    var fetchedTemperatures = data.temperatures;

    setState(() {
      var temperatureNumber = data.temperatureDates
          .where((i) =>
              DateTime.now().difference(i).inDays < 365 &&
              DateTime.now().difference(i).inSeconds > 0)
          .length;

      _temperatureNumber = temperatureNumber;

      var temperatures = fetchedTemperatures.sublist(0, temperatureNumber);

      _averageTemperature = temperatures.length > 0
          ? temperatures.reduce((a, b) => a + b) / temperatures.length
          : 0.0;
    });
  }

  @override
  void dispose() {
    super.dispose();

    if (timer != null) timer.cancel();
    _controller.stop();
    _tabController.dispose();
  }
}
