import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesi/Components/background.dart';
import 'package:tesi/Screens/Settings/Components/Setting_element.dart';
import 'package:tesi/global.dart' as globals;
import 'Setting_element_double.dart';

class AppThemeSettingPage extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const AppThemeSettingPage({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  _AppThemeSettingPageState createState() => _AppThemeSettingPageState();
}

class _AppThemeSettingPageState extends State<AppThemeSettingPage>
    with SingleTickerProviderStateMixin {
  Color textColor;
  Color containerColor;
  TabController _tabController;
  var prefs;

  @override
  void initState() {
    super.initState();
    textColor = Color(globals.textColor);
    containerColor = Color(globals.containerColor);
    _tabController = new TabController(vsync: this, length: 2);
    _tabController.index = globals.lightTheme ? 0 : 1;
    _loadAppTheme();
  }

  void _loadAppTheme() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _tabController.index = (prefs.getBool('LightTheme') ?? true) ? 0 : 1;
    });
  }

  void _saveAppTheme(bool lightTheme) async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('LightTheme', lightTheme);
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
                child: Text("Tema dell'app",
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
                "In questa schermata è possibile modificare il tema dell'app, scegliendo tra una palette chiara ed una scura."
                " Le modifiche avranno effetto al riavvio dell'app.",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 21,
                    color: textColor.withOpacity(0.7)),
              ),
            ),
            SizedBox(height: size.height * 0.09),
            Container(
              height: 80,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: containerColor),
              alignment: Alignment.topLeft,
              child: DefaultTabController(
                length: 2,
                child: Container(
                  height: 100.0,
                  child: TabBar(
                    controller: _tabController,
                    indicator: BubbleTabIndicator(
                      tabBarIndicatorSize: TabBarIndicatorSize.tab,
                      indicatorHeight: 60.0,
                      indicatorColor: textColor,
                    ),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                    ),
                    labelColor: containerColor,
                    unselectedLabelColor: textColor,
                    tabs: <Widget>[
                      Text("Tema chiaro"),
                      Text("Tema scuro"),
                    ],
                    onTap: (index) {
                      _saveAppTheme(index == 0 ? true : false);
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.4),
          ]),
        )))));
  }
}
