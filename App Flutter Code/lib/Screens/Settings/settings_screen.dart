import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tesi/Components/background.dart';
import 'package:tesi/Screens/Login/login_screen.dart';
import 'package:tesi/Screens/Settings/Components/Setting_element.dart';
import 'package:tesi/Screens/Settings/Components/app_info_screen.dart';
import 'package:tesi/Screens/Settings/Components/app_theme_setting_screen.dart';
import 'package:tesi/Screens/Settings/Components/profile_setting_screen.dart';
import 'package:tesi/Screens/Settings/Components/threshold_distance_settings_screen.dart';
import 'package:tesi/global.dart' as globals;
import 'Components/Setting_element_double.dart';
import 'package:app_settings/app_settings.dart';

class SettingsPage extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const SettingsPage({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with TickerProviderStateMixin {
  Color textColor;
  Color containerColor;

  @override
  void initState() {
    super.initState();
    textColor = Color(globals.textColor);
    containerColor = Color(globals.containerColor);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async {
          globals.streamController.add(0);
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
                child: Text("Impostazioni",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 36,
                        color: textColor))),
            SizedBox(
              height: size.height * 0.03,
            ),
            SettingElement(
                label: "Profilo",
                icon: Icons.person_outline_rounded,
                onTap: () {
                  globals.streamController.add(4);
                }),
            SizedBox(
              height: size.height * 0.03,
            ),
            SettingElementDouble(
                label1: "Aggiornamento automatico",
                icon1: Icons.sync_outlined,
                onTap1: () {
                  globals.streamController.add(5);
                },
                label2: "Distanza Soglia",
                icon2: Icons.connect_without_contact_outlined,
                onTap2: () {
                  globals.streamController.add(6);
                }),
            SizedBox(
              height: size.height * 0.03,
            ),
            SettingElementDouble(
                label1: "Tema dell'app",
                icon1: Icons.palette_outlined,
                onTap1: () {
                  globals.streamController.add(7);
                },
                label2: "Notifiche",
                icon2: Icons.notifications_outlined,
                onTap2: () {
                  if (Platform.isAndroid) {
                    AppSettings.openNotificationSettings();
                  }
                }),
            SizedBox(
              height: size.height * 0.03,
            ),
            SettingElement(
                label: "Informazioni sull'app",
                icon: Icons.info_outline,
                onTap: () {
                  globals.streamController.add(8);
                }),
            SizedBox(
              height: size.height * 0.03,
            ),
            SettingElement(
                label: "Logout",
                icon: Icons.logout_outlined,
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return LoginScreen();
                  }));
                }),
            SizedBox(height: size.height * 0.04),
          ]),
        )))));
  }
}
