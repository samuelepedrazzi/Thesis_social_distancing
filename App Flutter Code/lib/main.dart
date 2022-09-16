import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesi/Screens/Welcome/welcome_screen.dart';
import 'package:tesi/global.dart' as globals;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<SharedPreferences> _prefs = _loadAppTheme();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tesi',
        theme: ThemeData(
          fontFamily: 'Gilroy',
          primarySwatch: Colors.blue,
          //visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: FutureBuilder(
          future: _prefs,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print("Errore: ${snapshot.error.toString()}");
              return Text("Qualcosa è andato storto");
            } else if (snapshot.hasData) {
              return WelcomeScreen();
            } else {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              );
            }
          },
        ));
  }
}

/*
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tesi',
      theme: ThemeData(
        fontFamily: 'Gilroy',
        primarySwatch: Colors.blue,
        //visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: WelcomeScreen(),
    );
  }
}
*/

Future<SharedPreferences> _loadAppTheme() async {
  final prefs = await SharedPreferences.getInstance();
  globals.lightTheme = (prefs.getBool('LightTheme') ?? true);
  return prefs;
}
