import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_generator/screens/home_screen.dart';
import 'package:event_generator/screens/registration.dart';
import 'package:event_generator/admin_screens/admin_screen.dart';
import 'package:event_generator/widgets/widget_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailLoginPage extends StatefulWidget {
  const EmailLoginPage({
    super.key,
  });

  @override
  State<EmailLoginPage> createState() => _EmailLoginPageState();
}

class _EmailLoginPageState extends State<EmailLoginPage> {
  final TextEditingController _emailText = TextEditingController();
  final TextEditingController _passwordText = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Map userDetails = {};
  bool _isLoading = true;
  bool _ishindi = true;
  bool isObscure = true;
  String adminEmail = "";
  String adminPassword = "";

  @override
  void initState() {
    getAdmin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                                  image:
                                      AssetImage('assets/images/light-1.png'))),
                        ),
                      ),
                      Positioned(
                        top: 30,
                        right: 30,
                        child: Container(
                          child: TextButton(
                            onPressed: _ishindi
                                ? () {
                                    var locale = Locale('en', 'US');
                                    Get.updateLocale(locale);
                                    _ishindi = false;
                                  }
                                : () {
                                    var locale = Locale('hi', 'IN');
                                    Get.updateLocale(locale);
                                    _ishindi = true;
                                  },
                            child: Text(
                              _ishindi ? 'English' : 'हिन्दी',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        child: Container(
                          margin: EdgeInsets.only(top: 50),
                          child: Center(
                            child: Text(
                              'welcome'.tr,
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
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 350,
                  child: Column(
                    children: [
                      UtilsWidgets.textFormField('mail_tf'.tr, 'mail_tf'.tr,
                          (p0) {
                        if (p0 == null || p0.isEmpty) {
                          return 'please'.tr + "mail_tf".tr;
                        }
                      }, _emailText),
                      UtilsWidgets.textFormField(
                        'pass_tf'.tr,
                        'pass_tf'.tr,
                        (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return 'please'.tr + "pass_tf".tr;
                          }
                        },
                        _passwordText,
                        obscure: isObscure,
                        suffixIcon: IconButton(
                          icon: Icon(
                            isObscure ? Icons.visibility_off : Icons.visibility,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      _isLoading
                          ? Container(
                              height: 50,
                              width: 300,
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: ElevatedButton(
                                child: Text('login'.tr),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    if (_emailText.text == adminEmail &&
                                        _passwordText.text == adminPassword) {
                                      adminLogin();
                                    } else {
                                      loginWithEmail();
                                    }
                                  } else {
                                    UtilsWidgets.showToastFunc(
                                        "Please Check Credentials");
                                  }
                                },
                              ),
                            )
                          : const CircularProgressIndicator(),
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        child: Text(
                          'forget_password'.tr,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          if (_emailText.text == '' ||
                              _emailText.text.isEmpty) {
                            UtilsWidgets.showToastFunc('mail_tf'.tr);
                          } else {
                            resetPassword();
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(children: [
                        Text('account_status'.tr),
                        TextButton(
                          child: Text(
                            'register'.tr,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterPage()),
                            );
                          },
                        ),
                      ]),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Powered by EdIndia',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Future loginWithEmail() async {
    setState(() {
      _isLoading = false;
    });
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailText.text.trim(),
              password: _passwordText.text.trim())
          .then((value) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        _emailText.clear();
        _passwordText.clear();
      });
    } on FirebaseAuthException catch (e) {
      UtilsWidgets.showToastFunc(e.message.toString());
    }
    setState(() {
      _isLoading = true;
    });
  }

  Future getAdmin() async {
    try {
      FirebaseFirestore.instance
          .collection('admin')
          .doc('credentials')
          .get()
          .then((value) {
        setState(() {
          adminEmail = value["email"].toString();
          adminPassword = value["password"].toString();
        });
      });
    } catch (e) {
      UtilsWidgets.showToastFunc(e.toString());
    }
  }

  void adminLogin() {
    UtilsWidgets.bottomDialogs(
        'admin_note'.tr, 'login'.tr, 'cancel'.tr, 'login'.tr, context, () {
      Navigator.pop(context);
    }, () {
      Navigator.pop(context);
      _emailText.clear();
      _passwordText.clear();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AdminScreen()),
      );
    });
  }

  Future resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailText.text.trim())
          .whenComplete(() {
        UtilsWidgets.showAlertDialog(context, () {
          Navigator.of(context).pop();
        }, 'verify'.tr, 'verification'.tr, note: '');
      });
    } on FirebaseAuthException catch (e) {
      UtilsWidgets.showToastFunc(e.message.toString());
    }
  }
}
