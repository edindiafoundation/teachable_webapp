import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_generator/widgets/widget_decoration.dart';
import 'package:event_generator/widgets/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class PreTest extends StatefulWidget {
  final String webinarDate;
  final String ID;
  final String title;
  final String email;
  final bool webinarstatus;
  const PreTest(
      {super.key,
      required this.email,
      required this.ID,
      required this.title,
      required this.webinarstatus,
      required this.webinarDate});

  @override
  PreTestState createState() => PreTestState();
}

class PreTestState extends State<PreTest> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String videoID = '';
  String videoTitle = '';
  bool isSubmit = false;
  Map valueMap = {};
  int count = 0;
  List<String> question = [];
  List<String> correctanswer = [];
  List<String> useranswer = [];
  List<List> options = [];
  List submitedAns = [];
  String cureentDate = '';

  @override
  void initState() {
    cureentDate = widget.webinarDate;
    email = widget.email;
    videoID = widget.ID;
    videoTitle = widget.title;
    getVerification();
    getQuestions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: UtilsWidgets.buildAppBar(videoTitle + ":" + 'pre_test'.tr),
        body: !isSubmit
            ? ListView.builder(
                itemCount: count,
                itemBuilder: (BuildContext context, int index) {
                  return Column(children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Widgets.questionField(index, question),
                    UtilsWidgets.dropDownButton(
                      'ans_tf'.tr,
                      'ans_tf'.tr,
                      useranswer[index],
                      options[index],
                      (val) {
                        setState(() {
                          useranswer[index] = val.toString();
                        });
                      },
                      validator: (p0) {
                        if (p0 == null || p0.isEmpty) {
                          return 'please'.tr + 'ans_tf'.tr;
                        }
                      },
                    ),
                  ]);
                })
            : ListView.builder(
                itemCount: count,
                itemBuilder: (BuildContext context, int index) {
                  return Column(children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Widgets.questionField(index, question),
                    Widgets.fieldData(useranswer[index].toString(),
                        correctanswer[index].toString(), context,
                        isHighlight: true,
                        color: useranswer[index] == correctanswer[index]
                            ? Colors.green
                            : Colors.red),
                  ]);
                }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
            icon: !isSubmit
                ? Icon(Icons.save_alt_rounded)
                : Icon(Icons.video_file),
            foregroundColor: Colors.white,
            label: !isSubmit ? Text('submit'.tr) : Text('go_webinar'.tr),
            onPressed: !isSubmit
                ? () {
                    if (_formKey.currentState!.validate()) {
                      UtilsWidgets.bottomDialogs('final_check'.tr, 'submit'.tr,
                          'cancel'.tr, 'save'.tr, context, () {
                        Navigator.pop(context);
                      }, () {
                        Navigator.pop(context);
                        onSubmit();
                      });
                    }
                  }
                : widget.webinarstatus
                    ? () async {
                        final Uri formurl = Uri.parse(
                            'https://www.youtube.com/live/$videoID?feature=share');
                        if (!await launchUrl(formurl)) {
                          throw 'Could not launch $formurl';
                        }
                      }
                    : () {
                        UtilsWidgets.showToastFunc('Please Wait');
                      }),
      ),
    );
  }

  Future getVerification() async {
    try {
      FirebaseFirestore.instance
          .collection('preTestResult')
          .doc(email)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          if (documentSnapshot.data().toString().contains('$cureentDate')) {
            Map abc = documentSnapshot['$cureentDate'];
            setState(() {
              isSubmit = abc['isSubmit'];
            });
          }
        } else {
          setState(() {
            isSubmit = false;
          });
        }
        if (isSubmit) {
          getField();
          getResult();
        }
      });
    } catch (e) {
      UtilsWidgets.showToastFunc(e.toString());
    }
  }

  Future getQuestions() async {
    try {
      FirebaseFirestore.instance
          .collection('Event')
          .doc('pre-test')
          .get()
          .then((value) {
        setState(() {
          int i = value[cureentDate].toString().indexOf('No: ');
          int no = i + 4;
          count = int.parse(value[cureentDate].toString()[no]);
          for (var i = 0; i < count; i++) {
            question.add(value[cureentDate]["Question$i"].toString());
            options.add(value[cureentDate]["Options$i"]);
            correctanswer.add(value[cureentDate]["Answer$i"].toString());
            useranswer.add('');
          }
        });
      });
    } catch (e) {
      UtilsWidgets.showToastFunc(e.toString());
    }
  }

  Future onSubmit() async {
    int total = 0;
    Map<String, dynamic> addAnswer = {};
    addAnswer['email'] = email;
    addAnswer['isSubmit'] = true;
    for (var i = 0; i < count; i++) {
      if (correctanswer[i] == useranswer[i]) {
        addAnswer['Mark$i'] = '1';
        addAnswer['Answer$i'] = useranswer[i];
        setState(() {
          total = total + 1;
        });
      } else {
        addAnswer['Mark$i'] = '0';
        addAnswer['Answer$i'] = useranswer[i];
      }
    }
    addAnswer['TotalMark'] = total;
    try {
      final addresult =
          FirebaseFirestore.instance.collection('preTestResult').doc(email);
      await addresult.set({'$cureentDate': addAnswer}, SetOptions(merge: true));
      getVerification();
    } catch (e) {
      UtilsWidgets.showToastFunc(e.toString());
    }
  }

  Future getField() async {
    try {
      FirebaseFirestore.instance
          .collection('Event')
          .doc('pre-test')
          .get()
          .then((value) {
        setState(() {
          int count = int.parse(value['$cureentDate']['No'].toString());
          for (var i = 0; i < count; i++) {
            submitedAns.add("Answer$i");
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
          .doc(email)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        useranswer.clear();
        submitedAns.forEach((element) {
          setState(() {
            useranswer
                .add(documentSnapshot['$cureentDate'][element].toString());
          });
        });
      });
    } on FirebaseException catch (e) {
      UtilsWidgets.showToastFunc(e.message.toString());
    }
  }
}
