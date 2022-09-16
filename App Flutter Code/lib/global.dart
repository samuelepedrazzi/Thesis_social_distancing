library my_prj.globals;

import 'dart:async';

import 'constants.dart';

final url = 'https://students.atmosphere.tools/v1';
String tokenMeasurify;
String tokenFirebase;
String actualUser = "User B";
bool lightTheme = true;
bool autoUpdate = true;
int textColor = lightTheme ? kLightText : kDarkText;
int containerColor = lightTheme ? kLightContainer : kDarkContainer;
int tresholdDistance = 100;

String appUsername = "username";
String appPassword = "password";
String name = "Marco";

StreamController<int> streamController = StreamController<int>.broadcast();
