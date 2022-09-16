import 'package:flutter/material.dart';
import 'package:tesi/global.dart' as globals;

class TemperatureHomeCard extends StatelessWidget {
  const TemperatureHomeCard({
    Key key,
    @required double bigTemperature,
    @required List<double> otherTemperatures,
  })  : _bigTemperature = bigTemperature,
        _otherTemperatures = otherTemperatures,
        super(key: key);

  final double _bigTemperature;
  final List<double> _otherTemperatures;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Text(
          "Temperatura",
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 17,
              color: Color(globals.textColor)),
        ),
        SizedBox(height: size.height * 0.02),
        Text(
          _bigTemperature.toStringAsPrecision(3) + "°",
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 44,
              color:
                  _bigTemperature < 37 ? Color(globals.textColor) : Colors.red),
        ),
        SizedBox(height: size.height * 0.02),
        Text(
          "ultime misure:",
          style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 13,
              color: Color(globals.textColor)),
        ),
        SizedBox(height: size.height * 0.02),
        Container(
            height: size.height * 0.065,
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
                            _otherTemperatures[0].toStringAsPrecision(3) + "°",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: _otherTemperatures[0] <= 36.9
                                    ? Color(globals.textColor)
                                    : Colors.red),
                          ),
                          SizedBox(height: size.height * 0.02),
                          Text(
                            _otherTemperatures[3].toStringAsPrecision(3) + "°",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: _otherTemperatures[3] <= 36.9
                                    ? Color(globals.textColor)
                                    : Colors.red),
                          ),
                        ])),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            child: Column(children: <Widget>[
                              Text(
                                _otherTemperatures[1].toStringAsPrecision(3) +
                                    "°",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: _otherTemperatures[1] <= 36.9
                                        ? Color(globals.textColor)
                                        : Colors.red),
                              ),
                              SizedBox(height: size.height * 0.02),
                              Text(
                                _otherTemperatures[4].toStringAsPrecision(3) +
                                    "°",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: _otherTemperatures[4] <= 36.9
                                        ? Color(globals.textColor)
                                        : Colors.red),
                              ),
                            ])),
                        Container(
                            child: Column(children: <Widget>[
                          Text(
                            _otherTemperatures[2].toStringAsPrecision(3) + "°",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: _otherTemperatures[2] <= 36.9
                                    ? Color(globals.textColor)
                                    : Colors.red),
                          ),
                          SizedBox(height: size.height * 0.02),
                          Text(
                            _otherTemperatures[5].toStringAsPrecision(3) + "°",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: _otherTemperatures[5] <= 36.9
                                    ? Color(globals.textColor)
                                    : Colors.red),
                          ),
                        ]))
                      ],
                    ),
                  )
                ]))
      ],
    );
  }
}
