import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesi/Screens/Login/login_screen.dart';
import 'package:tesi/Components/background.dart';
import 'package:tesi/Components/rounded_button.dart';
import 'package:tesi/global.dart' as globals;

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context)
        .size; //this size provide us total height and width of our screen

    return Background(
        child: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.only(left: 20, top: 100),
              child: Text(
                "Benvenuto",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600,
                    fontSize: 44,
                    color: Color(globals.textColor)),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.72),
          RoundedButton(
            text: "Login",
            press: () {
              loadPreferences();
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return LoginScreen();
              }));
            },
          ),
        ],
      ),
    ));
  }
}

void loadPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  globals.tresholdDistance = (prefs.getInt('thresholdDistance') ?? 100);
  globals.actualUser = (prefs.getString("actualUser") ?? "User B");
  globals.appUsername = (prefs.getString("appUsername") ?? "username");
  globals.appPassword = (prefs.getString("appPassword") ?? "password");
  globals.name = (prefs.getString("name") ?? "Samuele");
  globals.autoUpdate = (prefs.getBool("autoUpdate") ?? true);
}
