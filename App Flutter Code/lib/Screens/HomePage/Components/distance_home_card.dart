import 'package:flutter/material.dart';
import 'package:tesi/global.dart' as globals;

class DistanceHomeCard extends StatelessWidget {
  const DistanceHomeCard({
    Key key,
    @required int bigDistance,
    @required List<int> otherDistances,
  })  : _bigDistance = bigDistance,
        _otherDistances = otherDistances,
        super(key: key);

  final int _bigDistance;
  final List<int> _otherDistances;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Text(
          "Distanziamento",
          style: TextStyle(
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w600,
            fontSize: 17,
            color: Color(globals.textColor),
          ),
        ),
        SizedBox(height: size.height * 0.02),
        Text(
          (_bigDistance / 100).toString() + " m",
          style: TextStyle(
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w600,
              fontSize: 44,
              color: _bigDistance > globals.tresholdDistance
                  ? Color(globals.textColor)
                  : Colors.red),
        ),
        SizedBox(height: size.height * 0.02),
        Text(
          "ultime misure:",
          style: TextStyle(
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w300,
            fontSize: 13,
            color: Color(globals.textColor),
          ),
        ),
        SizedBox(height: size.height * 0.02),
        Container(
            height: size.height * 0.065,
            child: Column(children: <Widget>[
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        child: Column(children: <Widget>[
                      Text(
                        (_otherDistances[0] / 100).toString() + 'm',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: _otherDistances[0] > globals.tresholdDistance
                                ? Color(globals.textColor)
                                : Colors.red),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Text(
                        (_otherDistances[3] / 100).toString() + 'm',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: _otherDistances[3] > globals.tresholdDistance
                                ? Color(globals.textColor)
                                : Colors.red),
                      ),
                    ])),
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        child: Column(children: <Widget>[
                          Text(
                            (_otherDistances[1] / 100).toString() + 'm',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: _otherDistances[1] >
                                        globals.tresholdDistance
                                    ? Color(globals.textColor)
                                    : Colors.red),
                          ),
                          SizedBox(height: size.height * 0.02),
                          Text(
                            (_otherDistances[4] / 100).toString() + 'm',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: _otherDistances[4] >
                                        globals.tresholdDistance
                                    ? Color(globals.textColor)
                                    : Colors.red),
                          ),
                        ])),
                    Container(
                        child: Column(children: <Widget>[
                      Text(
                        (_otherDistances[2] / 100).toString() + 'm',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: _otherDistances[2] > globals.tresholdDistance
                                ? Color(globals.textColor)
                                : Colors.red),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Text(
                        (_otherDistances[5] / 100).toString() + 'm',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: _otherDistances[5] > globals.tresholdDistance
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
