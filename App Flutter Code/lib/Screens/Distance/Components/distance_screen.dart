import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:tesi/Components/background.dart';
import 'package:tesi/Components/distance_chart.dart';
import 'package:tesi/Components/stat.dart';
import 'package:tesi/global.dart' as globals;
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:tesi/data.dart' as data;

class DistancePage extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const DistancePage({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  _DistancePageState createState() => _DistancePageState();
}

class _DistancePageState extends State<DistancePage>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Color textColor;
  Color containerColor;
  int tresholdDistance;
  int _updateTime = 0;
  int _lastDistance = 200;
  int _averageDistance = 200;
  int _lastAlert = 0;
  int _alertNumber = 0;
  Timer timer;
  TabController _tabController;
  List<double> _barValues = <double>[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

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
    tresholdDistance = globals.tresholdDistance;
    _lastDistance = data.distances.first;
    _lastAlert = DateTime.now().difference(data.alertDates.first).inMinutes;
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
                            child: Text("Distanza",
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
              height: size.height * 0.3,
              width: size.width * 0.9,
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: new Column(children: <Widget>[
                Container(
                  height: size.height * 0.25,
                  width: size.width * 0.8,
                  child: DistanceChart(
                    barValues: _barValues,
                  ),
                ),
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
              height: size.height * 0.37,
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
                Stat(
                  label: "Ultima distanza:",
                  data: (_lastDistance / 100).toString() + " m",
                  dataColor: _lastDistance > globals.tresholdDistance
                      ? textColor
                      : Colors.red,
                ),
                SizedBox(height: 15),
                Stat(
                  label: "Distanza media:",
                  data: (_averageDistance / 100).toString() + " m",
                  dataColor: _averageDistance > globals.tresholdDistance ||
                          _averageDistance == 0
                      ? textColor
                      : Colors.red,
                ),
                SizedBox(height: 15),
                Stat(
                  label: "Ultimo alert:",
                  data: _lastAlert < 60
                      ? (_lastAlert).toString() + " minuti fa"
                      : _lastAlert < 1440
                          ? (_lastAlert ~/ 60).toString() + " ore fa"
                          : (_lastAlert ~/ 1440).toString() + " giorni fa",
                  dataColor: textColor,
                ),
                SizedBox(height: 15),
                Stat(
                  label: "Numero alert:",
                  data: (_alertNumber).toString(),
                  dataColor: textColor,
                ),
                SizedBox(height: 12),
                Container(
                  width: size.width * 0.9,
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FlatButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                      color: globals.lightTheme
                          ? Color(globals.textColor)
                          : Colors.white,
                      onPressed: () {
                        globals.streamController.add(6);
                      },
                      child: Text("Impostazioni misurazione",
                          style: TextStyle(
                              color: containerColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                )
              ]))
        ])))));
  }

  void fetchData() {
    data.fetchDistance().then((result) {
      setState(() {
        _lastDistance = data.distances.first;
        updateDay();
      });
    });
    data.fetchAlert().then((result) {
      setState(() {
        if (timer != null) timer.cancel();

        _alertNumber = data.alerts.length;
        timer = new Timer.periodic(
            Duration(seconds: 1),
            (Timer timer) => setState(() {
                  _updateTime =
                      DateTime.now().difference(data.fetchDateTime).inMinutes;
                  _lastAlert = DateTime.now()
                      .difference(data.alertDates.first)
                      .inMinutes;
                }));

        _tabController.index = 0;
        _controller.stop();
        _controller.value = 0;
      });
      updateDay();
    });
  }

  void updateDay() {
    var fetchedDistances = data.distances;
    var fetchedDates = data.distanceDates;

    setState(() {
      var distanceNumber = data.distanceDates
          .where((i) =>
              DateTime.now().day == i.day &&
              DateTime.now().month == i.month &&
              DateTime.now().year == i.year &&
              DateTime.now().difference(i).inSeconds > 0)
          .length;

      var distances = fetchedDistances.sublist(0, distanceNumber);
      var dates = fetchedDates.sublist(0, distanceNumber);

      for (DateTime d in dates) {
        if (d.hour < 6 || d.hour > 22) {
          distances.removeAt(dates.indexOf(d));
          dates.remove(d);
        }
      }

      _averageDistance = distances.length > 0
          ? distances.reduce((a, b) => a + b) ~/ distances.length
          : 0;

      _alertNumber = data.alertDates
          .where((i) =>
              DateTime.now().day == i.day &&
              DateTime.now().month == i.month &&
              DateTime.now().year == i.year &&
              DateTime.now().difference(i).inSeconds > 0)
          .length;

      _barValues = <double>[
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
      ];

      print(distances);
      print(dates);

      for (int i = 1; i <= 16; i++) {
        List<int> selectedDistances = <int>[];
        for (DateTime d in dates) {
          if (d.hour >= 5 + i && d.hour < 6 + i)
            selectedDistances.add(distances[dates.indexOf(d)]);
        }

        print(7 + i);
        print(selectedDistances);

        _barValues[i - 1] = selectedDistances.length > 0
            ? selectedDistances.reduce((a, b) => a + b) /
                selectedDistances.length
            : 0;
      }
    });
  }

  void updateWeek() {
    var fetchedDistances = data.distances;
    var fetchedDates = data.distanceDates;

    setState(() {
      var distanceNumber = data.distanceDates
          .where((i) =>
              DateTime.now().difference(i).inDays < 7 &&
              DateTime.now().difference(i).inSeconds > 0)
          .length;

      var distances = fetchedDistances.sublist(0, distanceNumber);
      var dates = fetchedDates.sublist(0, distanceNumber);

      for (DateTime d in dates) {
        if (d.hour < 6 || d.hour > 22) {
          distances.removeAt(dates.indexOf(d));
          dates.remove(d);
        }
      }

      _averageDistance = distances.length > 0
          ? distances.reduce((a, b) => a + b) ~/ distances.length
          : 0;

      _alertNumber = data.alertDates
          .where((i) =>
              DateTime.now().difference(i).inDays < 7 &&
              DateTime.now().difference(i).inSeconds > 0)
          .length;

      _barValues = <double>[
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
      ];

      print(distances);
      print(dates);

      for (int i = 1; i <= 16; i++) {
        List<int> selectedDistances = <int>[];
        for (DateTime d in dates) {
          if (d.hour >= 5 + i && d.hour < 6 + i)
            selectedDistances.add(distances[dates.indexOf(d)]);
        }

        print(7 + i);
        print(selectedDistances);

        _barValues[i - 1] = selectedDistances.length > 0
            ? selectedDistances.reduce((a, b) => a + b) /
                selectedDistances.length
            : 0;
      }
    });
  }

  void updateMonth() {
    var fetchedDistances = data.distances;
    var fetchedDates = data.distanceDates;

    setState(() {
      var distanceNumber = data.distanceDates
          .where((i) =>
              DateTime.now().difference(i).inDays < 30 &&
              DateTime.now().difference(i).inSeconds > 0)
          .length;

      var distances = fetchedDistances.sublist(0, distanceNumber);
      var dates = fetchedDates.sublist(0, distanceNumber);

      for (DateTime d in dates) {
        if (d.hour < 6 || d.hour > 22) {
          distances.removeAt(dates.indexOf(d));
          dates.remove(d);
        }
      }

      _averageDistance = distances.length > 0
          ? distances.reduce((a, b) => a + b) ~/ distances.length
          : 0;

      _alertNumber = data.alertDates
          .where((i) =>
              DateTime.now().difference(i).inDays < 30 &&
              DateTime.now().difference(i).inSeconds > 0)
          .length;

      _barValues = <double>[
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
      ];

      print(distances);
      print(dates);

      for (int i = 1; i <= 16; i++) {
        List<int> selectedDistances = <int>[];
        for (DateTime d in dates) {
          if (d.hour >= 5 + i && d.hour < 6 + i)
            selectedDistances.add(distances[dates.indexOf(d)]);
        }

        print(7 + i);
        print(selectedDistances);

        _barValues[i - 1] = selectedDistances.length > 0
            ? selectedDistances.reduce((a, b) => a + b) /
                selectedDistances.length
            : 0;
      }
    });
  }

  void updateYear() {
    var fetchedDistances = data.distances;
    var fetchedDates = data.distanceDates;

    setState(() {
      var distanceNumber = data.distanceDates
          .where((i) =>
              DateTime.now().difference(i).inDays < 365 &&
              DateTime.now().difference(i).inSeconds > 0)
          .length;

      var distances = fetchedDistances.sublist(0, distanceNumber);
      var dates = fetchedDates.sublist(0, distanceNumber);

      for (DateTime d in dates) {
        if (d.hour < 6 || d.hour > 22) {
          distances.removeAt(dates.indexOf(d));
          dates.remove(d);
        }
      }

      _averageDistance = distances.length > 0
          ? distances.reduce((a, b) => a + b) ~/ distances.length
          : 0;

      _alertNumber = data.alertDates
          .where((i) =>
              DateTime.now().difference(i).inDays < 365 &&
              DateTime.now().difference(i).inSeconds > 0)
          .length;

      _barValues = <double>[
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
      ];

      print(distances);
      print(dates);

      for (int i = 1; i <= 16; i++) {
        List<int> selectedDistances = <int>[];
        for (DateTime d in dates) {
          if (d.hour >= 5 + i && d.hour < 6 + i)
            selectedDistances.add(distances[dates.indexOf(d)]);
        }

        print(7 + i);
        print(selectedDistances);

        _barValues[i - 1] = selectedDistances.length > 0
            ? selectedDistances.reduce((a, b) => a + b) /
                selectedDistances.length
            : 0;
      }
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
