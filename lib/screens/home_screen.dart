import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_generator/screens/post-test.dart';
import 'package:event_generator/screens/pre-test.dart';
import 'package:event_generator/screens/email_login_screen.dart';
import 'package:event_generator/widgets/drawer.dart';
import 'package:event_generator/widgets/utility.dart';
import 'package:event_generator/widgets/widget_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int i = 3;
  User? user;
  bool isSubmit = false;
  bool postislive = false;
  bool webinarislive = false;
  String webinarID = "";
  String webinarTitle = "";
  String username = '';
  String cureentDate = '';
  String downloadURL =
      'https://edindia.org/wp-content/uploads/2019/11/EdIndia-Transparent.png';
  // bool isadded = false;
  // Uint8List? imageFile;

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      getRecentDate();
      isLive();
      onOpen(i);
      // getWebImage();
      getImage();
      getUser();
      userSession();
      getVerification();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return user == null
        ? EmailLoginPage()
        : Scaffold(
            drawer: BuildDrawer.buildUserDrawer(context),
            appBar: UtilsWidgets.buildAppBar('Welcome ' + username),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      UtilsWidgets.buildSqureBtn(
                          'go_webinar'.tr,
                          webinarislive
                              ? () {
                                  isLive();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PreTest(
                                              webinarDate: cureentDate,
                                              ID: webinarID,
                                              title: webinarTitle,
                                              email: user!.email.toString(),
                                              webinarstatus: webinarislive,
                                            )),
                                  );
                                }
                              : () {
                                  UtilsWidgets.showToastFunc(
                                      'pretest_activation'.tr);
                                }),
                      const SizedBox(
                        width: 30,
                      ),
                      UtilsWidgets.buildSqureBtn('post_assessment'.tr, () {
                        getVerification();
                        isLive();
                        isSubmit
                            ? postislive
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PostTest(
                                              email: user!.email.toString(),
                                              webinarDate: cureentDate,
                                              title: webinarTitle,
                                            )),
                                  )
                                : UtilsWidgets.showToastFunc(
                                    'posttest_activation'.tr)
                            : UtilsWidgets.showToastFunc(
                                'pretest_validation'.tr);
                      }),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  // isadded ? Image.memory(imageFile!) : SizedBox(),
                  Image.network(downloadURL),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          );
  }

//get list of all webinar date and id
  Future getRecentDate() async {
    List<dynamic> sessionDate = [];
    FirebaseFirestore.instance
        .collection('webinar')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        webinarID = querySnapshot.docs.last.get('id').toString();
        webinarTitle = querySnapshot.docs.last.get('title').toString();
      });
      querySnapshot.docs.forEach((doc) {
        setState(() {
          sessionDate.add(doc.id.toString());
        });
      });
      setState(() {
        cureentDate = sessionDate.last;
      });
    });
  }

//admin set test is live or not
  Future isLive() async {
    try {
      FirebaseFirestore.instance
          .collection('admin')
          .doc('activation')
          .get()
          .then((value) {
        setState(() {
          postislive = value["post-islive"];
          webinarislive = value["webinar"];
        });
      });
    } catch (e) {
      UtilsWidgets.showToastFunc(e.toString());
    }
  }

// //intial dialog
  onOpen(int i) {
    Timer.periodic(Duration(seconds: i), (val) {
      setState(() {
        val.cancel();
      });
      UtilsWidgets.showAlertDialog(context, () {
        Navigator.of(context).pop();
      }, 'im_title'.tr, 'steps'.tr, note: 'notess'.tr);
    });
  }

// //get current user info i.e fname
  Future getUser() async {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: user!.email.toString())
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          setState(() {
            username = doc["fname"].toString();
          });
        });
      });
    } catch (e) {
      UtilsWidgets.showToastFunc(e.toString());
    }
  }

// //get banner image
  Future getImage() async {
    final ref = FirebaseStorage.instance.ref().child('images/webinar.jpeg');
    ref.getDownloadURL().then((value) {
      setState(() {
        downloadURL = value;
      });
    });
  }

  // Future getWebImage() async {
  //   final ref = FirebaseStorage.instance.ref().child('images/webinar');
  //   ref.getData().then((value) {
  //     setState(() {
  //       imageFile = value;
  //       isadded = true;
  //     });
  //   });
  // }

//Monitor user enterance
  Future userSession() async {
    String todayDate = Utils.getDate(DateTime.now());
    Map sessionMap = {};
    int count = 0;
    List abc = [];
    try {
      DocumentReference ref = FirebaseFirestore.instance
          .collection('user-session')
          .doc(user!.email.toString());
      ref.get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          if (documentSnapshot.data().toString().contains('$todayDate')) {
            setState(() {
              int len = int.parse(
                  documentSnapshot['$todayDate']['TotalIn'].toString());
              sessionMap['TotalIn'] = len + 1;
              List q = documentSnapshot['$todayDate']['entries'];
              q.forEach((element) {
                abc.add(element);
              });
              abc.add(DateTime.now());
              sessionMap['entries'] = abc;
            });
            ref.set({'$todayDate': sessionMap}, SetOptions(merge: true));
          } else {
            setState(() {
              abc.insert(count, DateTime.now());
              sessionMap['TotalIn'] = count + 1;
              sessionMap['entries'] = abc;
            });
            ref.set({'$todayDate': sessionMap}, SetOptions(merge: true));
          }
        } else {
          setState(() {
            abc.insert(count, DateTime.now());
            sessionMap['TotalIn'] = count + 1;
            sessionMap['entries'] = abc;
          });
          ref.set({'$todayDate': sessionMap});
        }
      });
    } catch (e) {
      UtilsWidgets.showToastFunc(e.toString());
    }
  }

  // //check pre-test is given or not
  Future getVerification() async {
    try {
      FirebaseFirestore.instance
          .collection('preTestResult')
          .doc(user!.email.toString())
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          if (documentSnapshot.data().toString().contains('$cureentDate')) {
            setState(() {
              isSubmit = documentSnapshot['$cureentDate']['isSubmit'];
            });
          }
        } else {
          setState(() {
            isSubmit = false;
          });
        }
      });
    } catch (e) {
      UtilsWidgets.showToastFunc(e.toString());
    }
  }
}
