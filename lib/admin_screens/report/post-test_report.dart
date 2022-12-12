import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_generator/widgets/widget_utils.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PostTestReport extends StatefulWidget {
  const PostTestReport({super.key});

  @override
  State<PostTestReport> createState() => _PostTestReportState();
}

class _PostTestReportState extends State<PostTestReport> {
  List<List<String>> testData = [
    [
      "email",
      "isSubmit",
      "TotalMark",
    ]
  ];

  List<List<String>> testData1 = [
    [
      "email",
      "comment",
      "iscurrent",
      "rate",
    ]
  ];
  List<String> mark = [];
  List<String> answer = [];
  List<dynamic> sessionDate = [];
  String cureentDate = '';
  // String cureentDate = Utils.getCureentDate(DateTime.now());

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
            UtilsWidgets.dropDownButton(
              'Choose Webinar Date',
              'Choose Webinar Date',
              cureentDate,
              sessionDate,
              (val) {
                setState(() {
                  cureentDate = val;
                });
                getField();
                getTestResult();
                getRatingResult();
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
                ? Column(
                    children: [
                      UtilsWidgets.buildRoundBtn('Download Test Reports',
                          () async {
                        downloadCSV();
                      }),
                      SizedBox(
                        height: 20,
                      ),
                      UtilsWidgets.buildRoundBtn('Download Rating Reports',
                          () async {
                        downloadReportCSV();
                      }),
                    ],
                  )
                : Column(
                    children: [
                      UtilsWidgets.buildRoundBtn('Generate Test Report',
                          () async {
                        uploadCSV();
                      }),
                      SizedBox(
                        height: 20,
                      ),
                      UtilsWidgets.buildRoundBtn('Generate Rating Report',
                          () async {
                        uploadReportCSV();
                      }),
                    ],
                  ),
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

  Future uploadReportCSV() async {
    String csvData = ListToCsvConverter().convert(testData1);

    String directory = (await getApplicationSupportDirectory()).path;
    final path = "$directory/rating$cureentDate.csv";
    File file = File(path);
    await file.writeAsString(csvData).then((value) {
      FileSaver.instance.saveAs(
          'rating$cureentDate', file.readAsBytesSync(), 'csv', MimeType.CSV);
      final ref = FirebaseStorage.instance
          .ref()
          .child('report/rating/rating$cureentDate.csv');
      ref
          .putFile(file)
          .then((p0) => UtilsWidgets.showToastFunc('csv Uploaded Sucessfully'));
    });
  }

  Future downloadReportCSV() async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('report/rating/rating$cureentDate.csv');
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

  Future getRatingResult() async {
    try {
      FirebaseFirestore.instance
          .collection('rating')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          if (doc.data().toString().contains('$cureentDate')) {
            List<String> test = [];
            setState(() {
              test.clear();
              testData1[0].forEach((element) {
                test.add(doc["$cureentDate"][element].toString());
              });
              testData1.add(test);
            });
          }
        });
        UtilsWidgets.showToastFunc('Now Download The rating Report');
      });
    } on FirebaseException catch (e) {
      UtilsWidgets.showToastFunc(e.message.toString());
    }
  }

/////////////////////////////////////////////////////////
  Future uploadCSV() async {
    String csvData = ListToCsvConverter().convert(testData);

    String directory = (await getApplicationSupportDirectory()).path;
    final path = "$directory/posttest$cureentDate.csv";
    File file = File(path);
    await file.writeAsString(csvData).then((value) {
      FileSaver.instance.saveAs(
          'posttest$cureentDate', file.readAsBytesSync(), 'csv', MimeType.CSV);
      final ref = FirebaseStorage.instance
          .ref()
          .child('report/posttest/posttest$cureentDate.csv');
      ref
          .putFile(file)
          .then((p0) => UtilsWidgets.showToastFunc('csv Uploaded Sucessfully'));
    });
  }

  Future downloadCSV() async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('report/pretest/posttest$cureentDate.csv');
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
          .doc('post-test')
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

  Future getTestResult() async {
    try {
      FirebaseFirestore.instance
          .collection('postTestResult')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          if (doc.data().toString().contains('$cureentDate')) {
            List<String> test = [];
            setState(() {
              test.clear();
              testData[0].forEach((element) {
                test.add(doc["$cureentDate"][element].toString());
              });
              testData.add(test);
            });
          }
        });
        UtilsWidgets.showToastFunc('Now Download The postTestResult Report');
      });
    } on FirebaseException catch (e) {
      UtilsWidgets.showToastFunc(e.message.toString());
    }
  }
}
