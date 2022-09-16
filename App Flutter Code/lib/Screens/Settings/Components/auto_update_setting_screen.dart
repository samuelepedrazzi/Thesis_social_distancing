import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesi/Components/background.dart';
import 'package:tesi/global.dart' as globals;
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class AutoUpdateSettingPage extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const AutoUpdateSettingPage({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  _AutoUpdateSettingPageState createState() => _AutoUpdateSettingPageState();
}

class _AutoUpdateSettingPageState extends State<AutoUpdateSettingPage> {
  Color textColor;
  Color containerColor;
  var prefs;
  bool _value = globals.autoUpdate;

  @override
  void initState() {
    super.initState();
    textColor = Color(globals.textColor);
    containerColor = Color(globals.containerColor);

    _loadAutoUpdate();
  }

  void _loadAutoUpdate() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _value = (prefs.getBool('autoUpdate') ?? true);
      globals.autoUpdate = _value;
    });
  }

  void _saveAutoUpdate(bool autoUpdate) async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('autoUpdate', autoUpdate);
      globals.autoUpdate = autoUpdate;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async {
          globals.streamController.add(3);
          return false;
        },
        child: Scaffold(
            body: Background(
                child: SingleChildScrollView(
                    child: Container(
          width: size.width * 0.9,
          child: Column(children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 100, right: 0, bottom: 0),
                alignment: Alignment.centerLeft,
                child: Text("Aggiornamento automatico",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 36,
                        color: textColor))),
            SizedBox(
              height: size.height * 0.02,
            ),
            Container(
              padding: EdgeInsets.only(right: 20),
              child: Text(
                "In questa schermata è possibile scegliere se aggiornare in automatico l'app ogni volta che si accede alla Homepage.",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 21,
                    color: textColor.withOpacity(0.7)),
              ),
            ),
            SizedBox(height: size.height * 0.15),
            Container(
              height: size.height * 0.17,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: containerColor),
              alignment: Alignment.topLeft,
              child: Column(children: <Widget>[
                Center(
                  child: Text("Aggiornamento automatico:",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                          color: textColor)),
                ),
                SizedBox(height: size.height * 0.04),
                LiteRollingSwitch(
                  textSize: 12,
                  value: _value,
                  textOn: 'attivato',
                  textOff: 'disattivato',
                  animationDuration: Duration(milliseconds: 500),
                  colorOn: Color(0xff5BBA6F),
                  colorOff: textColor.withOpacity(0.7),
                  iconOn: Icons.sync_outlined,
                  iconOff: Icons.sync_disabled_outlined,
                  onChanged: (bool state) {
                    _saveAutoUpdate(state);
                  },
                )
              ]),
            ),
          ]),
        )))));
  }
}
