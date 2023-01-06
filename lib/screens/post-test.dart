import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_generator/widgets/widget_decoration.dart';
import 'package:event_generator/widgets/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostTest extends StatefulWidget {
  final String email;
  final String webinarDate;
  final String title;
  const PostTest(
      {super.key,
      required this.email,
      required this.title,
      required this.webinarDate});

  @override
  PostTestState createState() => PostTestState();
}

class PostTestState extends State<PostTest> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String videoTitle = '';
  String cureentDate = '';
  bool isSubmit = false;
  int count = 0;
  List<String> question = [];
  List<String> correctanswer = [];
  List<String> useranswer = [];
  List<List> options = [];
  List submitedAns = [];

  @override
  void initState() {
    cureentDate = widget.webinarDate;
    email = widget.email;
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
          appBar: UtilsWidgets.buildAppBar(videoTitle + ":" + 'post_test'.tr),
          body: Column(
            children: [
              !isSubmit
                  ? Expanded(
                      child: ListView.builder(
                          itemCount: count,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Widgets.questionField(index, question),
                              const SizedBox(
                                height: 10,
                              ),
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
                                  return null;
                                },
                              ),
                            ]);
                          }),
                    )
                  : Expanded(
                      child: ListView.builder(
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
                                  color:
                                      useranswer[index] == correctanswer[index]
                                          ? Colors.green
                                          : Colors.red),
                            ]);
                          }),
                    ),
              SizedBox(
                height: 20,
              ),
              UtilsWidgets.buildRoundBtn(
                  !isSubmit ? 'submit'.tr : 'tx'.tr,
                  !isSubmit
                      ? () {
                          if (_formKey.currentState!.validate()) {
                            UtilsWidgets.bottomDialogs(
                                'final_check'.tr,
                                'submit'.tr,
                                'cancel'.tr,
                                'save'.tr,
                                context, () {
                              Navigator.pop(context);
                            }, () {
                              Navigator.pop(context);
                              onSubmit();
                            });
                          }
                        }
                      : () {}),
              SizedBox(
                height: 20,
              ),
            ],
          )

          // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          // floatingActionButton: FloatingActionButton.extended(
          //     icon: !isSubmit
          //         ? Icon(Icons.save_alt_rounded)
          //         : Icon(Icons.thumb_up_alt_rounded),
          //     foregroundColor: Colors.white,
          //     label: !isSubmit ? Text('submit'.tr) : Text('tx'.tr),
          //     onPressed: !isSubmit
          //         ? () {
          //             if (_formKey.currentState!.validate()) {
          //               UtilsWidgets.bottomDialogs('final_check'.tr, 'submit'.tr,
          //                   'cancel'.tr, 'save'.tr, context, () {
          //                 Navigator.pop(context);
          //               }, () {
          //                 Navigator.pop(context);
          //                 onSubmit();
          //               });
          //             }
          //           }
          //         : () {}),
          ),
    );
  }

  onOpen(int i) {
    Map<String, dynamic> rate = {};
    Timer.periodic(Duration(seconds: i), (val) {
      setState(() {
        val.cancel();
      });
      UtilsWidgets.showRatingAppDialog(context, videoTitle, () async {
        rate = {
          'email': email,
          'comment': 'Cancelled',
          'rate': '0',
          'iscurrent': true
        };
        final addresult =
            FirebaseFirestore.instance.collection('rating').doc(email);
        await addresult.set({'$cureentDate': rate}, SetOptions(merge: true));
      }, (response) async {
        rate = {
          'email': email,
          'comment': response.comment,
          'rate': response.rating,
          'iscurrent': true
        };
        try {
          final addresult =
              FirebaseFirestore.instance.collection('rating').doc(email);
          await addresult.set({'$cureentDate': rate}, SetOptions(merge: true));
        } catch (e) {
          UtilsWidgets.showToastFunc(e.toString());
        }
        if (response.rating < 3.0) {
          print('response.rating: ${response.rating}');
        } else {
          Container();
        }
      });
    });
  }

  Future getVerification() async {
    try {
      FirebaseFirestore.instance
          .collection('postTestResult')
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
          .doc('post-test')
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
          FirebaseFirestore.instance.collection('postTestResult').doc(email);
      await addresult.set({'$cureentDate': addAnswer}, SetOptions(merge: true));
      getVerification();
      onOpen(2);
    } catch (e) {
      UtilsWidgets.showToastFunc(e.toString());
    }
  }

  Future getField() async {
    try {
      FirebaseFirestore.instance
          .collection('Event')
          .doc('post-test')
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
          .collection('postTestResult')
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
