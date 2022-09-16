import 'package:flutter/material.dart';
import 'package:tesi/Components/background.dart';
import 'package:tesi/global.dart' as globals;
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThresholdDistancePage extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const ThresholdDistancePage({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  _ThresholdDistancePageState createState() => _ThresholdDistancePageState();
}

class _ThresholdDistancePageState extends State<ThresholdDistancePage>
    with SingleTickerProviderStateMixin {
  Color textColor;
  Color containerColor;
  TabController _tabController;
  int _thresholdDistance = 100;
  var prefs;

  @override
  void initState() {
    super.initState();
    textColor = Color(globals.textColor);
    containerColor = Color(globals.containerColor);
    _tabController = new TabController(vsync: this, length: 2);
    _tabController.index = globals.lightTheme ? 0 : 1;
    _loadThDistance();
  }

  void _loadThDistance() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _thresholdDistance = (prefs.getInt('thresholdDistance') ?? 100);
    });
  }

  void _saveThDistance(int thDistance) async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _thresholdDistance = thDistance;
      prefs.setInt('thresholdDistance', thDistance);
      globals.tresholdDistance = thDistance;
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
                margin: EdgeInsets.only(top: 100, right: 20, bottom: 0),
                alignment: Alignment.centerLeft,
                child: Text("Distanza Soglia",
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
                "In questa schermata è possibile modificare la soglia minima della distanza.",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 21,
                    color: textColor.withOpacity(0.7)),
              ),
            ),
            SizedBox(height: size.height * 0.14),
            Container(
                height: size.height * 0.32,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: containerColor),
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    Text("Distanza soglia:",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 22,
                            color: textColor)),
                    SizedBox(height: size.height * 0.04),
                    NumberPicker(
                      value: _thresholdDistance,
                      minValue: 50,
                      maxValue: 200,
                      selectedTextStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 30,
                          color: textColor),
                      textStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                          color: textColor.withOpacity(0.5)),
                      onChanged: (value) => _saveThDistance(value),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Text('Valore attuale: ' + _thresholdDistance.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            color: textColor)),
                  ],
                )),
            SizedBox(height: size.height * 0.17),
          ]),
        )))));
  }
}
