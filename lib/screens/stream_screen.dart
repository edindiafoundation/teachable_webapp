import 'package:event_generator/screens/email-verification_status.dart';
import 'package:event_generator/screens/email_login_screen.dart';
import 'package:event_generator/widgets/widget_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StreamBuilderScreen extends StatefulWidget {
  const StreamBuilderScreen({super.key});

  @override
  State<StreamBuilderScreen> createState() => _StreamBuilderScreenState();
}

class _StreamBuilderScreenState extends State<StreamBuilderScreen> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            Center(
              child: UtilsWidgets.showToastFunc("Something Went Wrong"),
            );
            return const EmailLoginPage();
          } else {
            return const EmailVerify();
            
          }
        });
  }
}
