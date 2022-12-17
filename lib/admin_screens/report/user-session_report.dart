import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_generator/widgets/utility.dart';
import 'package:event_generator/widgets/widget_utils.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class UserSessionReport extends StatefulWidget {
  const UserSessionReport({super.key});

  @override
  State<UserSessionReport> createState() => _UserSessionReportState();
}

class _UserSessionReportState extends State<UserSessionReport> {
  List<List<dynamic>> reportData = [
    ["Email", "Total Login", "Entries"]
  ];
  List<dynamic> sessionDate = [];
  final TextEditingController _Startdate = TextEditingController();
  final TextEditingController _Enddate = TextEditingController();
  List<String> days = [];
  String todayDate = Utils.getDate(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            kIsWeb
                ? Column(
                    children: [
                      UtilsWidgets.buildDatePicker(
                        'Choose Start Date',
                        'Choose Start Date',
                        _Startdate,
                        (val) {
                          setState(() {
                            todayDate = Utils.getDate(DateTime.parse(val));
                          });
                        },
                      ),
                    ],
                  )
                : Column(
                    children: [
                      UtilsWidgets.buildDatePicker(
                        'Choose Start Date',
                        'Choose Start Date',
                        _Startdate,
                        (val) {},
                      ),
                      UtilsWidgets.buildDatePicker(
                        'Choose End Date',
                        'Choose End Date',
                        _Enddate,
                        (val) {
                          getDaysInBeteween(DateTime.parse(_Startdate.text),
                              DateTime.parse(_Enddate.text));
                          days.forEach(
                            (element) {
                              getReport(element);
                            },
                          );
                          UtilsWidgets.showToastFunc('Now Download The Report');
                        },
                      ),
                    ],
                  ),
            const SizedBox(
              height: 20,
            ),
            kIsWeb
                ? UtilsWidgets.buildRoundBtn('Download', () async {
                    downloadCSV();
                  })
                : UtilsWidgets.buildRoundBtn('Generate', () async {
                    uploadCSV();
                  }),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Future uploadCSV() async {
    String csvData = ListToCsvConverter().convert(reportData);
    String directory = (await getApplicationSupportDirectory()).path;
    final path = "$directory/user-session$todayDate.csv";
    File file = File(path);
    await file.writeAsString(csvData).then((value) {
      FileSaver.instance.saveAs('user-session$todayDate',
          file.readAsBytesSync(), 'csv', MimeType.CSV);
      final ref = FirebaseStorage.instance
          .ref()
          .child('report/user-session/user-session$todayDate.csv');
      ref
          .putFile(file)
          .then((p0) => UtilsWidgets.showToastFunc('csv Uploaded Sucessfully'));
    });
  }

  Future downloadCSV() async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child("report/user-session");
      final listResult = await storageRef.listAll();
      for (var item in listResult.items) {
        if (item.fullPath == 'report/user-session/user-session$todayDate.csv') {
          final ref = FirebaseStorage.instance
              .ref()
              .child('report/user-session/user-session$todayDate.csv');
          ref.getDownloadURL().then((value) async {
            if (!await launchUrl(Uri.parse(value))) {
              throw 'Could not launch $value';
            }
            UtilsWidgets.showToastFunc('User Data Download Sucessfully');
          });
        } else {
          UtilsWidgets.showToastFunc('No Record Found');
        }
      }
    } on FirebaseException catch (e) {
      UtilsWidgets.showToastFunc(e.message.toString());
    }
  }

  getDaysInBeteween(DateTime startDate, DateTime endDate) {
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      setState(() {
        days.add(Utils.getDate(
            DateTime(startDate.year, startDate.month, startDate.day + i)));
      });
    }
  }

  Future getReport(String cureentDate) async {
    try {
      FirebaseFirestore.instance
          .collection('user-session')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          if (doc.data().toString().contains('$cureentDate')) {
            List<String> time = [];
            int TotalIn = 0;
            List<dynamic> timeStamp = [];
            setState(() {
              TotalIn = doc['$cureentDate']["TotalIn"];
              timeStamp = doc['$cureentDate']["entries"];
              timeStamp.forEach((element) {
                time.add(Utils.TimeStampToDate(
                    element.toString().substring(18, 28)));
              });
              reportData.add([doc.id, TotalIn, time]);
            });
          }
        });
        // UtilsWidgets.showToastFunc('Now Download The Report');
      });
    } on FirebaseException catch (e) {
      UtilsWidgets.showToastFunc(e.message.toString());
    }
  }
}
