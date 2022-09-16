import 'package:flutter/material.dart';
import 'package:tesi/global.dart' as globals;

class Background extends StatelessWidget {
  final Widget child;
  const Background({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (globals.lightTheme == true)
      return Container(
          decoration: BoxDecoration(color: Color(0xffEDEDED)),
          height: size.height,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              child,
            ],
          ));
    else
      return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF32333D), Color(0xFF1C1C1F)],
          )),
          height: size.height,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              child,
            ],
          ));
  }
}
