import 'package:flutter/material.dart';
import 'package:tesi/global.dart' as globals;

class TemperatureList extends StatelessWidget {
  const TemperatureList({
    Key key,
    @required List<double> temperatures,
  })  : _temperatures = temperatures,
        super(key: key);
  final List<double> _temperatures;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Expanded(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      child: Column(children: <Widget>[
                    Text(
                      _temperatures[0].toStringAsPrecision(3) + "°",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 19,
                          color: _temperatures[0] <= 36.9
                              ? Color(globals.textColor)
                              : Colors.red),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      _temperatures[3].toStringAsPrecision(3) + "°",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 19,
                          color: _temperatures[3] <= 36.9
                              ? Color(globals.textColor)
                              : Colors.red),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      _temperatures[6].toStringAsPrecision(3) + "°",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 19,
                          color: _temperatures[6] <= 36.9
                              ? Color(globals.textColor)
                              : Colors.red),
                    ),
                  ])),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 70),
                      child: Column(children: <Widget>[
                        Text(
                          _temperatures[1].toStringAsPrecision(3) + "°",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 19,
                              color: _temperatures[1] <= 36.9
                                  ? Color(globals.textColor)
                                  : Colors.red),
                        ),
                        SizedBox(height: size.height * 0.02),
                        Text(
                          _temperatures[4].toStringAsPrecision(3) + "°",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 19,
                              color: _temperatures[4] <= 36.9
                                  ? Color(globals.textColor)
                                  : Colors.red),
                        ),
                        SizedBox(height: size.height * 0.02),
                        Text(
                          _temperatures[7].toStringAsPrecision(3) + "°",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 19,
                              color: _temperatures[7] <= 36.9
                                  ? Color(globals.textColor)
                                  : Colors.red),
                        ),
                      ])),
                  Container(
                      child: Column(children: <Widget>[
                    Text(
                      _temperatures[2].toStringAsPrecision(3) + "°",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 19,
                          color: _temperatures[2] <= 36.9
                              ? Color(globals.textColor)
                              : Colors.red),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      _temperatures[5].toStringAsPrecision(3) + "°",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 19,
                          color: _temperatures[5] <= 36.9
                              ? Color(globals.textColor)
                              : Colors.red),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      _temperatures[8].toStringAsPrecision(3) + "°",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 19,
                          color: _temperatures[8] <= 36.9
                              ? Color(globals.textColor)
                              : Colors.red),
                    ),
                  ]))
                ],
              ),
            )
          ]),
    );
  }
}
