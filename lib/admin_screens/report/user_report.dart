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

class UsersReport extends StatefulWidget {
  const UsersReport({super.key});

  @override
  State<UsersReport> createState() => _UsersReportState();
}

class _UsersReportState extends State<UsersReport> {
  List<List<String>> userData = [
    [
      "fname",
      "lname",
      "email",
      "age",
      "mobile",
      "gender",
      "state",
      "disctict",
      "institution",
      "diet",
      "pvtInstitution",
      "course",
      "courseyear",
      "role",
      "college_name"
    ]
  ];
  String cureentDate = Utils.getDate(DateTime.now());

  @override
  void initState() {
    getUser();
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
            kIsWeb
                ? UtilsWidgets.buildRoundBtn('Download User Data', () async {
                    downloadCSV();
                  })
                : UtilsWidgets.buildRoundBtn('Generate UserData', () async {
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
    String csvData = ListToCsvConverter().convert(userData);

    String directory = (await getApplicationSupportDirectory()).path;
    final path = "$directory/users$cureentDate.csv";
    File file = File(path);
    await file.writeAsString(csvData).then((value) {
      FileSaver.instance.saveAs(
          'user$cureentDate', file.readAsBytesSync(), 'csv', MimeType.CSV);
      final ref = FirebaseStorage.instance
          .ref()
          .child('report/user/users$cureentDate.csv');
      ref
          .putFile(file)
          .then((p0) => UtilsWidgets.showToastFunc('csv Uploaded Sucessfully'));
    });
  }

  Future downloadCSV() async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('report/user/users$cureentDate.csv');
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

  Future getUser() async {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          List<String> abc = [];
          setState(() {
            userData[0].forEach((element) {
              abc.add(doc['$element'].toString());
            });
            userData.add(abc);
          });
        });
        UtilsWidgets.showToastFunc('Now Download The Report');
      });
    } on FirebaseException catch (e) {
      UtilsWidgets.showToastFunc(e.message.toString());
    }
  }
}
