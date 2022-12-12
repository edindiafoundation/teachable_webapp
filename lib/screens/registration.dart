import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_generator/screens/email_login_screen.dart';
import 'package:event_generator/screens/stream_screen.dart';
import 'package:event_generator/widgets/utility.dart';
import 'package:event_generator/widgets/widget_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  List<dynamic> states = [];
  List<dynamic> districts = [];
  List<dynamic> abc = [];
  List<dynamic> course = ['D.El.Ed', 'B.Ed', 'M.Ed'];
  List<dynamic> year = ['First', 'Second'];
  List<dynamic> ageRange = ['16-25', '26-35', '36-45', 'More Than 45'];
  List<dynamic> pvtInstitutes = [];
  List<dynamic> diets = [];
  String gender = "";
  String role = "";
  String state = "";
  String district = "";
  String age = "";
  String courseValue = "";
  String courseYValue = "";
  String institution = "";
  String pvtInstitute = "";
  String diet = "";
  bool isObscure = true;
  bool _isLoading = true;

  final TextEditingController _fnameText = TextEditingController();
  final TextEditingController _lnameText = TextEditingController();
  final TextEditingController _emailText = TextEditingController();
  final TextEditingController _passwordText = TextEditingController();
  final TextEditingController _mobileText = TextEditingController();
  final TextEditingController _otherText = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 200,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/backround.png'),
                            fit: BoxFit.fill)),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 30,
                          width: 80,
                          height: 200,
                          child: Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/light-1.png'))),
                          ),
                        ),
                        Positioned(
                          left: 140,
                          width: 80,
                          height: 150,
                          child: Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/light-2.png'))),
                          ),
                        ),
                        Positioned(
                          right: 40,
                          top: 40,
                          width: 80,
                          height: 150,
                          child: Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/clock.png'))),
                          ),
                        ),
                        Positioned(
                          child: Container(
                            margin: EdgeInsets.only(top: 40),
                            child: Center(
                              child: Text(
                                'register'.tr,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 400,
                    child: Column(
                      children: [
                        UtilsWidgets.textFormField(
                          "fname_tf".tr,
                          "fname_tf".tr,
                          (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return 'please'.tr + "fname_tf".tr;
                            }
                          },
                          _fnameText,
                        ),
                        UtilsWidgets.textFormField(
                          'lname_tf'.tr,
                          'lname_tf'.tr,
                          (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return 'please'.tr + 'lname_tf'.tr;
                            }
                          },
                          _lnameText,
                        ),
                        UtilsWidgets.textFormField(
                            'mobile_tf'.tr, 'mobile_tf'.tr,
                            textInputType: TextInputType.phone, (p0) {
                          if (p0 == null || p0.isEmpty)
                            return 'please'.tr + 'mobile_tf'.tr;
                          else if (Utils.validateMobile(p0.toString())) {
                            return "mobile_vtf".tr;
                          }
                        }, _mobileText),
                        UtilsWidgets.textFormField(
                            'mail_tf'.tr, "example@gmail.com", (p0) {
                          if (p0 == null || p0.isEmpty)
                            return 'please'.tr + 'mail_tf'.tr;
                          else if (Utils.validateGmail(p0.toString())) {
                            return "mail_vtf".tr;
                          }
                        }, _emailText),
                        UtilsWidgets.textFormField(
                          'pass_rtf'.tr,
                          'pass_rtf'.tr,
                          (p0) {
                            if (p0 == null || p0.isEmpty)
                              return 'please'.tr + 'pass_rtf'.tr;
                            else if (p0.length < 6) {
                              return "pass_vtf".tr;
                            }
                          },
                          _passwordText,
                          obscure: isObscure,
                          suffixIcon: IconButton(
                            icon: Icon(
                              isObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            onPressed: () {
                              setState(() {
                                isObscure = !isObscure;
                              });
                            },
                          ),
                        ),
                        UtilsWidgets.dropDownButton(
                          'age_tf'.tr,
                          'age_tf'.tr,
                          age,
                          ageRange,
                          (val) {
                            setState(() {
                              age = val;
                            });
                          },
                          validator: (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return 'please'.tr + 'age_tf'.tr;
                            }
                          },
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'gender_tf'.tr,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      Radio(
                                          value: "Male",
                                          groupValue: gender,
                                          onChanged: (value) {
                                            setState(() {
                                              gender = value.toString();
                                            });
                                          }),
                                      Text('male'.tr)
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Radio(
                                          value: "Female",
                                          groupValue: gender,
                                          onChanged: (value) {
                                            setState(() {
                                              gender = value.toString();
                                            });
                                          }),
                                      Text('female'.tr)
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Radio(
                                          value: "Other",
                                          groupValue: gender,
                                          onChanged: (value) {
                                            setState(() {
                                              gender = value.toString();
                                            });
                                          }),
                                      Text('other_tf'.tr)
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        UtilsWidgets.searchAbleDropDown(
                            states,
                            state,
                            'state_tf'.tr,
                            'state_tf'.tr,
                            const Icon(Icons.search),
                            (value) {
                              setState(() {
                                if (value == null) {
                                  districts.add('state_tf'.tr);
                                } else {
                                  setState(() {
                                    state = value;
                                    int i = states.indexOf(value);
                                    districts = abc[i]["districts"];
                                  });
                                }
                              });
                            },
                            'state_tf'.tr,
                            Colors.black,
                            'state_tf'.tr,
                            (value) {
                              if (value == 'state_tf'.tr ||
                                  value == null ||
                                  value.toString().isEmpty) {
                                return 'please'.tr + 'state_tf'.tr;
                              }
                            }),
                        SizedBox(
                          height: 10,
                        ),
                        UtilsWidgets.searchAbleDropDown(
                            districts,
                            district,
                            'district_tf'.tr,
                            'district_tf'.tr,
                            const Icon(Icons.search),
                            (value) {
                              setState(() {
                                district = value.toString();
                              });
                              getDIET();
                              getPVT();
                            },
                            'district_tf'.tr,
                            Colors.black,
                            'district_tf'.tr,
                            (value) {
                              if (value == 'district_tf'.tr ||
                                  value == null ||
                                  value == 'state_tf'.tr ||
                                  value.toString().isEmpty) {
                                return 'please'.tr + 'district_tf'.tr;
                              }
                            }),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'institute_tf'.tr,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      Radio(
                                          value: "DIET/BTI",
                                          groupValue: institution,
                                          onChanged: (value) {
                                            setState(() {
                                              institution = value.toString();
                                            });
                                          }),
                                      Text('DIET/BTI')
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Radio(
                                          value: "Private TEIs",
                                          groupValue: institution,
                                          onChanged: (value) {
                                            setState(() {
                                              institution = value.toString();
                                            });
                                          }),
                                      const Text('Private TEIs')
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        institution == 'Private TEIs'
                            ? UtilsWidgets.searchAbleDropDown(
                                pvtInstitutes,
                                pvtInstitute,
                                "pvtinstitute_tf".tr,
                                "pvtinstitute_tf".tr,
                                const Icon(Icons.school),
                                (value) {
                                  setState(() {
                                    diet = '';
                                    pvtInstitute = value.toString();
                                  });
                                },
                                "Search",
                                Colors.black,
                                'pvtinstitute_tf'.tr,
                                (value) {
                                  if (value == null ||
                                      value == "pvtinstitute_tf".tr) {
                                    return 'Please'.tr + 'pvtinstitute_tf'.tr;
                                  }
                                })
                            : institution == 'DIET/BTI'
                                ? UtilsWidgets.searchAbleDropDown(
                                    diets,
                                    diet,
                                    "diet_tf".tr,
                                    "diet_tf".tr,
                                    const Icon(Icons.school),
                                    (value) {
                                      setState(() {
                                        pvtInstitute = '';
                                        diet = value.toString();
                                      });
                                    },
                                    "Search",
                                    Colors.black,
                                    'diet_tf'.tr,
                                    (value) {
                                      if (value == "diet_tf".tr ||
                                          value == null) {
                                        return "please".tr + "diet_tf".tr;
                                      }
                                    })
                                : const SizedBox(),
                        diet == "Other" || pvtInstitute == "Other"
                            ? UtilsWidgets.textFormField(
                                "college_tf".tr, "college_tf".tr, (p0) {
                                if (p0 == null || p0.isEmpty) {
                                  return "please".tr + "college_tf".tr;
                                }
                              }, _otherText)
                            : SizedBox(),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'role_tf'.tr,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      Radio(
                                          value: "Student",
                                          groupValue: role,
                                          onChanged: (value) {
                                            setState(() {
                                              role = value.toString();
                                            });
                                          }),
                                      Text('student'.tr)
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Radio(
                                          value: "Teacher",
                                          groupValue: role,
                                          onChanged: (value) {
                                            setState(() {
                                              role = value.toString();
                                            });
                                          }),
                                      Text('teacher'.tr)
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Radio(
                                          value: "Other",
                                          groupValue: role,
                                          onChanged: (value) {
                                            setState(() {
                                              role = value.toString();
                                            });
                                          }),
                                      Text('other_tf'.tr)
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        role == 'Student'
                            ? UtilsWidgets.dropDownButton(
                                'course_tf'.tr,
                                'course_tf'.tr,
                                courseValue,
                                course,
                                (val) {
                                  setState(() {
                                    courseValue = val;
                                  });
                                },
                                validator: (p0) {
                                  if (p0 == null || p0.isEmpty) {
                                    return 'please'.tr + 'course_tf'.tr;
                                  }
                                },
                              )
                            : SizedBox(),
                        role == 'Student'
                            ? UtilsWidgets.dropDownButton(
                                'coursey_tf'.tr,
                                'coursey_tf'.tr,
                                courseYValue,
                                year,
                                (val) {
                                  setState(() {
                                    courseYValue = val;
                                  });
                                },
                                validator: (p0) {
                                  if (p0 == null || p0.isEmpty) {
                                    return 'please'.tr + 'coursey_tf'.tr;
                                  }
                                },
                              )
                            : const SizedBox(),
                        const SizedBox(
                          height: 20,
                        ),
                        _isLoading
                            ? UtilsWidgets.buildRoundBtn("register".tr,
                                () async {
                                if (gender == "") {
                                  UtilsWidgets.showAlertDialog(context, () {
                                    Navigator.of(context).pop();
                                  }, 'Something Missing',
                                      'please'.tr + 'gender_tf'.tr,
                                      note: '');
                                } else if (institution == "") {
                                  UtilsWidgets.showAlertDialog(context, () {
                                    Navigator.of(context).pop();
                                  }, 'Something Missing',
                                      'please'.tr + 'institute_tf'.tr,
                                      note: '');
                                } else if (role == "") {
                                  UtilsWidgets.showAlertDialog(context, () {
                                    Navigator.of(context).pop();
                                  }, 'Something Missing',
                                      'please'.tr + 'role_tf'.tr,
                                      note: '');
                                } else if (_formKey.currentState!.validate()) {
                                  UtilsWidgets.bottomDialogs(
                                      '',
                                      'register_note'.tr,
                                      'cancel'.tr,
                                      'submit'.tr,
                                      context, () {
                                    Navigator.of(context).pop();
                                  }, () {
                                    registerUser();
                                    createUser();
                                  });
                                }
                              })
                            : const CircularProgressIndicator(),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(children: [
                          Text('already_account'.tr),
                          TextButton(
                            child: Text(
                              'login'.tr,
                              style: TextStyle(fontSize: 16),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const EmailLoginPage()),
                              );
                            },
                          )
                        ]),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Future registerUser() async {
    setState(() {
      _isLoading = false;
    });
    final userinfo = {
      "fname": _fnameText.text.trim(),
      "lname": _lnameText.text.trim(),
      "email": _emailText.text.trim(),
      "age": age,
      "mobile": _mobileText.text.trim(),
      "course": courseValue,
      "courseyear": courseYValue,
      "state": state,
      "disctict": district,
      "gender": gender,
      "institution": institution,
      "pvtInstitution": pvtInstitute,
      "diet": diet,
      "role": role,
      "college_name": _otherText.text.trim()
    };
    try {
      final addUser = FirebaseFirestore.instance
          .collection('users')
          .doc(_emailText.text.trim());
      await addUser.set(userinfo);
    } catch (e) {
      UtilsWidgets.showToastFunc(e.toString());
    }
    setState(() {
      _isLoading = true;
    });
  }

  Future createUser() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailText.text.trim(),
              password: _passwordText.text.trim())
          .then((value) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StreamBuilderScreen()),
        );
      });
    } on FirebaseAuthException catch (e) {
      UtilsWidgets.showToastFunc(e.message.toString());
    }
  }

  Future getPVT() async {
    pvtInstitutes.clear();
    pvtInstitutes.add('Other');
    try {
      FirebaseFirestore.instance
          .collection('pvt')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          if (doc.data().toString().contains(district)) {
            setState(() {
              pvtInstitutes.add(doc['$district'].toString());
            });
          } else {}
        });
      });
    } catch (e) {
      UtilsWidgets.showToastFunc(e.toString());
    }
  }

  Future getDIET() async {
    diets.clear();
    diets.add('Other');
    try {
      FirebaseFirestore.instance
          .collection('diet')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          if (doc.data().toString().contains(district)) {
            setState(() {
              diets.add(doc['$district'].toString());
            });
          } else {}
        });
      });
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

  void onTapClear() {
    setState(() {
      _fnameText.clear();
      _lnameText.clear();
      _emailText.clear();
      _mobileText.clear();
      _passwordText.clear();
      courseValue = "";
      courseYValue = "";
      district = "";
      age = '';
      gender = "";
      state = "";
    });
  }
}
