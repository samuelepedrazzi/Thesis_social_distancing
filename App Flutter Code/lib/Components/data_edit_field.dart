import 'package:flutter/material.dart';
import 'package:tesi/global.dart' as globals;

class DataEditField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String text;
  const DataEditField({
    Key key,
    this.text,
    this.onChanged,
  }) : super(key: key);

  @override
  _DataEditFieldState createState() => _DataEditFieldState();
}

class _DataEditFieldState extends State<DataEditField> {
  bool _readOnly = true;
  TextEditingController textEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    textEditingController.text = widget.text;
    textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: textEditingController.text.length));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.9,
      decoration: BoxDecoration(
        color: _readOnly
            ? Color(globals.containerColor).withOpacity(0)
            : Color(globals.containerColor),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: textEditingController,
        key: Key('textField'),
        readOnly: _readOnly,
        onChanged: widget.onChanged,
        cursorColor: globals.lightTheme ? Colors.grey : Colors.white,
        style: TextStyle(
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w400,
            fontSize: 18,
            color: Color(globals.textColor)),
        decoration: InputDecoration(
          hintText: widget.text,
          suffixIcon: IconButton(
            icon: Icon(
                _readOnly ? Icons.edit_outlined : Icons.done_outline_rounded),
            onPressed: () {
              setState(() {
                _readOnly = !_readOnly;
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
