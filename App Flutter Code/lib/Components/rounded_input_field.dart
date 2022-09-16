import 'package:flutter/material.dart';
import 'package:tesi/Components/text_fields_container.dart';
import 'package:tesi/global.dart' as globals;

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        cursorColor: globals.lightTheme ? Colors.grey : Colors.white,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 18,
          color: globals.lightTheme ? Color(0xff8a8a8a) : Color(0xff848591),
        ),
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Color(0xff848591),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 18,
              color:
                  globals.lightTheme ? Color(0xff8a8a8a) : Color(0xff848591)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
