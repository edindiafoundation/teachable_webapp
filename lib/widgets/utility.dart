import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Utils {
  static DateTime parseDate(String date) {
    return DateTime.parse(date);
  }

  static String getCureentDate(DateTime datetime) {
    DateTime date = new DateTime(datetime.year, datetime.month, datetime.day);
    String todate = date.toString().replaceAll("00:00:00.000", "");
    return todate;
  }

  static String formatDate(DateTime date, String format) {
    DateFormat formatter = new DateFormat(format);
    return formatter.format(date);
  }

  static String TimeStampToDate(String timestamp,
      {String format = 'dd-MM-yyyy hh:mm a'}) {
    DateTime createDate =
        DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp) * 1000);
    String date = Utils.formatDate(createDate, format);
    return date;
  }

  static String currentDateWithFormat(String format) {
    return DateFormat(format).format(DateTime.now());
  }

  static String convertStringIntoDateWithFormat(
      String InputFormat, String inputDate, String outputFormat) {
    var inputFormat = DateFormat(InputFormat);
    var date = inputFormat.parse(inputDate);
    var output = DateFormat(outputFormat);
    return output.format(date);
  }

  static String dateToTime(String inputDate) {
    DateTime InDate = new DateFormat("yyyy-MM-dd HH:mm").parse(inputDate);
    String formattedTime = DateFormat.jm().format(InDate);
    return formattedTime;
  }

  static int daysBetween(DateTime from) {
    from = DateTime(from.year, from.month, from.day);
    DateTime to = DateTime.now();
    return (to.difference(from).inHours / 24).round();
  }

  // static Future<Response> httpPost(String uri, BuildContext context) async {
  //   final pref = await SharedPreferences.getInstance();
  //   String? token = pref.getString("token");
  //   token = token == null ? "" : token;
  //   Response response =
  //       await http.post(Uri.parse(uri), headers: {"token": token});
  //   if (response.statusCode == 401) {
  //     pref.clear();
  //     Navigator.of(context).pushAndRemoveUntil(
  //         MaterialPageRoute(builder: (context) => LoginScreen()),
  //         (Route<dynamic> route) => false);
  //   }
  //   return response;
  // }

  // static Future<Response> httpPostWithBody(
  //     String uri, Map params, BuildContext context) async {
  //   final pref = await SharedPreferences.getInstance();
  //   String? token = pref.getString("token");
  //   token = token == null ? "" : token;
  //   Response response = await http.post(Uri.parse(uri),
  //       headers: {"token": token}, body: jsonEncode(params));
  //   if (response.statusCode == 401) {
  //     pref.clear();
  //     Navigator.of(context).pushAndRemoveUntil(
  //         MaterialPageRoute(builder: (context) => LoginScreen()),
  //         (Route<dynamic> route) => false);
  //   }
  //   return response;
  // }

  static bool validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10}$)';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return true;
    }
    return false;
  }

  static bool validateGmail(String email) {
    final bool isvalid =
        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@gmail.com")
            .hasMatch(email);
    if (isvalid) {
      return false;
    } else {
      return true;
    }
  }

  static bool isNumericUsingRegularExpression(String string) {
    final numericRegex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return numericRegex.hasMatch(string);
  }

  static onlyFloatNumber() {
    final value = [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))];
    return value;
  }

  static onlyIntNumber() {
    final value = [FilteringTextInputFormatter.allow(RegExp('[0-9]'))];
    return value;
  }

  static onlyNumberAndSlash() {
    final value = [FilteringTextInputFormatter.allow(RegExp('[0-9/.,-]'))];
    return value;
  }

  static onlyAlphNumeric() {
    final value = [FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]'))];
    return value;
  }
}
