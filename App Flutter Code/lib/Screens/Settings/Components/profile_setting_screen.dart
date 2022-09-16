import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesi/Components/background.dart';
import 'package:tesi/Components/data_edit_field.dart';
import 'package:tesi/Components/rounded_button.dart';
import 'package:tesi/Components/rounded_input_field.dart';
import 'package:tesi/Screens/Settings/Components/Setting_element.dart';
import 'package:tesi/global.dart' as globals;
import 'Setting_element_double.dart';

class ProfileSettingPage extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const ProfileSettingPage({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  _ProfileSettingPageState createState() => _ProfileSettingPageState();
}

class _ProfileSettingPageState extends State<ProfileSettingPage>
    with SingleTickerProviderStateMixin {
  Color textColor;
  Color containerColor;
  TabController _tabController;
  String name;
  String username;
  String password;
  String actualUser;

  @override
  void initState() {
    super.initState();
    textColor = Color(globals.textColor);
    containerColor = Color(globals.containerColor);
    _tabController = new TabController(vsync: this, length: 2);
    _tabController.index = globals.actualUser == "User A" ? 0 : 1;
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
                child: Text("Profilo",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 36,
                        color: textColor))),
            SizedBox(
              height: size.height * 0.02,
            ),
            Container(
              padding: EdgeInsets.only(right: 50),
              child: Text(
                "In questa schermata è possibile modificare il proprio nome, le credenziali di accesso e il dispositivo in uso",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 21,
                    color: textColor.withOpacity(0.7)),
              ),
            ),
            SizedBox(height: size.height * 0.045),
            Container(
                alignment: Alignment.topLeft,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Nome:",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 22,
                              color: textColor)),
                      DataEditField(
                        text: globals.name,
                        onChanged: (text) {
                          name = text;
                        },
                      ),
                      Text("Username:",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 22,
                              color: textColor)),
                      DataEditField(
                        text: globals.appUsername,
                        onChanged: (text) {
                          username = text;
                        },
                      ),
                      Text("Password:",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 22,
                              color: textColor)),
                      DataEditField(
                        text: globals.appPassword,
                        onChanged: (text) {
                          password = text;
                        },
                      ),
                      SizedBox(height: size.height * 0.15),
                      RoundedButton(
                          text: "Salva",
                          press: () {
                            _saveProfileData();
                            Navigator.pop(context);
                          }),
                    ]))
          ]),
        )))));
  }

  void _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    if (name != null) {
      prefs.setString('name', name);
      globals.name = name;
    }

    if (username != null) {
      prefs.setString('appUsername', username);
      globals.appUsername = username;
    }

    if (password != null) {
      globals.appPassword = password;
      prefs.setString('appPassword', password);
    }

    if (_tabController.index == 0) {
      globals.actualUser = "User A";
      prefs.setString('actualUser', "User A");
    } else {
      globals.actualUser = "User B";
      prefs.setString('actualUser', "User B");
    }
  }
}
