import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_generator/widgets/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddPVT extends StatefulWidget {
  const AddPVT({super.key});

  @override
  State<AddPVT> createState() => _AddPVTState();
}

class _AddPVTState extends State<AddPVT> {
  final TextEditingController _pvtInstitude = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String state = "";
  String district = "";
  List<dynamic> states = [];
  List<dynamic> districts = [];
  List<dynamic> abc = [];
  
  @override
  void initState() {
    loadData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UtilsWidgets.buildAppBar('Add Edit Private Institute'),
      body: Form(
        key: _formKey,
        child: Center(
          child: SizedBox(
            width: 400,
            child: Column(
              children: [
                UtilsWidgets.textFormField(
                    "Enter Private Institute", "Private Institute", (value) {
                  if (value == '' || value == null) {
                    return "Please add Private Institute";
                  }
                }, _pvtInstitude),
                UtilsWidgets.searchAbleDropDown(
                    states,
                    state,
                    "Select State",
                    "--Choose College State--",
                    const Icon(Icons.search),
                    (value) {
                      setState(() {
                        if (value == null) {
                          districts.add("Select State Please");
                        } else {
                          setState(() {
                            state = value;
                            int i = states.indexOf(value);
                            districts = abc[i]["districts"];
                          });
                        }
                      });
                    },
                    "Search",
                    Colors.black,
                    'Select State',
                    (value) {
                      if (value == "--Choose College State--" ||
                          value == null ||
                          value.toString().isEmpty) {
                        return "Please Select Your State";
                      }
                    }),
                SizedBox(
                  height: 10,
                ),
                UtilsWidgets.searchAbleDropDown(
                    districts,
                    district,
                    "Select District",
                    "--Choose College District--",
                    const Icon(Icons.search),
                    (value) {
                      setState(() {
                        district = value;
                      });
                    },
                    "Search",
                    Colors.black,
                    'Select District',
                    (value) {
                      if (value == "--Choose College District--" ||
                          value == null ||
                          value == "Select Your State" ||
                          value.toString().isEmpty) {
                        return "Please Select Your District";
                      }
                    }),
                Row(
                  children: [
                    UtilsWidgets.buildRoundBtn("Submit", () {
                      if (_formKey.currentState!.validate()) {
                        putPVT();
                        setState(() {
                          _pvtInstitude.clear();
                          state = '';
                        });
                      }
                    }),
                    const SizedBox(
                      width: 10,
                    ),
                    UtilsWidgets.buildRoundBtn("Delete", () {
                      if (_formKey.currentState!.validate()) {
                        deletePVT();
                        setState(() {
                          _pvtInstitude.clear();
                          state = '';
                        });
                      }
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future deletePVT() async {
    try {
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection("pvt");

      collectionReference
          .where(district, isEqualTo: _pvtInstitude.text.trim())
          .get()
          .then(
        (QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            collectionReference.doc(doc.id).delete().then((value) =>
                UtilsWidgets.showToastFunc(
                    "Sucessfully delete Private Institute"));
          });
        },
      ).onError((error, stackTrace) =>
              UtilsWidgets.showToastFunc(error.toString()));
    } catch (e) {
      UtilsWidgets.showToastFunc(e.toString());
    }
  }

  Future putPVT() async {
    final pvt = {district: _pvtInstitude.text.trim().toString()};
    try {
      final addpvt = FirebaseFirestore.instance.collection('pvt').doc();
      await addpvt.set(pvt);
      UtilsWidgets.showToastFunc("Sucessfully add Private Institude");
    } catch (e) {
      UtilsWidgets.showToastFunc(e.toString());
    }
  }

  Future<String> loadData() async {
    var data =
        await rootBundle.loadString("assets/json/states-and-districts.json");
    Map<String, dynamic> catalogdata = {};
    setState(() {
      catalogdata = json.decode(data);
      catalogdata.entries.forEach((element) {
        abc = element.value;
      });
      abc.forEach((element) {
        states.add(element['state']);
      });
    });
    return "success";
  }
}
