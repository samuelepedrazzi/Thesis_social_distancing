import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesi/Components/background.dart';
import 'package:tesi/global.dart' as globals;

class AppInfoPage extends StatelessWidget {
  const AppInfoPage({Key key}) : super(key: key);

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
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(top: 100),
                                  alignment: Alignment.centerLeft,
                                  child: Text("Informazioni sull'app",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 36,
                                          color: Color(globals.textColor)))),
                              SizedBox(
                                height: size.height * 0.07,
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 20),
                                child: Text(
                                  "App sviluppata da:\n\nMarco Macchia\nSamuele Pedrazzi\n\n" +
                                      "nell'ambito della Tesi di Laurea in Ingeneria Elettronica e Tecnologie dell'Informazione.\n\n\n\n" +
                                      "Per il corretto funzionamento dell'app è necessario una board Arduino MKR WiFi 1010, ed una connessione " +
                                      "ad internet funzionante.\n\n\n\n" +
                                      "L'app non è da intendersi come sostituzione dei particolari sitemi di controllo del distanziamento sociale" +
                                      " richiesti all'interno di luoghi chiusi.",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 21,
                                      color: Color(globals.textColor)
                                          .withOpacity(0.7)),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                            ]))))));
  }
}
