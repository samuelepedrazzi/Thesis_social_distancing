import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:tesi/Components/background.dart';
import 'package:tesi/Components/distance_chart.dart';
import 'package:tesi/Screens/HomePage/Components/distance_home_card.dart';
import 'package:tesi/Screens/HomePage/Components/temperature_home_card.dart';
import 'package:tesi/global.dart' as globals;
import 'package:tesi/data.dart' as data;
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const HomePage({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  int _lastDistance = 200;
  double _lastTemperature = 36;
  Timer timer;
  int _updateTime = 3;
  List<int> _otherDistances = <int>[200, 200, 200, 200, 200, 200];
  List<double> _otherTemperatures = <double>[
    36.0,
    36.0,
    36.0,
    36.0,
    36.0,
    36.0
  ];
  List<double> _barValues = <double>[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  Color textColor;
  Color containerColor;
  int tresholdDistance;
  bool firstTime = true;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1))
          ..repeat();
    textColor = Color(globals.textColor);
    containerColor = Color(globals.containerColor);
    tresholdDistance = globals.tresholdDistance;
  }

  void fetchData() {
    data.fetchDistance().then((result) {
      setState(() {
        _lastDistance = data.distances.first;
        _otherDistances = data.distances.sublist(1, 7);

        if (timer != null) timer.cancel();
        timer = new Timer.periodic(
            Duration(seconds: 1),
            (Timer timer) => setState(() {
                  _updateTime =
                      DateTime.now().difference(data.fetchDateTime).inMinutes;
                }));
      });
      updateBar();
    });
    data.fetchTemperature().then((value) {
      setState(() {
        _lastTemperature = data.temperatures.first;
        _otherTemperatures = data.temperatures.sublist(1, 7);
        _controller.stop();
        _controller.value = 0;
      });
    });
    data.fetchAlert();
  }

  void updateUI() {
    setState(() {
      _lastDistance = data.distances.first;
      _otherDistances = data.distances.sublist(1, 7);

      if (timer != null) timer.cancel();
      timer = new Timer.periodic(
          Duration(seconds: 1),
          (Timer timer) => setState(() {
                _updateTime =
                    DateTime.now().difference(data.fetchDateTime).inMinutes;
              }));
    });
    updateBar();

    setState(() {
      _lastTemperature = data.temperatures.first;
      _otherTemperatures = data.temperatures.sublist(1, 7);
      _controller.stop();
      _controller.value = 0;
    });
  }

  final Future<bool> _data = _fetchData();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: _data,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("Errore: ${snapshot.error.toString()}");
          return Text("Qualcosa è andato storto");
        } else if (snapshot.hasData) {
          if (firstTime) {
            firstTime = false;
            _lastDistance = data.distances.first;
            _otherDistances = data.distances.sublist(1, 7);
            if (timer != null) timer.cancel();
            timer = new Timer.periodic(
                Duration(seconds: 1),
                (Timer timer) => setState(() {
                      _updateTime = DateTime.now()
                          .difference(data.fetchDateTime)
                          .inMinutes;
                    }));
            _lastTemperature = data.temperatures.first;
            _otherTemperatures = data.temperatures.sublist(1, 7);

            var distanceNumber = data.distanceDates
                .where((i) =>
                    DateTime.now().day == i.day &&
                    DateTime.now().month == i.month &&
                    DateTime.now().year == i.year &&
                    DateTime.now().difference(i).inSeconds > 0)
                .length;

            var distances = data.distances.sublist(0, distanceNumber);
            var dates = data.distanceDates.sublist(0, distanceNumber);

            for (DateTime d in dates) {
              if (d.hour < 6 || d.hour > 22) {
                distances.removeAt(dates.indexOf(d));
                dates.remove(d);
              }
            }

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

              _controller.stop();
              _controller.value = 0;
            }
          }
          globals.streamController.add(100);
          return Scaffold(
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
                            child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: EdgeInsets.only(
                                    top: 100, right: 0, bottom: 0),
                                child: RichText(
                                  text: TextSpan(
                                    text: "Bentornato ",
                                    style: TextStyle(
                                        fontFamily: 'Gilroy',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 22,
                                        color: textColor),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: globals.name,
                                        style: TextStyle(
                                          fontFamily: 'Gilroy',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 22,
                                          color: textColor,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ",\necco i rilevamenti di oggi:",
                                        style: TextStyle(
                                          fontFamily: 'Gilroy',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 22,
                                          color: textColor,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                        Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(top: 75),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: AnimatedBuilder(
                                      animation: _controller,
                                      builder: (_, child) {
                                        return Transform.rotate(
                                          angle:
                                              _controller.value * 4 * math.pi,
                                          child: child,
                                        );
                                      },
                                      child: IconButton(
                                        icon: Icon(Icons.refresh,
                                            color: textColor),
                                        iconSize: 30,
                                        onPressed: () {
                                          _controller.forward();
                                          fetchData();
                                        },
                                      )),
                                )))
                      ]))
                    ])),
                GestureDetector(
                  onTap: () {
                    globals.streamController.add(1);
                  },
                  child: Container(
                      height: size.height * 0.35,
                      width: size.width * 0.9,
                      decoration: BoxDecoration(
                        color: containerColor,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: new Column(children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            padding: EdgeInsets.only(left: 20, top: 20),
                            child: Text(
                              "Riepilogo:",
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: textColor,
                              ),
                            ),
                          ),
                        ),
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
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.w300,
                                fontSize: 11,
                                color: textColor,
                              ),
                            ),
                          ),
                        ),
                      ])),
                ),
                SizedBox(height: size.height * 0.02),
                Container(
                    height: size.height * 0.255,
                    width: size.width * 0.9,
                    child: Column(children: <Widget>[
                      Flexible(
                          child: Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              globals.streamController.add(1);
                            },
                            child: Container(
                                width: size.width * 0.435,
                                margin:
                                    EdgeInsets.only(right: size.width * 0.015),
                                padding: const EdgeInsets.only(
                                    right: 20, left: 20, top: 20),
                                decoration: BoxDecoration(
                                  color: containerColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                child: DistanceHomeCard(
                                    bigDistance: _lastDistance,
                                    otherDistances: _otherDistances)),
                          ),
                          GestureDetector(
                              onTap: () {
                                globals.streamController.add(2);
                              },
                              child: Container(
                                  width: size.width * 0.435,
                                  margin:
                                      EdgeInsets.only(left: size.width * 0.015),
                                  padding: const EdgeInsets.only(
                                      right: 20, left: 20, top: 20),
                                  decoration: BoxDecoration(
                                    color: containerColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  child: TemperatureHomeCard(
                                      bigTemperature: _lastTemperature,
                                      otherTemperatures: _otherTemperatures)))
                        ],
                      )),
                    ]))
              ]),
            ),
          ));
        } else {
          return Scaffold(
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
                            child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: EdgeInsets.only(
                                    top: 100, right: 0, bottom: 0),
                                child: RichText(
                                  text: TextSpan(
                                    text: "Bentornato ",
                                    style: TextStyle(
                                        fontFamily: 'Gilroy',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 22,
                                        color: textColor),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: globals.name,
                                        style: TextStyle(
                                          fontFamily: 'Gilroy',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 22,
                                          color: textColor,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ",\nsto recuperando i dati...",
                                        style: TextStyle(
                                          fontFamily: 'Gilroy',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 22,
                                          color: textColor,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                      ]))
                    ])),
                Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    child: Column(
                      children: <Widget>[
                        Container(
                            height: size.height * 0.35,
                            width: size.width * 0.9,
                            decoration: BoxDecoration(
                              color: containerColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            child: new Column(children: <Widget>[
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  padding: EdgeInsets.only(left: 20, top: 20),
                                ),
                              ),
                              Container(
                                height: size.height * 0.25,
                                width: size.width * 0.8,
                              ),
                              SizedBox(
                                height: size.height * 0.006,
                              ),
                            ])),
                        SizedBox(height: size.height * 0.02),
                        Container(
                            height: size.height * 0.255,
                            width: size.width * 0.9,
                            child: Column(children: <Widget>[
                              Flexible(
                                  child: Row(
                                children: <Widget>[
                                  Container(
                                    width: size.width * 0.435,
                                    margin: EdgeInsets.only(
                                        right: size.width * 0.015),
                                    padding: const EdgeInsets.only(
                                        right: 20, left: 20, top: 20),
                                    decoration: BoxDecoration(
                                      color: containerColor,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
                                  ),
                                  Container(
                                    width: size.width * 0.435,
                                    margin: EdgeInsets.only(
                                        left: size.width * 0.015),
                                    padding: const EdgeInsets.only(
                                        right: 20, left: 20, top: 20),
                                    decoration: BoxDecoration(
                                      color: containerColor,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
                                  ),
                                ],
                              )),
                            ])),
                      ],
                    ))
              ]),
            ),
          ));
        }
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   Size size = MediaQuery.of(context).size;
  //   return Scaffold(
  //       body: Background(
  //     child: SingleChildScrollView(
  //       child: Column(children: <Widget>[
  //         Container(
  //             height: size.height * 0.2,
  //             width: size.width * 0.9,
  //             child: Column(children: <Widget>[
  //               Flexible(
  //                   child: Row(children: <Widget>[
  //                 Container(
  //                     child: Column(
  //                   children: <Widget>[
  //                     Align(
  //                       alignment: Alignment.centerLeft,
  //                       child: Container(
  //                         padding:
  //                             EdgeInsets.only(top: 100, right: 0, bottom: 0),
  //                         child: RichText(
  //                           text: TextSpan(
  //                             text: "Bentornato ",
  //                             style: TextStyle(
  //                                 fontFamily: 'Gilroy',
  //                                 fontWeight: FontWeight.w400,
  //                                 fontSize: 22,
  //                                 color: textColor),
  //                             children: <TextSpan>[
  //                               TextSpan(
  //                                 text: globals.name,
  //                                 style: TextStyle(
  //                                   fontFamily: 'Gilroy',
  //                                   fontWeight: FontWeight.w700,
  //                                   fontSize: 22,
  //                                   color: textColor,
  //                                 ),
  //                               ),
  //                               TextSpan(
  //                                 text: ",\necco i rilevamenti di oggi:",
  //                                 style: TextStyle(
  //                                   fontFamily: 'Gilroy',
  //                                   fontWeight: FontWeight.w400,
  //                                   fontSize: 22,
  //                                   color: textColor,
  //                                 ),
  //                               )
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 )),
  //                 Expanded(
  //                     child: Padding(
  //                         padding: EdgeInsets.only(top: 75),
  //                         child: Align(
  //                           alignment: Alignment.centerRight,
  //                           child: AnimatedBuilder(
  //                               animation: _controller,
  //                               builder: (_, child) {
  //                                 return Transform.rotate(
  //                                   angle: _controller.value * 4 * math.pi,
  //                                   child: child,
  //                                 );
  //                               },
  //                               child: IconButton(
  //                                 icon: Icon(Icons.refresh, color: textColor),
  //                                 iconSize: 30,
  //                                 onPressed: () {
  //                                   _controller.forward();
  //                                   fetchData();
  //                                 },
  //                               )),
  //                         )))
  //               ]))
  //             ])),
  //         Container(
  //             height: size.height * 0.35,
  //             width: size.width * 0.9,
  //             decoration: BoxDecoration(
  //               color: containerColor,
  //               borderRadius: BorderRadius.all(Radius.circular(15)),
  //             ),
  //             child: new Column(children: <Widget>[
  //               Align(
  //                 alignment: Alignment.topLeft,
  //                 child: Container(
  //                   padding: EdgeInsets.only(left: 20, top: 20),
  //                   child: Text(
  //                     "Riepilogo:",
  //                     style: TextStyle(
  //                       fontFamily: 'Gilroy',
  //                       fontWeight: FontWeight.w600,
  //                       fontSize: 18,
  //                       color: textColor,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               Container(
  //                 height: size.height * 0.25,
  //                 width: size.width * 0.8,
  //                 child: DistanceChart(
  //                   barValues: _barValues,
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: size.height * 0.006,
  //               ),
  //               Align(
  //                 alignment: Alignment.topLeft,
  //                 child: Container(
  //                   padding: EdgeInsets.only(left: 20, top: 10),
  //                   child: Text(
  //                     ("Ultimo aggiornamento: " +
  //                         _updateTime.toString() +
  //                         " minuti fa"),
  //                     style: TextStyle(
  //                       fontFamily: 'Gilroy',
  //                       fontWeight: FontWeight.w300,
  //                       fontSize: 11,
  //                       color: textColor,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ])),
  //         SizedBox(height: size.height * 0.02),
  //         Container(
  //             height: size.height * 0.255,
  //             width: size.width * 0.9,
  //             child: Column(children: <Widget>[
  //               Flexible(
  //                   child: Row(
  //                 children: <Widget>[
  //                   Container(
  //                       width: size.width * 0.435,
  //                       margin: EdgeInsets.only(right: size.width * 0.015),
  //                       padding:
  //                           const EdgeInsets.only(right: 20, left: 20, top: 20),
  //                       decoration: BoxDecoration(
  //                         color: containerColor,
  //                         borderRadius: BorderRadius.all(Radius.circular(15)),
  //                       ),
  //                       child: DistanceHomeCard(
  //                           bigDistance: _lastDistance,
  //                           otherDistances: _otherDistances)),
  //                   Container(
  //                       width: size.width * 0.435,
  //                       margin: EdgeInsets.only(left: size.width * 0.015),
  //                       padding:
  //                           const EdgeInsets.only(right: 20, left: 20, top: 20),
  //                       decoration: BoxDecoration(
  //                         color: containerColor,
  //                         borderRadius: BorderRadius.all(Radius.circular(15)),
  //                       ),
  //                       child: TemperatureHomeCard(
  //                           bigTemperature: _lastTemperature,
  //                           otherTemperatures: _otherTemperatures))
  //                 ],
  //               )),
  //             ]))
  //       ]),
  //     ),
  //   ));
  // }

  void updateBar() {
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
    _controller.stop();
    timer.cancel();
  }
}

Future<bool> _fetchData() async {
  if (globals.autoUpdate == true ||
      data.distances.length == 0 ||
      data.temperatures.length == 0 ||
      data.alerts.length == 0) {
    await data.fetchDistance();
    await data.fetchTemperature();
    await data.fetchAlert();
  }

  return true;
}
