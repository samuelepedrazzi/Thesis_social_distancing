import 'package:flutter/material.dart';
import 'package:tesi/Components/text_fields_container.dart';
import 'package:tesi/global.dart' as globals;

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  const RoundedPasswordField({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  _PasswordWidgetState createState() => _PasswordWidgetState();
}

class _PasswordWidgetState extends State<RoundedPasswordField> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        key: Key('textField'),
        obscureText: !_passwordVisible,
        onChanged: widget.onChanged,
        cursorColor: globals.lightTheme ? Colors.grey : Colors.white,
        style: TextStyle(
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.w400,
          fontSize: 18,
          color: globals.lightTheme ? Color(0xff8a8a8a) : Color(0xff848591),
        ),
        decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: globals.lightTheme ? Color(0xff8a8a8a) : Color(0xff848591),
          ),
          suffixIcon: IconButton(
            icon: Icon(
                _passwordVisible ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
            color: globals.lightTheme ? Color(0xff8a8a8a) : Color(0xff848591),
          ),
          hintStyle: TextStyle(
              fontFamily: 'Gilroy',
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
