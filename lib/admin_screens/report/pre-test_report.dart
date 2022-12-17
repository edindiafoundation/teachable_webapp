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

class PreTestReport extends StatefulWidget {
  const PreTestReport({super.key});

  @override
  State<PreTestReport> createState() => _PreTestReportState();
}

class _PreTestReportState extends State<PreTestReport> {
  List<List<String>> testData = [
    [
      "email",
      "isSubmit",
      "TotalMark",
    ]
  ];
  List<String> mark = [];
  List<String> answer = [];
  List<dynamic> sessionDate = [];
  String cureentDate = '';
  final TextEditingController _dateText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            UtilsWidgets.buildDatePicker(
              'Choose Webinar Date',
              'Choose Webinar Date',
              _dateText,
              (val) {
                setState(() {
                  cureentDate = Utils.getDate(DateTime.parse(val));
                });
                getResult();
              },
            ),
            kIsWeb
                ? UtilsWidgets.buildRoundBtn('Download Reports', () async {
                    downloadCSV();
                  })
                : UtilsWidgets.buildRoundBtn('Generate Report', () async {
                    uploadCSV();
                  }),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Future uploadCSV() async {
    String csvData = ListToCsvConverter().convert(testData);
    String directory = (await getApplicationSupportDirectory()).path;
    final path = "$directory/pretest$cureentDate.csv";
    File file = File(path);
    await file.writeAsString(csvData).then((value) {
      FileSaver.instance.saveAs(
          'pretest$cureentDate', file.readAsBytesSync(), 'csv', MimeType.CSV);
      final ref = FirebaseStorage.instance
          .ref()
          .child('report/pretest/pretest$cureentDate.csv');
      ref
          .putFile(file)
          .then((p0) => UtilsWidgets.showToastFunc('csv Uploaded Sucessfully'));
    });
  }

  Future downloadCSV() async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('report/pretest/pretest$cureentDate.csv');
      ref.getDownloadURL().then((value) async {
        if (!await launchUrl(Uri.parse(value))) {
          throw 'Could not launch $value';
        }
        UtilsWidgets.showToastFunc('Reports Download Sucessfully');
      });
    } on FirebaseException catch (e) {
      UtilsWidgets.showToastFunc(e.message.toString());
    }
  }

  Future getField() async {
    try {
      FirebaseFirestore.instance
          .collection('Event')
          .doc('pre-test')
          .get()
          .then((value) {
        int count = int.parse(value['$cureentDate']['No'].toString());
        setState(() {
          for (var i = 0; i < count; i++) {
            testData[0].add("Answer$i");
            testData[0].add("Mark$i");
          }
        });
      });
    } on FirebaseException catch (e) {
      UtilsWidgets.showToastFunc(e.message.toString());
    }
  }

  Future getResult() async {
    try {
      FirebaseFirestore.instance
          .collection('preTestResult')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          if (doc.data().toString().contains('$cureentDate')) {
            getField();
            List<String> test = [];
            setState(() {
              test.clear();
              testData[0].forEach((element) {
                test.add(doc['$cureentDate'][element].toString());
              });
              testData.add(test);
            });
          } else {
            testData.add(['No Record Found']);
          }
        });
        UtilsWidgets.showToastFunc('Now Download The Report');
      });
    } on FirebaseException catch (e) {
      UtilsWidgets.showToastFunc(e.message.toString());
    }
  }
}
