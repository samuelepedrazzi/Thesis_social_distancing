import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:tesi/global.dart' as globals;
import 'package:tesi/constants.dart';

List<int> distances = <int>[];
List<int> alerts = <int>[];
List<double> temperatures = <double>[];
List<DateTime> distanceDates = <DateTime>[];
List<DateTime> alertDates = <DateTime>[];
List<DateTime> temperatureDates = <DateTime>[];
DateTime fetchDateTime;

Future fetchTemperature() async {
  temperatures = <double>[];
  temperatureDates = <DateTime>[];
  var response = await http.get(
      Uri.parse(globals.url +
          "/measurements?filter={\"thing\":\"" +
          globals.actualUser +
          "\",\"feature\":\"temperature\"}&limit=1000"),
      headers: <String, String>{
        'Authorization': globals.tokenMeasurify,
      });
  print("temperature response body");
  print(response.body);
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    for (int i = 0; i < jsonResponse['totalDocs']; i++) {
      String value = convert
          .jsonDecode(convert.jsonEncode(convert.jsonDecode(
              convert.jsonEncode(jsonResponse['docs']))[i]))['samples']
          .toString();
      value = value.replaceAll(new RegExp(r'[^0-9\.]'), '');
      temperatures.add(double.parse(value));
      temperatureDates.add(DateTime.parse(convert
          .jsonDecode(convert.jsonEncode(convert.jsonDecode(
              convert.jsonEncode(jsonResponse['docs']))[i]))['startDate']
          .toString()));
    }

    print("temperatures");
    print(temperatures);

    return jsonResponse;
  } else if (response.statusCode == 401) {
    login();
    fetchTemperature();
  } else
    return "error";
}

Future fetchDistance() async {
  fetchDateTime = DateTime.now();
  distances = <int>[];
  distanceDates = <DateTime>[];
  var response = await http.get(
      Uri.parse(globals.url +
          "/measurements?filter={\"thing\":\"" +
          globals.actualUser +
          "\",\"feature\":\"distance\"}&limit=1000"),
      headers: <String, String>{
        'Authorization': globals.tokenMeasurify,
      });
  print("distance response body");
  print(response.body);
  if (response.statusCode == 200) {
    fetchDateTime = DateTime.now();
    var jsonResponse = convert.jsonDecode(response.body);
    for (int i = 0; i < jsonResponse['totalDocs']; i++) {
      String value = convert
          .jsonDecode(convert.jsonEncode(convert.jsonDecode(
              convert.jsonEncode(jsonResponse['docs']))[i]))['samples']
          .toString();
      value = value.replaceAll(new RegExp(r'[^0-9]'), '');
      distances.add(int.parse(value));
      distanceDates.add(DateTime.parse(convert
          .jsonDecode(convert.jsonEncode(convert.jsonDecode(
              convert.jsonEncode(jsonResponse['docs']))[i]))['startDate']
          .toString()));
    }
    print("distances");
    print(distances);
    print("distanceDates");
    print(distanceDates);
    return jsonResponse;
  } else if (response.statusCode == 401) {
    login();
    fetchDistance();
  } else
    return "error";
}

Future fetchAlert() async {
  alerts = <int>[];
  alertDates = <DateTime>[];
  var response = await http.get(
      Uri.parse(globals.url +
          "/measurements?filter={\"thing\":\"" +
          globals.actualUser +
          "\",\"feature\":\"alert\"}&limit=1000"),
      headers: <String, String>{
        'Authorization': globals.tokenMeasurify,
      });
  print("alert response body");
  print(response.body);
  if (response.statusCode == 200) {
    fetchDateTime = DateTime.now();
    var jsonResponse = convert.jsonDecode(response.body);
    for (int i = 0; i < jsonResponse['totalDocs']; i++) {
      String value = convert
          .jsonDecode(convert.jsonEncode(convert.jsonDecode(
              convert.jsonEncode(jsonResponse['docs']))[i]))['samples']
          .toString();
      value = value.replaceAll(new RegExp(r'[^0-9\.]'), '');
      alerts.add(double.parse(value).floor());
      alertDates.add(DateTime.parse(convert
          .jsonDecode(convert.jsonEncode(convert.jsonDecode(
              convert.jsonEncode(jsonResponse['docs']))[i]))['startDate']
          .toString()));
    }
    print("alerts");
    print(alerts);
    print("alertDates");
    print(alertDates);
    return jsonResponse;
  } else if (response.statusCode == 401) {
    login();
    fetchAlert();
  } else
    return "error";
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
  }
}
