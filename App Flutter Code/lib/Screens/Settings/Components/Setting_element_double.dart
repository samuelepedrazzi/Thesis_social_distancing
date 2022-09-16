import 'package:flutter/material.dart';
import 'package:tesi/global.dart' as globals;

class SettingElementDouble extends StatelessWidget {
  final String label1;
  final IconData icon1;
  final Function onTap1;
  final String label2;
  final IconData icon2;
  final Function onTap2;

  const SettingElementDouble({
    Key key,
    this.label1,
    this.icon1,
    this.onTap1,
    this.label2,
    this.icon2,
    this.onTap2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        height: size.height * 0.15,
        decoration: BoxDecoration(
          color: Color(globals.containerColor),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(children: <Widget>[
          Flexible(
            child: GestureDetector(
                onTap: onTap1,
                child: Row(children: <Widget>[
                  Container(
                      child: Column(children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 17, left: 15),
                      child: Icon(icon1,
                          size: 30, color: Color(globals.textColor)),
                    )
                  ])),
                  Expanded(
                      child: Container(
                          padding: EdgeInsets.only(
                            top: 5,
                            left: 20,
                          ),
                          child: Text(label1,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 21,
                                  color: Color(globals.textColor))))),
                ])),
          ),
          Container(
              width: size.width * 0.75,
              child: Divider(
                  thickness: 1.5,
                  color: Color(globals.textColor).withOpacity(0.5))),
          Flexible(
              child: GestureDetector(
                  onTap: onTap2,
                  child: Row(children: <Widget>[
                    Container(
                        child: Column(children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12, left: 15),
                        child: Icon(icon2,
                            size: 30, color: Color(globals.textColor)),
                      )
                    ])),
                    Expanded(
                        child: Container(
                            padding: EdgeInsets.only(
                              bottom: 7,
                              left: 20,
                            ),
                            child: Text(label2,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 21,
                                    color: Color(globals.textColor))))),
                  ])))
        ]));
  }
}
