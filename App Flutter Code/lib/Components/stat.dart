import 'package:flutter/material.dart';
import 'package:tesi/global.dart' as globals;

class Stat extends StatefulWidget {
  final Color dataColor;
  final String label;
  final String data;

  const Stat({
    Key key,
    this.label,
    this.data,
    this.dataColor,
  }) : super(key: key);

  @override
  _StatState createState() => _StatState();
}

class _StatState extends State<Stat> {
  Color labelColor;

  @override
  void initState() {
    super.initState();
    labelColor = Color(globals.textColor);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        height: size.height * 0.04,
        width: size.width * 0.9,
        child: Column(children: <Widget>[
          Flexible(
              child: Row(children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 4),
                height: size.height * 0.03,
                child: Column(children: <Widget>[
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.label,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: labelColor,
                          )))
                ])),
            Expanded(
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    widget.data,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        color: widget.dataColor),
                  )),
            )
          ]))
        ]));
  }
}
