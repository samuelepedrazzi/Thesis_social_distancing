import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tesi/Screens/Distance/Components/distance_screen.dart';
import 'package:tesi/Screens/HomePage/home_screen.dart';
import 'package:tesi/Screens/Settings/Components/app_info_screen.dart';
import 'package:tesi/Screens/Settings/Components/app_theme_setting_screen.dart';
import 'package:tesi/Screens/Settings/Components/auto_update_setting_screen.dart';
import 'package:tesi/Screens/Settings/Components/profile_setting_screen.dart';
import 'package:tesi/Screens/Settings/Components/threshold_distance_settings_screen.dart';
import 'package:tesi/Screens/Temperature/temperature_screen.dart';
import 'package:tesi/global.dart' as globals;

import 'Settings/settings_screen.dart';

class BottomNavBar extends StatefulWidget {
  //final StreamController<int> streamController;
  const BottomNavBar({
    Key key,
    //this.streamController,
  }) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  List _screens = [];
  int _currentIndex;
  Stream<int> stream;
  Widget _body;
  bool _visibility = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;

    _screens = [
      HomePage(),
      DistancePage(),
      TemperaturePage(),
      SettingsPage(),
      ProfileSettingPage(),
      AutoUpdateSettingPage(),
      ThresholdDistancePage(),
      AppThemeSettingPage(),
      AppInfoPage(),
    ];

    stream = globals.streamController.stream;
    stream.listen((index) {
      if (index == 100) {
        updateNavBar();
      } else {
        changeIndex(index);
      }
    }, onError: (e) {
      print(e);
    });

    _body = _screens[_currentIndex];
  }

  void changeIndex(int index) {
    setState(() {
      if (index > 3) {
        _body = _screens[index];
        _currentIndex = 3;
      } else {
        _currentIndex = index;
        _body = _screens[_currentIndex];
      }
    });
  }

  void updateNavBar() {
    setState(() {
      _visibility = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: _body,
      bottomNavigationBar: Visibility(
        visible: _visibility,
        replacement: Container(
            decoration: BoxDecoration(
                color: globals.lightTheme == true
                    ? Color(0xffEDEDED)
                    : Color(0xff1e1e22)),
            height: size.height * 0.07),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(
              () => {_currentIndex = index, _body = _screens[_currentIndex]}),
          type: BottomNavigationBarType.fixed,
          backgroundColor: globals.lightTheme == true
              ? Color(0xffEDEDED)
              : Color(0xff1e1e22),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Color(0xff1e1e22),
          unselectedItemColor: Color(0xff73767F),
          items: [
            Icons.home_outlined,
            Icons.insert_chart_outlined_rounded,
            Icons.thermostat_outlined,
            Icons.settings_outlined,
          ]
              .asMap()
              .map((key, value) => MapEntry(
                    key,
                    BottomNavigationBarItem(
                      label: '',
                      icon: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6.0,
                          horizontal: 16.0,
                        ),
                        decoration: BoxDecoration(
                          color: _currentIndex == key
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Icon(value),
                      ),
                    ),
                  ))
              .values
              .toList(),
        ),
      ),
    );
  }
}
