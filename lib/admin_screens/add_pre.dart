import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_generator/widgets/utility.dart';
import 'package:event_generator/widgets/widget_utils.dart';
import 'package:flutter/material.dart';

class AddPreTest extends StatefulWidget {
  final int no;
  const AddPreTest({super.key, required this.no});

  @override
  State<AddPreTest> createState() => _AddPreTestState();
}

class _AddPreTestState extends State<AddPreTest> {
  int count = 0;
  bool isAdd = false;
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  String cureentDate = Utils.getCureentDate(DateTime.now());
  List<TextEditingController> question = [];
  List<TextEditingController> answer = [];
  List<TextEditingController> options = [];

  @override
  void initState() {
    count = widget.no;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    question = List.generate(count, (index) => TextEditingController());
    answer = List.generate(count, (index) => TextEditingController());
    options = List.generate(count, (index) => TextEditingController());
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: UtilsWidgets.buildAppBar('Add Pre-Test Questions'),
        body: ListView.builder(
            itemCount: count,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  leading: Text(
                    "QUESTION-" + (index + 1).toString(),
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.add, color: Colors.red),
                    onPressed: () {
                      UtilsWidgets.addField(
                        context,
                        () {
                          if (_formKey2.currentState!.validate()) {
                            Navigator.pop(context);
                          }
                        },
                        'Add Options And Answer',
                        _formKey2,
                        answer[index],
                        options: options[index],
                      );
                    },
                  ),
                  title: UtilsWidgets.textFormField(
                      "Enter Question $index", "Enter Question $index", (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return "Please Enter Question $index";
                    }
                  }, question[index]));
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
            icon: Icon(Icons.save_alt_rounded),
            foregroundColor: Colors.black,
            label: Text('Submit'),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                UtilsWidgets.bottomDialogs('Please Check Answer and Options',
                    'Submit', 'Cancel', 'Save', context, () {
                  Navigator.pop(context);
                }, () {
                  Navigator.pop(context);
                  addPreTestQue();
                });
              }
            }),
      ),
    );
  }

  Future addPreTestQue() async {
    Map<String, dynamic> addQuiz = {};
    for (var i = 0; i < count; i++) {
      addQuiz['Question$i'] = question[i].text.trim();
      addQuiz['Answer$i'] = answer[i].text.trim();
      addQuiz['Options$i'] = options[i].text.split(',');
    }
    addQuiz['No'] = count.toString();
    try {
      final getDoc =
          FirebaseFirestore.instance.collection('Event').doc('pre-test');
      getDoc
          .set({'$cureentDate': addQuiz}, SetOptions(merge: true)).whenComplete(
              () => UtilsWidgets.showToastFunc('Successfully Updated'));
    } catch (e) {
      UtilsWidgets.showToastFunc(e.toString());
    }
  }
}
