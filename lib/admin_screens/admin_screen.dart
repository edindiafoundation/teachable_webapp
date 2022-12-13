import 'package:event_generator/widgets/utility.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_generator/admin_screens/add_post.dart';
import 'package:event_generator/admin_screens/add_pre.dart';
import 'package:event_generator/widgets/drawer.dart';
import 'package:event_generator/widgets/widget_utils.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  String downloadURL = '';
  bool postislive = false;
  bool iswebinar = false;
  Map<String, dynamic> data = {};
  final TextEditingController _preTestQuestion = TextEditingController();
  final TextEditingController _postTestQuestion = TextEditingController();
  final _formPre = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  final _formPost = GlobalKey<FormState>();
  final TextEditingController _dateText = TextEditingController();
  String cureentDate = '';

  @override
  void initState() {
    isLive();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UtilsWidgets.buildAppBar("Admin Panel"),
      drawer: BuildDrawer.buildAdminDrawer(context),
      body: Form(
        key: _formKey,
        child: Center(
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
                    cureentDate = Utils.getCureentDate(DateTime.parse(val));
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              UtilsWidgets.buildRoundBtn('Set PreTest', () {
                if (_formKey.currentState!.validate()) {
                  UtilsWidgets.addField(context, () {
                    if (_formPre.currentState!.validate()) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddPreTest(
                                    no: int.parse(_preTestQuestion.text.trim()),
                                    setDate: cureentDate,
                                  )));
                    }
                  }, 'Add Number of Question', _formPre, _preTestQuestion,
                      isRequired: false);
                  _preTestQuestion.clear();
                }
              }),
              const SizedBox(
                height: 10,
              ),
              UtilsWidgets.buildRoundBtn('Set PostTest', () {
                if (_formKey.currentState!.validate()) {
                  UtilsWidgets.addField(context, () {
                    if (_formPost.currentState!.validate()) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddPostTest(
                                    no: int.parse(_postTestQuestion.text),
                                    setDate: cureentDate,
                                  )));
                    }
                  }, 'Add Number of Question', _formPost, _postTestQuestion,
                      isRequired: false);
                }
                _postTestQuestion.clear();
              }),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Webinar is Live :",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  UtilsWidgets.buildToggelButton([iswebinar, !iswebinar],
                      (index) {
                    setState(() {
                      if (index == 0) {
                        iswebinar = true;
                      } else {
                        iswebinar = false;
                      }
                    });
                    data = {
                      'webinar': iswebinar,
                    };
                    isLiveUpdate();
                  }),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Post Test is Live :",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  UtilsWidgets.buildToggelButton(
                    [postislive, !postislive],
                    (index) {
                      setState(() {
                        if (index == 0) {
                          postislive = true;
                        } else {
                          postislive = false;
                        }
                      });
                      data = {
                        'post-islive': postislive,
                      };
                      isLiveUpdate();
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future isLive() async {
    try {
      FirebaseFirestore.instance
          .collection('admin')
          .doc('activation')
          .get()
          .then((value) {
        setState(() {
          postislive = value["post-islive"];
          iswebinar = value["webinar"];
        });
      });
    } catch (e) {
      UtilsWidgets.showToastFunc(e.toString());
    }
  }

  Future isLiveUpdate() async {
    try {
      FirebaseFirestore.instance
          .collection('admin')
          .doc('activation')
          .update(data);
    } catch (e) {
      UtilsWidgets.showToastFunc(e.toString());
    }
  }
}
