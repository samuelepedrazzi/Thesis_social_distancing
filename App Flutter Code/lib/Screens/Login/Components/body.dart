import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tesi/Components/background.dart';
import 'package:tesi/Components/rounded_button.dart';
import 'package:tesi/Components/rounded_input_field.dart';
import 'package:tesi/Components/rounded_password_field.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:tesi/Screens/bottomNavBar.dart';
import 'package:tesi/constants.dart';
import 'package:tesi/global.dart' as globals;

class Body extends StatefulWidget {
  final ValueChanged<String> onChanged;
  const Body({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String username;
  String password;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _messageText = "Waiting for message...";

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "Push Messaging message: $message";
        });
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "Push Messaging message: $message";
        });
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "Push Messaging message: $message";
        });
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        globals.tokenFirebase = token;
      });
      print("firebase Token: $token");
    });
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
              padding: EdgeInsets.only(left: 20, top: 100, right: 100),
              child: Text(
                "Effettua l’accesso per continuare",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600,
                    fontSize: 30,
                    color: Color(globals.textColor)),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 0),
              child: Text(
                "Qui ci possiamo mettere tutto il testo che vogliamo",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 24,
                    color: globals.lightTheme == true
                        ? Color(0xffb2b2b2)
                        : Color(0xff6A6A6A)),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.16),
          RoundedInputField(
            hintText: "Username",
            onChanged: (text) {
              username = text;
            },
          ),
          RoundedPasswordField(
            onChanged: (text) {
              password = text;
            },
          ),
          SizedBox(height: size.height * 0.23),
          RichText(
            text: TextSpan(
              text: "Hai dimenticato la password?",
              style: TextStyle(
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: globals.lightTheme == true
                    ? Color(0xffb8b8b8)
                    : Color(0xff6A6A6A),
              ),
              children: <TextSpan>[
                TextSpan(
                    text: ' Clicca qui',
                    style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: Color(globals.textColor)),
                    recognizer: TapGestureRecognizer()..onTap = () {})
              ],
            ),
          ),
          SizedBox(height: size.height * 0.01),
          RoundedButton(
              text: "Accedi",
              press: () async {
                if (username == globals.appUsername &&
                        password == globals.appPassword ||
                    true) {
                  login();
                } else {
                  await showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        titleTextStyle: TextStyle(
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: Color(0xff000000)),
                        contentTextStyle: TextStyle(
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color(0xff000000)),
                        title: const Text('Errore'),
                        content: Text(
                            'Username e password non sono corretti, per favore riprova.'),
                        actions: <Widget>[
                          RoundedButton(
                            text: "OK",
                            press: () async {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              })
        ],
      ),
    ));
  }

  void login() async {
    var response = await http.post(Uri.parse(globals.url + "/login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode(<String, String>{
          'username': edgeUsername,
          'password': edgePassword,
          'tenant': edgeTenant
        }));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      globals.tokenMeasurify = jsonResponse['token'];

      var response2 = await http.get(Uri.parse(globals.url + "/subscriptions"),
          headers: <String, String>{
            'Authorization': globals.tokenMeasurify,
          });
      if (response2.statusCode == 200) {
        bool subscriptionPresent = false;

        var jsonResponse = convert.jsonDecode(response2.body);
        for (int i = 0; i < jsonResponse['totalDocs']; i++) {
          String value = convert
              .jsonDecode(convert.jsonEncode(convert.jsonDecode(
                  convert.jsonEncode(jsonResponse['docs']))[i]))['token']
              .toString();
          if (value == globals.tokenFirebase) subscriptionPresent = true;
        }
        if (!subscriptionPresent) {
          var response3 =
              await http.post(Uri.parse(globals.url + "/subscriptions"),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                    'Authorization': globals.tokenMeasurify,
                  },
                  body: convert.jsonEncode(<String, String>{
                    'token': globals.tokenFirebase,
                    'thing': globals.actualUser,
                    'device': "distance-monitor-1",
                  }));
          print(response3.statusCode);
          print(response3.body);
          if (response3.statusCode == 200) {
            print("Subscription effettuata con successo");
          }
        } else
          print("Subscription già presente");

        print(response.statusCode);
        print(response.body);

        //StreamController<int> streamController = StreamController<int>();

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return BottomNavBar();
        }));
      }
    } else {
      await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            titleTextStyle: TextStyle(
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Color(0xff000000)),
            contentTextStyle: TextStyle(
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Color(0xff000000)),
            title: const Text('Errore'),
            content:
                Text('Impossibile connettersi al server, per favore riprova.'),
            actions: <Widget>[
              RoundedButton(
                text: "OK",
                press: () async {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }
}
