import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_generator/widgets/utility.dart';
import 'package:event_generator/widgets/widget_utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddLink extends StatefulWidget {
  const AddLink({super.key});

  @override
  State<AddLink> createState() => _AddLinkState();
}

class _AddLinkState extends State<AddLink> {
  final TextEditingController _webinarIDText = TextEditingController();
  final TextEditingController _webinarTitleText = TextEditingController();
  final TextEditingController _webinarLinkText = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isPicked = false;
  bool _isLoading = true;
  PlatformFile? pickedFile;
  final TextEditingController _dateText = TextEditingController();
  String cureentDate = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UtilsWidgets.buildAppBar("Add Latest Webinar"),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: SizedBox(
            width: 400,
            child: Form(
              key: _formKey,
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
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  UtilsWidgets.textFormField(
                      "Enter Latest Webinar Title", "Webinar Title", (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return "Please Enter Latest Webinar Title";
                    }
                  }, _webinarTitleText),
                  const SizedBox(
                    height: 20,
                  ),
                  UtilsWidgets.textFormField(
                      "Enter Latest Webinar Link", "Webinar Link", (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return "Please Enter Latest Webinar Link";
                    }
                  }, _webinarLinkText),
                  const SizedBox(
                    height: 20,
                  ),
                  UtilsWidgets.textFormField(
                      "Enter Latest Webinar ID", "Webinar ID", (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return "Please Enter Latest Webinar ID";
                    }
                  }, _webinarIDText),
                  const SizedBox(
                    height: 20,
                  ),
                  _isLoading
                      ? UtilsWidgets.buildRoundBtn("Submit", () {
                          if (_formKey.currentState!.validate()) {
                            addWebinar();
                            _webinarTitleText.clear();
                            _webinarIDText.clear();
                            _webinarLinkText.clear();
                            _dateText.clear();
                          }
                        })
                      : const Center(child: CircularProgressIndicator()),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(thickness: 2),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      const Text(
                        'Choose Banner:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      !isPicked
                          ? UtilsWidgets.buildRoundBtn('Upload Image',
                              () async {
                              if (kIsWeb) {
                                uploadFileData();
                              } else {
                                uploadFile();
                              }
                            })
                          : CircularProgressIndicator(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future uploadFileData() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null) {
      UtilsWidgets.showToastFunc('Select File');
      return null;
    }
    setState(() {
      pickedFile = result.files.first;
    });
    final ref = FirebaseStorage.instance.ref().child('images/webinar');
    final data = pickedFile!.bytes;
    ref.putData(data!).then(
        (p0) => UtilsWidgets.showToastFunc('Image coded Uploaded Sucessfully'));
  }

  Future uploadFile() async {
    setState(() {
      isPicked = true;
    });
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null) {
      UtilsWidgets.showToastFunc('Select File');
      return null;
    }
    setState(() {
      pickedFile = result.files.first;
    });
    File data = File(pickedFile!.path.toString());
    final ref = FirebaseStorage.instance.ref().child('images/webinar.jpeg');
    ref.putFile(data).then((p0) {
      setState(() {
        isPicked = false;
      });
      UtilsWidgets.showToastFunc('Image Uploaded Sucessfully');
    });
  }

  Future addWebinar() async {
    setState(() {
      _isLoading = false;
    });
    Map<String, dynamic> data = {};
    data['title'] = _webinarTitleText.text.trim();
    data['link'] = _webinarLinkText.text.trim();
    data['id'] = _webinarIDText.text.trim();
    try {
      FirebaseFirestore.instance
          .collection('webinar')
          .doc('$cureentDate')
          .set(data, SetOptions(merge: true))
          .then((value) {
        UtilsWidgets.showToastFunc('Successfully Updated');
      });
    } catch (e) {
      UtilsWidgets.showToastFunc(e.toString());
    }
    setState(() {
      _isLoading = true;
    });
  }
}
