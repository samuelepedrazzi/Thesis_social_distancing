import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:tesi/global.dart' as globals;

class RoundedButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color;
  const RoundedButton({
    Key key,
    this.text,
    this.press,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 0),
      width: size.width * 0.9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
          color: globals.lightTheme ? Color(globals.textColor) : Colors.white,
          onPressed: press,
          child: Text(text,
              style: TextStyle(
                  color:
                      globals.lightTheme == true ? kBackLight : kPrimaryColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
