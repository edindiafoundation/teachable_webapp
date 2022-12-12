import 'dart:async';
import 'package:event_generator/screens/home_screen.dart';
import 'package:event_generator/widgets/widget_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class EmailVerify extends StatefulWidget {
  const EmailVerify({super.key});

  @override
  State<EmailVerify> createState() => _EmailVerifyState();
}

class _EmailVerifyState extends State<EmailVerify> {
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationMail();
      timer = Timer.periodic(const Duration(seconds: 3), (_) {
        checkVerificationMail();
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? const HomeScreen()
        : Scaffold(
            body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    height: 100,
                    width: 100,
                    child: LiquidLinearProgressIndicator(
                      value: 0.45,
                      valueColor: AlwaysStoppedAnimation(Colors.teal),
                      backgroundColor: Colors.white,
                      borderColor: Colors.teal,
                      borderWidth: 1.0,
                      borderRadius: 50.0,
                      direction: Axis.vertical,
                      center: Text(
                        'wait'.tr,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'verification'.tr,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'verify'.tr,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 30,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'note'.tr,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text('note_msg'.tr),
                  ],
                )
              ],
            ),
          ));
  }

  Future sendVerificationMail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (e) {
      UtilsWidgets.showToastFunc("Something Went Wrong");
    }
  }

  Future checkVerificationMail() async {
    try {
      await FirebaseAuth.instance.currentUser!.reload();
      setState(() {
        isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      });
      if (isEmailVerified) {
        timer?.cancel();
      }
    } on FirebaseAuthException catch (e) {
      UtilsWidgets.showToastFunc(e.message.toString());
    }
  }
}
