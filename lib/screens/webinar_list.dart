import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_generator/widgets/utility.dart';
import 'package:event_generator/widgets/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ArchivedWebinar extends StatefulWidget {
  const ArchivedWebinar({super.key});

  @override
  State<ArchivedWebinar> createState() => _ArchivedWebinarState();
}

class _ArchivedWebinarState extends State<ArchivedWebinar> {
  int count = 0;
  List<String> links = [];
  List<String> titles = [];
  List<String> webinarDate = [];

  String cureentDate = Utils.getDate(DateTime.now());

  @override
  void initState() {
    getWebinar();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UtilsWidgets.buildAppBar('Archived Webinars'),
      body: ListView.builder(
          itemCount: count,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () async {
                final Uri formurl = Uri.parse(links[index]);
                if (!await launchUrl(formurl)) {
                  throw 'Could not launch $formurl';
                }
              },
              child: ListTile(
                leading: Icon(Icons.archive_rounded, color: Colors.red),
                trailing: Text(
                  webinarDate[index],
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                title: Text(titles[index],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2),
              ),
            );
          }),
    );
  }

  Future getWebinar() async {
    try {
      FirebaseFirestore.instance
          .collection('webinar')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((element) {
          setState(() {
            links.add(element['link']);
            titles.add(element['title']);
            webinarDate.add(element.id.toString());
            count = querySnapshot.docs.length;
          });
        });
      });
    } on FirebaseException catch (e) {
      UtilsWidgets.showToastFunc(e.message.toString());
    }
  }
}
