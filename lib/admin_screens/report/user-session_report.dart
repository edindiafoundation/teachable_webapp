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
  String cureentDate = '';
  // = Utils.getCureentDate(DateTime.now());

  @override
  void initState() {
    getDate();
    super.initState();
  }

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
            UtilsWidgets.dropDownButton(
              'Choose Webinar Date',
              'Choose Webinar Date',
              cureentDate,
              sessionDate,
              (val) {
                setState(() {
                  cureentDate = val;
                });
                getReport();
              },
              validator: (p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Please Choose Webinar Date';
                }
              },
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

  Future getDate() async {
    FirebaseFirestore.instance
        .collection('webinar')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          sessionDate.add(doc.id.toString());
        });
      });
    });
  }

  Future uploadCSV() async {
    String csvData = ListToCsvConverter().convert(reportData);

    String directory = (await getApplicationSupportDirectory()).path;
    final path = "$directory/user-session$cureentDate.csv";
    File file = File(path);
    await file.writeAsString(csvData).then((value) {
      FileSaver.instance.saveAs('user-session$cureentDate',
          file.readAsBytesSync(), 'csv', MimeType.CSV);
      final ref = FirebaseStorage.instance
          .ref()
          .child('report/user-session/user-session$cureentDate.csv');
      ref
          .putFile(file)
          .then((p0) => UtilsWidgets.showToastFunc('csv Uploaded Sucessfully'));
    });
  }

  Future downloadCSV() async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('report/user-session/user-session$cureentDate.csv');
      ref.getDownloadURL().then((value) async {
        if (!await launchUrl(Uri.parse(value))) {
          throw 'Could not launch $value';
        }
        UtilsWidgets.showToastFunc('User Data Download Sucessfully');
      });
    } on FirebaseException catch (e) {
      UtilsWidgets.showToastFunc(e.message.toString());
    }
  }

  Future getReport() async {
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

        UtilsWidgets.showToastFunc('Now Download The Report');
      });
    } on FirebaseException catch (e) {
      UtilsWidgets.showToastFunc(e.message.toString());
    }
  }
}
