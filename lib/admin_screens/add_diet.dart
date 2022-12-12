import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_generator/widgets/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddDIET extends StatefulWidget {
  const AddDIET({super.key});

  @override
  State<AddDIET> createState() => _AddDIETState();
}

class _AddDIETState extends State<AddDIET> {
  final TextEditingController _diet = TextEditingController();
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
      appBar: UtilsWidgets.buildAppBar('Add Edit DIET'),
      body: Form(
        key: _formKey,
        child: Center(
          child: SizedBox(
            width: 400,
            child: Column(
              children: [
                UtilsWidgets.textFormField("Enter DIET", "DIET", (value) {
                  if (value == '' || value == null) {
                    return "Please add diet";
                  }
                }, _diet),
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
                        putDIET();
                        setState(() {
                          _diet.clear();
                        });
                      }
                    }),
                    const SizedBox(
                      width: 10,
                    ),
                    UtilsWidgets.buildRoundBtn("Delete", () {
                      if (_formKey.currentState!.validate()) {
                        deleteDIET();
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

  Future deleteDIET() async {
    try {
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection("diet");

      collectionReference
          .where(district, isEqualTo: _diet.text.trim())
          .get()
          .then(
        (QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            collectionReference.doc(doc.id).delete().then((value) =>
                UtilsWidgets.showToastFunc("Sucessfully delete DIET"));
          });
        },
      ).onError((error, stackTrace) =>
              UtilsWidgets.showToastFunc(error.toString()));
    } catch (e) {
      UtilsWidgets.showToastFunc(e.toString());
    }
  }

  Future putDIET() async {
    final pvt = {district: _diet.text.trim().toString()};
    try {
      final addDIET = FirebaseFirestore.instance.collection('diet').doc();
      await addDIET.set(pvt);
      UtilsWidgets.showToastFunc("Sucessfully add DIET");
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
