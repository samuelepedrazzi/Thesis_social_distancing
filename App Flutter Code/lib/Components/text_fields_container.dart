import 'package:flutter/material.dart';
import 'package:tesi/global.dart' as globals;

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.9,
      decoration: BoxDecoration(
          color: Color(globals.containerColor),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              color: globals.lightTheme == true
                  ? Color(0xffCECECE)
                  : Color(0xff51515B),
              width: 2)),
      child: child,
    );
  }
}
