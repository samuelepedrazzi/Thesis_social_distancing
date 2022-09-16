import 'package:flutter/material.dart';
import 'package:tesi/global.dart' as globals;

class SettingElement extends StatelessWidget {
  final String label;
  final IconData icon;
  final Function onTap;

  const SettingElement({
    Key key,
    this.label,
    this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: size.height * 0.08,
          decoration: BoxDecoration(
            color: Color(globals.containerColor),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Column(children: <Widget>[
            Flexible(
                child: Row(children: <Widget>[
              Container(
                  child: Column(children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 15),
                  child: Icon(icon, size: 30, color: Color(globals.textColor)),
                )
              ])),
              Expanded(
                  child: Container(
                      padding: EdgeInsets.only(
                        left: 20,
                      ),
                      child: Text(label,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 21,
                              color: Color(globals.textColor))))),
            ]))
          ])),
    );
  }
}
